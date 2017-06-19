package com.fh.controller.Warehouse;

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
import com.fh.service.Warehouse.AllotService; 
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;

@Controller
@RequestMapping(value = "/allot") 
public class AllotController  extends BaseController{

	private String mapperFileName = "allotXMapper";
	
	String menuUrl = "allot/Allot_list.do"; // 菜单地址(权限用)
	@Resource(name = "AllotService")
	private AllotService allotService; 
	
	private  String wno;
	
	
	/**
	 * 普通入库模块菜单点击入口
	 */
	@RequestMapping(value = "/Allot_list") 
	public ModelAndView listInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Allot/Allot_list");
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	} 
	
	
	/**
	 * 出库单分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/allotlistPage")
	@ResponseBody
	public Map<String, Object> allotlistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = allotService.allotlistPage(page); // 列出入库单列表
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
	@RequestMapping(value = "/goAddAllot") 
	public ModelAndView goAddAllot() throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd.put("operatorName", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("OutBoundNo", "DBDH" + DateUtil.getTimes() + AppUtil.getRandomNum(4)); 
		pd.put("OutBoundTime", DateUtil.getTime());
		mv.setViewName("Warehouse/Allot/Allot_Edit");
		mv.addObject("msg", "saveAllot"); 
		mv.addObject("pd", pd);  
		return mv; 
	}
	
	
	
	/**
	 * 保存数据
	 * @throws Exception 
	 */
	@RequestMapping(value = "/saveAllot")
	@ResponseBody
	public Object saveAllot() throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);	
		if (null != jsonArray) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
				allotService.saveAllot(pd,(List)jsonArray);  
			} // 判断新增权限
			map.put("msg", "success");
		} else {
			map.put("msg", "failed"); 
		}	 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	
	@RequestMapping(value = "/SelectAllot")  
	public ModelAndView SelectAllot() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		List<PageData> gdlist= allotService.findByOutGoods(pd);
		pd.put("ApplyNo", pd.getString("AllocationNo"));
		queryApplyInfo(pd, mv); 
		pd = allotService.findByOut(pd);     
		if(pd.getString("ApprovalStatus").equals("3")){
			mv.addObject("isShow", false);
		}
		mv.setViewName("Warehouse/Allot/Allot_select"); 
		mv.addObject("pd", pd);  
		mv.addObject("gdlist", gdlist); 
		return mv; 
	}
	
	/**
	 * 删除信息
	 * @throws Exception 
	 */
	@RequestMapping(value = "/deleteAllot")
	public void deleteAllot(PrintWriter out){ 
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> prelist= flowService.findApplyByNo(pd); 
			if(prelist.size()<1){
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
					allotService.deleteAllot(pd);
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
		result = super.applyAudit(menuUrl , mapperFileName, allotService);
		return result;
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
		pd.put("AllocationNo", pd.getString("ApplyNo"));
		pd = allotService.findByOut(pd);     
		if(pd.getString("ApprovalStatus").equals("2")){
			map.put("msg", "failed"); 
		}else{		
			map = (Map) doFlowAuthentication();
		}
		return AppUtil.returnObject(new PageData(), map); 
	}


	@Override
	public void terminateFlow(PageData pageData) {
		try {
			allotService.saveBusinessData(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 进行仓库商品选择
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/WHNoGoodslistPage")
	@ResponseBody
	public Map<String, Object>  WHNoGoodslistPage(Page page) throws Exception { 
		PageData pd = new PageData();
		pd=this.getPageData();
		pd.put("WHNo", wno);
		page.setPd(pd);
		List<PageData> pdlist = allotService.WHNoGoodslistPage(page);   
		if(pdlist.size()!=0){
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", pdlist);
			return result;		
		}
		return null;
	}
	
	/**
	 * 进行仓库商品选择
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goWHNoGoods") 
	public ModelAndView goWHNoGoods(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		PageData pd = new PageData();
		pd = this.getPageData(); 
		wno=pd.getString("WHNo"); 
		mv.setViewName("Warehouse/Allot/WHNoGoods"); 
		mv.addObject("pd", pd); 
		mv.addObject("msg", "saveAllotGoods");
		mv.addObject("way", "allot");
		mv.addObject(Const.SESSION_QX, this.getHC()); 
		return mv; 
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
		allotService.UpdateStatus(pd);
	 	map.put("msg", "success");   
		return AppUtil.returnObject(new PageData(), map); 
	}
	
}
