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
public class Purchase {
	
	private String Id;
	private String PurchaseNo;
	private String OrderPerson;
	private String OrderTime;
	private String Comment;
	private String Status;
	public String getPurchaseNo() {
		return PurchaseNo;
	}
	public void setPurchaseNo(String purchaseNo) {
		PurchaseNo = purchaseNo;
	}
	public String getOrderPerson() {
		return OrderPerson;
	}
	public void setOrderPerson(String orderPerson) {
		OrderPerson = orderPerson;
	}
	public String getOrderTime() {
		return OrderTime;
	}
	public void setOrderTime(String orderTime) {
		OrderTime = orderTime;
	}
	public String getComment() {
		return Comment;
	}
	public void setComment(String comment) {
		Comment = comment;
	}
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	
	
}
