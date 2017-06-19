package com.fh.controller.Warehouse;

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
import com.fh.service.Warehouse.StockService;
import com.fh.service.system.Supplier.SupplierService;
import com.fh.util.Const;
import com.fh.util.PageData;


@Controller
@RequestMapping(value = "/Stock") 
public class StockController extends BaseController{
	
	String menuUrl = "Stock/Stock_list.do"; // 菜单地址(权限用)
	@Resource(name = "StockService")
	private StockService stockService; 
	@Resource(name = "SupplierService")
	private SupplierService suppService;
	
	/**
	 * 普通入库模块菜单点击入口
	 */
	@RequestMapping(value = "/Stock_list") 
	public ModelAndView listStock() throws Exception {
		ModelAndView mv = this.getModelAndView();
		List<PageData> suppList = suppService.listAllSupplier();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Stock/Stock_list");
		mv.addObject("pd", pd);
		mv.addObject("SupplierList", suppList); 
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	} 
	
	
	/**
	 * 库存分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/StocklistPage")
	@ResponseBody
	public Map<String, Object> StocklistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = stockService.StocklistPage(page); // 列出入库单列表
		if (inComeList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", inComeList);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
}
	