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
	<div class="container-fluid" id="main-container" style="height:700px;"> 
		<div style="height:10px"></div> 
			<form action="product/productlist" method="post" name="productForm" id="productForm"> 
			<!-- 检索  --> 
			<table>
				<tr>
					<td align="center">
						<input id="ProductNo" name="ProductNo" class="easyui-searchbox" data-options="prompt:'请输入关键字商品编号',searcher:search" style="width:100%">
					</td>
					<td align="center">
						<input id="ProductName" name="ProductName" class="easyui-searchbox" data-options="prompt:'请输入关键字商品名称',searcher:search" style="width:100%">
					</td> 
					<td align="center">
						<input id="BarCode" name="BarCode" class="easyui-searchbox" data-options="prompt:'请输入关键字商品条码',searcher:search" style="width:100%">
					</td> 
				</tr>
			</table>
			<!-- 检索  -->
			 
			<div style="height:10px"></div> 
			<table  id="productList" title="物料信息" class="easyui-datagrid"  data-options="singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
 						<th data-options="field:'Id',width:fixWidth(0.12),align:'left',halign:'center'">编号</th>
						<th data-options="field:'ProductNo',width:fixWidth(0.16),align:'left',halign:'center'">商品编号</th>
						<th data-options="field:'ProductName',width:fixWidth(0.16),align:'left',halign:'center'">商品名称</th>
						<th data-options="field:'Abbreviation',width:fixWidth(0.15),align:'left',halign:'center'">商品简称</th>
						<th data-options="field:'BarCode',width:fixWidth(0.168),align:'left',halign:'center'">商品条码</th> 
						<th data-options="field:'CategoryName',width:fixWidth(0.16),align:'left',halign:'center'">商品类型</th> 						
					</tr>
				</thead>
			</table>
			<div class="page-header position-relative">
				<table style="width:100%;">
					<tr>
						<td style="vertical-align:top;">
							<c:if test="${QX.add == 1 }">
								<a class="btn btn-small btn-success" onclick="add();">新增</a>
							</c:if> <c:if test="${QX.edit == 1 }">
								<a class="btn btn-small btn-primary" onclick="edit();">修改</a>
							</c:if><c:if test="${QX.del == 1 }">
								<a class="btn btn-small btn-danger" onclick="makeAll();">删除</a>
							</c:if>
						</td>
						<td style="vertical-align:top;"></td>
					</tr> 
				</table>
			</div>
		</form>
		</div> 
		<div id="productWindow" class="easyui-window" title="商品信息" 
		data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:350px;height:auto;padding:10px;">
			The window content.
		</div>
	 
 
	<!--提示框-->
	<script type="text/javascript">
	
		//检索
		function search(){
			$("#productList").datagrid({  
                url:"product/listProductPage?ProductName=" + $("#ProductName").val() + "&&ProductNo="+ $("#ProductNo").val() +"&&BarCode="+ $("#BarCode").val()
            });
            $("#productList").datagrid('reload'); 
		}
	
	 	$(function () { 
		 	var pageUrl = "product/listProductPage";
			loadGrid($('#productList'),pageUrl);
			
			//初始化信息弹出框
			$("#userWindow").window({
				 width: 350,
	            height: 450,
	            top: 50,
	            left:300,
	            collapsible: true,
	            minimizable: true,
	            maximizable: true,
	            resizable: false,
	            modal: true,
	            href: "",
			 });
		});    
	 
	 	//新增
		function add(){   
			$("#productWindow").window({
				href:"product/goAddProduct"
			}); 
			$("#productWindow").window('open');  
		};
		 
		//修改
		function edit(){
		 	var row = $("#productList").datagrid("getSelected");
		 	if(row==null) return;
		 	var id=row.Id; 
		    $("#productWindow").window({
				href:"product/goEditProduct?ProductId="+id,
			}); 
			$("#productWindow").window('open');   
		};
		
		//删除
		function makeAll(){ 
			$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#productList").datagrid("getSelected");
		 			if(row==null) return;
		 			var id=row.Id;
		 			var url = "<%=basePath%>product/deleteProduct.do?Id="+id;
		 			$.get(url,function(data){
						 alert("删除成功");
						 $("#productList").datagrid('reload');  
					}); 
				}; 
			}); 
	     };
		 
	</script> 
</body>
</html>

