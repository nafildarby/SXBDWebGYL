<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
<%@ include file="../admin/top.jsp"%>
</head>
<body>

	<div class="container-fluid" id="main-container" style="height:700px;"> 
			<div style="height:10px"></div>
					<!-- 检索  -->
					<form action="purchase/purchaselist" method="post" name="prucahseForm" id="prucahseForm">
						<table>
							<tr>
								<td align="center">
									 <input name="PurchaseNo" class="easyui-searchbox" data-options="prompt:'请输入关键字',searcher:search" style="width:100%">
								</td>
							</tr>
							<tr>
								<c:if test="${QX.cha == 1 }">
									<td style="vertical-align:top;"><button
											class="btn btn-mini btn-light" onclick="search();" title="检索" style="height:28px;">
											<i id="nav-search-icon" class="icon-search"></i>
										</button></td>
								</c:if>
							</tr>
						</table>
						<!-- 检索  --> 

						<div style="height:10px"></div> 
						<table id="purchaseList" title="采购单据" data-options="singleSelect:true">
							<thead>
								<tr>
									<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
									<th data-options="field:'Id',align:'middle',halign:'center',"></th>
 									<th data-options="field:'PurchaseNo',width:fixWidth(0.201),align:'left',halign:'center'">采购单据编号</th>
									<th data-options="field:'OrderPerson',width:fixWidth(0.201),align:'left',halign:'center'">单据填写人</th>
									<th data-options="field:'OrderTime',width:fixWidth(0.201),align:'left',halign:'center'">单据填写时间</th>
									<th data-options="field:'Comment',width:fixWidth(0.201),align:'left',halign:'center'">备注</th>
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
											<a title="删除" class="btn btn-small btn-danger"
												onclick="makeAll('确定要删除选中的数据吗?');">删除</a>
										</c:if></td>
									<td style="vertical-align:top;"></td>
								</tr>
							</table>
						</div>
					</form>
				</div>
				
				<div id="purchaseWindow" class="easyui-window" title="采购单据信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:500px;height:200px;padding:10px;">
					The window content.
				</div> 
	 
	<!--/.fluid-container#main-container-->

	<!-- 返回顶部  
	<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse"> <i
		class="icon-double-angle-up icon-only"></i>
	</a>
	-->

	<!--提示框-->
	<script type="text/javascript">
		
		$(function() {
			
			//分页处理
			var pageUrl = 'Purchase/listPurchasePage';
			loadGrid($('#purchaseList'),pageUrl);
			
			$("#purchaseList").datagrid('hideColumn', 'Id');
			
			//初始化采购单据信息弹出框
			$("#purchaseWindow").window({
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
		
		
		//检索
		function search(){
			$("#prucahseForm").submit();
		}
	 	
	 	//新增
		function add(){   
			$("#purchaseWindow").window({
				href:"Purchase/goAddP"
			}); 
			$("#purchaseWindow").window('open');  
		}
		 
		//修改
		function edit(){
		 	var row = $("#purchaseList").datagrid("getSelected");
		 	if(row==null) return;
		 	var id=row.Id; 
		    $("#purchaseWindow").window({
				href:"Purchase/goEditP?PURCHASE_ID="+id,
			}); 
			$("#purchaseWindow").window('open');   
		}
		
		//删除
		function makeAll(){ 
			$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
// 					var row = $("#purchaseList").datagrid("getSelected");
// 		 			if(row==null) return;
// 		 			var id=row.Id; 
		 			var url = "<%=basePath%>Purchase/deleteP.do?PURCHASE_ID=13";
		 			$.get(url,function(data){
						 alert("删除成功");
						 $('#purchaseList').datagrid('reload');  
					}); 
				}; 
			}); 
	     };
		
		</script>

</body>
</html>

