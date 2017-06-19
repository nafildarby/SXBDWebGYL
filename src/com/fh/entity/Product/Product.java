package com.fh.entity.Product;

import com.fh.entity.Page;

public class Product {

	private String Id;					 
	private String CategoryId;			 
	private String ComboItemId; 		 
	private String TimingId;		 
	private String ProductNo;			 
	private String ProductName;				 
	private String Abbreviation;				 
	private String BarCode;					 
	private String SpareCode;			 
	private String Price; 		 
	private String Pledge;		 
	private String Rental;			 
	private String IsLease;				 
	private String LeaseType;				 
	private String IsGroup;					 
	private String SupplierId;			 
	private String Comment; 		 
	private String Status;
	private Page page;		
	private String TaxRate;
	
	
	public String getTaxRate() {
		return TaxRate;
	}
	public void setTaxRate(String taxRate) {
		TaxRate = taxRate;
	}
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public Page getPage() {
		return page;
	}
	public void setPage(Page page) {
		this.page = page;
	}
	public String getCategoryId() {
		return CategoryId;
	}
	public void setCategoryId(String categoryId) {
		CategoryId = categoryId;
	}
	public String getComboItemId() {
		return ComboItemId;
	}
	public void setComboItemId(String comboItemId) {
		ComboItemId = comboItemId;
	}
	public String getTimingId() {
		return TimingId;
	}
	public void setTimingId(String timingId) {
		TimingId = timingId;
	}
	public String getProductNo() {
		return ProductNo;
	}
	public void setProductNo(String productNo) {
		ProductNo = productNo;
	}
	public String getProductName() {
		return ProductName;
	}
	public void setProductName(String productName) {
		ProductName = productName;
	}
	public String getAbbreviation() {
		return Abbreviation;
	}
	public void setAbbreviation(String abbreviation) {
		Abbreviation = abbreviation;
	}
	public String getBarCode() {
		return BarCode;
	}
	public void setBarCode(String barCode) {
		BarCode = barCode;
	}
	public String getSpareCode() {
		return SpareCode;
	}
	public void setSpareCode(String spareCode) {
		SpareCode = spareCode;
	}
	public String getPrice() {
		return Price;
	}
	public void setPrice(String price) {
		Price = price;
	}
	public String getPledge() {
		return Pledge;
	}
	public void setPledge(String pledge) {
		Pledge = pledge;
	}
	public String getRental() {
		return Rental;
	}
	public void setRental(String rental) {
		Rental = rental;
	}
	public String getIsLease() {
		return IsLease;
	}
	public void setIsLease(String isLease) {
		IsLease = isLease;
	}
	public String getLeaseType() {
		return LeaseType;
	}
	public void setLeaseType(String leaseType) {
		LeaseType = leaseType;
	}
	public String getIsGroup() {
		return IsGroup;
	}
	public void setIsGroup(String isGroup) {
		IsGroup = isGroup;
	}
	public String getSupplierId() {
		return SupplierId;
	}
	public void setSupplierId(String supplierId) {
		SupplierId = supplierId;
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
