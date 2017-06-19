package com.fh.entity.system;

import java.util.List;
/**
 * 
* 类名称：Menu.java
* 类描述： 
* @author FH
* 作者单位： 
* 联系方式：
* 创建时间：2014年6月28日
* @version 1.0
 */
public class ApplyAudit {
	private String Id;
	private String FlowNo;
	private String MenuName;
	private String ApplyNo;
	private String ApplyTime;
	private String Status;
	private String FlowName;
	private String CurrentStep;
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getFlowNo() {
		return FlowNo;
	}
	public void setFlowNo(String flowNo) {
		FlowNo = flowNo;
	}
	public String getMenuName() {
		return MenuName;
	}
	public void setMenuName(String menuName) {
		MenuName = menuName;
	}
	public String getApplyNo() {
		return ApplyNo;
	}
	public void setApplyNo(String applyNo) {
		ApplyNo = applyNo;
	}
	public String getApplyTime() {
		return ApplyTime;
	}
	public void setApplyTime(String applyTime) {
		ApplyTime = applyTime;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	public String getFlowName() {
		return FlowName;
	}
	public void setFlowName(String flowName) {
		FlowName = flowName;
	}
	public String getCurrentStep() {
		return CurrentStep;
	}
	public void setCurrentStep(String currentStep) {
		CurrentStep = currentStep;
	}
	
	
}
