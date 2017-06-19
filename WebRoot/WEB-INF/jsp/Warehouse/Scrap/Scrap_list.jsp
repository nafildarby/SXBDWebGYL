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
		报废单单号：<input class="easyui-textbox" data-options="prompt:'这里输入单号'" id="ScrappedNo" style="width:250px;" />         
        <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="reset();" title="重置" style="width:70px;height:28px">
				重置
		</button>              
    </div>
</div>

<div style="height:10px"></div>
<table id="Scraplist" title="报废申请单据" data-options="singleSelect:true">
    <thead>
        <tr>
        	<th data-options="field:'ScrappedNo',align:'center',width:fixWidth(0.18)">报废单号</th>
            <th data-options="field:'WarehouseName',align:'center',width:fixWidth(0.14)">报废申请仓库</th> 
            <th data-options="field:'ScrappedPerson',align:'center',width:fixWidth(0.128)">操作人姓名</th>
            <th data-options="field:'ScrappedTime',align:'center',width:fixWidth(0.14), formatter:formatDate">申请时间</th>
            <th data-options="field:'Status',align:'center',width:fixWidth(0.13), formatter:formatStatus">数据状态</th>  
            <th data-options="field:'ApprovalStatus',align:'center',width:fixWidth(0.13), formatter:formatAudit">审核状态</th>	
			<th data-options="field:'opt',align:'center',width:fixWidth(0.13), formatter:formatOpt">操作</th>   
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

<div id="scrapWindow" class="easyui-window" title="新增报废单据" data-options="modal:true,closed:true,iconCls:'icon-save'" 
	style="width:90%;height:500px;padding:10px;">
		The window content.
</div>
<div id="SelectscrappedNoWindow" class="easyui-window" title="查看报废单据信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:99%;height:500px;padding:5px;">
		The window content.
</div>

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#scrapWindow").window({
			href:"scrap/goAddScrap"
		}); 
		$("#scrapWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#Scraplist").datagrid("getSelected");
	 			if(row==null) return; 
	 			var url = "scrap/deleteScrap.do?Id="+row.Id+"&&ApplyNo="+row.PickingNo;
	 			$.get(url,function(data){
	 				if(data=="success"){
						alert("删除成功");
						$('#Scraplist').datagrid('reload');  
					}else alert("已审核不允许执行删除操作"); 
				}); 
			}; 
		}); 
	}
	
	$(function() {		
		$('#Scraplist').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = "scrap/scraplistPage";
		loadGrid($('#Scraplist'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"ScrappedNo":$("#ScrappedNo").val()};
		$("#Scraplist").datagrid('load', params); 
	} 
	
	//连接格式化
	function formatOpt(value,row,index){  
		if(row.ApprovalStatus ==  0){ 
			return '<a href="javascript:void(0)" onclick="submitAudit(\'' + row.ScrappedNo+ '\')">提交审核</a>';	 
		}else
			return '<a href="javascript:void(0)" onclick="toSelect(\'' + row.ScrappedNo +'\')">查看状态</a>';  
	}
	function  toSelect(scrappedNo) {  
		$("#SelectscrappedNoWindow").window({ 
			href:"scrap/SelectScrap.do?ScrappedNo="+scrappedNo,
		}); 
		$("#SelectscrappedNoWindow").window('open');
	};  
 	function submitAudit(scrappedNo){ 
		$.ajax({
			type:"post",
			url:"scrap/applyAudit",
			dataType:"json",
			data:{
				"ApplyNo": scrappedNo
			},
			success:function(data){
				if(data.msg == "failed"){
					alert("提交审批失败");
				}else if(data.msg == "success"){
					alert("提交审批成功");
					$("#Scraplist").datagrid("reload"); 
				}
				else{
					alert("未知结果");
				};
			},
			error:function(){
				alert("审批失败");
			}
 		});    
	};
	
	//状态格式化
	function formatStatus(value,row,index){
		switch(value){
			case 0: return "已删除"; 
			case 1: return "已确认"; 
			default: return value;  
		}
	};
	</script> 
</body>
</html>

