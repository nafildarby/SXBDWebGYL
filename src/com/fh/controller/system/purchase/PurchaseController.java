package com.fh.controller.system.purchase;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.entity.PageJson;
import com.fh.entity.system.Role;
import com.fh.service.system.menu.MenuService;
import com.fh.service.system.purchase.PurchaseService;
import com.fh.service.system.role.RoleService;
import com.fh.service.system.user.UserService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.FileDownload;
import com.fh.util.FileUpload;
import com.fh.util.GetPinyin;
import com.fh.util.Jurisdiction;
import com.fh.util.MD5;
import com.fh.util.ObjectExcelRead;
import com.fh.util.PageData;
import com.fh.util.ObjectExcelView;
import com.fh.util.PathUtil;
import com.fh.util.Tools;

@Controller
@RequestMapping(value = "/Purchase")
public class PurchaseController extends BaseController {

	String menuUrl = "Purchase/Purchases.do"; // 菜单地址(权限用)
	@Resource(name = "PurchaseService")
	private PurchaseService purchaseService;

	
	/**
	 * 显示采购单据列表
	 */
	@RequestMapping(value = "/purchaselist")
	public ModelAndView purchaselist() throws Exception {
		
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		List<PageData> purchaseList = purchaseService.PurchaseList();   
		mv.setViewName("system/purchase/purchase_list");
		mv.addObject("pdlist", purchaseList); 
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
	
	@RequestMapping(value = "/listPurchasePage")
	@ResponseBody
	public Map<String, Object> listPurchasePage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();

		String PurchaseNo = pd.getString("PurchaseNo");

		if (null != PurchaseNo && !"".equals(PurchaseNo)) {
			PurchaseNo = PurchaseNo.trim();
			pd.put("PurchaseNo", PurchaseNo);
		}

		List<PageData> purchaseList = purchaseService.listPdPagePurchase(page); // 列出采购单据列表
		if (purchaseList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", purchaseList);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}

		return null;
	}
	
	/**
	 * 保存采购单据
	 */
	@RequestMapping(value = "/saveP")
	public ModelAndView saveP(PrintWriter out) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
				purchaseService.saveP(pd);
			// 判断新增权限
			mv.addObject("msg", "success");
		} else {
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 修改采购单据
	 */
	@RequestMapping(value = "/editP")
	@ResponseBody
	public Object editP() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();
		if (Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
			purchaseService.editP(pd);
		}
		map.put("msg", "success");
		return AppUtil.returnObject(new PageData(), map);
	}

	/**
	 * 去修改采购单据页面
	 */
	@RequestMapping(value = "/goEditP")
	public ModelAndView goEditP() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		pd = purchaseService.findByPid(pd); // 根据ID读取
		mv.setViewName("system/purchase/purchase_edit");
		mv.addObject("msg", "editP");
		mv.addObject("pd", pd);

		return mv;
	}

	/**
	 * 去新增采购单据页面
	 */
	@RequestMapping(value = "/goAddP")
	public ModelAndView goAddU() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		mv.setViewName("system/purchase/purchase_edit");
		mv.addObject("msg", "saveP");
		mv.addObject("pd", pd);

		return mv;
	}

//	/**
//	 * 显示用户列表(用户组)
//	 */
//	@RequestMapping(value = "/listUsers")
//	public ModelAndView listUsers(Page page) throws Exception {
//		ModelAndView mv = this.getModelAndView();
//		PageData pd = new PageData();
//		pd = this.getPageData();
//
//		String USERNAME = pd.getString("USERNAME");
//
//		if (null != USERNAME && !"".equals(USERNAME)) {
//			USERNAME = USERNAME.trim();
//			pd.put("USERNAME", USERNAME);
//		}
//
//		String lastLoginStart = pd.getString("lastLoginStart");
//		String lastLoginEnd = pd.getString("lastLoginEnd");
//
//		if (lastLoginStart != null && !"".equals(lastLoginStart)) {
//			lastLoginStart = lastLoginStart + " 00:00:00";
//			pd.put("lastLoginStart", lastLoginStart);
//		}
//		if (lastLoginEnd != null && !"".equals(lastLoginEnd)) {
//			lastLoginEnd = lastLoginEnd + " 00:00:00";
//			pd.put("lastLoginEnd", lastLoginEnd);
//		}
//
//		List<PageData> userList = userService.listPdPageUser(page); // 列出用户列表
//		List<Role> roleList = roleService.listAllERRoles(); // 列出所有二级角色
//
//		mv.setViewName("system/user/user_list");
//		mv.addObject("userList", userList);
//		mv.addObject("roleList", roleList);
//		mv.addObject("pd", pd);
//		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
//		return mv;
//	}

//	@RequestMapping(value = "/listUsersPage")
//	@ResponseBody
//	public Map<String, Object> listUserPage(Page page) throws Exception {
//
//		PageData pd = new PageData();
//		pd = this.getPageData();
//
//		String USERNAME = pd.getString("USERNAME");
//
//		if (null != USERNAME && !"".equals(USERNAME)) {
//			USERNAME = USERNAME.trim();
//			pd.put("USERNAME", USERNAME);
//		}
//
//		String lastLoginStart = pd.getString("lastLoginStart");
//		String lastLoginEnd = pd.getString("lastLoginEnd");
//
//		if (lastLoginStart != null && !"".equals(lastLoginStart)) {
//			lastLoginStart = lastLoginStart + " 00:00:00";
//			pd.put("lastLoginStart", lastLoginStart);
//		}
//		if (lastLoginEnd != null && !"".equals(lastLoginEnd)) {
//			lastLoginEnd = lastLoginEnd + " 00:00:00";
//			pd.put("lastLoginEnd", lastLoginEnd);
//		}
//
//		List<PageData> userList = userService.listPdPageUser(page); // 列出用户列表
//		if (userList != null) {
//			Map<String, Object> result = new HashMap<String, Object>();
//			result.put("total", page.getTotalResult());
//			result.put("rows", userList);
//			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
//		}
//
//		return null;
//	}

//	/**
//	 * 显示用户列表(tab方式)
//	 */
//	@RequestMapping(value = "/listtabUsers")
//	public ModelAndView listtabUsers(Page page) throws Exception {
//		ModelAndView mv = this.getModelAndView();
//		PageData pd = new PageData();
//		pd = this.getPageData();
//		List<PageData> userList = userService.listAllUser(pd); // 列出用户列表
//		mv.setViewName("system/user/user_tb_list");
//		mv.addObject("userList", userList);
//		mv.addObject("pd", pd);
//		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
//		return mv;
//	}

	/**
	 * 删除采购单据
	 */
	@RequestMapping(value = "/deleteP")
	public void deleteP(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
				purchaseService.deleteP(pd);
			}
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	// ===================================================================================================

	@InitBinder
	public void initBinder(WebDataBinder binder) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,
				true));
	}

	/* ===============================权限================================== */
	public Map<String, String> getHC() {
		Subject currentUser = SecurityUtils.getSubject(); // shiro管理的session
		Session session = currentUser.getSession();
		return (Map<String, String>) session.getAttribute(Const.SESSION_QX);
	}
	/* ===============================权限================================== */
}
