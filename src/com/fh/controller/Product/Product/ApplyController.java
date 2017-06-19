package com.fh.controller.Product.Product;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController; 
import com.fh.entity.Page;
import com.fh.service.Product.Product.ApplyService; 
import com.fh.service.Product.Product.ProductService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;

@Controller
@RequestMapping(value = "/apply")
public class ApplyController extends BaseController {
 
	private String mapperFileName = "applyXMapper";
	
	String menuUrl = "apply/apply_list.do";
	
	@Resource(name = "ApplyService")
	private ApplyService applyService; 
	@Resource(name = "ProductService")
	private ProductService pdService;
	
	
	/**
	 * 模块菜单点击入口
	 */
	@RequestMapping(value = "/apply_list") 
	public ModelAndView listInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Product/Apply/apply_list");
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	} 
	
	
	/**
	 * 申请单分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applylistPage")
	@ResponseBody
	public Map<String, Object> applylistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = applyService.applylistPage(page); // 列出入库单列表
		if (inComeList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", inComeList);
			return result;// 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	
	/**
	 * 新增页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goAddApply") 
	public ModelAndView goAddApply() throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd.put("ApplyPerson", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("GoodsApplyNo", "WLSQDH" + DateUtil.getTimes() + AppUtil.getRandomNum(4)); 
		pd.put("ApplyTime", DateUtil.getTime());
		mv.setViewName("Product/Apply/apply_Edit");
		mv.addObject("msg", "saveApply"); 
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
		page.setPd(pd);
		List<PageData> pdlist = pdService.listProduct(page);   
		mv.setViewName("system/admin/selectProduct");
		mv.addObject("pdlist", pdlist);
		mv.addObject("pd", pd);
		mv.addObject("msg", "saveApplyProduct");
		mv.addObject(Const.SESSION_QX, this.getHC()); 
		return mv;
	}
	
	
	
	/**
	 * 保存数据
	 * @throws Exception 
	 */
	@RequestMapping(value = "/saveApply")
	@ResponseBody
	public Object saveApply() throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);	
		if (null != jsonArray) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
				applyService.saveApply(pd,(List)jsonArray);  
			} // 判断新增权限
			map.put("msg", "success");
		} else {
			map.put("msg", "failed"); 
		}	 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	
	@RequestMapping(value = "/SelectApply")  
	public ModelAndView SelectApply() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		List<PageData> gdlist= applyService.findByApplyDetail(pd); 
		pd.put("ApplyNo", pd.getString("GoodsApplyNo"));
		queryApplyInfo(pd, mv);  	 
		pd = applyService.findByApply(pd);  
 		if(pd.getString("ApprovalStatus").equals("3")){
			mv.addObject("isShow", false);
		} 
		mv.setViewName("Product/Apply/apply_select"); 
		mv.addObject("pd", pd);  
		mv.addObject("gdlist", gdlist); 
		return mv; 
	}
	
	/**
	 * 删除信息
	 * @throws Exception 
	 */
	@RequestMapping(value = "/deleteApply")
	public void deleteApply(PrintWriter out){ 
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> prelist= flowService.findApplyByNo(pd); 
			if(prelist.size()<1){
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
					applyService.deleteApply(pd);
				}
				out.write("success");
			}else out.write("failed");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
	}

	/**
	 * 提交申请审批
	 */
	@RequestMapping(value = "/applyAudit")
	@ResponseBody
	public Object applyAudit() throws Exception {
		Object result = null;
		result = super.applyAudit(menuUrl , mapperFileName, applyService);
		return result;
	}

	/**
	 * 流程审批完成后需要进行数据库的操作处理
	 */
	@Override
	public void terminateFlow(PageData pageData) {
		try {
			applyService.saveBusinessData(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 保存审核数据
	 * @throws Exception 
	 */ 
	@RequestMapping(value = "/saveApplyData")
	@ResponseBody
	public Object saveApplyData() throws Exception{
		Map<String, String>  map = new HashMap<String, String>(); 
		//TODO 判断是否可以进行审核
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		pd.put("GoodsApplyNo", pd.getString("ApplyNo"));
		pd = applyService.findByApply(pd);   
		if(pd.getString("ApprovalStatus").equals("2")){ 
			map.put("msg", "failed"); 
		}else if(pd.getString("ApprovalStatus").equals("1")){		
			map = (Map) doFlowAuthentication();
		}
		return AppUtil.returnObject(new PageData(), map); 
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
		pd.put("ApplyTime", DateUtil.getTime());
		pd.put("UserName", this.getSession().getAttribute(Const.SESSION_USERNAME)); 
		applyService.UpdateStatus(pd);
		map.put("msg", "success"); 
		return AppUtil.returnObject(new PageData(), map); 
	}
}