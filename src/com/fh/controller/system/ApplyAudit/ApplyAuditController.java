package com.fh.controller.system.ApplyAudit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.entity.system.ApplyAudit;
import com.fh.entity.system.AskforDetail;
import com.fh.entity.system.Menu;
import com.fh.entity.system.Role;
import com.fh.entity.system.User;
import com.fh.service.Product.Product.ApplyService;
import com.fh.service.Warehouse.AllotService;
import com.fh.service.Warehouse.CheckService;
import com.fh.service.Warehouse.CommonService;
import com.fh.service.Warehouse.InComeService;
import com.fh.service.Warehouse.PickingService;
import com.fh.service.Warehouse.ScrapService;
import com.fh.service.system.ApplyAuditService;
import com.fh.service.system.askfor.AskforService;
import com.fh.service.system.menu.MenuService;
import com.fh.service.system.role.RoleService;
import com.fh.service.system.user.UserService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.MD5;
import com.fh.util.PageData;
import com.fh.util.RightsHelper;
import com.fh.util.Tools;

@Controller
@RequestMapping(value = "/applyAudit")
public class ApplyAuditController extends BaseController {
	@Resource(name = "ApplyAuditService")
	private ApplyAuditService appAuditService;
	@Resource(name = "AskforService")
	private AskforService askService;
	@Resource(name = "AllotService")
	private AllotService allotService; 
	@Resource(name = "PickingService")
	private PickingService pickingService;
	@Resource(name = "ScrapService")
	private ScrapService scrapService;
	@Resource(name = "CheckService")
	private CheckService checkService;  
	@Resource(name = "CommonService")
	private CommonService commonService;
	@Resource(name = "InComeService")
	private InComeService inComeService;
	@Resource(name = "ApplyService")
	private ApplyService applyService; 
	
	/**
	 * 根据角色Id查询待办事项
	 */
	@RequestMapping(value = "/findTodoList")
	@ResponseBody
	public Object findTodoList(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();
		
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USER);
		String RoleId = user.getROLE_ID();
		pd.put("RoleId", RoleId);
		page.setPd(pd);
		
		List<PageData> todolist = appAuditService.findTodolistByRoleId(page);
		
		if (todolist != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("entities", todolist);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	
	/**
	 *去各审核申请页面
	 **/ 
	@RequestMapping(value = "/toAudit")
	public ModelAndView toAudit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();
		String Name = pd.getString("ApplyNo");
		Name=Name.substring(0,4);
		if(Name.equals("CGSQ")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("AskforNo", applyNo);
			List<AskforDetail> Detaillist= askService.findDetailByAskNo(pd);
			JSONArray jsonArray = JSONArray.fromObject(Detaillist);
			pd = askService.findAskforByAskNo(pd); 
			if(pd.getString("AuditStatus").equals("3") || pd.getString("AuditStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("system/purchase/askfor_detail");
			mv.addObject("pd", pd);
			mv.addObject("askProduct", jsonArray);
			mv.addObject("aplist",applylist);


			return mv;
		}else if(Name.equals("DBDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("AllocationNo", applyNo);
			List<PageData> gdlist= allotService.findByOutGoods(pd);
			pd = allotService.findByOut(pd);
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Allot/Allot_select");
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("LLDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("PickingNo", applyNo);
			List<PageData> gdlist= pickingService.findGoodsByNo(pd);
			pd = pickingService.findApplyDetailByNo(pd); 
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Picking/picking_select");
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("BSDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("ScrappedNo", applyNo);
			List<PageData> gdlist= scrapService.findByGoods(pd); 
			pd = scrapService.findByScrap(pd);  
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Scrap/Scrap_select");
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("PDDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("CheckNo", applyNo);
			List<PageData> gdlist= checkService.findByCheckGoods(pd);
			pd = checkService.findByCheck(pd); 
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Check/Check_select"); 
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("CKDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("OutBoundNo", applyNo);
			List<PageData> gdlist= commonService.findByOutGoods(pd);
			pd = commonService.findByOut(pd);  
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Common/Common_select");  
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("RKDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("IncomeCode", applyNo);
			List<GoodsDetail> gdlist= inComeService.findByGoods(pd);
			pd = inComeService.findByIncome(pd);  
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Warehouse/Inbound/Inbound_Select");  
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}else if(Name.equals("WLSQDH")){
			List<PageData> applylist= flowService.findApplyByNo(pd);
			String applyNo = pd.getString("ApplyNo");
			pd.put("GoodsApplyNo", applyNo);
			List<PageData> gdlist= applyService.findByApplyDetail(pd); 
			pd = applyService.findByApply(pd); 
			if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
				mv.addObject("isShow", false);
			}else{
				mv.addObject("isShow", true);
			}
			mv.setViewName("Product/Apply/apply_select");  
			mv.addObject("pd", pd);
			mv.addObject("aplist",applylist);
			mv.addObject("gdlist", gdlist); 

			return mv;
		}
		
		return null;
	}
}
