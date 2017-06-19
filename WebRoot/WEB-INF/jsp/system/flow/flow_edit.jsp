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
	<form action="Askfor/${msg}.do" name="AskforForm" id="AskforForm" method="post">
		<input type="hidden" name="Id" id="Id" value="${pd.Id }"/>
		<div id="zhongxin">
		<table>
			<tr>
		        <td class="tabAlign">流程名称：</td>
			        <td colspan="10">
			        <input type="text" id="FlowName" cols="88" style="width:350px;height:20px;" value="${pd.Name }"></input>
		        </td>
		        <td class="tabAlign">流程编号：</td>
			        <td colspan="10">
			        <input type="text" id="CodeNo" cols="88" style="width:350px;height:20px;" value="${pd.CodeNo }"></input>
		        </td>
	        </tr>
			<tr>
		        <td class="tabAlign">备注：</td>
			        <td colspan="10">
			        <textarea class="easyui-validatebox validatebox-text" id="Comment" cols="88" style="width:100%;height:20px;">${pd.Comment}</textarea>
		        </td>
	        </tr>
		</table>
		<div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">审核流程明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div style="width: 100%; " title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table  id="flowCodeList" title="流程明细信息" class="easyui-datagrid" data-options="singleSelect:true">
							<thead>
								<tr>
									<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
									<th data-options="field:'NodeName',width:fixWidth(0.275),align:'left',halign:'center'">审核名称</th>
									<th data-options="field:'SartRole',width:fixWidth(0.275),align:'left',halign:'center'">审核角色</th>
									<th data-options="field:'RoleId',align:'middle',halign:'center',"></th>
									<th data-options="field:'FlowOrder',align:'middle',halign:'center',"></th>
									<th data-options="field:'Comment',width:fixWidth(0.26),align:'left',halign:'center'">备注</th>				
								</tr>
							</thead>
						</table>
						<div id="tb1" style="height:auto">
							<div style="height:5px"></div>
							<a title="添加审核人" class="btn btn-small btn-success" onclick="newNode()">添加审核人</a>
							<a title="修改审核人" class="btn btn-small btn-failed" onclick="editNode()">修改审核人</a>
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
		
		<div id="dlg" class="easyui-dialog" style="width:600px;" closed="true" buttons="#dlg-buttons">
			<input type="hidden" name="DetailType" id="DetailType"/>
			<input type="hidden" name="RowIndex" id="RowIndex"/>
	        <form id="fm" method="post" novalidate style="margin:0;padding:20px 50px">
	        <table>
	        	<tr>
			        <td class="tabAlign">审核名称：</td>
				        <td colspan="10">
				        <input type="text" id="DetailNodeName" cols="88" style="width:85%;height:20px;" value="${pd.NodeName }"></input>
			        </td>
		        </tr>
		        <tr>
			        <td class="tabAlign">备注：</td>
				        <td colspan="10">
				        <textarea class="easyui-validatebox validatebox-text" id="DetailComment" cols="88" style="width:85%;height:20px;"></textarea>
			        </td>
	       		 </tr>
		    </table>
	            <div style="margin-bottom:10px">
	                <select class="easyui-combobox" name="state" id="DetailEndRole" label="审核角色:" labelPosition="top" style="width:100%;">
	                	<c:forEach items="${roleList}" var="role">
							<option value="${role.ROLE_ID }"
							<c:if test="${pd.ROLE_ID==role.ROLE_ID}">selected</c:if>>${role.ROLE_NAME}</option>
						</c:forEach>
	                </select>
	            </div>
	        </form>
	    	</div>
	    	<div id="dlg-buttons">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6" onclick="saveNode()" style="width:90px">保存</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dlg').dialog('close')" style="width:90px">取消</a>
	    	</div>
	</form>

