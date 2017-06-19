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
 									<th data-options="field:'askforNo',width:fixWidth(0.2),align:'left',halign:'center'">采购申请编号</th>
									<th data-options="field:'askforPerson',width:fixWidth(0.15),align:'left',halign:'center'">申请填写人</th>
									<th data-options="field:'askforTime',width:fixWidth(0.15),align:'left',halign:'center',formatter:formatDate">申请填写时间</th>
									<th data-options="field:'AuditStatus',width:fixWidth(0.15),align:'left',halign:'center',formatter:formatAudi">申请状态</th>
									<th data-options="field:'Comment',width:fixWidth(0.15),align:'left',halign:'center'">备注</th>
									<th data-options="field:'opt',align:'center',width:fixWidth(0.12), formatter:formatOpt">操作</th> 
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
										</c:if>
										</td>
									<td style="vertical-align:top;"></td>
								</tr>
							</table>
						</div>
					</form>
				</div>
				
				<div id="askforWindow" class="easyui-window" title="采购申请信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:90%;height:500px;padding:10px;">
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
			var pageUrl = 'Askfor/listAskforPage';
			loadGrid($('#askforList'),pageUrl);
			
			$("#askforList").datagrid('hideColumn', 'Id');
		});
		
		//检索
		function search(){
			$("#askforList").datagrid({  
                url:"Askfor/listAskforPage?AskforNo=" + $("#AskforNo").val() + "&&AskforPerson="+ $("#AskforPerson").val()
            });
            $("#askforList").datagrid('reload'); 
		}
	 	
	 	//新增
		function add(){   
			$("#askforWindow").window({
				href:"Askfor/goAddAskfor"
			}); 
			$("#askforWindow").window('open');  
		}
		 
		//修改
		function edit(){
		 	var row = $("#askforList").datagrid("getSelected");
		 	if(row==null) return;
		 	var askforNo=row.askforNo;
		    $("#askforWindow").window({
				href:"Askfor/goEditAskfor?AskforNo="+askforNo,
			}); 
			$("#askforWindow").window('open');   
		}
		
		//删除
		function makeAll(){ 
			$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#applicationList").datagrid("getSelected");
		 			if(row==null) return;
		 			var id=row.Id; 
 		 			var url = "<%=basePath%>Application/deleteApplication.do?APPLICATION_ID="+id;
		 			$.get(url,function(data){
						 alert("删除成功");
						 $("#askforList").datagrid('reload'); 
					}); 
				}; 
			}); 
	     };
	     
	   //连接格式化
	 	function formatOpt(value,row,index){  
	 		if(row.AuditStatus ==  0)
	 	    	return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.askforNo + '\')">提交审核</a>';
	 		else
	 			return '<a href="javascript:void(0)" onclick="toSelect(\'' +row.askforNo +'\')">查看明细</a>';  
	 	}
	 	function  toSelect(askforNo) {  
	 		$("#askforWindow").window({ 
	 			href:"Askfor/goAskforDetail?AskforNo="+askforNo,
	 		}); 
	 		$('#askforWindow').panel('open').panel('refresh'); 
	 	};  
	 	
	 	function submitAudit(askforNo){
			$.ajax({
				type:"post",
				url:"Askfor/applyAudit",
				dataType:"json",
				data:{
					"ApplyNo": askforNo
				},
				success:function(data){
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("提交审批成功");
						$('#askforList').datagrid('reload'); 
					}
					else{
						alert("未知结果");
						$('#askforList').datagrid('reload'); 
					};
				},
				error:function(){
					alert("保存失败");
					$('#askforList').datagrid('reload'); 
				}
			});
		};
	    
	    //状态格式化
		function formatAudi(value,row,index){
			switch(value){
				case 0: return "未提交";
				case 1: return "审核中"; 
				case 2: return "审核完成"; 
				case 3: return "未通过"; 
				default: return value;  
			}
		};
		
		</script>

</body>
</html>

