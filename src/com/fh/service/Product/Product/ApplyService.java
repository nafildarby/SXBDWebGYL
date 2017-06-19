package com.fh.service.Product.Product;

import java.util.List; 

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; 
import com.fh.entity.Page; 
import com.fh.service.BaseService;
import com.fh.util.PageData;

@Service("ApplyService")
public class ApplyService extends BaseService {

	public List<PageData> applylistPage(Page page) throws Exception{
		return listPageInfo(page,"applyXMapper.applylistPage");
	} 

	@Transactional
	public void saveApply(PageData pd, List jsonArray) throws Exception{
		dao.save("applyXMapper.saveApply", pd); 
		dao.save("applyXMapper.saveApplyDetail", jsonArray); 
	}

	
	public PageData findByApply(PageData pd)throws Exception{
		return (PageData) dao.findForObject("applyXMapper.findByApply", pd);
	}

	@SuppressWarnings("unchecked")
	public List<PageData> findByApplyDetail(PageData pd)throws Exception{
		return (List<PageData>) dao.findForList("applyXMapper.findByApplyDetail",pd); 
	}

	public void deleteApply(PageData pd)throws Exception{
		dao.delete("applyXMapper.deleteApply", pd);  
	}
	
	/**
	 * 审核完成后改变审核状态
	 * @throws Exception 
	 * */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception { 
		super.doApplyRecord(pd);  
		dao.update( "FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 2);
		dao.update( "applyXMapper.updateFlowStatus",pd); 
	}

	public void UpdateStatus(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyAudit",pd);  
		pd.put("auditStatus", 3);
		dao.update("applyXMapper.updateFlowStatus",pd); 
		super.doApplyRecord(pd);
	}
 
}
