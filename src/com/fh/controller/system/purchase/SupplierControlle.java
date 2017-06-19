package com.fh.controller.system.purchase;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 
import javax.annotation.Resource; 
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView; 
import com.fh.controller.base.BaseController;
import com.fh.entity.Page; 
import com.fh.service.system.Supplier.SupplierService;
import com.fh.util.AppUtil;
import com.fh.util.Const; 
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;

@Controller
@RequestMapping(value = "/supplier")
public class SupplierControlle extends BaseController {


	String menuUrl = "supplier/supplier_list.do"; // 菜单地址(权限用) 
	 
	@Resource(name = "SupplierService")
	private SupplierService suppService;	 
	
	
	/**
	 * 模块菜单点击入口
	 */
	@RequestMapping(value = "/supplier_list") 
	public ModelAndView listIndent() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("system/purchase/supplier_list");
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	} 
	
	/**
	 * 供应商信息分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/supplierlistPage")
	@ResponseBody
	public Map<String, Object> supplierlistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = suppService.supplierlistPage(page);  
		if (inComeList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", inComeList);
			return result; 
		}
		return null;
	}
	 
	/**
	 * 新增页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goAddSupplier") 
	public ModelAndView goAddSupplier() throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		mv.setViewName("system/purchase/supplier_Edit"); 
		mv.addObject("msg", "saveSupplier");
		return mv; 
	}
	
	/**
	 * 保存入库数据
	 */
	@RequestMapping(value = "/saveSupplier")
	@ResponseBody
	public Object saveSupplier() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		pd.put("CreateDate",DateUtil.getTime()); 
		if (Jurisdiction.buttonJurisdiction(menuUrl, "add"))  // 判断新增权限
			suppService.saveSupplier(pd);   
		map.put("msg", "success");  
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goEditSupplier")
	public ModelAndView goEditSupplier() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		pd = suppService.findSupplierById(pd); // 根据ID读取
		mv.setViewName("system/purchase/supplier_Edit");
		mv.addObject("msg", "editSupplier");
		mv.addObject("pd", pd); 
		return mv;
	}

	/**
	 * 修改保存
	 */
	@RequestMapping(value = "/editSupplier")
	@ResponseBody
	public Object editSupplier() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();  
		if (Jurisdiction.buttonJurisdiction(menuUrl, "edit")) 
			suppService.editSupplier(pd); 
		map.put("msg", "success");
		return AppUtil.returnObject(new PageData(), map);
	}
	
	/**
	 * 删除供应商信息
	 */
	@RequestMapping(value = "/deleteSupplier")
	public void deleteSupplier(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> goodlist=suppService.findGoodsBySupplierId(pd);
			List<PageData> whlist=suppService.findInWHNoBySupplierId(pd);
			//判断供应商下面是否有商品
			if(goodlist.size()<1 || whlist.size()<1){ 
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del"))  
					suppService.deleteSupplier(pd); 
				out.write("success"); 
			}else out.write("failed");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}
}
