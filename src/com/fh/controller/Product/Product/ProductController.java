package com.fh.controller.Product.Product; 

import java.io.PrintWriter; 
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import javax.annotation.Resource;    
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
import com.fh.entity.system.ComboItem;  
import com.fh.service.Product.Category.CategoryService;
import com.fh.service.Product.Product.ProductService;  
import com.fh.service.system.Supplier.SupplierService;
import com.fh.service.system.comboItem.ComboItemService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData; 


@Controller
@RequestMapping(value = "/product")
public class ProductController extends BaseController {
	
	String menuUrl = "product/productlist.do";  
	@Resource(name = "ProductService")
	private ProductService pdService;
	@Resource(name = "CategoryService")
	private CategoryService cateService;
	@Resource(name = "ComboItemService")
	private ComboItemService comboService;
	@Resource(name = "SupplierService")
	private SupplierService suppService;
	  
	/**
	 * 显示商品列表
	 */
	@RequestMapping(value = "/productlist")
	public ModelAndView productlist(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 		
		page.setPd(pd);
		List<PageData> pdlist = pdService.listProduct(page);   
		mv.setViewName("Product/Product/Product_list");
		mv.addObject("pdlist", pdlist); 
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
	
	/**
	 * 商品分页查询
	 */
	@RequestMapping(value = "/listProductPage")
	@ResponseBody
	public Map<String, Object> listProductPage(Page page) throws Exception {  
		PageData pd = new PageData();
		pd = this.getPageData();
		page.setPd(pd);
		List<PageData> productList = pdService.listProductPage(page); // 列出采购单据列表
		if (productList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", productList);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	 
	

	/**
	 * 删除商品信息
	 */
	@RequestMapping(value = "/deleteProduct")
	public void deleteProduct(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
				pdService.deleteProduct(pd);
			}
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 去新增商品页面
	 */
	@RequestMapping(value = "/goAddProduct")
	public ModelAndView goAddProduct() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		List<Category> categoryList;
		List<ComboItem> comboItemList;
		List<PageData> suppList;

		categoryList = cateService.listAllcategory(); //获取所有商品类型
		
		comboItemList = comboService.listAllcomboItem(); //获取所有商品单位
		
		suppList = suppService.listAllSupplier();

		mv.setViewName("Product/Product/product_edit");
		mv.addObject("msg", "saveProduct");
		mv.addObject("pd", pd);
		mv.addObject("CategoryList", categoryList);
		mv.addObject("ComboItemList", comboItemList);
		mv.addObject("SupplierList", suppList);

		return mv;
	}
	
	/**
	 * 保存商品数据
	 */
	@RequestMapping(value = "/saveProduct")
	@ResponseBody
	public ModelAndView saveProduct(PrintWriter out) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
			pdService.saveProduct(pd);
			// 判断新增权限
			mv.addObject("msg", "success");
		} else {
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	@RequestMapping(value="/goEditProduct")
	public ModelAndView goEditProduct( String ProductId )throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		List<Category> categoryList = cateService.listAllcategory(); //获取所有商品类型 
		List<ComboItem> comboItemList = comboService.listAllcomboItem(); //获取所有商品单位 
		List<PageData> suppList = suppService.listAllSupplier(); 
		pd.put("Id", ProductId);
		pd = pdService.findObjectById(pd); // 根据ID读取
		mv.setViewName("Product/Product/product_edit");
		mv.addObject("msg", "editProduct");
		mv.addObject("pd", pd);
		mv.addObject("CategoryList", categoryList);
		mv.addObject("ComboItemList", comboItemList);
		mv.addObject("SupplierList", suppList); 
		return mv;
	}
	
	/**
	 * 编辑
	 */
	@RequestMapping(value="/editProduct")
	@ResponseBody
	public Object editProduct()throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		try{
			PageData pd = new PageData();
			pd = this.getPageData();
		if (Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
			pdService.editProduct(pd);
		}
			map.put("msg", "success");
		}catch(Exception e){
			map.put("msg", "false");
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
