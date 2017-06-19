package com.fh.entity.Warehouse;
 

public class Warehouse {

	private String Id;					//id
	private String WarehouseNo;			//仓库编号
	private String WarehouseName; 		//仓库名称
	private String WarehouseStatus;		//仓库状态 
	private String ParentNo;			//所属仓库
	private String Comment;				//备注
	private String Status;				//状态 

	
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getWarehouseNo() {
		return WarehouseNo;
	}
	public void setWarehouseNo(String warehouseNo) {
		WarehouseNo = warehouseNo;
	}
	public String getWarehouseName() {
		return WarehouseName;
	}
	public void setWarehouseName(String warehouseName) {
		WarehouseName = warehouseName;
	}
	public String getWarehouseStatus() {
		return WarehouseStatus;
	}
	public void setWarehouseStatus(String warehouseStatus) {
		WarehouseStatus = warehouseStatus;
	}
	public String getParentNo() {
		return ParentNo;
	}
	public void setParentNo(String parentNo) {
		ParentNo = parentNo;
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
