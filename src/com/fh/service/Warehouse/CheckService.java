package com.fh.service.Warehouse;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.service.BaseService;
import com.fh.util.PageData;

@Service("CheckService")
public class CheckService extends BaseService {

	//查询所有的盘点信息
	public List<PageData> ChecklistPage(Page page) throws Exception {
		return listPageInfo(page,"checkXMapper.ChecklistPage");
	}
	
	//根据仓库查询商品信息
	@SuppressWarnings("unchecked")
	public List<PageData> findGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("checkXMapper.findGoods",pd); 
	}
	
	//保存数据
	@Transactional
	public void saveCheck(PageData pd, List array) throws Exception { 
		dao.save("checkXMapper.saveCheck", pd);  
		dao.save("checkXMapper.saveDetail", array);  
	}

	//根据盘点单号查询盘点列表
	public PageData findByCheck(PageData pd) throws Exception {
		return (PageData) dao.findForObject("checkXMapper.findByCheck", pd); 
	}
	
	//根据盘点单号查询盘点商品信息
	@SuppressWarnings("unchecked")
	public List<PageData> findByCheckGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("checkXMapper.findByCheckGoods",pd);
	}

	//删除盘点信息表 
	public void deleteCheck(PageData pd) throws Exception { 
		dao.delete("checkXMapper.deleteCheck", pd);  
	}
	
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("CheckNo",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("checkXMapper.findByCheck", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("checkXMapper.findByCheckGoods",allotpg);  
		if(list!=null){ 
			for(Object jsonObj: list){ 
				JSONObject obj = JSONObject.fromObject(jsonObj);
				String barCode = obj.getString("BarCode"); 
				String CheckNum=obj.getString("CheckNum");
				PageData pg=new PageData(); 
				pg.put("BarCode", barCode);
				pg.put("WHNo", pb.getString("CheckWarehouseNo"));
				//查询出库库存商品信息
				PageData p= (PageData) dao.findForObject("checkXMapper.findByWHCheck",pg);   
				PageData pa=null;
				if(p!=null){    
					pa=new PageData();
					pa.put("InventoryQuantity", CheckNum);
					pa.put("Id", p.getString("Id"));   
					dao.update("checkXMapper.updateInventory", pa);  
				}  
			}   
		}
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus", 2);
		dao.update( "checkXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);
		pd.put("auditStatus", 3);
		dao.update( "checkXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}

}