<script type="text/javascript">	 
		$(document).ready(function(){
		 	var dg = $('#flowCodeList').datagrid({
		 		toolbar: '#tb1',
		 		width:'auto',
				height:'auto',
		        nowrap: false, 
		        striped: true, 
		        border: true, 
		        collapsible:false,
		        url:'', 
		        method: 'POST',
		        remoteSort:false,
			}); 
		 	//dg.datagrid('enableCellEditing');
			var date=new Date();
  			dg.datagrid('loadData',${flowCodeList});
  			
  			$("#flowCodeList").datagrid('hideColumn', 'RoleId');
  			$("#flowCodeList").datagrid('hideColumn', 'FlowOrder');
		});
		
		
		function btnSave(){
			var flag=false;
			var entities = null;
			var objArray=[]; 
	 		var date = new Date(); 
			var rows = $('#flowCodeList').datagrid('getRows');
			var Name = $("#FlowName").val();
			var CodeNo = $("#CodeNo").val();
// 			循环 datagrid 中现有的数据，并且逐行复制给Entities ，并且转换成json格式 
// 			在后台反序列话成对象的对象集合。
			if(Name == null || Name == "" || CodeNo == null || CodeNo == ""){
				alert("请填写流程名称与编号"); 
				return;
			}
			var j = 0;
			for(i = 0;i< rows.length;i++){
				rows[i].CodeNo = $("#CodeNo").val();
				if(++j >= rows.length){
					rows[i].SartRole = rows[i].RoleId;
					rows[i].EndRole = -1;
					rows[i].FlowOrder = $("#flowCodeList").datagrid("getRowIndex",rows[i]);
					objArray.push(rows[i]); 
				}else{
					j = i;
					rows[i].SartRole = rows[i].RoleId;
					rows[i].EndRole = rows[++j].RoleId;
					rows[i].FlowOrder = $("#flowCodeList").datagrid("getRowIndex",rows[i]);
					objArray.push(rows[i]); 
				}
			}  
			if(rows.length==0){
				alert("请添加审核人信息"); 
				return;
			}else{  
	   			entities =JSON.stringify(objArray);
	   			$.ajax({
					type:"post",
					url:"WorkProcedure/" + '${msg }',
					dataType:"json",
					data:{ 
						"Id":$("#Id").val(), 
						"CodeNo":$("#CodeNo").val(), 
						"Name":$("#FlowName").val(),
						"StartDate":date.toLocaleDateString(),
						"Description":$("#Comment").val(),
						"Status":1,
						"entities":entities
					}, 
					success:function(data){ 
						if(data.msg == "failed"){
							alert("保存失败");
						}else if(data.msg == "success"){
							alert("保存成功");  
							 $('#workProcedurelist').datagrid('reload');  
							//关闭父页面弹出窗口
							$("#flowWindow").window('close');
						}
					},
					error:function(){ 
						alert("保存失败"); 
					}
				}); 
	   		}
		};
		
		function newNode(){
			$('#dlg').dialog('open').dialog('center').dialog('setTitle','新增流程审核角色');
            $('#fm').form('clear');
            $('#DetailType').val('newDetail');
		}
		
		function saveNode(){
			var type = $('#DetailType').val();
			if(type == 'newDetail'){
	 			var EndRole = $('#DetailEndRole').combobox('getText');
	 			var RoleId = $('#DetailEndRole').combobox('getValue');
				$('#flowCodeList').datagrid('appendRow',{
					NodeName : $('#DetailNodeName').val(),
					SartRole : EndRole,
					RoleId : RoleId,
					Comment : $('#DetailComment').val()
				});
			}else if(type == 'editDetail'){
				var EndRole = $('#DetailEndRole').combobox('getText');
				var rowIndex =  $('#RowIndex').val();
				var RoleId = $('#DetailEndRole').combobox('getValue');
				$('#flowCodeList').datagrid('updateRow',{
					index: rowIndex,
					row: {
						NodeName : $('#DetailNodeName').val(),
						SartRole : EndRole,
						RoleId : RoleId,
						Comment : $('#DetailComment').val()
					}
				});
			}
			$('#flowCodeList').datagrid('reload');  
			$('#dlg').dialog('close');
		}
		
		//取消按钮
		function btnCancel(){
			$("#flowWindow").window('close');
		}
		
		function editNode(){
            var row = $("#flowCodeList").datagrid("getSelected");
            $('#DetailNodeName').val(row.NodeName);
            $('#DetailComment').val(row.Comment);
            $('#DetailEndRole').combobox('setValues',row.SartRole);
			$('#dlg').dialog('open').dialog('center').dialog('setTitle','修改流程审核角色');
			$('#DetailType').val('editDetail');
			var ri = $("#flowCodeList").datagrid("getRowIndex",row);
			$('#RowIndex').val(ri);
		}
</script>	 
</body>
</html>