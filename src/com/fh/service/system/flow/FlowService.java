/**
 * 
 */
package com.fh.service.system.flow;

import java.util.List;

import javax.annotation.Resource;

import com.fh.service.BaseService;
import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.util.PageData;
import org.springframework.transaction.annotation.Transactional;

/**
 * 类名：FlowService 创建人： PuLifan 创建时间： 2016-10-13
 * 
 * @version
 */

@Service("flowService")
public class FlowService extends BaseService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	/**
	 * 初次提交流程审批申请，需要根据业务菜单和当前用户角色查询本次审批的数据
	 * 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData findFlowByMenuAndRole(PageData pd) throws Exception {
		return (PageData) dao.findForObject("FlowMapper.findFlowByUrlAndRole", pd);
	}

	/**
	 * 根据申请单号查询当前申请表中是否已经存在当前单据的审核流程
	 * 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData findFlowByApplyNo(PageData pd) throws Exception {
		return (PageData) dao.findForObject("FlowMapper.findFlowInfo", pd);
	}

	public void updateApplyFlow(PageData pd) throws Exception {
		dao.update("FlowMapper.updateApplyFlow", pd);
	}

	/**
	 * 根据处理单号查询审批信息
	 * 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData findFlowInfoByApplyNo(PageData pd) throws Exception {
		return (PageData) dao.findForObject("FlowMapper.findFlowInfoByApplyNo", pd);
	}

	/**
	 * 通过流程编号查询审核流水信息
	 * 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findApplyByNo(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("FlowMapper.findApplyByNo", pd);
	}

	/**
	 * 查询审批明细信息
	 * 
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findDetail(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("FlowMapper.findDetail", pd);
	}

	/**
	 * 审核记录数据保存
	 * @param pd
	 * @throws Exception
	 */
	@Transactional
	public void saveApplyRecord(PageData pd) throws Exception {
		super.doApplyRecord(pd);
	}

}
