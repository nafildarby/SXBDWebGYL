package com.fh.service.system.askfor;

import java.util.List; 

import javax.annotation.Resource;

import com.fh.service.BaseService;

import com.fh.service.system.IService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.dao.DaoSupport;  
import com.fh.entity.Page; 
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.entity.system.AskforDetail;
import com.fh.util.PageData;


@Service("AskforService")
public class AskforService extends BaseService implements IService{
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	 
	/**
	 * 分页显示采购申请信息
	 */
	public List<PageData> listAskforPage(Page page) throws Exception {
		return (List<PageData>) dao.findForList("AskforMapper.listPageAskfor",page);
	}

	/*
	 * 显示所有采购申请信息
	 */
	public List<PageData> listAskfor(Page page) throws Exception {
		return (List<PageData>) dao.findForList("AskforMapper.listAskfor",page);
	}
	
	/*
	 * 显示所有未审核通过的采购申请信息
	 */
	public List<PageData> listAskforAudit(Page page) throws Exception {
		return (List<PageData>) dao.findForList("AskforMapper.listAskforAudit",page);
	}

	/**
	 * 分页显示未审核采购申请信息
	 */
	public List<PageData> listAskforAuditPage(Page page) throws Exception {
		return (List<PageData>) dao.findForList("AskforMapper.listAskforAuditPage",page);
	}
	
	/*
	 * 删除采购申请数据
	 */
	public void deleteAskfor(PageData pd) throws Exception {
		dao.delete("AskforMapper.deleteAskfor", pd);		
	}
 
	/*
	 * 保存采购申请信息
	 */
	@Transactional
	public void saveAskfor(PageData pd,List p)throws Exception{
		dao.save("AskforMapper.saveAskfor", pd); 
		dao.save("AskforMapper.saveAskforDetail", p);
	}	
	
	/**
	 * 通过申请编号查找采购申请
	 */
	public PageData findAskforByAskNo(PageData pd)throws Exception {
		return (PageData) dao.findForObject("AskforMapper.findAskforByAskNo", pd);
	}

	/**
	 * 通过申请编号查找采购申请明细信息返回JSON数据
	 */
	public List<AskforDetail> findDetailByAskNo(PageData pd)throws Exception {
		return (List<AskforDetail>) dao.findForList("AskforMapper.findDetailByAskNo",pd);
	}

	/*
	 * 修改采购申请信息
	 */
	@Transactional
	public void editAskfor(PageData pd, List p)throws Exception {
		dao.update("AskforMapper.editAskfor", pd); 
		dao.delete("AskforMapper.deleteAskforDetail", pd);
		dao.save("AskforMapper.saveAskforDetail", p);
	}
	
	/**
	 * 通过申请编号查找采购申请信息
	 */
	public PageData findByAskfor(PageData pd) throws Exception {
		return (PageData) dao.findForObject("AskforMapper.findByAskfor", pd); 
	}
	
	/**
	 * 结束审核
	 */
	@Transactional 
	public void saveBusinessData(PageData pd) throws Exception {
		dao.update("ApplyAuditMapper.editApplyAudit", pd); 
		String applyNo = pd.getString("ApplyNo");
		pd.put("AskforNo", applyNo);
		dao.update("AskforMapper.endApply", pd); 
	}
}
