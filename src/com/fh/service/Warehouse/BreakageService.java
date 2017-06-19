package com.fh.service.Warehouse;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.service.BaseService;
import com.fh.util.PageData;


@Service("BreakageService")
public class BreakageService extends BaseService {

	public List<PageData> breakagelistPage(Page page) throws Exception {
		return listPageInfo(page,"breakageXMapper.breakagelistPage");
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("breakageXMapper.findbreakageGoods",pd); 
	}

	@Transactional
	public void saveBreakage(PageData pd, List array) throws Exception { 
		dao.save("breakageXMapper.saveBreakage", pd);  
		dao.save("breakageXMapper.saveBreakageDetail", array); 
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findByGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("breakageXMapper.findByGoods",pd);
	} 

	public PageData findByBreakage(PageData pd) throws Exception {
		return (PageData) dao.findForObject("breakageXMapper.findByBreakage", pd); 
	}


	public void deleteBreakage(PageData pd) throws Exception { 
		dao.delete("breakageXMapper.deleteBreakage", pd); 
	}

	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("ReportedLossNo",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("breakageXMapper.findByBreakage", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("breakageXMapper.findByGoods",allotpg); 
		if(list!=null){
			for(Object jsonObj: list){ 
				JSONObject obj = JSONObject.fromObject(jsonObj);
				String barCode = obj.getString("BarCode"); 
				String num=obj.getString("Number");
				PageData pg=new PageData(); 
				pg.put("BarCode", barCode);
				pg.put("WarehouseNo", pb.getString("WarehouseNo"));
				//查询库存商品信息
				PageData p= (PageData) dao.findForObject("breakageXMapper.findByWhsId",pg);   
				PageData pa=null;
				if(p!=null){   
					int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))-Integer.parseInt(num);
					pa=new PageData();
					pa.put("Quantity", Quantity);
					pa.put("Id", p.getString("Id"));   
					dao.update("breakageXMapper.updateInventory", pa);  
				}  
			}
		}
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus", 2);
		dao.update( "breakageXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus", 3); 
		dao.update( "breakageXMapper.updateFlowStatus",pd);  
		super.doApplyRecord(pd);
	}
	 

}
