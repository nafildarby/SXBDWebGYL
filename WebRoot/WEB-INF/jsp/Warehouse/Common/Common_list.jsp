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
		出库单号：<input class="easyui-textbox" data-options="prompt:'这里输入出库单号'" id="OutCode" style="width:250px;" /> 
	    <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="setValue();" title="重置" style="width:70px;height:28px">
				重置
		</button>              
    </div>
</div>

<div style="height:10px"></div>
<table id="commonlist" title="普通出库单" data-options="singleSelect:true">
    <thead>
        <tr>
        	<th data-options="field:'OutBoundNo',align:'center',width:fixWidth(0.16)">出库单号</th>
            <th data-options="field:'OutWarehouseName',align:'center',width:fixWidth(0.15)">出库仓库</th>
            <th data-options="field:'InWarehouseName',align:'center',width:fixWidth(0.15)">入库仓库</th>
            <th data-options="field:'OutBoundTime',align:'center',width:fixWidth(0.118), formatter:formatDate">出库时间</th>
            <th data-options="field:'OutBoundPerson',align:'center',width:fixWidth(0.10)">操作人姓名</th>
            <th data-options="field:'Status',align:'center',width:fixWidth(0.10), formatter:formatStatus">数据状态</th>
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.10), formatter:formatAudit">审核状态</th>            
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

<div id="comWindow" class="easyui-window" title="新增普通出库单" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:90%;height:500px;padding:10px;">
		The window content.
</div>
<div id="SelectcomWindow" class="easyui-window" title="查看出库信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:5px;">
		The window content.
</div>

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#comWindow").window({
			href:"common/goAddCommon"
		}); 
		$("#comWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#commonlist").datagrid("getSelected");
	 			if(row==null) return; 
	 			var url = "common/deleteCommon.do?Id="+row.Id+"&&ApplyNo="+row.CheckNo;
	 			$.get(url,function(data){
	 				if(data=="success"){
			 				alert("删除成功");
					 		$('#commonlist').datagrid('reload');   
					}else  alert("已审核不允许执行删除操作"); 
				});    
			}; 
		}); 
	}
	
	$(function() {		
		$('#commonlist').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = "common/CommonlistPage";
		loadGrid($('#commonlist'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"OutBoundNo":$("#OutCode").val(), 
					  "Status": $("#StatusFlag").combobox("getValue")
						};
		$("#commonlist").datagrid('load', params); 
	}
	
	//重置
	function setValue(){ 
		$("#StatusFlag").combobox("setValue","");
		$("#form").find("input").val("");
	}
	
	//连接格式化
	function formatOpt(value,row,index){  
		if(row.ApprovalStatus ==  0)
		    return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.OutBoundNo + '\')">提交审核</a>';
		else
			return '<a href="javascript:void(0)" onclick="toSelect(\'' + row.OutBoundNo +'\')">查看状态</a>';  
	}
	function  toSelect(outBoundNo) {  
		$("#SelectcomWindow").window({ 
			href:"common/SelectCommon.do?OutBoundNo="+outBoundNo,
		}); 
		$('#SelectcomWindow').window('open'); 
	};  
 	function submitAudit(outBoundNo){
		$.ajax({
			type:"post",
			url:"common/applyAudit",
			dataType:"json",
			data:{
				"ApplyNo": outBoundNo
			},
			success:function(data){
				if(data.msg == "failed"){
					alert("保存失败");
				}else if(data.msg == "success"){
					alert("提交审批成功");
					$("#commonlist").datagrid("reload"); 
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
			case 1: return "已出库"; 
			default: return value;  
		}
	};
	</script> 
</body>
</html>

