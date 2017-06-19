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
			<form method="post" name="whForm" id="whForm"> 
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
								</c:if>
							</td>
							<td style="vertical-align:top;"></td>
						</tr>
					</table>
				<div style="height:10px"></div>  
				<table Id="list_data" class="easyui-treegrid" title="仓库信息 " fitcolumns="true" 
					data-options="
						url:'wh/listWHouse',
						method: 'get',
						rownumbers: true,
						showFooter: true,
						idField:'WarehouseNo',
						treeField: 'WarehouseName',
						onLoadSuccess: function () {$('#list_data').treegrid('collapseAll')}">
					<thead>
						<tr>  
							<th data-options="field:'WarehouseName',width:400,align:'left',halign:'center'">仓库名称</th>  
							<th data-options="field:'WarehouseNo',width:400,align:'left',halign:'center'">仓库编号</th>
							<th data-options="field:'Id',align:'left',halign:'center'" hidden="true">Id编号</th> 
						</tr>
					</thead> 
				</table> 
			 
			<!--<div class="page-header position-relative"> 下划线</div> -->
			</form>
			</div> 
			
			<div id="whWindow" class="easyui-window" title="仓库信息" 
				data-options="modal:true,closed:true,iconCls:'icon-save'" 
				style="width:340px;height:270px;padding:10px;">
				The window content.
			</div>
 

	<!--提示框-->
	<script type="text/javascript"> 
	
	 	//新增
		function add(){   
			$("#whWindow").window({
				href:"wh/goAddWH"
			}); 
			$("#whWindow").window('open');  
		};
		 
		//修改
		function edit(){
		 	var row = $("#list_data").treegrid('getSelected');
		  	if(row==null) {
		 		alert("请选择要修改的数据");
		 	} 
		    $("#whWindow").window({
				href:"wh/goEditWH?Id="+row.Id,
			}); 
			$("#whWindow").window('open');   
		};
		
		//删除
		function makeAll(){   
		 	$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#list_data").treegrid("getSelected");					
		 			if(row==null) return;   
		 			var url = "<%=basePath%>wh/deleteWH.do?Id="+row.Id;
		 			$.get(url,function(data){ 
		 				if(data == "child"){
		 					alert("该节点下含有数据，不允许执行该操作！"); 
						}else if(data == "success"){
							alert("删除成功");  
						}else alert("删除失败"); 
						$('#list_data').treegrid('reload'); 
					});    
				};  
			});     
		};  
	</script> 
</body>
</html>

