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
	<form action="wh/${msg }.do" name="whForm" id="whForm" method="post" style="width:auto;height:auto;">
		<input type="hidden" name="ID" id="id" value="${pd.Id }"/> 
		<div id="zhongxin">
		<table>  
			<tr class="info">
			<td>所属仓库：</td>
				<td>
					<input id="combotree" value="${pd.ParentNo}" class="easyui-combotree" style="width:100%;height:32px">					 
				</td>
			</tr>
			<tr>
				<td>仓库编号：</td>
				<td><input name="No" id="NO"  value="${pd.WarehouseNo }" class="easyui-textbox"
				 	data-options="required:true,prompt:'这里输入仓库编号'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>仓库名称：</td>
				<td><input name="NAME" id="name"  value="${pd.WarehouseName }"  class="easyui-textbox" 
					data-options="required:true,prompt:'这里输入仓库名称'"  style="width:100%;height:32px"></td>
			</tr> 
			<tr>
				<td>仓库状态：</td>
				<td>
					<select id="WHStatus" class="easyui-combobox" name="WHStatus" style="width:100%;height:32px" 
						data-options="required:true,prompt:'这里选择仓库状态'">   
					    <option></option>   
					    <option value="1" <c:if test="${pd.WarehouseStatus == 1}">selected</c:if>>正常</option>   
					    <option value="2" <c:if test="${pd.WarehouseStatus == 2}">selected</c:if>>冻结</option>    
					</select>   
				</td>
			</tr> 
			<tr>
				<td>备      注：</td>
				<td><input name="BZ" id="BZ"value="${pd.Comment }" class="easyui-textbox" maxlength="64" 
					data-options="prompt:'这里输入备注'" style="width:100%;height:32px">
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<button type="button" class="btn btn-small btn-primary" onclick="saveBtn()">保存</button>
					<a class="btn btn-small btn-danger" onclick="cancel()">取消</a>
				</td>
			</tr>
		</table>  
		</div>
	</form>

	<script type="text/javascript">
	
 	  $(document).ready(function(){
		 	$("#combotree").combotree({
				url: 'wh/listWHCombotree',
				method: 'get',			
				valueField: 'id',			
				textField: 'text',	
				prompt:'这里选择所属仓库',		 
		 	}); 	
	  });     
	 
	 function  saveBtn(){    
	 	var Id=$("#id").val();
	 	var whNo=$("#NO").val();
		var whname=$("#name").val();
		var whStatus=$("#WHStatus").combobox("getValue");	
		var ParentNo=$("#combotree").combobox("getValue");
		if((whNo==""||whNo==null)&&(whname==""||whname==null)&&(whStatus==""||whStatus==null)){
			alert("请填写必填项");
			return; 
		}else{ 
			$.ajax({
				type:"post",
				url:"wh/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#id").val(), 
					"ParentNo":$("#combotree").combobox("getValue"),
					"WarehouseNo":$("#NO").val(),
					"WarehouseName":$("#name").val(),
					"WarehouseStatus":$("#WHStatus").combobox("getValue"), 
					"Comment":$("#BZ").val(),
					"Status":1
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}
					else if(data.msg == "success"){
						alert("保存成功");  
						$('#list_data').treegrid('reload');
					}
				},
				error:function(){ 
					alert("保存失败"); 
				}
			});
		};
		//关闭父页面弹出窗口
		$("#whWindow").window('close'); 			 
	};
	  
	 
		
	//取消
	function cancel() { 
		$("#whWindow").window('close');
	};
	 
	

</script>	 
</body>
</html>