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
		<form action="role/${msg}.do" name="form1" id="form1"  method="post">
		<input type="hidden" name="ROLE_ID" id="roleId" value="${pd.ID}"/>
			<div id="zhongxin">
			<table>
				<tr>
					<td><input type="text" name="ROLE_NAME" id="roleName" value="${pd.ROLENAME}" placeholder="这里输入名称" title="名称" /></td>
				</tr>
				<tr>
					<td style="text-align: center;">
						<button type="button" class="btn btn-small btn-primary" id="EditSave">保存</button>
					<a class="btn btn-small btn-danger" id="cancel">取消</a>
					</td>
				</tr>
			</table>
			</div>
		</form>
	
	<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif"  style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>

		
		<script type="text/javascript">
	
	$(function(){  
		$("#EditSave").click(function(){
				$.ajax({
					type:"POST",
					url:"role/" + '${msg}',
					dataType:"json",
					data:{
						"RoleName":$("#roleName").val(),
						"ROLE_ID":$("#roleId").val()
					},
					success:function(data){
						if(data.msg == "success"){
							alert("保存成功");
						}
						else{
							alert("保存失败");
						}
					},
					error:function(){
						alert("保存失败");
					}
				});
				//关闭父页面弹出窗口
				$("#roleWindow").window('close');
				$('#roleDataGrid').datagrid('reload'); 
		});
		
		//取消按钮
		$("#cancel").click(function(){
			$("#roleWindow").window('close');
		});
	});
	

</script>	
</body>
</html>
