package com.fh.controller.Warehouse;

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
import com.fh.service.Warehouse.WarehouseService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.Jurisdiction; 
import com.fh.util.PageData; 

@Controller
@RequestMapping(value = "/wh")
public class WarehouseController extends BaseController {
	
	String menuUrl = "wh/listWH.do"; // 菜单地址(权限用)
	@Resource(name = "WarehouseService")
	private WarehouseService WHService; 
	 
	/**
	 * 加载一级菜单 根目录 
	 * @param  父级功能菜单编号
	 * @return JSONArray
	 */
	@RequestMapping(value = "/listWHouse") 
	@ResponseBody
	public JSONArray listWHouse(Page page) throws Exception { 
		List<PageData> whList = WHService.listAllPageWH(page); 
		JSONArray gResTable = new JSONArray(); 
		JSONObject node = new JSONObject();
		if (whList != null) {  
			for(PageData pd:whList){   
				if("".equals(pd.getString("ParentNo")) || pd.getString("ParentNo")==null){  
					node.put("Id",pd.getString("Id"));
					node.put("WarehouseStatus",pd.getString("WarehouseStatus")); 
					node.put("Status",pd.getString("Status")); 
					node.put("ParentNo",pd.getString("ParentNo"));
					node.put("WarehouseNo",pd.getString("WarehouseNo"));
					node.put("WarehouseName",pd.getString("WarehouseName"));  
					JSONArray js = findChildren(whList,pd.getString("WarehouseNo"));
					if(js.size()>0){
						node.put("children",js);
					}
					gResTable.add(node);
				} 		
			}
		} 
		return gResTable;  
	}
	
	/**
	 * 根据父级编号查出相应的子功能菜单，包含所有孩子，用于显示 treegrid
	 * @param  父级功能菜单编号
	 * @return JSONArray
	 */
	private JSONArray findChildren(List<PageData> whList, String warehouseNo) {
		JSONArray gResTable = new JSONArray(); 
		JSONObject nde = new JSONObject(); 
		for(PageData pd:whList){ 
			String parentNo=pd.getString("ParentNo");
			if(warehouseNo.equals(parentNo)){ 
				nde.put("Id",pd.getString("Id"));
				nde.put("WarehouseStatus",pd.getString("WarehouseStatus")); 
				nde.put("Status",pd.getString("Status")); 
				nde.put("ParentNo",pd.getString("ParentNo"));
				nde.put("WarehouseNo",pd.getString("WarehouseNo"));
				nde.put("WarehouseName",pd.getString("WarehouseName"));  
				
				JSONArray js = findChildren(whList,pd.getString("WarehouseNo"));
				if(js.size()>0){
					nde.put("children",js);					
				}
				gResTable.add(nde);
			} 
		}
		return gResTable;
	} 
	 
	/**
	 * 显示所有仓库信息
	 */
	@RequestMapping(value = "/listWH") 
	public ModelAndView listWH() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		List<PageData> whList = WHService.listAllWH();  
		mv.setViewName("Warehouse/Warehouse/Warehouse_list");
		mv.addObject("whList", whList);
		mv.addObject("pd", pd);  
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	}  
	
	
	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAddWH")
	public ModelAndView goAddWH() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Warehouse/Warehouse_Edit");
		mv.addObject("msg", "saveWH");
		mv.addObject("pd", pd);  
		return mv;
	}
	/**
	 * 修改仓库信息
	 */
	@RequestMapping(value = "/editWH")
	@ResponseBody
	public Object editWH() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();  
		if (Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
			WHService.editWH(pd);
		}
		map.put("msg", "success");
		return AppUtil.returnObject(new PageData(), map);
	}

	/**
	 * 去修改仓库页面
	 */
	@RequestMapping(value = "/goEditWH")
	public ModelAndView goEditWH() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd = WHService.findByWHId(pd); // 根据ID读取
		mv.setViewName("Warehouse/Warehouse/Warehouse_Edit");
		mv.addObject("msg", "editWH");
		mv.addObject("pd", pd); 
		return mv;
	}

	
	/**
	 * combotree 加载根目录菜单 
	 * @param  父级功能菜单编号
	 * @return JSONArray
	 **/
	@RequestMapping(value = "/listWHCombotree")
	@ResponseBody 
	public JSONArray listWHCombotree() throws Exception{ 
		List<PageData> whList = WHService.listAllWH();
		JSONArray gResTable = new JSONArray(); 
		JSONObject node = new JSONObject();
		for(PageData pd:whList){ 
			if("".equals(pd.getString("ParentNo")) || pd.getString("ParentNo")==null){    
				node.put("id",pd.getString("WarehouseNo"));
				node.put("text",pd.getString("WarehouseName"));  
				
				JSONArray js = findSelect(whList,pd.getString("WarehouseNo"));
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
			Object parentNo=pd.getString("ParentNo");
			if(warehouseNo.equals(parentNo)){   
				nde.put("id",pd.getString("WarehouseNo"));
				nde.put("text",pd.getString("WarehouseName"));  
				
				JSONArray js = findSelect(whList,pd.getString("WarehouseNo"));
				if(js.size()>0){
					nde.put("children",js);
				}
				gResTable.add(nde);
			} 
		}
		return gResTable;
	} 
	

	/**
	 * 删除仓库信息
	 */
	@RequestMapping(value = "/deleteWH")
	public void deleteWH(PrintWriter out) { 
		PageData pd = new PageData();
		try {
			pd = this.getPageData(); 
			List<PageData> plist=WHService.findByWHList(pd);
			if(plist.size()>0){
				out.write("child"); 
				out.close();
			} else{
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {				 
					WHService.deleteWH(pd);
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
	@RequestMapping(value = "/saveWH")
	@ResponseBody
	public Object saveWH() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();   
		if (null == WHService.findByWHId(pd)) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
				WHService.saveWH(pd);
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
	/* ===============================权限================================== */
}
