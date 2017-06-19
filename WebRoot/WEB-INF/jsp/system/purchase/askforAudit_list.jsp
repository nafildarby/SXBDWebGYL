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
					<form action="Askfor/Askforlist" method="post" name="askforForm" id="askforForm">
						<table>
							<tr>
								<td align="center">
									 <input id="AskforNo" name="AskforNo" class="easyui-searchbox" data-options="prompt:'请输入申请订单编号',searcher:search" style="width:100%">
								</td>
								<td align="center">
									 <input id="AskforPerson" name="AskforPerson" class="easyui-searchbox" data-options="prompt:'请输入申请订单人员名称',searcher:search" style="width:100%">
								</td>
							</tr>
						</table>
						<!-- 检索  --> 

						<div style="height:10px"></div> 
						<table id="askforList" title="采购申请" data-options="singleSelect:true">
							<thead>
								<tr>
									<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
									<th data-options="field:'Id',align:'middle',halign:'center',"></th>
 									<th data-options="field:'askforNo',width:fixWidth(0.21),align:'left',halign:'center'">采购申请编号</th>
									<th data-options="field:'askforPerson',width:fixWidth(0.25),align:'left',halign:'center'">申请填写人</th>
									<th data-options="field:'askforTime',width:fixWidth(0.25),align:'left',halign:'center'">申请填写时间</th>
									<th data-options="field:'Comment',width:fixWidth(0.22),align:'left',halign:'center'">备注</th>
								</tr>
							</thead>  
						</table>
						
						<div class="page-header position-relative">
							<table style="width:100%;">
								<tr>
									<td style="vertical-align:top;">
											<a class="btn btn-small btn-success" onclick="audit();">采购申请审核</a>
											<a class="btn btn-small btn-success" onclick="detail();">查看明细</a>
										</td>
									<td style="vertical-align:top;"></td>
								</tr>
							</table>
						</div>
					</form>
				</div>
				
				<div id="askforWindow" class="easyui-window" title="采购申请信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:90%;height:500px;padding:10px;">
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
			var pageUrl = 'Askfor/listAskforAuditPage';
			loadGrid($('#askforList'),pageUrl);
			
			$("#askforList").datagrid('hideColumn', 'Id');
		});
		
		//检索
		function search(){
			$("#askforList").datagrid({  
                url:"Askfor/listAskforAuditPage?AskforNo=" + $("#AskforNo").val() + "&&AskforPerson="+ $("#AskforPerson").val()
            });
            $("#askforList").datagrid('reload'); 
		}
		 
		//审核采购申请
		function audit(){
		 	var row = $("#askforList").datagrid("getSelected");
		 	if(row==null) return;
		 	var id=row.Id;
		    $("#askforWindow").window({
				href:"Askfor/goEditP?PURCHASE_ID="+id,
			}); 
			$("#askforWindow").window('open');   
		}
		
		//查看明细
		function detail(){
			var row = $("#askforList").datagrid("getSelected");
		 	if(row==null) return;
		 	var id=row.Id;
		    $("#askforWindow").window({
				href:"Askfor/goAskforDetail?ASKFORID="+id,
			}); 
			$("#askforWindow").window('open');
		}
		</script>

</body>
</html>

