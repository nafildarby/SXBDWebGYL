package com.fh.controller.system.workflow; 

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import javax.annotation.Resource;   

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
import com.fh.entity.Product.Product;
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.entity.system.AskforDetail;
import com.fh.entity.system.ComboItem; 
import com.fh.entity.system.FlowDetail;
import com.fh.entity.system.Menu;
import com.fh.entity.system.MenuFlow;
import com.fh.entity.system.Role;
import com.fh.entity.system.Supplier;
import com.fh.service.Product.Category.CategoryService;
import com.fh.service.Product.Product.ProductService;  
import com.fh.service.system.Supplier.SupplierService;
import com.fh.service.system.WorkProcedure.WorkProcedureService;
import com.fh.service.system.comboItem.ComboItemService;
import com.fh.service.system.menu.MenuService;
import com.fh.service.system.role.RoleService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;
import com.google.gson.JsonArray;


@Controller
@RequestMapping(value = "/WorkProcedure")
public class WorkProcedureController extends BaseController {
	
	String menuUrl = "WorkProcedure/WorkProcedurelist.do";  
	@Resource(name = "workProcedureService")
	private WorkProcedureService workFlowService;
	@Resource(name = "roleService")
	private RoleService roleService;
	@Resource(name = "menuService")
	private MenuService menuService;
	  
	/**
	 * 显示流程列表
	 */
	@RequestMapping(value = "/WorkProcedurelist")
	public ModelAndView workProcedurelist(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 

		mv.setViewName("system/flow/flow_list");
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
	
	/**
	 * 流程信息分页查询
	 */
	@RequestMapping(value = "/listPageworkProcedure")
	@ResponseBody
	public Map<String, Object> listworkProcedurePage(Page page) throws Exception {  
		PageData pd = new PageData();
		pd = this.getPageData();

		String Name = pd.getString("Name");

		if (null != Name && !"".equals(Name)) {
			Name = Name.trim();
			pd.put("Name", Name);
		}
		
		page.setPd(pd);
		List<PageData> productList = workFlowService.listPageworkProcedure(page); // 列出采购单据列表
		if (productList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", productList);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	
	/**
	 * 去新增流程页面
	 */
	@RequestMapping(value = "/goAddWorkProcedure")
	public ModelAndView goAddWorkProcedure() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		List<Role> roleList = roleService.listAllERRoles();
		mv.setViewName("system/flow/flow_edit");
		mv.addObject("msg", "saveFlow");
		mv.addObject("flowCodeList", new JSONArray());
		mv.addObject("pd", pd);
		mv.addObject("roleList", roleList);
		
		return mv;
	}
	
	/**
	 * 保存流程数据信息
	 */
	@RequestMapping(value = "/saveFlow")
	@ResponseBody
	public Object saveFlow() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);
		
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
			workFlowService.saveFlow(pd,(List)jsonArray);
			map.put("msg", "success");
		}
		else {
			map.put("msg", "failed"); 	
		}
		return AppUtil.returnObject(new PageData(), map); 
	}

	/**
	 * 删除流程信息
	 */
	@RequestMapping(value = "/deleteWorkFlow")
	public void deleteWorkFlow(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
				workFlowService.deleteWorkFlow(pd);
			}
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value="/goEditWorkProcedure")
	public ModelAndView goEditWorkProcedure()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		pd = workFlowService.findFlowByCodeNo(pd); // 根据申请编号读取
		
		List<Role> roleList = roleService.listAllERRoles();
		List<FlowDetail> Detaillist= workFlowService.findDetailByCodeNo(pd);
		JSONArray jsonArray = JSONArray.fromObject(Detaillist);
		mv.setViewName("system/flow/flow_edit");
		mv.addObject("msg", "editFlow");
		mv.addObject("pd", pd);
		mv.addObject("flowCodeList", jsonArray);
		mv.addObject("roleList", roleList);
		return mv;
	}
	
	
	/**
	 * 编辑
	 */
	@RequestMapping(value="/editFlow")
	@ResponseBody
	public Object editFlow()throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();  
		
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
			workFlowService.updateFlow(pd,(List)jsonArray);
			map.put("msg", "success");
		}
		else {
			map.put("msg", "failed"); 	
		}
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	/**
	 *去流程分配页面
	 **/ 
	@RequestMapping(value = "/distributionFlow")
	public ModelAndView distributionFlow() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		pd = workFlowService.findFlowByCodeNo(pd);
		mv.setViewName("system/flow/flow_distribution"); 
		mv.addObject("pd", pd);
		return mv; 
	}

	/**
	 * combotree 加载根目录菜单
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/listMenuCombotree")
	@ResponseBody 
	public JSONArray listMenuCombotree() throws Exception{ 
		List<PageData> menuList = menuService.AllMenulist();
		JSONArray gResTable = new JSONArray(); 
		JSONObject node = new JSONObject();
		for(PageData pd:menuList){ 
			if("0".equals(pd.getString("PARENT_ID")) || pd.getString("PARENT_ID")==null){    
				node.put("id",pd.getString("MENU_ID"));
				node.put("text",pd.getString("MENU_NAME"));  
				
				JSONArray js = findSelect(menuList,pd.getString("MENU_ID"));
				if(js.size()>0){
					node.put("children",js);
				} 
				gResTable.add(node);
			}
		}
		return gResTable;		
	}
 
	
	/**
	 * 根据父级编号查出相应的子功能菜单，包含所有孩子，用于显示 combotree
	 * @param  父级功能菜单编号
	 * @return JSONArray
	 **/
	private JSONArray findSelect(List<PageData> whList, String warehouseNo) {
		JSONArray gResTable = new JSONArray(); 
		JSONObject nde = new JSONObject();
		for(PageData pd:whList){ 
			Object parentNo=pd.getString("PARENT_ID");
			if(warehouseNo.equals(parentNo)){   
				nde.put("id",pd.getString("MENU_ID"));
				nde.put("text",pd.getString("MENU_NAME"));  
				
				JSONArray js = findSelect(whList,pd.getString("MENU_ID"));
				if(js.size()>0){
					nde.put("children",js);
				}
				gResTable.add(nde);
			} 
		}
		return gResTable;
	} 

	/**
	 * 保存流程分配信息
	 */
	@RequestMapping(value = "/Savedistribution")
	@ResponseBody
	public Object Savedistribution() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();   
		
		List<MenuFlow> mfist = workFlowService.ValidationMenuFlow(pd);
		if(mfist.size() >0){
			map.put("msg", "Validationfailed");
			return AppUtil.returnObject(new PageData(), map); 
		}
		
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
			workFlowService.savedistribution(pd);
			map.put("msg", "success");
		}
		else {
			map.put("msg", "failed"); 	
		}
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
