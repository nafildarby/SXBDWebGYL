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
	入库单号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入入库单号',searcher:search" id="IncomeCode" style="width:150px;" />
         入库批号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入入库批号',searcher:search" id="IncomeBatch" style="width:150px;" />
        <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="setValue();" title="重置" style="width:70px;height:28px">
				重置
		</button>        
    </div>
</div>

<div style="height:10px"></div>
<table id="tblWhsInbound" title="采购入库单" data-options="singleSelect:true">
	<thead>
		<tr>
            <th data-options="field:'IncomeCode',align:'center',width:fixWidth(0.16)">入库单号</th>
            <th data-options="field:'WhsName',align:'center',width:fixWidth(0.14)">仓库名称</th>
            <th data-options="field:'IncomeBatch',align:'center',width:fixWidth(0.16)">入库批号</th>
            <th data-options="field:'IncomeDate',align:'center',width:fixWidth(0.16), formatter:formatDate">入库日期</th>
            <th data-options="field:'OpName',align:'center',width:fixWidth(0.10)">操作人姓名</th>
            <th data-options="field:'StatusFlag',align:'center',width:fixWidth(0.08), formatter:formatStatus">数据状态</th>
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.08), formatter:formatAudit">审核状态</th>            
			<th data-options="field:'opt',align:'center',width:fixWidth(0.10), formatter:formatOpt">操作</th>
		</tr>
	</thead>
</table>

<div id="tb" style="height:auto">
	<div style="height:5px"></div>
	<a title="新增" class="btn btn-small btn-success" onclick="append();">新增</a>
	<a title="删除" class="btn btn-small btn-danger" onclick="removeit();">删除</a>
	<div style="height:5px"></div>
</div>
</form>

<div id="inbWindow" class="easyui-window" title="新增普通入库" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:90%;height:500px;padding:10px;">
		The window content.
</div>
<div id="SelectinbWindow" class="easyui-window" title="查看入库信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:5px;">
		The window content.
</div>

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#inbWindow").window({
			href:"inbound/goAddinbound"
		}); 
		$("#inbWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#tblWhsInbound").datagrid("getSelected");
	 			if(row==null) return; 
	 			var url = "inbound/deleteInbound.do?Id="+row.Id+"&&ApplyNo="+row.IncomeCode;
	 			$.get(url,function(data){
	 				if(data=="success"){
			 			alert("删除成功");  
					 	$('#tblWhsInbound').datagrid('reload');  
					}else  alert("已审核不允许执行删除操作");  
				}); 
			}; 
		}); 
	}
	
	$(function() {		
		$('#tblWhsInbound').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = 'inbound/listInboundPage';
		loadGrid($('#tblWhsInbound'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"IncomeCode":$("#IncomeCode").val(),
					  "IncomeBatch":$("#IncomeBatch").val() };
		$("#tblWhsInbound").datagrid('load', params); 
	}
	
	//重置
	function setValue(){ 
		$("#StatusFlag").combobox("setValue","");
		$("#form").find("input").val("");
	}
	
	//连接格式化
	function formatOpt(value,row,index){  
		if(row.ApprovalStatus ==  0)
		    return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.IncomeCode + '\')">提交审核</a>';
		else 
			return '<a href="javascript:void(0)" onclick="toSelect(\'' + row.IncomeCode +'\')">查看状态</a>';  
	}
	function  toSelect(incomeCode) {  
		$("#SelectinbWindow").window({ 
			href:"inbound/SelectInbound.do?IncomeCode="+incomeCode,
		}); 
		$('#SelectinbWindow').window('open');  
	};  
 	function submitAudit(incomeCode){
		$.ajax({
			type:"post",
			url:"inbound/applyAudit",
			dataType:"json",
			data:{
				"ApplyNo": incomeCode
			},
			success:function(data){
				if(data.msg == "failed"){
					alert("保存失败");
				}else if(data.msg == "success"){
					alert("提交审批成功");
					$("#tblWhsInbound").datagrid("reload"); 
				}
				else{
					alert("未知结果");
				};
			},
			error:function(){
				alert("保存失败");
			}
		});
	};
	
	//状态格式化
	function formatStatus(value,row,index){
		switch(value){
			case 0: return "已删除";
			case 1: return "已入库"; 
			default: return value;
		}
	};
	</script> 
</body>
</html>

