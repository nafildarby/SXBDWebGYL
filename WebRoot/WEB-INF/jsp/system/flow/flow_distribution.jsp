<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<body style="witdh:80%;height:40%">
	<div class="info_innerframe" style="margin:0px 10px 0px 10px;clear:both;"> 
	<input type="hidden" name="Id" id="Id" value="${pd.Id }"/>
		<div style="height:10px"></div> 
			<!-- 检索  --> 
			<table>
				<tr>
					<td align="tabAlign">流程名称：</td>
				        <td>
				        	<input type="text" disabled="disabled" id="askforNo" cols="88" style="width:85%;height:20px;" value="${pd.Name }"></input>
			        	</td>
			    </tr>
			    <tr>
			    	<td class="tabAlign">分配菜单：</td>
					<td>
						<input id="combotree" value="${pd.MenuId}" class="easyui-combotree" style="width:220px;">
					</td> 
				</tr>
				<tr>
					<td>
						<a class="btn btn-small btn-success" onclick="distributionSave();">保存</a>
					</td>
				</tr>
			</table>
		</div> 
 
	<!--提示框-->
	<script type="text/javascript">
	$(document).ready(function(){
		$("#combotree").combotree({
			url: 'WorkProcedure/listMenuCombotree',
			method: 'get',			
			valueField: 'id',			
			textField: 'text',	
			prompt:'这里选择分配菜单',	
			required:true,	 
	 	});  
	});
	
 	//新增
	function distributionSave(){   
		var menuId = $("#combotree").combobox("getValue");	 
		var flowId = $("#Id").val();	 
		
		$.ajax({
			type:"post",
			url:"WorkProcedure/Savedistribution" ,
			dataType:"json",
			data:{ 
				"menuId": menuId,
				"flowId": flowId
			}, 
			success:function(data){ 
				if(data.msg == "failed"){
					alert("保存失败");
				}else if(data.msg == "success"){
					alert("保存成功");
					//关闭父页面弹出窗口
					$("#DistributionWindow").window('close');
				}else if(data.msg == "Validationfailed"){
					alert("该菜单已分配过其他流程，不可再次分配");
				};
			},
			error:function(){ 
				alert("保存失败"); 
			}
		});  
	};
	</script> 
</body>
</html>

