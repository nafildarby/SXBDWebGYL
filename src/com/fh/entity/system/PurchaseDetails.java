package com.fh.entity.system;

public class PurchaseDetails {
	
	public String Id;
	public String PurchaseNo;
	public String ProductName;
	public String Abbreviation;
	public String BarCode;
	public String Quantity;
	public String Unit;
	public String CostPrice;
	public String SupplierName;
	public String Comment;
	public String Status;
	public String StorageQuantity;
	
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getPurchaseNo() {
		return PurchaseNo;
	}
	public void setPurchaseNo(String purchaseNo) {
		PurchaseNo = purchaseNo;
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
	public String getQuantity() {
		return Quantity;
	}
	public void setQuantity(String quantity) {
		Quantity = quantity;
	}
	public String getUnit() {
		return Unit;
	}
	public void setUnit(String unit) {
		Unit = unit;
	}
	public String getCostPrice() {
		return CostPrice;
	}
	public void setCostPrice(String costPrice) {
		CostPrice = costPrice;
	}
	public String getSupplierName() {
		return SupplierName;
	}
	public void setSupplierName(String supplierName) {
		SupplierName = supplierName;
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
	public String getStorageQuantity() {
		return StorageQuantity;
	}
	public void setStorageQuantity(String storageQuantity) {
		StorageQuantity = storageQuantity;
	} 
}
