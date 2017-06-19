/**
 * 
 */
package com.fh.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.PageData; 

/**
 * 类名：BaseService 创建人： PuLifan 创建时间： 2016-9-21
 * 
 * @version
 */

@Service("BaseService")
public class BaseService {

	@Resource(name = "daoSupport")
	protected DaoSupport dao;

	/**
	 * 根据page信息和mybaits的配置id获取相应的分页列表信息
	 * 
	 * @param page
	 *            页面传过来的page信息,包括查询条件和分页信息
	 * @param mapCfgId
	 *            mybatis的配置Id
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listPageInfo(Page page, String mapCfgId)
			throws Exception {
		return (List<PageData>) dao.findForList(mapCfgId, page);
	}

	/**
	 * 根据page信息和mybaits的配置id获取相应的所有列表信息
	 * 
	 * @param page
	 *            页面传过来的page信息,主要为查询条件,分页信息不匹配分页表达式,不做考虑,查询所有
	 * @param mapCfgId
	 *            mybatis的配置Id
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listAllInfo(Page page, String mapCfgId) throws Exception {
		return (List<PageData>) dao.findForList(mapCfgId, page);
	}


	public void saveApplyFlow(PageData pd, String mapperFileName,PageData pt) throws Exception {
		dao.save("FlowMapper.insertApplyFlow", pd);
		dao.update( mapperFileName + ".updateFlowStatus",pd); 
		dao.save("FlowMapper.insertApplyRecord", pt);
	}

	/**
	 * 流程处理完成写入业务数据
	 * @param pd
	 * @param mapperFileName
	 * @throws Exception
	 */
	public void saveBusinessFlow(PageData pd, String mapperFileName,PageData pt)throws Exception {
		dao.save("FlowMapper.insertApplyFlow", pd);
		dao.update( mapperFileName + ".updateFlowStatus",pd); 
		dao.save("FlowMapper.insertApplyRecord", pt);
	}
	
	/**
	 * 更新流程表审核步骤状态并添加审核流水记录
	 * @param pd
	 * @throws Exception
	 */
	public void doApplyRecord(PageData pd) throws Exception {
		PageData pa = (PageData) dao.findForObject("FlowMapper.findFlowInfo", pd);
		PageData pc = new PageData();
		pc.put("Id", pa.getString("Id"));
		pc.put("CurrentStep", pa.get("CurrentStep"));
		dao.update("FlowMapper.updateApplyFlow", pc);		
		pd.put("CurrentStep",pa.get("CurrentStep"));
		PageData pt = (PageData) dao.findForObject("FlowMapper.findNodeNameByNo", pd);		
		pd.put("NodeName", pt.getString("NodeName"));  
		dao.save("FlowMapper.insertApplyRecord", pd);
	}

 
}
