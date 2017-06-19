package com.fh.service.Warehouse;
 
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.service.BaseService; 
import com.fh.util.PageData;


@Service("AllotService")
public class AllotService extends BaseService {

	public List<PageData> allotlistPage(Page page) throws Exception {
		return listPageInfo(page,"allotXMapper.allotlistPage");
	}
 
	
	public List<PageData> WHNoGoodslistPage(Page page) throws Exception {
		return listPageInfo(page,"allotXMapper.WHNoGoodslistPage"); 
	}

	@Transactional
	public void saveAllot(PageData pd, List array) throws Exception { 
		dao.save("allotXMapper.saveWhsOut", pd);  
		dao.save("allotXMapper.saveOutDetail", array); 
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findByOutGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("allotXMapper.findByAllotGoods",pd);
	}

	public PageData findByOut(PageData pd) throws Exception {
		return (PageData) dao.findForObject("allotXMapper.findByAllot", pd); 
	}

	@Transactional
	public void deleteAllot(PageData pd) throws Exception {  
		dao.delete("allotXMapper.deleteAllot", pd); 
	} 
	
	
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("AllocationNo",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("allotXMapper.findByAllot", allotpg); 
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("allotXMapper.findByAllotGoods",allotpg); 
		if(list==null) return;
		for(Object jsonObj: list){ 
			JSONObject obj = JSONObject.fromObject(jsonObj);
			String barCode = obj.getString("BarCode"); 
			String totalNum=obj.getString("TotalNum");
			PageData pg=new PageData(); 
			pg.put("BarCode", barCode);
			pg.put("WhsId", pb.getString("OutWarehouseNo"));
			//查询出库库存商品信息
			PageData p= (PageData) dao.findForObject("allotXMapper.findByWhsId",pg);  
			//查询入库库存商品信息 
			pg.put("inWHNo", pb.getString("InWarehouseNo")); 
			PageData pga=(PageData) dao.findForObject("allotXMapper.findByinWHNo",pg);
			PageData pa=null;
			if(p!=null){   
				int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))-Integer.parseInt(totalNum);
				pa=new PageData();
				pa.put("InventoryQuantity", Quantity);
				pa.put("Id", p.getString("Id"));   
				dao.update("allotXMapper.updateInventory", pa);  
			} 
			if(pga!=null){
				int Qty=Integer.parseInt(pga.getString("InventoryQuantity"))+Integer.parseInt(totalNum);
				pa=new PageData();
				pa.put("InventoryQuantity", Qty);
				pa.put("Id", pga.getString("Id"));   
				dao.update("allotXMapper.updateInventory", pa); 
			}else{	
				pa=new PageData();
				pa.put("InventoryQuantity",totalNum );
				pa.put("ProductBarCode",barCode);  
				pa.put("WarehouseNo",pb.getString("InWarehouseNo"));
				pa.put("Status", 1);
				dao.save("allotXMapper.saveInventory", pa); 
			} 
		}		
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus", 2);
		dao.update( "allotXMapper.updateFlowStatus",pd); 
	}
	  

	public void UpdateStatus(PageData pd) throws Exception { 
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus",3);
		dao.update( "allotXMapper.updateFlowStatus",pd);  
		super.doApplyRecord(pd); 
	}

 
	 
}
