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
			<form action="flow/flowlist" method="post" name="flowForm" id="flowForm"> 
			<!-- 检索  --> 
			<table>
				<tr>
					<td align="center">
						<input id="Name" name="Name" class="easyui-searchbox" data-options="prompt:'请输入关键字名称',searcher:search" style="width:100%">
					</td>
				</tr>
			</table>
			<!-- 检索  -->
			 
			<div style="height:10px"></div> 
			<table  id="workProcedurelist" title="流程信息" class="easyui-datagrid" data-options="singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
 						<th data-options="field:'Id',width:fixWidth(0.18),align:'center',halign:'center'">编号</th>
						<th data-options="field:'Name',width:fixWidth(0.17),align:'center',halign:'center'">流程名称</th>
						<th data-options="field:'CodeNo',width:fixWidth(0.17),align:'center',halign:'center'">流程代号</th>
						<th data-options="field:'StartDate',width:fixWidth(0.13),align:'center',halign:'center',formatter:formatDate">开始日期</th>
						<th data-options="field:'Description',width:fixWidth(0.13),align:'center',halign:'center'">流程描述</th>
						<th data-options="field:'opt',align:'center',width:fixWidth(0.14), formatter:formatOpt">操作</th>						
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
		
		<div id="flowWindow" class="easyui-window" title="流程信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:90%;height:500px;padding:10px;">
		</div> 
		
		<div id="DistributionWindow" class="easyui-window" title="流程信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:40%;height:200px;padding:10px;">
			
		</div> 
 
	<!--提示框-->
	<script type="text/javascript">
	
		//检索
		function search(){
			$("#workProcedurelist").datagrid({  
                url:"WorkProcedure/listworkProcedurePage?Name=" + $("#Name").val()
            });
            $("#workProcedurelist").datagrid('reload'); 
		}
	
	 	$(function () {
			$('#workProcedurelist').datagrid({
				toolbar: '#tb'    //添加表格工具栏
		    });
	 		
		 	var pageUrl = "WorkProcedure/listPageworkProcedure";
			loadGrid($('#workProcedurelist'),pageUrl);
		});    
	 	
	 	//连接格式化
 		function formatOpt(value,row,index){ 
 			var CodeNo = String(row.CodeNo);
 			return '<a href="javascript:void(0)" onclick="toDistribution(\'' + CodeNo +'\')">流程分配</a>';  
 		}
	 	
	 	//分配流程点击事件
 		function  toDistribution(CodeNo) {  
 			$("#DistributionWindow").window({ 
 				href:"WorkProcedure/distributionFlow?CodeNo="+CodeNo,
 			}); 
 			$('#DistributionWindow').panel('open').panel('refresh'); 
 		};  
	 
	 	//新增
		function add(){   
			$("#flowWindow").window({
				href:"WorkProcedure/goAddWorkProcedure"
			}); 
			$("#flowWindow").window('open');
		};
		 
		//修改
		function edit(){
			var row = $("#workProcedurelist").datagrid("getSelected");
		 	if(row==null) return;
		 	var CodeNo = row.CodeNo;
		    $("#flowWindow").window({
				href:"WorkProcedure/goEditWorkProcedure?CodeNo=" + CodeNo,
			}); 
			$("#flowWindow").window('open'); 
		};
		
		//删除
		function makeAll(){ 
			$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#workProcedurelist").datagrid("getSelected");
		 			if(row==null) return;
		 			var CodeNo=row.CodeNo;
		 			var url = "<%=basePath%>WorkProcedure/deleteWorkFlow?CodeNo="+CodeNo;
		 			$.get(url,function(data){
						 alert("删除成功");
						 $("#workProcedurelist").datagrid('reload');  
					}); 
				}; 
			}); 
	     };
		 
	</script> 
</body>
</html>

