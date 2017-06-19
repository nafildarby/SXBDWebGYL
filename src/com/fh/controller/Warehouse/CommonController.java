package com.fh.controller.Warehouse;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;  
import com.fh.service.Warehouse.CommonService;
import com.fh.service.Warehouse.WarehouseService;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;

@Controller
@RequestMapping(value = "/common") 
public class CommonController extends BaseController{
	
	private String mapperFileName = "commonXMapper";
	String menuUrl = "common/common_list.do"; // 菜单地址(权限用)
	@Resource(name = "CommonService")
	private CommonService commonService;
	@Resource(name = "WarehouseService")
	private WarehouseService WHService; 
	
	/**
	 * 普通入库模块菜单点击入口
	 */
	@RequestMapping(value = "/common_list") 
	public ModelAndView listInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Common/Common_list");
		mv.addObject("pd", pd);
		mv.addObject(Const.SESSION_QX, this.getHC()); // 按钮权限
		return mv;
	} 
	
	
	/**
	 * 普通入库单分页查询
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/CommonlistPage")
	@ResponseBody
	public Map<String, Object> CommonlistPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();
		String IncomeCode = pd.getString("IncomeCode");
		String IncomeBatch=pd.getString("IncomeBatch");
		String StatusFlag=pd.getString("StatusFlag");
		
		if (null != IncomeCode && !"".equals(IncomeCode)) {
			IncomeCode = IncomeCode.trim();
			pd.put("IncomeCode", IncomeCode);
		} 
		if (IncomeBatch != null && !"".equals(IncomeBatch)) { 
			pd.put("IncomeBatch", IncomeBatch);
		} 
		if (StatusFlag != null && !"".equals(StatusFlag)) { 
			pd.put("StatusFlag", StatusFlag);
		} 
		
		page.setPd(pd);
		List<PageData> inComeList = commonService.CommonlistPage(page); // 列出入库单列表
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
	@RequestMapping(value = "/goAddCommon") 
	public ModelAndView goAddCommon() throws Exception {
		ModelAndView mv = this.getModelAndView(); 
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd.put("operatorName", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("OutBoundNo", "CKDH" + DateUtil.getTimes() + AppUtil.getRandomNum(4)); 
		pd.put("OutBoundTime", DateUtil.getTime());
		mv.setViewName("Warehouse/Common/Common_Edit");
		mv.addObject("msg", "saveCommon"); 
		mv.addObject("pd", pd);  
		return mv; 
	}
	
	

	/**
	 * 查找入库商品信息 
	 **/
	@RequestMapping(value = "/incomGoods")
	@ResponseBody  
	public Map<String, Object> incomGoods(Page page) throws Exception{ 
		PageData pd = new PageData();
		pd = this.getPageData(); 
		List<PageData> pList = commonService.findincomGoods(pd);
		if (pList != null) {
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("total", page.getTotalResult());
			result.put("rows", pList);
			return result;  // 这个就是你在ajax成功的时候返回的数据，我在那边进行了一个对象封装
		}
		return null;
	}
	
	
	
	/**
	 * 保存入库数据
	 * @throws Exception 
	 */
	@RequestMapping(value = "/saveCommon")
	@ResponseBody
	public Object saveCommon() throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p);	
		if (null != jsonArray) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
				commonService.saveCommon(pd,(List)jsonArray);  
			} // 判断新增权限
			map.put("msg", "success");
		} else {
			map.put("msg", "failed"); 
		}	 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	
	
	@RequestMapping(value = "/SelectCommon")  
	public ModelAndView SelectCommon() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		List<PageData> gdlist= commonService.findByOutGoods(pd);
		pd.put("ApplyNo", pd.getString("OutBoundNo"));
 		queryApplyInfo(pd, mv);  	
 		pd = commonService.findByOut(pd);   
 		if(pd.getString("ApprovalStatus").equals("3")){
			mv.addObject("isShow", false);
		} 
		mv.setViewName("Warehouse/Common/Common_select"); 
		mv.addObject("pd", pd);  
		mv.addObject("gdlist", gdlist); 
		return mv; 
	}
	
	
	/**
	 * 删除信息
	 * @throws Exception 
	 */
	@RequestMapping(value = "/deleteCommon")
	public void deleteCommon(PrintWriter out){ 
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> prelist= flowService.findApplyByNo(pd); 
			if(prelist.size()<1){
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
					commonService.deleteCommon(pd);
				}
				out.write("success");
			}else out.write("failed");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
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
	 * 提交申请审批
	 */
	@RequestMapping(value = "/applyAudit")
	@ResponseBody
	public Object applyAudit() throws Exception {
		Object result = null;
		result = super.applyAudit(menuUrl , mapperFileName, commonService);
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
		pd.put("OutBoundNo", pd.getString("ApplyNo"));
		pd = commonService.findByOut(pd);     
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
			commonService.saveBusinessData(pageData);
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
		commonService.UpdateStatus(pd);
		map.put("msg", "success"); 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
}
