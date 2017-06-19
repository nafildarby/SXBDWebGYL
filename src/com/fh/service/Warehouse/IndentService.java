package com.fh.service.Warehouse;

import java.util.List; 
 
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service; 
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.service.BaseService;
import com.fh.util.PageData;

@Service("IndentService")
public class IndentService extends BaseService {
	
	 
	public List<PageData> listIndentPage(Page page) throws Exception {
		return listPageInfo(page,"IndentXMapper.IndentlistPage");
	}

	public List<PageData> listPurchasePage(Page page) throws Exception {
		return listAllInfo(page,"IndentXMapper.PurchaselistPage");
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findGoodsbyPurchase(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("IndentXMapper.listGoodsbyPurchase", pd);
	} 
	 

	@Transactional
	public void saveIndent(PageData pd, List array) throws Exception { 	 
		dao.save("IndentXMapper.saveWhsIndent", pd);  
		dao.save("IndentXMapper.saveGoodDetail", array); 
	}
	
	 
	public void deleteIndent(PageData pd) throws Exception { 
		dao.delete("IndentXMapper.deleteIndent", pd);
	}
	
	public PageData findByIndent(PageData pd) throws Exception {
		return (PageData) dao.findForObject("IndentXMapper.findByIndent", pd);
	}


	@SuppressWarnings("unchecked")
	public List<GoodsDetail> findByGoods(PageData pd) throws Exception {
		return (List<GoodsDetail>) dao.findForList("IndentXMapper.findByGoods",pd);
	}	

	
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("IncomeCode",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("IndentXMapper.findByIndent", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("IndentXMapper.findByGoods",allotpg);  
		if(list!=null){ 
			for(Object jsonObj: list){ 
				JSONObject obj = JSONObject.fromObject(jsonObj);
				String barCode = obj.getString("BarCode"); 
				String totalNum=obj.getString("TotalNum");
				PageData pg=new PageData();
				pg.put("BarCode", barCode);
				pg.put("WhsId", pb.getString("WarehouseNo"));
				PageData p= (PageData) dao.findForObject("IndentXMapper.findByBarCode",pg);
				PageData pa=null;
				if(p!=null){  
					int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))+Integer.parseInt(totalNum);
					pa=new PageData();
					pa.put("InventoryQuantity", Quantity);
					pa.put("Id", p.getString("Id"));  
					dao.update("IndentXMapper.updateInventory", pa); 
				}else{ 
					pa=new PageData();
					pa.put("InventoryQuantity",totalNum );
					pa.put("ProductBarCode",barCode);  
					pa.put("WarehouseNo", pb.getString("WarehouseNo"));
					pa.put("Status", 1);
					dao.save("IndentXMapper.saveInventory", pa); 
				}
			}  
		}
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "IndentXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("IndentXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}
}
