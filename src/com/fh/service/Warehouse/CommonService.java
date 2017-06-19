package com.fh.service.Warehouse;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; 
import com.fh.entity.Page; 
import com.fh.service.BaseService; 
import com.fh.util.PageData;

@Service("CommonService")
public class CommonService extends BaseService {

	public List<PageData> CommonlistPage(Page page) throws Exception {
		return listPageInfo(page,"commonXMapper.CommonlistPage");
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findincomGoods(PageData pd) throws Exception {
		List<PageData> list=null;
		list=(List<PageData>) dao.findForList("commonXMapper.findincomGoods",pd);
		if(list.size()==0){
			list=(List<PageData>) dao.findForList("commonXMapper.findindentGoods",pd); 
		} 
		return list;
	}

	 
	@Transactional
	public void saveCommon(PageData pd, List array) throws Exception { 
		dao.save("commonXMapper.saveWhsOut", pd);  
		dao.save("commonXMapper.saveOutDetail", array); 
	} 
   
	
	@SuppressWarnings("unchecked")
	public List<PageData> findByOutGoods(PageData pd) throws Exception { 
		return (List<PageData>) dao.findForList("commonXMapper.findByOutGoods",pd);
	}

	public PageData findByOut(PageData pd) throws Exception {
		return (PageData) dao.findForObject("commonXMapper.findByOut", pd); 
	}

	@Transactional
	public void deleteCommon(PageData pd) throws Exception { 
		dao.delete("commonXMapper.deleteCommon", pd); 
	}  
	
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("OutBoundNo",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("commonXMapper.findByOut", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("commonXMapper.findByOutGoods",allotpg);  
		if(list!=null){ 
			for(Object jsonObj: list){ 
				JSONObject obj = JSONObject.fromObject(jsonObj);
				String barCode = obj.getString("BarCode"); 
				String totalNum=obj.getString("DeployNum");
				PageData pg=new PageData(); 
				pg.put("BarCode", barCode);
				pg.put("WhsId", pb.getString("OutWarehouseNo"));
				//查询出库库存商品信息
				PageData p= (PageData) dao.findForObject("commonXMapper.findByWhsId",pg);  
				//查询入库库存商品信息 
				pg.put("inWHNo", pb.getString("InWarehouseNo")); 
				PageData pga=(PageData) dao.findForObject("commonXMapper.findByinWHNo",pg);
				PageData pa=null;
				if(p!=null){   
					int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))-Integer.parseInt(totalNum);
					pa=new PageData();
					pa.put("InventoryQuantity", Quantity);
					pa.put("Id", p.getString("Id"));   
					dao.update("commonXMapper.updateInventory", pa);  
				} 
				if(pga!=null){
					int Qty=Integer.parseInt(pga.getString("InventoryQuantity"))+Integer.parseInt(totalNum);
					pa=new PageData();
					pa.put("InventoryQuantity", Qty);
					pa.put("Id", pga.getString("Id"));   
					dao.update("commonXMapper.updateInventory", pa); 
				}else{	
					pa=new PageData();
					pa.put("InventoryQuantity",totalNum );
					pa.put("ProductBarCode",barCode);  
					pa.put("WarehouseNo",pb.getString("InWarehouseNo"));
					pa.put("Status", 1);
					dao.save("IncomeXMapper.saveInventory", pa); 
				} 
			}
		}   
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "commonXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("commonXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}

}
