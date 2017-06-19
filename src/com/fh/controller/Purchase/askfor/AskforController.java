package com.fh.controller.Purchase.askfor; 

import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import javax.annotation.Resource;

import com.fh.entity.system.*;
import com.fh.service.system.ApplyAuditService;
import com.fh.service.system.menu.MenuService;

import net.sf.json.JSONArray;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;  
import org.springframework.web.servlet.ModelAndView; 

import com.fh.controller.base.BaseController;
import com.fh.entity.Page; 
import com.fh.entity.Product.Category;
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.service.Product.Category.CategoryService;
import com.fh.service.Product.Product.ProductService;  
import com.fh.service.Warehouse.AllotService;
import com.fh.service.system.Supplier.SupplierService;
import com.fh.service.system.askfor.AskforService;
import com.fh.service.system.comboItem.ComboItemService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;


@Controller
@RequestMapping(value = "/Askfor")
public class AskforController extends BaseController {
	
	String menuUrl = "Askfor/askforlist.do";

	private String mapperFileName = "AskforMapper";
	
	@Resource(name = "AskforService")
	private AskforService askService;
	@Resource(name = "ProductService")
	private ProductService pdService;
	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "ApplyAuditService")
	private ApplyAuditService applyService;
	

	  
	/**
	 * 显示采购申请列表
	 */
	@RequestMapping(value = "/askforlist")
	public ModelAndView askforlist(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		
		String AskforNo = pd.getString("AskforNo");
		String AskforPerson = pd.getString("AskforPerson");
		
		if (null != AskforNo && !"".equals(AskforNo)) {
			AskforNo = AskforNo.trim();
			pd.put("AskforNo", AskforNo);
		}
		
		if (null != AskforPerson && !"".equals(AskforPerson)) {
			AskforPerson = AskforPerson.trim();
			pd.put("AskforPerson", AskforPerson);
		}
		
		page.setPd(pd);
//		List<PageData> asklist = askService.listAskfor(page);
		mv.setViewName("system/purchase/askfor_list");
//		mv.addObject("askforList", asklist);
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
	
	/**
	 * 采购申请分页查询
	 */
	@RequestMapping(value = "/listAskforPage")
	@ResponseBody
	public Map<String, Object> listAskforPage(Page page) throws Exception {  
		PageData pd = new PageData();
		pd = this.getPageData();

		String AskforNo = pd.getString("AskforNo");
		String AskforPerson = pd.getString("AskforPerson");
		
		if (null != AskforNo && !"".equals(AskforNo)) {
			AskforNo = AskforNo.trim();
			pd.put("AskforNo", AskforNo);
		}
		
		if (null != AskforPerson && !"".equals(AskforPerson)) {
			AskforPerson = AskforPerson.trim();
			pd.put("AskforPerson", AskforPerson);
		}
		
		page.setPd(pd);
		List<PageData> applicationList = askService.listAskforPage(page); 
		if (applicationList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", applicationList);
			return result;
		}
		return null;
	}
	
	/**
	 * 显示未审核的采购申请列表
	 */
	@RequestMapping(value = "/AskforAuditlist")
	public ModelAndView AskforAuditlist(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		
		String AskforNo = pd.getString("AskforNo");
		String AskforPerson = pd.getString("AskforPerson");
		
		if (null != AskforNo && !"".equals(AskforNo)) {
			AskforNo = AskforNo.trim();
			pd.put("AskforNo", AskforNo);
		}
		
		if (null != AskforPerson && !"".equals(AskforPerson)) {
			AskforPerson = AskforPerson.trim();
			pd.put("AskforPerson", AskforPerson);
		}
		
		page.setPd(pd);
		List<PageData> asklist = askService.listAskforAudit(page);   
		mv.setViewName("system/purchase/askforAudit_list");
		mv.addObject("askforList", asklist); 
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
	
	/**
	 * 未审核采购申请分页查询
	 */
	@RequestMapping(value = "/listAskforAuditPage")
	@ResponseBody
	public Map<String, Object> listAskforAuditPage(Page page) throws Exception {  
		PageData pd = new PageData();
		pd = this.getPageData();

		String AskforNo = pd.getString("AskforNo");
		String AskforPerson = pd.getString("AskforPerson");
		
		if (null != AskforNo && !"".equals(AskforNo)) {
			AskforNo = AskforNo.trim();
			pd.put("AskforNo", AskforNo);
		}
		
		if (null != AskforPerson && !"".equals(AskforPerson)) {
			AskforPerson = AskforPerson.trim();
			pd.put("AskforPerson", AskforPerson);
		}
		
		page.setPd(pd);
		List<PageData> applicationList = askService.listAskforAuditPage(page); 
		if (applicationList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", applicationList);
			return result;
		}
		return null;
	}

	/**
	 * 提交采购申请审批
	 */
	@RequestMapping(value = "/applyAudit")
	@ResponseBody
	public Object applyAudit() throws Exception {
		Object result = null;
		result = super.applyAudit(menuUrl , mapperFileName, askService);
		return result;
	}

	/**
	 * 删除采购申请信息
	 */
	@RequestMapping(value = "/deleteAskfor")
	public void deleteAskfor(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
				askService.deleteAskfor(pd);
			}
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 去新增采购申请页面
	 */
	@RequestMapping(value = "/goAddAskfor")
	public ModelAndView goAddAskfor() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		mv.setViewName("system/purchase/askfor_edit");
		pd.put("AskforPerson", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("AskforNo", "CGSQ" + DateUtil.getTimes() + AppUtil.getRandomNum(4));
		mv.addObject("msg", "saveAskfor");
		mv.addObject("askProduct", new JSONArray());
		mv.addObject("pd", pd);

		return mv;
	}
	
	/**
	 * 去选择商品页面
	 */
	@RequestMapping(value = "/goSelectProduct")
	public ModelAndView goSelectProduct(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		List<PageData> pdlist = pdService.listProduct(page);
		mv.setViewName("system/admin/selectProduct");
		mv.addObject("pdlist", pdlist);
		mv.addObject("pd", pd);
		mv.addObject("msg", "saveAskProduct");
		mv.addObject(Const.SESSION_QX, this.getHC());

		return mv;
	}
	
	/**
	 * 回到新增采购申请页面
	 */
	@RequestMapping(value = "/saveSelectProduct")
	public ModelAndView saveSelectProduct(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String ProductList = pd.getString("ProductList");
		
		mv.setViewName("system/purchase/askfor_edit");
		mv.addObject("pd", pd);
		mv.addObject("msg", "saveAskfor");
		mv.addObject(Const.SESSION_QX, this.getHC());

		return mv;
	}
	
	/**
	 * 保存采购申请
	 */
	@RequestMapping(value = "/saveAskfor")
	@ResponseBody
	public Object saveAskfor() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		pd.put("AskforTime", new Date());
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);
		
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
			askService.saveAskfor(pd,(List)jsonArray); 
			map.put("msg", "success");
		}
		else {
			map.put("msg", "failed"); 	
		}
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	/**
	 * 去修改采购申请页面
	 */
	@RequestMapping(value = "/goEditAskfor")
	public ModelAndView goEditAskfor() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		pd = askService.findAskforByAskNo(pd); // 根据申请编号读取
		
		List<AskforDetail> Detaillist= askService.findDetailByAskNo(pd);
		JSONArray jsonArray = JSONArray.fromObject(Detaillist);
		mv.setViewName("system/purchase/askfor_edit");
		mv.addObject("msg", "editAskfor");
		mv.addObject("pd", pd);
		mv.addObject("askProduct", jsonArray);

		return mv;
	}
	
	/**
	 * 修改采购申请
	 */
	@RequestMapping(value = "/editAskfor")
	@ResponseBody
	public Object editAskfor() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();  
		
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
			askService.editAskfor(pd,(List)jsonArray); 
			map.put("msg", "success");
		}
		else {
			map.put("msg", "failed"); 	
		}
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	/**
	 * 查看采购申请明细
	 */
	@RequestMapping(value = "/goAskforDetail")
	public ModelAndView goAskforDetail(String Name) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		if(Name != null){
			pd.put("ApplyNo", Name);
		}
		String applyNo = pd.getString("AskforNo");
		pd.put("ApplyNo", applyNo);
		List<PageData> applylist = flowService.findApplyByNo(pd); 
		if(Name != null){
			pd.put("AskforNo", Name);
		}
		applyNo = pd.getString("ApplyNo");
		pd.put("AskforNo", applyNo);
		pd = askService.findAskforByAskNo(pd); // 根据申请编号读取
		if(pd.getString("ApprovalStatus").equals("3") || pd.getString("ApprovalStatus").equals("2")){
			mv.addObject("isShow", false);
		}else{
			mv.addObject("isShow", true);
		}
		List<AskforDetail> Detaillist= askService.findDetailByAskNo(pd);
		JSONArray jsonArray = JSONArray.fromObject(Detaillist);
		mv.setViewName("system/purchase/askfor_detail");
		mv.addObject("msg", "editAskfor");
		mv.addObject("pd", pd);
		mv.addObject("askProduct", jsonArray);
		mv.addObject("aplist",applylist);

		return mv;
	}
	
	/**
	 * 保存审核信息
	 */
	@RequestMapping(value = "/saveApply")
	@ResponseBody
	public Object saveApply() throws Exception{
		Map<String, String>  map = new HashMap<String, String>(); 
		//TODO 判断是否可以进行审核
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		String applyNo = pd.getString("ApplyNo");
		pd.put("AskforNo", applyNo);
		pd = askService.findByAskfor(pd);     
		if(pd.getString("AuditStatus").equals("2")){
			map.put("msg", "failed"); 
		}else{
			map = (Map) doFlowAuthentication();
		}
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	/**
	 * 结束审核
	 */
	@Override
	public void terminateFlow(PageData pageData) {
		try {
			pageData.put("AuditStatus", 2);
			askService.saveBusinessData(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 拒绝审核
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveApplyDataRepulse") 
	@ResponseBody
	public Object saveApplyDataRepulse() throws Exception{
		Map<String, String>  map = new HashMap<String, String>(); 
		//TODO 审核不通过
		PageData pd = new PageData(); 
		pd = this.getPageData();
		pd.put("AuditStatus", 3);
		askService.saveBusinessData(pd);
	 	map.put("msg", "success");   
		return AppUtil.returnObject(new PageData(), map); 
	}

	/* ===============================权限================================== */
	public Map<String, String> getHC() {
		Subject currentUser = SecurityUtils.getSubject(); // shiro管理的session
		Session session = currentUser.getSession();
		return (Map<String, String>) session.getAttribute(Const.SESSION_QX);
	}
	/* ===============================权限================================== */
}
