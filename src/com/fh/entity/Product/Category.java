package com.fh.entity.Product;
 

public class Category {

	private String Id;					 
	private String ParentId;			 
	private String CategoryName; 		 
	private String Status;	
	 
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getParentId() {
		return ParentId;
	}
	public void setParentId(String parentId) {
		ParentId = parentId;
	}
	public String getCategoryName() {
		return CategoryName;
	}
	public void setCategoryName(String categoryName) {
		CategoryName = categoryName;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}		 
}