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
public class Askfor {
	
	private String Id;
	private String AskforNo;
	private String AskforPerson;
	private String AskforTime;
	private String IsSummary;
	private String AuditStatus;
	private String Comment;
	private String Status;
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getAskforNo() {
		return AskforNo;
	}
	public void setAskforNo(String askforNo) {
		AskforNo = askforNo;
	}
	public String getAskforPerson() {
		return AskforPerson;
	}
	public void setAskforPerson(String askforPerson) {
		AskforPerson = askforPerson;
	}
	public String getAskforTime() {
		return AskforTime;
	}
	public void setAskforTime(String askforTime) {
		AskforTime = askforTime;
	}
	public String getIsSummary() {
		return IsSummary;
	}
	public void setIsSummary(String isSummary) {
		IsSummary = isSummary;
	}
	public String getAuditStatus() {
		return AuditStatus;
	}
	public void setAuditStatus(String auditStatus) {
		AuditStatus = auditStatus;
	}
	public String getComment() {
		return Comment;
	}
	public void setComment(String comment) {
		Comment = comment;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
}
