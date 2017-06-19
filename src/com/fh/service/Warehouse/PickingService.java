package com.fh.service.Warehouse;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.service.BaseService;
import com.fh.util.PageData;


@Service("PickingService")
public class PickingService extends BaseService {

	/*查询所有的领料出库信息*/
	public List<PageData> picklistPage(Page page) throws Exception {
		return listPageInfo(page,"pickXMapper.picklistPage");
	}
	
	/*查找领料申请单据信息 */
	@SuppressWarnings("unchecked")
	public List<PageData> listGoodsApply(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("pickXMapper.listGoodsApply",pd); 
	}
	
	/*根据物料申请单号查询商品信息*/
	@SuppressWarnings("unchecked")
	public List<PageData> SelectByApply(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("pickXMapper.SelectByApply",pd); 
	}
	
	/*保存领料出库商品信息*/
	@Transactional
	public void savePicking(PageData pd, List jsonArray) throws Exception {
		dao.save("pickXMapper.saveApplyPick", pd);  
		dao.save("pickXMapper.savePickGoodsDetail", jsonArray); 
	}
	
	/*查询领料单据商品信息*/
	@SuppressWarnings("unchecked")
	public List<PageData> findGoodsByNo(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("pickXMapper.findGoodsByNo",pd); 
	}
	
	/*查询领料单据信息*/
	public PageData findApplyDetailByNo(PageData pd) throws Exception { 
		return (PageData) dao.findForObject("pickXMapper.findApplyDetailByNo", pd); 
	} 
	  

	/*删除领料记录信息*/ 
	public void deletePick(PageData pd) throws Exception {		
		dao.delete("pickXMapper.deletePick", pd); 
	}
	 
	
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("PickingNo",pd.getString("ApplyNo"));
		//查询领料单据信息
		PageData pb=(PageData) dao.findForObject("pickXMapper.findApplyDetailByNo", allotpg);
		PageData pdata=new PageData();
		pdata.put("GoodsApplyNo",pb.getString("GoodsApplyNo"));
		//查询物料申请中的入库仓库
		PageData pt=(PageData) dao.findForObject("pickXMapper.findApplyWHNoByNo", pdata);
		//查询领料单据商品信息
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("pickXMapper.findGoodsByNo",allotpg); 
		if(list==null) return;
		for(Object jsonObj: list){ 
			JSONObject obj = JSONObject.fromObject(jsonObj);
			String barCode = obj.getString("Barcode"); 
			String totalNum=obj.getString("DeployNum");
			PageData pg=new PageData(); 
			pg.put("BarCode", barCode);
			pg.put("WhsId", pb.getString("outWHNo"));
			//查询出库库存商品信息
			PageData p= (PageData) dao.findForObject("allotXMapper.findByWhsId",pg);  
			//查询入库库存商品信息 
			pg.put("inWHNo", pt.getString("WHNo")); 
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
				pa.put("WarehouseNo",pt.getString("WHNo"));
				pa.put("Status", 1);
				dao.save("allotXMapper.saveInventory", pa); 
			} 
		}
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "pickXMapper.updateFlowStatus",pd); 
	}

	/**
	 * 拒绝审批修改状态
	 * @param pd
	 * @throws Exception
	 */
	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("pickXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}
}
