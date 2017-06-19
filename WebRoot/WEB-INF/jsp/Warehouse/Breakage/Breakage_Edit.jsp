<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%> 
 

<!DOCTYPE html>
<html> 
<body>
<div style="height:100%;">
    <form id="myForm">
        <div class="info_innerframe" style="margin:0px 10px 0px 10px;clear:both;">
            <fieldset class="scheduler-border">
            <legend class="scheduler-border" style="font-size:14px;">基础信息</legend>
            <input id="Id" value="${pd.Id}"  style="width:230px;" hidden="true">					 
            <table class="tab" border="0" cellpadding="3px" cellspacing="0" width="100%">
             	<tbody> 
                     <tr>  
                        <td class="tabAlign">报损单号：</td>
                        <td>
                        	<input id="rLossNo" class="easyui-textbox" value="${pd.ReportedLossNo}" disabled="disabled" style="width:220px;" />
                        </td>
                        <td class="tabAlign">报损仓库：</td>
                        <td>
                        	<input id="WarehouseNo"  class="easyui-combotree" value="${pd.WarehouseNo}" data-options="required:true" style="width:220px;" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tabAlign">报损时间：</td> 
                        <td>
                        	<input id="ReportedLossTime" class="easyui-textbox" value="${pd.ReportedLossTime}" disabled="disabled" style="width:220px;" />
                        </td>
                        <td class="tabAlign">操作人：</td>
                        <td>
                        	<input id="ReportedLossPerson" class="easyui-textbox" value="${pd.ReportedLossPerson}" disabled="disabled" style="width:220px;" />
                        </td> 
                    </tr> 
                    <tr>
                        <td class="tabAlign">备注：</td>
                        <td colspan="10">
                        	<textarea class="easyui-validatebox validatebox-text" id="Comment" cols="88" style="width:99%;height:20px;"></textarea>
                        </td>
                    </tr>
                	</tbody>
            	</table>
            </fieldset>
        </div>
        <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">报损物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="breakageGoods" data-options="iconCls:'icon-edit',toolbar:'#tb',singleSelect:true">
					        <thead>
					            <tr>  
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.18)">物料名称</th>
					                <th data-options="field:'ProductBarCode',align:'center',width:fixWidth(0.20)">物料条码</th> 
					                <th data-options="field:'Number',align:'center',width:fixWidth(0.105),editor:'textbox'" >报损数量</th> 
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.18),editor:'textbox'">备注</th>
					                <th data-options="field:'opt',align:'center',width:fixWidth(0.14), formatter:formatOpt">操作</th>   
					            </tr>
					        </thead>
					    </table> 
						<div id="tb1" style="height:auto">
							<div style="height:5px"></div> 
							<a title="选择商品" class="btn btn-small btn-success" onclick="SelectWHNoGoods();">选择商品</a>
							<a title="保存" class="btn btn-small btn-danger" onclick="btnSave();">保存</a>
							<a title="取消" class="btn btn-small btn-primary" onclick="btnCancel();">取消</a>
							<div style="height:5px"></div>
						</div>
					</div>
				</div>
           </fieldset>
        </div>  
        <div id="selectGoodsWindow" class="easyui-window" title="仓库物料信息" 
        	data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:800px;height:400px;padding:10px;">
				The window content.
		</div> 
    </form>
</div> 

<script type="text/javascript"> 

	//页面加载时事件
 	$(document).ready(function(){
	 	$("#WarehouseNo").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择报损仓库',	
			required:true,	  
	 	});  
	  
	 	var dg = $('#breakageGoods').datagrid({
	 		toolbar: '#tb1',
	 		width:'auto',
			height:'auto',
	        nowrap: false, 
	        striped: true, 
	        border: true, 
	        collapsible:false,//是否可折叠的  
	        url:'', 
	        method: 'POST', 
	        remoteSort:false,
	        showFooter:true
	    });
	 	dg.datagrid('enableCellEditing');
	});      
	 
	 
	//选择物料 
	function SelectWHNoGoods(){
		var whno=$("#WarehouseNo").combobox("getValue"); 
		if(whno!=null && whno!=""){
			$("#selectGoodsWindow").window({
				href:"breakage/goWHNoGoods?WHNo="+whno
			});  
			$("#selectGoodsWindow").window('open');
		}else alert("请选择报损仓库");
	};
	
	//连接格式化
	function formatOpt(value,row,index){   
		return '<a href="javascript:void(0)" onclick="toDelete(\'' + index +'\')">删除</a>';  
	}
  	function  toDelete(index) {     
	    $('#breakageGoods').datagrid('deleteRow', index);
        var rows = $('#breakageGoods').datagrid('getRows');
        $('#breakageGoods').datagrid("loadData", rows);
	};    
	 
	
	//保存数据
 	function btnSave(){ 
 		var numflg=false;
 		var flag=false;
		var entities = null;
		var objArray=[];   
		var WHNo=$("#WarehouseNo").combobox("getValue");    
		var rows = $("#breakageGoods").datagrid('getRows');  
		// 循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
		// 在后台反序列话成对象的对象集合。 
		for(i = 0;i< rows.length;i++){	
			if(rows[i].Number==null||rows[i].Number==""){flag=true;} 
			rows[i].ReportedLossNo=$("#rLossNo").val();  
	   		objArray.push(rows[i]);		 
		}  
		if(WHNo=="" || WHNo==null){
			alert("请填写必填项");  
		}else if(flag==true){
   			alert("请填写报损商品数量");  
   		}else{  
			entities =JSON.stringify(objArray);
			$.ajax({
				type:"post",
				url:"breakage/" + '${msg }',
				dataType:"json",
				data:{  
					"ReportedLossNo":$("#rLossNo").val(), 
					"WarehouseNo":$("#WarehouseNo").combobox("getValue"),
					"ReportedLossTime":$("#ReportedLossTime").val(), 
					"Comment":$("#Comment").val(), 
					"ReportedLossPerson":$("#ReportedLossPerson").val(), 
					"ApprovalStatus":0,
					"Status":1,
					"entities":entities,
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("保存成功");  
						 $('#breakagelist').datagrid('reload');  
						//关闭父页面弹出窗口
						$("#breakageWindow").window('close');
					};
				},
				error:function(){ 
					alert("保存失败"); 
				}
			});  
		};    
	};
	 
	//取消操作
	function btnCancel(){
		$("#breakageWindow").window('close'); 			
	}; 
  
</script>
</body>
</html>


