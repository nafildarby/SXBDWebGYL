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
	申请单号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入申请单号',searcher:search" id="GoodsApplyNo" style="width:150px;" />
          审核状态：  <select id="approvalStatus" class="easyui-combobox" data-options="panelHeight:'auto'" style="width:150px;">
            <option value="">全部</option>
            <option value="0">未提交审核</option>
            <option value="1">审核中</option> 
            <option value="2">已审核</option> 
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
<table id="applylist" title="申请物料单" data-options="singleSelect:true">
	<thead>
		<tr>
            <th data-options="field:'GoodsApplyNo',align:'center',width:fixWidth(0.18)">申请单号</th>
            <th data-options="field:'WarehouseName',align:'center',width:fixWidth(0.16)">仓库名称</th>
            <th data-options="field:'ApplyTime',align:'center',width:fixWidth(0.16), formatter:formatDate">申请日期</th>
            <th data-options="field:'ApplyPerson',align:'center',width:fixWidth(0.11)">申请人</th>
            <th data-options="field:'Status',align:'center',width:fixWidth(0.11), formatter:formatStatus">数据状态</th>
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.11), formatter:formatAudit">审核状态</th>
			<th data-options="field:'opt',align:'center',width:fixWidth(0.148), formatter:formatOps">操作</th>
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

<div id="applyWindow" class="easyui-window" title="新增申请单据" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:90%;height:500px;padding:10px;">
		The window content.
</div>
<div id="SelectapplyWindow" class="easyui-window" title="查看申请信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:10px;">
		The window content.
</div>

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#applyWindow").window({
			href:"apply/goAddApply"
		}); 
		$("#applyWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#applylist").datagrid("getSelected"); 
	 			var url = "apply/deleteApply.do?Id="+row.Id+"&&ApplyNo="+row.GoodsApplyNo;
	 			$.get(url,function(data){
	 				if(data=="success"){
			 			alert("删除成功");  
					 	$('#applylist').datagrid('reload');   
					}else  alert("已审核不允许执行删除操作");    
				}); 
			}; 
		}); 
	}
	
	$(function() {		
		$('#applylist').datagrid({	toolbar: '#tb'   });    //添加表格工具栏  
		//分页处理
		var pageUrl ="apply/applylistPage";
		loadGrid($('#applylist'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"GoodsApplyNo":$("#GoodsApplyNo").val(),  
					  "ApprovalStatus":$("#approvalStatus").combobox("getValue")  };
		$("#applylist").datagrid('load', params); 
	}
	
	//重置
	function setValue(){ 
		$("#Status").combobox("setValue","");
		$("#form").find("input").val("");
	}
	
	//连接格式化
	function formatOps(data,row,index){
			if(row.ApprovalStatus ==  0)
	    		return '<a href="javascript:void(0)" onclick="submitAudit(\'' +  row.GoodsApplyNo + '\')">提交审核</a>';
			else
				return '<a href="javascript:void(0)" onclick="showAudit(\'' +  row.GoodsApplyNo + '\')">查看状态</a>';
	    }
	    
	    
	 function submitAudit(askforNo){
			$.ajax({
				type:"post",
				url:"apply/applyAudit",
				dataType:"json",
				data:{
					"ApplyNo": askforNo
				},
				success:function(data){
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("提交审批成功");
						$('#applylist').datagrid('reload'); 
					}
					else{
						alert("未知结果");
					};
				},
				error:function(){
					alert("保存失败");
				}
			});
	    }
	    
	function  showAudit(goodsApplyNo) {  
		$("#SelectapplyWindow").window({ 
			href:"apply/SelectApply.do?GoodsApplyNo="+goodsApplyNo,
		}); 
		$('#SelectapplyWindow').window('open'); 
	};  
 
	
	//状态格式化
	function formatStatus(value,row,index){
		switch(value){
			case 0: return "已删除";
			case 1: return "已申请"; 
			default: return value;
		}
	};
	</script> 
</body>
</html>

