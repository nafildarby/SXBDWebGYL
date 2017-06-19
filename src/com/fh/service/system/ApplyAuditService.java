/**
 * 
 */
package com.fh.service.system;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fh.entity.Page;
import com.fh.entity.system.ApplyAudit;
import com.fh.entity.system.FlowDetail;
import com.fh.entity.system.User;
import com.fh.service.BaseService;
import com.fh.util.PageData;

/**
 * 类名：FlowManageService
 * 创建人： PuLifan
 * 创建时间：  2016-9-21
 * @version 
 */

@Service("ApplyAuditService")
public class ApplyAuditService extends BaseService{

	/**
	 * 通过角色Id查询待办事项
	 */
	public List<PageData> findTodolistByRoleId(Page page) throws Exception {
		return listAllInfo(page,"ApplyAuditMapper.findTodolistByRoleId");
	}
	
}
