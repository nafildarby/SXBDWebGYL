<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<body>
	<div class="container-fluid" id="main-container" style="height:700px;"> 
		<div style="height:10px">
			<input type="hidden" id="SelectWay" value="${msg}">
		</div>
			<form action="product/productlist" method="post" name="productForm" id="productForm"> 
			<!-- 检索  --> 
			<table>
				<tr>
					<td align="center">
						<input id="ProductNo" name="ProductNo" class="easyui-searchbox" data-options="prompt:'请输入关键字商品编号',searcher:search" style="width:80%">
					</td>
					<td align="center">
						<input id="ProductName" name="ProductName" class="easyui-searchbox" data-options="prompt:'请输入关键字商品名称',searcher:search" style="width:80%">
					</td> 
					<td align="center">
						<input id="BarCode" name="BarCode" class="easyui-searchbox" data-options="prompt:'请输入关键字商品条码',searcher:search" style="width:80%">
					</td> 
					<td align="center">
						<a title="保存" class="btn btn-small btn-danger" onclick="Save();">保存</a>
					</td> 
					<td align="center"> 
						<a title="取消" class="btn btn-small btn-primary" onclick="cancel();">取消</a>
					</td> 
				</tr>
			</table>
			<!-- 检索  -->
			 
			<div style="height:10px"></div> 
			<table  id="productList" title="物料信息" >
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
 				<!-- 		<th data-options="field:'Id',width:80,align:'left',halign:'center'">编号</th>  -->
						<th data-options="field:'BarCode',width:fixWidth(0.09),align:'center',halign:'center'">商品条码</th> 
						<th data-options="field:'ProductNo',width:fixWidth(0.09),align:'center',halign:'center'">商品编号</th>
						<th data-options="field:'ProductName',width:fixWidth(0.10),align:'center',halign:'center'">商品名称</th>
						<th data-options="field:'Abbreviation',width:fixWidth(0.10),align:'center',halign:'center'">商品简称</th>
						<th data-options="field:'CategoryName',width:fixWidth(0.05),align:'center',halign:'center'">商品类型</th> 
						<th data-options="field:'EnterpriseName',width:fixWidth(0.10),align:'center',halign:'center'">商品供应商</th>						
					</tr>
				</thead>
			</table>
		</form>
		</div> 

	<script type="text/javascript">
		
	
	
		$(function(){
		 	var pageUrl = "product/listProductPage";
			loadGrid($('#productList'),pageUrl);
		});
		
		function search(){
			$("#productList").datagrid({  
                url:"product/listProductPage?ProductName=" + $("#ProductName").val() + "&&ProductNo="+ $("#ProductNo").val() +"&&BarCode="+ $("#BarCode").val()
            });
            $("#productList").datagrid('reload'); 
		}
		
		function  Save(){
			var SelectWay = $("#SelectWay").val();
			if(SelectWay == "saveAskProduct"){
				var rows = $('#productList').datagrid('getSelections');
				$('#askProduct').datagrid('loadData', rows); 
				$("#selectProductWindow").window('close');
			}else if(SelectWay == "saveInBoundProduct"){
				var rows = $('#productList').datagrid('getSelections'); 
				$('#productInfo').datagrid('loadData', rows); 
				$("#selectProductWindow").window('close');
			}else if(SelectWay == "saveApplyProduct"){
				var rows = $('#productList').datagrid('getSelections'); 
				$('#goods').datagrid('loadData', rows); 
				$("#selectProductWindow").window('close');
			}
		};
		
		function cancel(){
			$("#selectProductWindow").window('close');
		};
		
	</script>	 
</body>
</html>