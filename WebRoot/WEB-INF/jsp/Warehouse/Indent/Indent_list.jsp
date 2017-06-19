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
	订单单号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入订单单号',searcher:searchOrder" id="OrderNo" style="width:150px;" />
	入库单号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入入库单号',searcher:searchOrder" id="IncomeCode" style="width:150px;" />
          入库批号：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入入库批号',searcher:searchOrder" id="IncomeBatch" style="width:150px;" />  
        <button type="button" class="btn btn-small btn-light" onclick="searchOrder();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="setValue();" title="重置" style="width:70px;height:28px">
				重置
		</button>        
    </div>
</div>

<div style="height:10px"></div>
<table id="tbIndent" title="采购入库单" data-options="singleSelect:true">
	<thead>
		<tr>
		  	<th data-options="field:'OrderNo',align:'center',width:fixWidth(0.14)">订单单号</th>
            <th data-options="field:'GoodsReceiptNo',align:'center',width:fixWidth(0.15)">入库单号</th>
            <th data-options="field:'WarehouseName',align:'center',width:fixWidth(0.10)">仓库名称</th>
            <th data-options="field:'IncomeBatch',align:'center',width:fixWidth(0.15)">入库批号</th>
            <th data-options="field:'CollectTime',align:'center',width:fixWidth(0.12),formatter:formatDate">入库日期</th>
            <th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.14)">供应商名称</th>
            <th data-options="field:'Status',align:'center',width:fixWidth(0.058), formatter:formatStatus">数据状态</th>
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.06), formatter:formatAudit">审核状态</th>            
			<th data-options="field:'opt',align:'center',width:fixWidth(0.06), formatter:formatOpt">操作</th>
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

<div id="indWindow" class="easyui-window" title="新增采购入库" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:95%;height:500px;padding:10px;">
		The window content.
</div>  

<div id="goodsWindow" class="easyui-window" title="查看采购入库信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:5px;">
		The window content.
</div>


	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#indWindow").window({
			href:"indent/goAddindent"
		}); 
		$("#indWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#tbIndent").datagrid("getSelected"); 
	 			var url = "indent/deleteIndent.do?Id="+row.Id+"&&ApplyNo="+row.GoodsReceiptNo;
	 			$.get(url,function(data){
	 				if(data=="success"){
			 			alert("删除成功");  
					 	 $('#tbIndent').datagrid('reload');  
					}else  alert("已审核不允许执行删除操作");   
				}); 
			}; 
		}); 
	}
	
	$(function() {		
		$('#tbIndent').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = 'indent/listIndentPage';
		loadGrid($('#tbIndent'),pageUrl);		
	});
	
	
	//检索
	function searchOrder(){
		var params = {"OrderNo":$("#OrderNo").val(),
					  "IncomeCode":$("#IncomeCode").val(),
					  "IncomeBatch":$("#IncomeBatch").val()	 };
		$("#tbIndent").datagrid('load', params); 
	}
	
	//重置
	function setValue(){ 
		$("#StatusFlag").combobox("setValue","");
		$("#form").find("input").val("");
	}
	
	//连接格式化
	function formatOpt(value,row,index){  
		if(row.ApprovalStatus ==  0)
		    return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.GoodsReceiptNo + '\')">提交审核</a>';
		else 
			return '<a href="javascript:void(0)" onclick="toSelect(\'' + row.GoodsReceiptNo +'\')">查看状态</a>';   
	}
	function  toSelect(goodsReceiptNo) {    
		$("#goodsWindow").window({ 
			href:"indent/SelectIndent.do?IncomeCode="+goodsReceiptNo,
		}); 
		$('#goodsWindow').window('open'); 
	};  
 
 	function submitAudit(goodsReceiptNo){
		$.ajax({
			type:"post",
			url:"indent/applyAudit",
			dataType:"json",
			data:{
				"ApplyNo": goodsReceiptNo
			},
			success:function(data){
				if(data.msg == "failed"){
					alert("保存失败");
				}else if(data.msg == "success"){
					alert("提交审批成功");
					$("#tbIndent").datagrid("reload"); 
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

