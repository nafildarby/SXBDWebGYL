/**
 * 
 */
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
import com.fh.entity.Warehouse.GoodsDetail;
import com.fh.entity.system.Supplier;
import com.fh.service.Product.Product.ProductService;
import com.fh.service.Warehouse.InComeService;
import com.fh.service.Warehouse.WarehouseService;
import com.fh.service.system.Supplier.SupplierService; 
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData; 

/**
 * 类名称：InBoundController 创建人：PLF 创建时间：2016年9月6日
 * 普通入库模块控制器
 */

@Controller
@RequestMapping(value = "/inbound")
public class InComeController extends BaseController {

	String menuUrl = "inbound/list_Inbound.do"; // 菜单地址(权限用)
	
	private String mapperFileName = "IncomeXMapper";
	
	@Resource(name = "InComeService")
	private InComeService inComeService;	 
	@Resource(name = "WarehouseService")
	private WarehouseService WHService; 
	@Resource(name = "ProductService")
	private ProductService pdService;
	@Resource(name = "SupplierService")
	private SupplierService suppService;
	
	/**
	 * 普通入库模块菜单点击入口
	 */
	@RequestMapping(value = "/list_Inbound") 
	public ModelAndView listInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();  
		mv.setViewName("Warehouse/Inbound/Inbound_list");
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
	@RequestMapping(value = "/listInboundPage")
	@ResponseBody
	public Map<String, Object> listInboundPage(Page page) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData(); 
		page.setPd(pd);
		List<PageData> inComeList = inComeService.listInboundPage(page); // 列出入库单列表
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
	@RequestMapping(value = "/goAddinbound") 
	public ModelAndView goAddinbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		List<PageData> suppList = suppService.listAllSupplier();
		PageData pd = new PageData();
		pd = this.getPageData();  
		pd.put("operatorName", this.getSession().getAttribute(Const.SESSION_USERNAME));
		pd.put("inboundNo", "RKDH" + DateUtil.getTimes() + AppUtil.getRandomNum(4));
		pd.put("inboundBatchNo", "RKPC" + DateUtil.getTimes() + AppUtil.getRandomNum(4));
		pd.put("inboundDate", DateUtil.getTime());
		mv.setViewName("Warehouse/Inbound/Inbound_Edit");
		mv.addObject("msg", "saveInbound");
		mv.addObject("SupplierList", suppList); 
		mv.addObject("pd", pd);  
		return mv; 
	}
	
	/**
	 * 保存入库数据
	 */
	@RequestMapping(value = "/saveInbound")
	@ResponseBody
	public Object saveInbound() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = new PageData();
		pd = this.getPageData();     
		String p=pd.getString("entities"); 
		JSONArray jsonArray = JSONArray.fromObject(p); 
		if (null == WHService.findByWHId(pd)) {
			if (Jurisdiction.buttonJurisdiction(menuUrl, "add")) { 
				inComeService.saveIncome(pd,(List)jsonArray);  
			} // 判断新增权限
			map.put("msg", "success");
		} else {
			map.put("msg", "failed"); 
		}		 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
	
	/**
	 * 删除入库信息
	 * @throws Exception 
	 */
	@RequestMapping(value = "/deleteInbound")
	public void deleteInbound(PrintWriter out){ 
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> prelist= flowService.findApplyByNo(pd); 
			if(prelist.size()<1){
				if (Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
					inComeService.deleteInbound(pd);
				}
				out.write("success");
			}else out.write("failed");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
	}

	/**
	 *查看入库信息  
	 **/ 
	@RequestMapping(value = "/SelectInbound") 
	public ModelAndView SelectInbound() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(); 
		pd = this.getPageData();  
		List<GoodsDetail> gdlist= inComeService.findByGoods(pd);
		pd.put("ApplyNo", pd.getString("IncomeCode"));
		queryApplyInfo(pd, mv);  	 
		pd = inComeService.findByIncome(pd);  
 		if(pd.getString("ApprovalStatus").equals("3")){
			mv.addObject("isShow", false);
		} 
		mv.setViewName("Warehouse/Inbound/Inbound_Select"); 
		mv.addObject("pd", pd);  
		mv.addObject("gdlist", gdlist); 
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
		mv.addObject("msg", "saveInBoundProduct");
		mv.addObject(Const.SESSION_QX, this.getHC()); 
		return mv;
	}


	/**
	 * combotree 加载根目录菜单
	 * @return
	 * @throws Exception
	 */
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
	 * @param whList
	 * @param warehouseNo
	 * @return
	 */
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
		result = super.applyAudit(menuUrl , mapperFileName, inComeService);
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
		pd.put("IncomeCode", pd.getString("ApplyNo"));
		pd = inComeService.findByIncome(pd);     
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
			inComeService.saveBusinessData(pageData);
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
		inComeService.UpdateStatus(pd);
		map.put("msg", "success"); 
		return AppUtil.returnObject(new PageData(), map); 
	}
	
}
