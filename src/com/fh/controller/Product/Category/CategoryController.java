package com.fh.controller.Product.Category;

import java.io.PrintWriter;
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
import com.fh.service.Product.Category.CategoryService; 
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;


@Controller
@RequestMapping(value = "/cate")
public class CategoryController extends BaseController {
	

	String menuUrl = "cate/listCategory.do"; // 菜单地址(权限用)
	@Resource(name = "CategoryService")
	private CategoryService cateService;


	/**
	 * 加载一级菜单 根目录
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/listCate") 
	@ResponseBody
	public JSONArray listCate(Page page) throws Exception { 
		List<PageData> whList = cateService.listAllPageCate(page); 
		JSONArray gResTable = new JSONArray(); 
		JSONObject node = null;
		if (whList != null) {  
			for(PageData pd:whList){ 
				if("".equals(pd.getString("ParentId")) || pd.getString("ParentId")==null){  
					node = new JSONObject();
					node.put("Id",pd.getString("Id")); 
					node.put("Status",pd.getString("Status")); 
					node.put("ParentId",pd.getString("ParentId")); 
					node.put("CategoryName",pd.getString("CategoryName"));  
					
					JSONArray js = findChildren(whList,pd.getString("Id"));
					if(js.size() > 0 )  
						 node.put("children",js); 
					gResTable.add(node);					 
				} 		
			}
		} 
		return gResTable;  
	}

	/**
	 * 根据父级编号查出相应的子功能菜单，包含所有孩子，用于显示 treegrid
	 * @param whList
	 * @param Id
	 * @return
	 */
	private JSONArray findChildren(List<PageData> whList, String Id) {
		JSONArray gResult = new JSONArray(); 
		JSONObject nde = null; 
		for(PageData pd:whList){ 
			String ParentId=pd.getString("ParentId");
			if(Id.equals(ParentId)){
				nde = new JSONObject();
				nde.put("Id",pd.getString("Id")); 
				nde.put("Status",pd.getString("Status")); 
				nde.put("ParentId",pd.getString("ParentId")); 
				nde.put("CategoryName",pd.getString("CategoryName"));  
				
			 	JSONArray js = findChildren(whList,pd.getString("Id"));
				if(js.size()>0) 
					 nde.put("children",js);	 
				gResult.add(nde);
			} 
		}
		return gResult;
	} 
	 
	/**
	 * 显示所有物料分类信息
	 */
	@RequestMapping(value = "/listCategory") 
	public ModelAndView listCategory() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		List<PageData> whList = cateService.listAllCate();  
		mv.setViewName("Product/Category/Category_list");
		mv.addObject("whList", whList);
		mv.addObject("pd", pd);  
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	}  
	
	
	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAddCate")
	public ModelAndView goAddCate() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Product/Category/Category_Edit");
		mv.addObject("msg", "saveCate");
		mv.addObject("pd", pd);  
		return mv;
	}
	/**
	 * 修改信息
	 */
	@RequestMapping(value = "/editCate")
	@ResponseBody
	public Object editCate() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();  
		if (Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
			cateService.editCate(pd);
		}
		map.put("msg", "success");
		return AppUtil.returnObject(new PageData(), map);
	}

	/**
	 * 去修改信息页面
	 */
	@RequestMapping(value = "/goEditCate")
	public ModelAndView goEditCate() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd = cateService.findByCateId(pd); // 根据ID读取
		mv.setViewName("Product/Category/Category_Edit");
		mv.addObject("msg", "editCate");
		mv.addObject("pd", pd); 
		return mv;
	}


	/**
	 * combotree 加载根目录菜单
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/listCombotree")
	@ResponseBody 
	public JSONArray listCombotree() throws Exception{ 
		List<PageData> whList = cateService.listAllCate();
		JSONArray gResTable = new JSONArray(); 
		JSONObject node = null;
		for(PageData pd:whList){ 
			if("".equals(pd.getString("ParentId")) || pd.getString("ParentId")==null){    
				node = new JSONObject();
				node.put("Id",pd.getString("Id"));
				node.put("text",pd.getString("CategoryName"));  
				
				JSONArray js = findSelect(whList,pd.getString("Id"));
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
	 * @param whList
	 * @param warehouseNo
	 * @return
	 */
	private JSONArray findSelect(List<PageData> whList, String warehouseNo) {
		JSONArray gResTable = new JSONArray(); 
		JSONObject nde =null;
		for(PageData pd:whList){ 
			Object parentId=pd.getString("ParentId");
			if(warehouseNo.equals(parentId)){   
				nde = new JSONObject();
				nde.put("Id",pd.getString("Id"));
				nde.put("text",pd.getString("CategoryName"));  
				
				JSONArray js = findSelect(whList,pd.getString("Id"));
				if(js.size()>0){
					nde.put("children",js);
				}
				gResTable.add(nde);
			} 
		}
		return gResTable;
	} 
	

	/**
	 * 删除用户
	 */
	@RequestMapping(value = "/deleteCate")
	public void deleteCate(PrintWriter out) { 
		PageData pd = new PageData();
		try {
			pd = this.getPageData(); 
			List<PageData> plist=cateService.findByCategoryList(pd);
			if(plist.size()>0){
				out.write("child"); 
				out.close();
			} else{
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {				 
					cateService.deleteCategory(pd);
				} 
				out.write("success"); 
				out.close(); 
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
	}


	/**
	 * 保存用户
	 */
	@RequestMapping(value = "/saveCate")
	@ResponseBody
	public Object saveCate() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();   
		if (null == cateService.findByCateId(pd)) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
				cateService.saveCate(pd);
			} // 判断新增权限
			map.put("msg", "success");
		} else {
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
	/* ===============================权限================================*/
	
}
