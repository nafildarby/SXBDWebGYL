<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
<%@ include file="../../system/admin/top.jsp"%> 
</head>
<body>

<div style="height:10px"></div>
	<form  method="post" name="form" id="form">
	<div class="info_innerframe">
	<div style="margin:0px;">
	商品名称：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入商品名称',searcher:search" id="name" style="width:180px;" />
          商品条码：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入商品条码',searcher:search" id="barcode" style="width:180px;" />
          选择仓库：<input id="combotree"  class="easyui-combotree" style="width:180px;">	
          供应商：	<select class="easyui-combobox" name="SupplierId" id="SupplierId" data-options="prompt:'输入供应商首字进行查询'" style="width:180px;">
				<option value=""></option>
			    <c:forEach items="${SupplierList}" var="Supplier">
					<option value="${Supplier.Id }" <c:if test="${Supplier.Id == pd.SupplierId}">selected</c:if>>${Supplier.EnterpriseName}</option>
				</c:forEach>
			</select> 
        <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="setValue();" title="重置" style="width:70px;height:28px">
				重置
		</button>        
    </div>
</div>

<div style="height:10px"></div>
<table id="Stock" title="库存信息" data-options="singleSelect:true">
	<thead>
		<tr>  
            <th data-options="field:'ProductNo',align:'center',width:fixWidth(0.17)">商品编码</th>
            <th data-options="field:'InventoryQuantity',align:'center',width:fixWidth(0.08)">商品库存</th> 
            <th data-options="field:'ComItemName',align:'center',width:fixWidth(0.08)">商品单位</th>
			<th data-options="field:'Price',align:'center',width:fixWidth(0.08)">商品单价</th> 
			<th data-options="field:'CategoryName',align:'center',width:fixWidth(0.08)">商品类型</th> 
			<th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.18)">供应商名称</th> 
			<th data-options="field:'WarehouseName',align:'center',width:fixWidth(0.15)">所属仓库</th> 
            <th data-options="field:'Abbreviation',align:'center',width:fixWidth(0.15)">商品简称</th>
		</tr>
	</thead>
</table> 
</form>
 

	<!--提示框-->
	<script type="text/javascript"> 
 	
 	$(document).ready(function(){
	 	$("#combotree").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择要查询的仓库',	 
	 	});  
	 });
 	 
 	
	$(function() {		
		$('#Stock').datagrid({
			toolbar: '#tb',    //添加表格工具栏
			frozenColumns:[[
	  			{title:'商品名称',field:'ProductName',align:'center',width:fixWidth(0.15),sortable:true},
	  			{title:'商品条码',field:'ProductBarCode',align:'center',width:fixWidth(0.18),sortable:true}  
			]]
	    }); 
		//分页处理
		var pageUrl = 'Stock/StocklistPage';
		loadGrid($('#Stock'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"name":$("#name").val(),
					  "barcode":$("#barcode").val(),
					  "WHNo": $("#combotree").combobox("getValue"),
					  "Supplier":$("#SupplierId").combobox("getValue") };
		$("#Stock").datagrid('load', params); 
	}
	
	//重置
	function setValue(){  
		$("#combotree").combotree("setValue","");
		$("#SupplierId").combobox("setValue","");
		$("#form").find("input").val("");
	} 
	</script> 
</body>
</html>

