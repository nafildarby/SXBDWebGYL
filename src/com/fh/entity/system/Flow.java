package com.fh.entity.system;

import com.fh.entity.Page;

/**
 * 
* 类名称：User.java
* 类描述： 
* @author FH
* 作者单位： 
* 联系方式：
* 创建时间：2014年6月28日
* @version 1.0
 */
public class Flow {
	private String Id;			
	private String Name;		
	private String CodeNo; 		
	private String StartDate;		
	private String Status;		
	private String Description;
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getName() {
		return Name;
	}
	public void setName(String name) {
		Name = name;
	}
	public String getCodeNo() {
		return CodeNo;
	}
	public void setCodeNo(String codeNo) {
		CodeNo = codeNo;
	}
	public String getStartDate() {
		return StartDate;
	}
	public void setStartDate(String startDate) {
		StartDate = startDate;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	public String getDescription() {
		return Description;
	}
	public void setDescription(String description) {
		Description = description;
	}	
	
	
}
