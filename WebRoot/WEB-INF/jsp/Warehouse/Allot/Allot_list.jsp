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
<div style="height:5px"></div>
	<form  method="post" name="form" id="form">
	<div class="info_innerframe">
	<div style="margin:0px;">
		出库单号：<input class="easyui-textbox" data-options="prompt:'这里输入出库单号'" id="OutCode" style="width:250px;" /> 
                   审核状态：  <select id="approvalStatus" class="easyui-combobox" data-options="panelHeight:'auto'" style="width:150px;">
		            <option value="">全部</option>
		            <option value="0">未提交审核</option>
		            <option value="1">审核中</option> 
		            <option value="2">已完成</option> 
		            <option value="3">已拒绝</option> 
		        </select>   
        <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="setValue();" title="重置" style="width:70px;height:28px">
				重置
		</button>              
    </div>
</div>

<div style="height:10px"></div>
<table id="allotlist" title="调拨单据" data-options="singleSelect:true">
    <thead>
        <tr>
        	<th data-options="field:'AllocationNo',align:'center',width:fixWidth(0.16)">出库单号</th>
            <th data-options="field:'OutWarehouseNo',align:'center',width:fixWidth(0.12)">出库仓库</th>
            <th data-options="field:'InWarehouseNo',align:'center',width:fixWidth(0.12)">入库仓库</th>
            <th data-options="field:'AllocationTime',align:'center',width:fixWidth(0.15), formatter:formatDate">出库时间</th>
            <th data-options="field:'AllocationPerson',align:'center',width:fixWidth(0.10)">操作人姓名</th>
            <th data-options="field:'Status',align:'center',width:fixWidth(0.10), formatter:formatStatus">数据状态</th>
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.11), formatter:formatAudit">审核状态</th>
			<th data-options="field:'opt',align:'center',width:fixWidth(0.12), formatter:formatOpt">操作</th>   
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

<div id="allotWindow" class="easyui-window" title="新增调拨单据" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:90%;height:500px;padding:10px;">
		The window content.
</div>

<div id="SelectallotWindow" class="easyui-window" title="查看调拨单据" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:5px;">
		The window content.
</div>

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#allotWindow").window({
			href:"allot/goAddAllot"
		}); 
		$("#allotWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#allotlist").datagrid("getSelected"); 
	 			var url = "allot/deleteAllot.do?Id="+row.Id+"&&ApplyNo="+row.AllocationNo;
	 			$.get(url,function(data){
	 				if(data=="success"){
		 				 alert("删除成功");
						 $('#allotlist').datagrid('reload');  
					}else  alert("已审核不允许执行删除操作");
				}); 
			}; 
		}); 
	}
	
	$(function() {		
		$('#allotlist').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = "allot/allotlistPage";
		loadGrid($('#allotlist'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"OutBoundNo":$("#OutCode").val(),  
					  "ApprovalStatus":$("#approvalStatus").combobox("getValue")  }; 
		$("#allotlist").datagrid('load', params); 
	}
	
	//重置
	function setValue(){ 
		$("#StatusFlag").combobox("setValue","");
		$("#form").find("input").val("");
	}
	
	//连接格式化
	function formatOpt(value,row,index){  
		if(row.ApprovalStatus ==  0)
	    	return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.AllocationNo + '\')">提交审核</a>';
		else
			return '<a href="javascript:void(0)" onclick="toSelect(\'' +row.AllocationNo +'\')">查看状态</a>';  
	}
	function  toSelect(allocationNo) {  
		$("#SelectallotWindow").window({ 
			href:"allot/SelectAllot.do?AllocationNo="+allocationNo,
		}); 
		$('#SelectallotWindow').window("open"); 
	};  
 
  	function submitAudit(allocationNo){
		$.ajax({
			type:"post",
			url:"allot/applyAudit",
			dataType:"json",
			data:{
				"ApplyNo": allocationNo
			},
			success:function(data){
				if(data.msg == "failed"){
					alert("保存失败");
				}else if(data.msg == "success"){
					alert("提交审批成功");
					$("#allotlist").datagrid("reload"); 
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

