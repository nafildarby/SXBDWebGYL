/**
 * 
 */
package com.fh.controller.system;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.service.system.FlowManageService;
import com.fh.util.Const;
import com.fh.util.PageData;

/**
 * @author PuLiFan
 * @DATE  2016-9-21
 */


@Controller
@RequestMapping(value="/flow")
public class FlowManageController extends BaseController {

	
	String menuUrl = "flow/flowlist.do";  //菜单对应url，权限用
	
	
	@Resource(name = "FlowManageService")
	private FlowManageService flowMngService;
	
	
	
	@RequestMapping(value = "/flowlist")
	public ModelAndView flowList(){
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData(); 
		
		mv.addObject(Const.SESSION_QX, this.getHC());  
		return mv;
	}
}
