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
                        <td class="tabAlign">盘点单号：</td>
                        <td>
                        	<input id="checkNo" class="easyui-textbox" value="${pd.CheckNo}" disabled="disabled" style="width:180px;" />
                        </td>
                        <td class="tabAlign">盘点仓库：</td>
                        <td>
                        	<input id="WHNo"  class="easyui-combotree" value="${pd.CheckWarehouseNo}" data-options="required:true" style="width:180px;" />
                        </td>
                    </tr>
                    <tr>                    	
                        <td class="tabAlign">盘点时间：</td> 
                        <td>
                        	<input id="CheckTime" class="easyui-textbox" value="${pd.CheckTime}" disabled="disabled" style="width:180px;" />
                        </td>
                        <td class="tabAlign">盘点人：</td>
                        <td>
                        	<input id="CheckMan" class="easyui-textbox" value="${pd.CheckMan}" disabled="disabled" style="width:180px;" />
                        </td> 
                    </tr>  
                	</tbody>
            	</table>
            </fieldset>
        </div>
        <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">盘点物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="CheckGoods" data-options="iconCls:'icon-edit',toolbar:'#tb',singleSelect:true">
					        <thead>
					            <tr>  
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.13)">物料名称</th>
					                <th data-options="field:'ProductBarCode',align:'center',width:fixWidth(0.13)">物料编码</th>
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.14),editor:'textbox'">物料描述</th>
					                <th data-options="field:'InventoryQuantity',align:'center',width:fixWidth(0.10)" >库存数量</th>
					                <th data-options="field:'ComItemName',align:'center',width:fixWidth(0.09)">单位</th>
					                <th data-options="field:'CheckNum',align:'center',width:fixWidth(0.09),editor:'textbox'">盘点数量</th>
					                <th data-options="field:'opt',align:'center',width:fixWidth(0.12), formatter:formatOpt">操作</th>   
					                <th data-options="field:'differValue',align:'center',width:fixWidth(0.14)" hidden="true">差值</th> 
					                <th data-options="field:'CheckNo',align:'center',width:fixWidth(0.14)" hidden="true">盘点编号</th>   
					            </tr>
					        </thead>
					    </table> 
						<div id="tb1" style="height:auto">
							<div style="height:5px"></div> 
							<a title="保存" class="btn btn-small btn-danger" onclick="btnSave();">保存</a>
							<a title="取消" class="btn btn-small btn-primary" onclick="btnCancel();">取消</a>
							<div style="height:5px"></div>
						</div>
					</div>
				</div>
           </fieldset>
        </div>   
    </form>
</div> 

<script type="text/javascript"> 

	//页面加载时事件
 	$(document).ready(function(){
	 	$("#WHNo").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择出库仓库',	
			required:true,	 
			onChange:function(newValue, oldValue){   
				if(newValue!=null && newValue!=""){ 
					$("#CheckGoods").datagrid({
						url:"Check/CheckGoods.do?WHNo="+newValue,
						method:'get',  
					});  
				}
			}  
	 	});  
	 	 
	 	var dg = $('#CheckGoods').datagrid({
	 		toolbar: '#tb1',
	 		width:'auto',
			height:'300px',
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
	 
	
	//连接格式化
	function formatOpt(value,row,index){   
		return '<a href="javascript:void(0)" onclick="toDelete(\'' + index +'\')">删除</a>';  
	}
  	function  toDelete(index) {     
	    $('#CheckGoods').datagrid('deleteRow', index);
        var rows = $('#CheckGoods').datagrid('getRows');
        $('#CheckGoods').datagrid("loadData", rows);
	};    
	 
	
	//保存数据
 	function btnSave(){  
 		var numflg=false;
 		var flag=false;
		var entities = null;
		var objArray=[];   
		var WHNo=$("#WHNo").combobox("getValue");  
		var rows = $("#CheckGoods").datagrid('getRows');  
		// 循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
		// 在后台反序列话成对象的对象集合。 
		for(i = 0;i< rows.length;i++){	
			if(rows[i].CheckNum==null||rows[i].CheckNum==""){flag=true;} 
			rows[i].CheckNo=$("#checkNo").val();   
			rows[i].differValue=rows[i].InventoryQuantity-rows[i].CheckNum;
	   		objArray.push(rows[i]);		 
		}  
		if(WHNo=="" || WHNo==null){
			alert("请填写必填项");  
		}else if(flag==true){
   			alert("请填写盘点数量");  
   		}else{  
			entities =JSON.stringify(objArray);
			$.ajax({
				type:"post",
				url:"Check/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#id").val(),  
					"CheckNo":$("#checkNo").val(),
					"CheckWarehouseNo":$("#WHNo").combobox("getValue"), 
					"CheckTime":$("#CheckTime").val(),  
					"CheckMan":$("#CheckMan").val(), 
					"ApprovalStatus":0,
					"Status":1,
					"entities":entities,
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("保存成功");  
						 $('#checklist').datagrid('reload');  
						//关闭父页面弹出窗口
						$("#CheckWindow").window('close');
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
		$("#CheckWindow").window('close'); 			
	}; 
  
</script>
</body>
</html>


