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
			<input type="hidden" id="SWay" value="${way}">
		</div>
			<form method="post" name="GoodsForm" id="GoodsForm"> 
			<!-- 检索  --> 
			<table>
				<tr>
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
			<table  id="goodsList" title="仓库物料信息" >
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
						<th data-options="field:'ProductName',width:fixWidth(0.15),align:'center',halign:'center'">商品名称</th>
						<th data-options="field:'ProductBarCode',width:fixWidth(0.15),align:'center',halign:'center'">商品条码</th>  
						<th data-options="field:'InventoryQuantity',width:fixWidth(0.134),align:'center',halign:'center'">商品库存</th>						
						<th data-options="field:'ComItemName',width:fixWidth(0.13),align:'center',halign:'center'">商品单位</th> 
					</tr>
				</thead>  
				<%-- <tbody>
					<c:forEach items="${pglist}" var="pg">
						<tr>
							<td class="center" style="cursor:pointer">${pg.ProductName}</td>
					   		<td class="center" style="cursor:pointer">${pg.ProductBarCode}</td>
					   		<td class="center" style="cursor:pointer">${pg.InventoryQuantity}</td> 		
					   		<td class="center" style="cursor:pointer">${pg.ComItemName}</td>
						</tr>
					</c:forEach>
				</tbody> --%>
			</table>
		</form>
		</div> 

	<script type="text/javascript"> 
	
		$(function(){  
			var pageUrl ="${way}"+"/WHNoGoodslistPage";
			loadGrid($("#goodsList"),pageUrl);	   
		});
		 
		 
		
		function search(){
			$("#goodsList").datagrid({  
                url:"allot/WHNoGoodslistPage?ProductName=" + $("#ProductName").val() + "&&BarCode="+ $("#BarCode").val()
            });
            $("#goodsList").datagrid('reload'); 
		}
		
		
		function  Save(){
			var SelectWay = $("#SelectWay").val();
			if(SelectWay == "saveAllotGoods"){
				var rows = $('#goodsList').datagrid('getSelections');
				$('#allotGoods').datagrid('loadData', rows); 
				$("#selectGoodsWindow").window('close');				
			 }else if(SelectWay == "saveBreakageGoods"){
				var rows = $('#goodsList').datagrid('getSelections'); 
				$('#breakageGoods').datagrid('loadData', rows); 
				$("#selectGoodsWindow").window('close'); 
			 }else if(SelectWay == "saveScrapGoods"){
				var rows = $('#goodsList').datagrid('getSelections'); 
				$('#scrapGoods').datagrid('loadData', rows); 
				$("#selectGoodsWindow").window('close'); 
			}
		};
		
		function cancel(){
			$("#selectGoodsWindow").window('close');
		};
		
	</script>	 
</body>
</html>