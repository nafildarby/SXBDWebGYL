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
public class FlowDetail {
	private String Id;			
	private String NodeName;		
	private String CodeNo; 		
	private String SartRole;		
	private String EndRole;		
	private String Comment;
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getNodeName() {
		return NodeName;
	}
	public void setNodeName(String nodeName) {
		NodeName = nodeName;
	}
	public String getCodeNo() {
		return CodeNo;
	}
	public void setCodeNo(String codeNo) {
		CodeNo = codeNo;
	}
	public String getSartRole() {
		return SartRole;
	}
	public void setSartRole(String sartRole) {
		SartRole = sartRole;
	}
	public String getEndRole() {
		return EndRole;
	}
	public void setEndRole(String endRole) {
		EndRole = endRole;
	}
	public String getComment() {
		return Comment;
	}
	public void setComment(String comment) {
		Comment = comment;
	}
	
	
}
