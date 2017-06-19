package com.fh.controller.base;


import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
import javax.servlet.http.HttpServletRequest;

import com.fh.entity.system.Menu;
import com.fh.entity.system.Role;
import com.fh.entity.system.User;
import com.fh.service.BaseService;
import com.fh.service.system.flow.FlowService;
import com.fh.service.system.menu.MenuService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.fh.entity.Page;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.Logger;
import com.fh.util.PageData; 
import com.fh.util.UuidUtil;

public class BaseController {
	
	protected Logger logger = Logger.getLogger(this.getClass());

	private static final long serialVersionUID = 6357869213649815390L;

	@Autowired
	private MenuService menuService;
	
	@Autowired
	protected FlowService flowService;
	
	/**
	 * 得到PageData
	 */
	public PageData getPageData(){
		return new PageData(this.getRequest());
	}
	
	/**
	 * 得到ModelAndView
	 */
	public ModelAndView getModelAndView(){
		return new ModelAndView();
	}
	
	/**
	 * 得到request对象
	 */
	public HttpServletRequest getRequest() {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
		
		return request;
	}

	/**
	 * 得到32位的uuid
	 * @return
	 */
	public String get32UUID(){
		
		return UuidUtil.get32UUID();
	}
	
	/**
	 * 得到分页列表的信息 
	 */
	public Page getPage(){
		
		return new Page();
	}
	
	public static void logBefore(Logger logger, String interfaceName){
		logger.info("");
		logger.info("start");
		logger.info(interfaceName);
	}
	
	public static void logAfter(Logger logger){
		logger.info("end");
		logger.info("");
	}


	protected Object applyAudit(String menuUrl, String mapperFileName, BaseService service) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		PageData flowPd = flowService.findFlowByApplyNo(pd);
		
		if(null == flowPd){
			User user = (User) this.getSession().getAttribute(Const.SESSION_USERROL);
			Menu menu = menuService.getMenuByUrl(menuUrl);
			pd.put("menuId", menu.getMENU_ID());
			pd.put("memuName", menu.getMENU_NAME());
			pd.put("userRoleId", user.getRole().getROLE_ID());
			
			PageData auditPd = flowService.findFlowByMenuAndRole(pd);
			auditPd.put("memuName", pd.get("memuName"));
			auditPd.put("applyTime", new Date());
			auditPd.put("ApplyNo", pd.get("ApplyNo"));
			auditPd.put("status", 0); 
			
			PageData pt=new PageData();
		 	pt.put("ApplyNo", pd.get("ApplyNo"));
			pt.put("ApplyTime", new Date());
			pt.put("FlowOrder", auditPd.get("FlowOrder"));
			pt.put("NodeName", auditPd.get("NodeName"));
			pt.put("UserName",  this.getSession().getAttribute(Const.SESSION_USERNAME)); 
			
			
			if(auditPd.getString("EndRole").equals("-1")){
				auditPd.put("auditStatus", 2);
				service.saveBusinessFlow(auditPd, mapperFileName,pt);
				terminateFlow(auditPd);
			}
			else {				
				auditPd.put("auditStatus", 1);
				service.saveApplyFlow(auditPd, mapperFileName,pt);
			}

			map.put("msg","success");
		}
		return map;
	}
	
	
	/* ===============================权限================================== */
	public Map<String, String> getHC() {
		Subject currentUser = SecurityUtils.getSubject(); // shiro管理的session
		Session session = currentUser.getSession();
		return (Map<String, String>) session.getAttribute(Const.SESSION_QX);
	}
	/* ===============================权限================================== */
	
	/**
	 * 获取当前http中的用户session
	 * @return
	 */
	public Session getSession(){
		Subject currentUser = SecurityUtils.getSubject(); // shiro管理的session
		Session session = currentUser.getSession();
		return session;
	}

	/**
	 * 审批人员进行审批处理
	 * @return
	 * @throws Exception
	 */
	public Object doFlowAuthentication() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();
		PageData  pt = flowService.findFlowInfoByApplyNo(pd);
		pt.put("Common", pd.getString("Common"));
		pt.put("ApplyTime", DateUtil.getTime());
		pt.put("UserName", this.getSession().getAttribute(Const.SESSION_USERNAME)); 
		if(pt.get("EndRole").toString().equals("-1")){
			// 如果下一步要处理的角色为-1，即为流程的最后处理完成环节，则进行完结处理
			terminateFlow(pt);
		}
		else{
			flowService.saveApplyRecord(pt);
		}		
		map.put("msg", "success");
		return map;
	}


	public void terminateFlow(PageData pageData){}
	
	/**
	 * 查询审批步骤信息
	 * @param pd
	 * @param mv
	 * @throws Exception
	 */
	
	public void queryApplyInfo(PageData pd, ModelAndView mv) throws Exception{
		//查询审批流水信息 		
		List<PageData> applylist= flowService.findApplyByNo(pd);  
		//流程步骤整体信息
		List<PageData> plist= flowService.findDetail(pd);
		
		PageData auditInfo = flowService.findFlowByApplyNo(pd);
		
		Role role = ((User) this.getSession().getAttribute(Const.SESSION_USERROL)).getRole();  
		if(applylist.size()>0||plist.size()>0||auditInfo!=null){ 
			if(role.getROLE_ID().equals(auditInfo.getString("EndRole")) ){
				mv.addObject("isShow", true);
			} 
			if(Integer.parseInt(auditInfo.getString("CurrentStep")) + 1 >= plist.size()){
				mv.addObject("isOver", true);			
			}
			mv.addObject("currentStep", auditInfo.getString("CurrentStep"));
		}
		mv.addObject("aplist",applylist);
		mv.addObject("plist",plist);
	}

}
