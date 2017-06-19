<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%> <!-- 获取系统时间必须导入的  -->
<%@ page import="java.text.*"%> <!-- 获取系统时间必须导入的  -->
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
                        <td class="tabAlign">出库单号：</td>
                        <td>
                        	<input id="outCode" class="easyui-textbox" value="${pd.OutBoundNo}" disabled="disabled" style="width:180px;" />
                        </td>
                        <td class="tabAlign">出库仓库：</td>
                        <td>
                        	<input id="outWHNo"  class="easyui-combotree" value="${pd.WHNo}" data-options="required:true" style="width:180px;" />
                        </td>
                        <td class="tabAlign">入库仓库：</td>
                        <td>
                        	<input id="inWHNo"   class="easyui-combotree" value="${pd.WHNo}" data-options="required:true" style="width:180px;" />
                        </td> 
                    </tr>
                    <tr>
                    	<td class="tabAlign ImportTd hidden">总仓入库单号：</td>
                        <td class="ImportTd hidden">
                            <input class="easyui-textbox" id="comeCode" data-options="required:true" style="width:180px;" /> 
							<button type="button" class="btn btn-small btn-light" onclick="importIncome();" title="导入" style="width:70px;height:28px">
							导入
							</button>      
                        </td>
                        <td class="tabAlign">出库时间：</td> 
                        <td>
                        	<input id="OutTime" class="easyui-textbox" value="${pd.OutBoundTime}" disabled="disabled" style="width:180px;" />
                        </td>
                        <td class="tabAlign">操作人：</td>
                        <td>
                        	<input id="OpName" class="easyui-textbox" value="${pd.operatorName}" disabled="disabled" style="width:180px;" />
                        </td> 
                    </tr> 
                    <tr>
                        <td class="tabAlign">备注：</td>
                        <td colspan="10">
                        	<textarea class="easyui-validatebox validatebox-text" id="Note" cols="88" style="width:99%;height:20px;"></textarea>
                        </td>
                    </tr>
                	</tbody>
            	</table>
            </fieldset>
        </div>
        <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">出库物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="outGoods" data-options="iconCls:'icon-edit',toolbar:'#tb',singleSelect:true">
					        <thead>
					            <tr>  
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.13)">物料名称</th>
					                <th data-options="field:'BarCode',align:'center',width:fixWidth(0.13)">物料编码</th>
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.14),editor:'textbox'">物料描述</th>
					                <th data-options="field:'InventoryQuantity',align:'center',width:fixWidth(0.10)" >库存数量</th>
					                <th data-options="field:'Unit',align:'center',width:fixWidth(0.09)">单位</th>
					                <th data-options="field:'DeployNum',align:'center',width:fixWidth(0.09),editor:'textbox'">调配数量</th>
					                <th data-options="field:'opt',align:'center',width:fixWidth(0.14), formatter:formatOpt">操作</th>   
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
	 	$("#outWHNo").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择出库仓库',	
			required:true,	 
	 	});  
	 	$("#inWHNo").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择入库仓库',	
			required:true,	 
	 	});  
	 	var dg = $('#outGoods').datagrid({
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
	 
	function importIncome(){
		var outWHNo=$("#outWHNo").combobox("getValue");	 
		var incomcode=$("#comeCode").val();  
		if(outWHNo!=null && outWHNo!=""){
			if(incomcode!=null && incomcode!=""){
				$("#outGoods").datagrid({
		        	url:"common/incomGoods.do?incomcode="+incomcode+"&&outWhId="+outWHNo,
		       		method:'get',  
		      	}); 
			}else{ alert("导入数据时，入库单号不能为空");} 
		}else{ alert("请选择出库仓库");}  
	}
	  
	 
	
	//连接格式化
	function formatOpt(value,row,index){   
		return '<a href="javascript:void(0)" onclick="toDelete(\'' + index +'\')">删除</a>';  
	}
  	function  toDelete(index) {     
	    $('#outGoods').datagrid('deleteRow', index);      
	    var rows = $('#outGoods').datagrid('getRows');
        $('#outGoods').datagrid("loadData", rows);
	};    
	 
	
	//保存数据
 	function btnSave(){  
 		var numflg=false;
 		var flag=false;
		var entities = null;
		var objArray=[]; 
 		var myDate = new Date(); 
 		var incomcode=$("#comeCode").val(); 
		var outWHNo=$("#outWHNo").combobox("getValue"); 
		var inWHNo=$("#inWHNo").combobox("getValue"); 
		var rows = $('#outGoods').datagrid('getRows'); 
		// 循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
		// 在后台反序列话成对象的对象集合。 
		for(i = 0;i< rows.length;i++){	
			if(rows[i].DeployNum==null||rows[i].DeployNum==""){flag=true;}
			if((rows[i].DeployNum-rows[i].TotalNum)>0){numflg=true;}
			rows[i].OutboundNo=$("#outCode").val();
	   		objArray.push(rows[i]);		 
		}  
		if((incomcode=="" || incomcode==null)||(outWHNo=="" || outWHNo==null)
			||(inWHNo=="" || inWHNo==null)){
			alert("请填写必填项");  
		}else if(flag==true){
   			alert("请填写调配商品数量"); 
   		}else if(numflg==true){
   			alert("调配商品数量大于商品库存数量，请重新填写调配数量"); 
   		}else{  
			entities =JSON.stringify(objArray);
			$.ajax({
				type:"post",
				url:"common/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#id").val(),  
					"OutCode":$("#outCode").val(),
					"outWHNo":$("#outWHNo").combobox("getValue"),
					"inWHNo":$("#inWHNo").combobox("getValue"),
					"OutTime":$("#OutTime").val(), 
					"Note":$("#Note").val(), 
					"ApprovalStatus":0,
					"StatusFlag":1,
					"OpName":$("#OpName").val(), 
					"entities":entities,
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("保存成功");  
						 $('#commonlist').datagrid('reload');  
						//关闭父页面弹出窗口
						$("#comWindow").window('close');
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
		$("#inbWindow").window('close'); 			
	}; 
  
</script>
</body>
</html>


