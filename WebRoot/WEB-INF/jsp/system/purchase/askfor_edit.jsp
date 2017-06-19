<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<body>
	<form action="product/${msg}.do" name="productForm" id="productForm" method="post">
		<input type="hidden" name="Id" id="Id" value="${pd.Id }"/>
		<input type="hidden" name="AskforPerson" id="askforPerson" value="${pd.AskforPerson }"/>
		<div id="zhongxin">
		<table>
			<tr>
		        <td class="tabAlign">采购申请编号：</td>
			        <td colspan="10">
			        <input type="text" disabled="disabled" id="askforNo" cols="88" style="width:85%;height:20px;" value="${pd.AskforNo }"></input>
		        </td>
	        </tr>
			<tr>
		        <td class="tabAlign">备注：</td>
			        <td colspan="10">
			        <textarea class="easyui-validatebox validatebox-text" id="Comment" cols="88" style="width:85%;height:20px;">${pd.Comment}</textarea>
		        </td>
	        </tr>
		</table>
		<div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">采购物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div style="width: 100%; " title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="askProduct" data-options="singleSelect:true">
					        <thead>
					            <tr>
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.13)">物料名称</th>
					                <th data-options="field:'BarCode',align:'center',width:fixWidth(0.13)">物料编码</th>
					                <th data-options="field:'Comment',editor:'text',align:'center',width:fixWidth(0.12)">物料描述</th>
					                <th data-options="field:'Quantity',editor:'text',align:'center',width:fixWidth(0.10)" >数量</th>
					                <th data-options="field:'ComItemName',align:'center',width:fixWidth(0.10)">单位</th>
					                <th data-options="field:'Price',editor:'text',align:'center',width:fixWidth(0.10)">单价</th>
					                <th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.14)">供应商名称</th>
					                <th data-options="field:'AskforNo',align:'center'" hidden="true">采购申请编号</th>
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
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
		<div id="selectProductWindow" class="easyui-window" title="选择商品信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:800px;height:400px;padding:10px;">
		</div> 
	</form>

<script type="text/javascript">	 
		$(document).ready(function(){
		 	var dg = $('#askProduct').datagrid({
		 		toolbar: '#tb1',
		 		width:'auto',
				height:'auto',
		        nowrap: false, 
		        striped: true, 
		        border: true, 
		        collapsible:false,//是否可折叠的 
		        //fit: true,//自动大小 
		        url:'', 
		        method: 'POST',
		        //sortName: 'code', 
		        //sortOrder: 'desc', 
		        remoteSort:false,
			}); 
		 	dg.datagrid('enableCellEditing');
			var date=new Date();  
			dateStr=dateToString(date); 
			$('#askforNo').val(dateStr);
  			dg.datagrid('loadData',${askProduct});
		});
		
		function btnSave(){
			var flag=false;
			var entities = null;
			var objArray=[]; 
	 		var date = new Date(); 
			var rows = $('#askProduct').datagrid('getRows'); 
			// 循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
			// 在后台反序列话成对象的对象集合。
			for(i = 0;i< rows.length;i++){	
				if(rows[i].Quantity==null||rows[i].Quantity==""){flag=true;}
				rows[i].AskforNo=$("#askforNo").val();
		   		objArray.push(rows[i]);		 
			}  
			if(rows.length==0){
				alert("请选择采购商品信息"); 
			}else if(flag==true){
	   			alert("请填写采购商品数量"); 
	   		}else{  
	   			entities =JSON.stringify(objArray);
	   			$.ajax({
					type:"post",
					url:"Askfor/" + '${msg }',
					dataType:"json",
					data:{ 
						"Id":$("#Id").val(), 
						"AskforNo":$("#askforNo").val(), 
						"AskforPerson":$("#askforPerson").val(),
						"IsSummary":0,
						"AuditStatus":0,
						"Comment":$("#Comment").val(),
						"Status":1,
						"entities":entities
					}, 
					success:function(data){ 
						if(data.msg == "failed"){
							alert("保存失败");
						}else if(data.msg == "success"){
							alert("保存成功");  
							 $('#askforList').datagrid('reload');  
							//关闭父页面弹出窗口
							$("#askforWindow").window('close');
						};
					},
					error:function(){ 
						alert("保存失败"); 
					}
				}); 
	   		}
		};
			
		function dateToString(now){  
			var id = $("#Id").val();
			if(id == null){
			    var year = now.getFullYear();  
			    var month =(now.getMonth() + 1).toString();  
			    var day = (now.getDate()).toString();  
			    var hour = (now.getHours()).toString();  
			    var minute = (now.getMinutes()).toString();  
			    var second = (now.getSeconds()).toString();  
			    if (month.length == 1) {  
			        month = "0" + month;  
			    }  
			    if (day.length == 1) {  
			        day = "0" + day;  
			    }  
			    if (hour.length == 1) {  
			        hour = "0" + hour;  
			    }  
			    if (minute.length == 1) {  
			        minute = "0" + minute;  
			    }  
			    if (second.length == 1) {  
			        second = "0" + second;  
			    }  
			     var code = Math.floor(Math.random()*9000)+1000;
			     var dateTime = year + month + day + hour + minute + second + code;  
			     return dateTime;  
			}else{
				return $("#askforNo").val();
			}
		  }  
		
		function SelectProduct(){
			$("#selectProductWindow").window({
				href:"Askfor/goSelectProduct"
			}); 
			$("#selectProductWindow").window('open');
		}
		
		//取消按钮
		function btnCancel(){
			$("#askforWindow").window('close');
		}
</script>	 
</body>
</html>