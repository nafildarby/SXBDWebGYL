/**
 * 
 */
package com.fh.service.Warehouse;

import java.util.List; 
import com.fh.service.BaseService;
import net.sf.json.JSONObject; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; 
import com.fh.entity.Page;
import com.fh.entity.Warehouse.GoodsDetail; 
import com.fh.util.PageData;

/**
 * @author PLF 2016年9月7日
 *
 */
@Service("InComeService")
public class InComeService extends BaseService {

	public List<PageData> listInboundPage(Page page)throws Exception{
		return listPageInfo(page,"IncomeXMapper.inboundlistPage");
	}
 
	public void deleteInbound(PageData pd) throws Exception { 
		dao.delete("IncomeXMapper.deleteInbound", pd);
	}
	
	@Transactional
	public void saveIncome(PageData pd,List array)throws Exception{ 
		dao.save("IncomeXMapper.saveWhsIncome", pd); 
		dao.save("IncomeXMapper.saveGoodDetail", array);
	}


	public PageData findByIncome(PageData pd) throws Exception {
		return (PageData) dao.findForObject("IncomeXMapper.findByIncome", pd);
	}


	@SuppressWarnings("unchecked")
	public List<GoodsDetail> findByGoods(PageData pd) throws Exception {
		return (List<GoodsDetail>) dao.findForList("IncomeXMapper.findByGoods",pd); 
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
		PageData pb=(PageData) dao.findForObject("IncomeXMapper.findByIncome", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("IncomeXMapper.findByGoods",allotpg);  
		if(list!=null){ 
			for(Object jsonObj: list){ 
				JSONObject obj = JSONObject.fromObject(jsonObj);
				String barCode = obj.getString("BarCode"); 
				String totalNum=obj.getString("TotalNum");
				PageData pg=new PageData();
				pg.put("BarCode", barCode);
				pg.put("WhsId", pb.getString("WhsId"));
				PageData p= (PageData) dao.findForObject("IndentXMapper.findByBarCode",pg);
				PageData pa=null;
				if(p!=null){  
					int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))+Integer.parseInt(totalNum);
					pa=new PageData();
					pa.put("InventoryQuantity", Quantity);
					pa.put("Id", p.getString("Id"));  
					dao.update("IncomeXMapper.updateInventory", pa); 
				}else{ 
					pa=new PageData();
					pa.put("InventoryQuantity",totalNum );
					pa.put("ProductBarCode",barCode);  
					pa.put("WarehouseNo",pb.getString("WhsId"));
					pa.put("Status", 1);
					dao.save("IncomeXMapper.saveInventory", pa); 
				}
			}  
		}   
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "IncomeXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("IncomeXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}
}
