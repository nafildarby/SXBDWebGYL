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
                       <td class="tabAlign" >入库单号：</td>
                       <td>
							<input id="inboundNo" value="${pd.inboundNo}" class="easyui-textbox" style="width:220px;" disabled="disabled">					 
						</td>
                       <td class="tabAlign" >入库仓库：</td>
                       <td>
							<input id="combotree" value="${pd.ParentNo}" class="easyui-combotree" style="width:220px;">					 
						</td> 
						<td class="tabAlign">操作人：</td>
                       	<td>
							<input id="operatorName" value="${pd.operatorName}" class="easyui-textbox" style="width:220px;" disabled="disabled">					 
						</td>
                    </tr>
                    <tr>
                       <td class="tabAlign" >入库批次：</td>
                       <td>
							<input id="inboundBatchNo" value="${pd.inboundBatchNo}" class="easyui-textbox" style="width:220px;"disabled="disabled">					 
						</td>
                       <td class="tabAlign" >入库日期：</td>
                       <td>
							<input id="inboundDate" value="${pd.inboundDate}" class="easyui-textbox" style="width:220px;">					 
						</td> 
 					    <td class="tabAlign">供应商：</td>   
						<td> 
                           	<select class="easyui-combobox" name="SupplierId" id="SupplierId" data-options="required:true,prompt:'输入关键字后自动搜索商品供应单位'" style="width:220px;">
								<option value=""></option>
								<c:forEach items="${SupplierList}" var="Supplier">
									<option value="${Supplier.Id }" <c:if test="${Supplier.Id == pd.SupplierId}">selected</c:if>>${Supplier.EnterpriseName}</option>
								</c:forEach>
							</select>
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
                <legend class="scheduler-border" style="font-size:14px;">入库物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="productInfo" data-options="iconCls:'icon-edit',toolbar:'#tb',singleSelect:true">
					        <thead>
					            <tr> 
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.13)">物料名称</th>
					                <th data-options="field:'ProductNo',align:'center',width:fixWidth(0.13)">物料编码</th>
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.14),editor:'textbox'">物料描述</th>
					                <th data-options="field:'TotalNum',align:'center',width:fixWidth(0.10),editor:'textbox'" >数量</th>
					                <th data-options="field:'ComItemName',align:'center',width:fixWidth(0.09)">单位</th>
					                <th data-options="field:'Price',align:'center',width:fixWidth(0.09)">单价</th>
					                <th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.12)">供应商名称</th>
					                <th data-options="field:'GoodsReceiptNo',align:'center',width:fixWidth(0.12)" hidden="true">入库编号</th>
					            </tr>
					        </thead>
					    </table> 
						<div id="tb1" style="height:auto">
							<div style="height:5px"></div>
							<a title="选择商品" class="btn btn-small btn-success" onclick="SelectProduct();">选择商品</a>
							<a title="保存" class="btn btn-small btn-danger" onclick="btnSave();">保存</a>
							<a title="取消" class="btn btn-small btn-primary" onclick="btnCancel();">取消</a>
							<div style="height:5px"></div>
						</div>
					</div>
				</div>
           </fieldset>
        </div> 
        <div id="selectProductWindow" class="easyui-window" title="物料信息" 
        	data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:800px;height:400px;padding:10px;">
				The window content.
		</div>
    </form>
</div>

<script type="text/javascript"> 

	//页面加载时事件
 	$(document).ready(function(){
	 	$("#combotree").combotree({
			url: 'inbound/listWHCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择入库仓库',	
			required:true,	 
	 	});  
	 	var dg = $('#productInfo').datagrid({
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
	
	//选择物料
	function SelectProduct(){
		$("#selectProductWindow").window({
			href:"inbound/goSelectProduct"
		});  
		$("#selectProductWindow").window('open');
	};
	
	//本地数据过滤 关键字q开头的数据
	$('#SupplierId').combobox({
		filter: function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q) == 0;
		}
	});
	
	//保存数据
 	function btnSave(){  
 		var flag=false;
		var entities = null;
		var objArray=[]; 
 		var myDate = new Date(); 
		var ParentNo=$("#combotree").combobox("getValue");	 
		var Supplier=$("#SupplierId").combobox("getValue");
		var rows = $('#productInfo').datagrid('getRows'); 
		// 循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
		// 在后台反序列话成对象的对象集合。
		for(i = 0;i< rows.length;i++){	
			if(rows[i].TotalNum==null||rows[i].TotalNum==""){flag=true;}
			rows[i].GoodsReceiptNo=$("#inboundNo").val();
	   		objArray.push(rows[i]);		 
		}  
		if((ParentNo==""||ParentNo==null)||(Supplier==""||Supplier==null)){
			alert("请填写必填项"); 
		}else if(rows.length==0){
			alert("请选择入库商品信息"); 
		}else if(flag==true){
   			alert("请填写入库商品数量"); 
   		}else{  
			entities =JSON.stringify(objArray);
			$.ajax({
				type:"post",
				url:"inbound/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#id").val(), 
					"WhsId":$("#combotree").combobox("getValue"),
					"SupplierId":$("#SupplierId").combobox("getValue"), 
					"IncomeBatch":$("#inboundBatchNo").val(),
					"IncomeCode":$("#inboundNo").val(),
					"IncomeDate":$("#inboundDate").val(), 
					"Note":$("#Note").val(),
					"IncomeType":1,
					"StatusFlag":1,
					"ApprovalStatus":0,
					"OpName":$("#operatorName").val(),
					"CreateTime":myDate.toLocaleDateString(), 
					"entities":entities,
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}else if(data.msg == "success"){
						alert("保存成功");  
						 $('#tblWhsInbound').datagrid('reload');  
						//关闭父页面弹出窗口
						$("#inbWindow").window('close');
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


