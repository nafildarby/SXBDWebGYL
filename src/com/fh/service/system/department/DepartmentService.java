package com.fh.service.system.department;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.PageData;

@Service("departmentService")
public class DepartmentService {

	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 部门列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listPdPageDepartment(Page page)throws Exception{
		return (List<PageData>) dao.findForList("UserXMapper.userlistPage", page);
	}
}
