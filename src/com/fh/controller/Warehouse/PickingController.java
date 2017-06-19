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
import com.fh.service.Warehouse.PickingService; 
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;

@Controller
@RequestMapping(value = "/pick") 
public class PickingController extends BaseController{

	private String mapperFileName = "pickXMapper";
	
	String menuUrl = "pick/picking_list.do"; // 菜单地址(权限用)
	@Resource(name = "PickingService")
	private PickingService pickingService; 
	
 
	/**
	 * 普通入库模块菜单点击入口
	 */
	@RequestMapping(value = "/picking_list") 
	public ModelAndView listInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Picking/picking_list");
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
	@RequestMapping(value = "/picklistPage")
	@ResponseBody
	public Map<String, Object> picklistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = pickingService.picklistPage(page); // 列出入库单列表
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
	@RequestMapping(value = "/goAddPick") 
	public ModelAndView goAddPick() throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd.put("PickingPerson", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("PickingNo", "LLDH" + DateUtil.getTimes() + AppUtil.getRandomNum(4)); 
		pd.put("PickingTime", DateUtil.getTime());
		mv.setViewName("Warehouse/Picking/picking_Edit");
		mv.addObject("msg", "savePicking"); 
		mv.addObject("pd", pd);  
		return mv; 
	}
	
	/**
	 * 查找领料申请单据信息 
	 **/
	@RequestMapping(value = "/listGoodsApply")
	@ResponseBody  
	public Map<String, Object> listGoodsApply(Page page) throws Exception{ 
		PageData pd = new PageData();
		pd = this.getPageData(); 
		List<PageData> pList = pickingService.listGoodsApply(pd);
		if (pList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", pList);
			return result;  // 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	
	
	
	/**
	 * 根据物料申请单号查询商品信息
	 **/
	@RequestMapping(value = "/SelectByApply")
	@ResponseBody  
	public Map<String, Object> SelectByApply(Page page) throws Exception{ 
		PageData pd = new PageData();
		pd = this.getPageData(); 
		List<PageData> gaList = pickingService.SelectByApply(pd);
		if (gaList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", gaList);
			return result;  // 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	 
	
	
	/**
	 * 保存数据
	 * @throws Exception 
	 */
	@RequestMapping(value = "/savePicking")
	@ResponseBody
	public Object savePicking() throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);	
		if (null != jsonArray) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
				pickingService.savePicking(pd,(List)jsonArray);  
			} // 判断新增权限
			map.put("msg", "success");
		} else {
			map.put("msg", "failed"); 
		}	 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	
	@RequestMapping(value = "/SelectPicking")  
	public ModelAndView SelectPicking() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();  
		pd = this.getPageData();   
		//查询领料商品信息
		List<PageData> gdlist= pickingService.findGoodsByNo(pd);  
		//查询领料单据信息
		pd.put("ApplyNo", pd.getString("PickingNo")); 
		queryApplyInfo(pd, mv);  	 
		pd = pickingService.findApplyDetailByNo(pd); 
 		if(pd.getString("ApprovalStatus").equals("3")){
			mv.addObject("isShow", false);
		} 
		mv.setViewName("Warehouse/Picking/picking_select"); 
		mv.addObject("pd", pd);  
		mv.addObject("gdlist", gdlist); 
		return mv; 
	}
	
	/**
	 * 删除信息
	 * @throws Exception 
	 */
	@RequestMapping(value = "/deletePick")
	public void deletePick(PrintWriter out){ 
		PageData pd = new PageData();
		try {
			pd = this.getPageData(); 
			//查询审批信息 		
			List<PageData> applylist= flowService.findApplyByNo(pd);  
			if(applylist.size()<1){
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
					pickingService.deletePick(pd);
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
		result = super.applyAudit(menuUrl , mapperFileName, pickingService);
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
		pd.put("PickingNo", pd.getString("ApplyNo"));
		pd = pickingService.findApplyDetailByNo(pd);   
		if(pd.getString("ApprovalStatus").equals("2")){ 
			map.put("msg", "failed"); 
		}else if(pd.getString("ApprovalStatus").equals("1")){		
			map = (Map) doFlowAuthentication();
		}
		return AppUtil.returnObject(new PageData(), map); 
	}


	@Override
	public void terminateFlow(PageData pageData) {
		try {
			pickingService.saveBusinessData(pageData);
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
		pd.put("ApplyTime", DateUtil.getTime());
		pd.put("UserName", this.getSession().getAttribute(Const.SESSION_USERNAME)); 
		pickingService.UpdateStatus(pd);
		map.put("msg", "success"); 
		return AppUtil.returnObject(new PageData(), map); 
	}
}
