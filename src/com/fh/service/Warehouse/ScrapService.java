package com.fh.service.Warehouse;

import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.service.BaseService;
import com.fh.util.PageData;


@Service("ScrapService")
public class ScrapService extends BaseService {

	public List<PageData> scraplistPage(Page page) throws Exception {
		return listPageInfo(page,"scrapXMapper.scraplistPage");
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("scrapXMapper.scrapGoods",pd); 
	}

	@Transactional
	public void saveScrap(PageData pd, List array) throws Exception { 
		dao.save("scrapXMapper.saveScrap", pd);  
		dao.save("scrapXMapper.saveScrapDetail", array); 
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findByGoods(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("scrapXMapper.findByGoods",pd);
	}

	public PageData findByScrap(PageData pd) throws Exception {
		return (PageData) dao.findForObject("scrapXMapper.findByScrap", pd); 
	}

	public void deleteScrap(PageData pd) throws Exception { 
		dao.delete("scrapXMapper.deleteScrap", pd); 
	}
	/**
	 * 审核完成后写入业务数据
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd); 
		PageData allotpg=new PageData();
		allotpg.put("ScrappedNo",pd.getString("ApplyNo"));
		PageData pb=(PageData) dao.findForObject("scrapXMapper.findByScrap", allotpg);  
		@SuppressWarnings("unchecked")
		List<PageData> list=(List<PageData>) dao.findForList("scrapXMapper.findByGoods",allotpg); 
		for(Object jsonObj: list){ 
			JSONObject obj = JSONObject.fromObject(jsonObj);
			String barCode = obj.getString("BarCode"); 
			String num=obj.getString("Number");
			PageData pg=new PageData(); 
			pg.put("BarCode", barCode);
			pg.put("WarehouseNo", pb.getString("WarehouseNo"));
			//查询库存商品信息
			PageData p= (PageData) dao.findForObject("scrapXMapper.findByWhsId",pg);   
			PageData pa=null;
			if(p!=null){   
				int Quantity=Integer.parseInt(p.getString("InventoryQuantity"))-Integer.parseInt(num);
				pa=new PageData();
				pa.put("Quantity", Quantity);
				pa.put("Id", p.getString("Id"));   
				dao.update("scrapXMapper.updateInventory", pa);  
			}  
		}   
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "scrapXMapper.updateFlowStatus",pd); 
	}

	/**
	 * 拒绝审批修改状态
	 * @param pd
	 * @throws Exception
	 */
	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("scrapXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}
}
