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
			<form method="post" name="cateForm" id="cateForm">   
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
				<table Id="list_data" class="easyui-treegrid" title="物料分类信息 "style="width:auto;height:auto"
					data-options="
						url:'cate/listCate',
						method: 'get',
						rownumbers: true,
						showFooter: true,
						idField:'Id',
						treeField: 'CategoryName',
						onLoadSuccess: function () {$('#list_data').treegrid('collapseAll')}" fitcolumns="true">
					<thead>
						<tr>  
							<th data-options="field:'CategoryName',width:300,align:'left',halign:'center'">类型名称</th>  
							<th data-options="field:'Id',align:'left',halign:'center'" hidden="true">Id编号</th> 
						</tr>
					</thead> 
				</table>  
				
			</form>
			</div> 
			
	 		<div id="cateWindow" class="easyui-window" title="物料分类" style="width:390px;height:170px;padding:10px;"   
			        data-options="iconCls:'icon-save',closed:true,modal:true,resizable:false">   
			    Window Content    
			</div>  

	<!--提示框-->
	<script type="text/javascript"> 
	
	 	//新增
		function add(){   
			$("#cateWindow").window({
				href:"cate/goAddCate"
			}); 
			$("#cateWindow").window('open');  
		};
		 
		//修改
		function edit(){
		 	var row = $("#list_data").treegrid('getSelected');
		  	if(row==null) {
		 		alert("请选择要修改的数据");
		 	} 
		    $("#cateWindow").window({
				href:"cate/goEditCate?Id="+row.Id,
			}); 
			$("#cateWindow").window('open');   
		};
		
		//删除
		function makeAll(){   
		 	$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#list_data").treegrid("getSelected");					
		 			if(row==null) return;   
		 			var url = "<%=basePath%>cate/deleteCate.do?Id="+row.Id;
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

