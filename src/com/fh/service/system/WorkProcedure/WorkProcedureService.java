package com.fh.service.system.WorkProcedure;

import java.util.List; 

import javax.annotation.Resource; 

import org.springframework.stereotype.Service; 
import org.springframework.transaction.annotation.Transactional;

import com.fh.dao.DaoSupport;  
import com.fh.entity.Page; 
import com.fh.entity.system.AskforDetail;
import com.fh.entity.system.FlowDetail;
import com.fh.entity.system.MenuFlow;
import com.fh.service.BaseService;
import com.fh.util.PageData;


@Service("workProcedureService")
public class WorkProcedureService extends BaseService {
	
	/**
	 * 分页显示流程信息
	 */
	public List<PageData> listPageworkProcedure(Page page) throws Exception {
		return  listPageInfo(page, "WorkProcedureMapper.listPageworkProcedure");
	}

	/*
	 * 查询全部流程信息
	 */
	public List<PageData> listworkProcedure(Page page) throws Exception {
		return listAllInfo(page,"WorkProcedureMapper.listworkProcedure");
	}
	
	/*
	 * 保存流程信息
	 */
	@Transactional
	public void saveFlow(PageData pd,List p)throws Exception{
		dao.save("WorkProcedureMapper.saveFlow", pd); 
		dao.save("WorkProcedureMapper.saveFlowDetail", p);
	}	

	/*
	 * 删除流程信息数据
	 */
	@Transactional
	public void deleteWorkFlow(PageData pd) throws Exception {
		dao.delete("WorkProcedureMapper.deleteWorkFlow", pd);	
		dao.delete("WorkProcedureMapper.deleteFlowDetail", pd);
	}
	
	/**
	 * 通过id查找
	 */
	public PageData findFlowByCodeNo(PageData pd) throws Exception {
		return (PageData)dao.findForObject("WorkProcedureMapper.findFlowByCodeNo", pd);
	}
 
	/**
	 * 通过编号查找流程明细信息
	 */
	public List<FlowDetail> findDetailByCodeNo(PageData pd)throws Exception {
		return (List<FlowDetail>) dao.findForList("WorkProcedureMapper.findDetailByCodeNo",pd);
	}
	
	/*
	 * 修改流程信息
	 */
	@Transactional
	public void updateFlow(PageData pd, List p)throws Exception {
		dao.update("WorkProcedureMapper.editFlow", pd); 
		dao.delete("WorkProcedureMapper.deleteFlowDetail", pd);
		dao.save("WorkProcedureMapper.saveFlowDetail", p);
	}

	/*
	 * 流程分配信息
	 */
	@Transactional
	public void savedistribution(PageData pd) throws Exception {
		dao.delete("WorkProcedureMapper.deletedistribution", pd);
		dao.save("WorkProcedureMapper.savedistribution", pd); 
	}

	/*
	 * 流程分配信息验证
	 */
	public List<MenuFlow> ValidationMenuFlow(PageData pd) throws Exception{
		return (List<MenuFlow>) dao.findForList("WorkProcedureMapper.ValidationMenuFlow",pd);
	}
}
