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
	企业名称：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入单位名称',searcher:search" id="supplierName" style="width:150px;" />
          联系人：<input class="easyui-textbox" data-options="required:false,prompt:'这里输入联系人',searcher:search" id="linkName" style="width:150px;" />
        <button type="button" class="btn btn-small btn-light" onclick="search();" title="查询" style="width:70px;height:28px">
				<i id="nav-search-icon" class="icon-search"></i>查询
		</button>
		<button type="button" class="btn btn-small btn-light" onclick="reset();" title="重置" style="width:70px;height:28px">
				重置
		</button>        
    </div>
</div>

<div style="height:10px"></div>
<table id="supplierlist" title="供应商信息" data-options="singleSelect:true">
	<thead>
		<tr>
            <th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.20)">企业名称</th>
            <th data-options="field:'LinkmanName',align:'center',width:fixWidth(0.18)">联系人名称</th>
            <th data-options="field:'Telephone',align:'center',width:fixWidth(0.22)">联系电话</th> 
            <th data-options="field:'formatOpt',align:'center',width:fixWidth(0.178)">创建时间</th>
            <th data-options="field:'WebSite',align:'center',width:fixWidth(0.20)">企业网址</th>
            <th data-options="field:'Id',align:'center',width:fixWidth(0.08)" hidden="true"></th>
		</tr>
	</thead>
</table>

<div id="tb" style="height:auto">
	<div style="height:5px"></div>
	<a title="新增" class="btn btn-small btn-success" onclick="append();">新增</a>
	<a title="删除" class="btn btn-small btn-primary" onclick="edit();">修改</a>
	<a title="删除" class="btn btn-small btn-danger" onclick="removeit();">删除</a>
	<div style="height:5px"></div>
</div>
</form>

<div id="supplierWindow" class="easyui-window" title="新增供应商信息" 
	data-options="modal:true,closed:true,iconCls:'icon-save',minimizable:false,collapsible:false,maximizable:false" 
	style="width:700px;height:auto;padding:5px;">
		The window content.
</div> 

	<!--提示框-->
	<script type="text/javascript"> 
		
	//新增页面
	function append(){
		$("#supplierWindow").window({
			href:"supplier/goAddSupplier"
		}); 
		$("#supplierWindow").window('open');  
	}
	
	//删除
	function removeit(){
		$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
			if (r){
				var row = $("#supplierlist").datagrid("getSelected"); 
	 			var url = "supplier/deleteSupplier.do?Id="+row.Id;
	 			$.get(url,function(data){
	 				if(data=="success"){
			 			alert("删除成功");  
					 	$('#supplierlist').datagrid('reload');  
					}else if(data=="failed"){
						alert("该供应商下存在商品，不允许执行删除操作");
					} 
				}); 
			}; 
		}); 
	}
	
	//修改
	function edit() {
		var row = $("#supplierlist").datagrid("getSelected");
		if(row==null) return;
		 	var user_id=row.Id; 
		    $("#supplierWindow").window({
				href:"supplier/goEditSupplier?Id="+row.Id,
			}); 
		$("#supplierWindow").window('open');
	} 
	
	$(function() {		
		$('#supplierlist').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		//分页处理
		var pageUrl = 'supplier/supplierlistPage';
		loadGrid($('#supplierlist'),pageUrl);		
	});
	
	
	//检索
	function search(){
		var params = {"EnterpriseName":$("#supplierName").val(),
					  "LinkmanName":$("#linkName").val() };
		$("#supplierlist").datagrid('load', params); 
	}
	 
	
	
 </script> 
</body>
</html>

