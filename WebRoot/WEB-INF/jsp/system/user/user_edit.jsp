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
	<form action="user/${msg }.do" name="userForm" id="userForm" method="post">
		<input type="hidden" name="USER_ID" id="user_id" value="${pd.Id }"/>
		<div id="zhongxin">
		<table>
			
			<c:if test="${fx != 'head'}">
			<c:if test="${pd.ROLE_ID != '1'}">	
			<tr class="info">
			<td>角色名称：</td>
				<td>
				<select class="chzn-select" name="ROLE_ID" id="role_id" data-placeholder="请选择职位" style="vertical-align:top;">
				<option value=""></option>
				<c:forEach items="${roleList}" var="role">
					<option value="${role.ROLE_ID }" <c:if test="${role.ROLE_ID == pd.RoleId}">selected</c:if>>${role.ROLE_NAME }</option>
				</c:forEach>
				</select>
				</td>
			</tr>
			</c:if>
			<c:if test="${pd.ROLE_ID == '1'}">
			<input name="ROLE_ID" id="role_id" value="1" type="hidden" />
			</c:if>
			</c:if>
			
			<c:if test="${fx == 'head'}">
				<input name="ROLE_ID" id="role_id" value="${pd.ROLE_ID }" type="hidden" />
			</c:if>
			
			<tr> 
				<td><input name="Id" id="USER_ID" value="${pd.USER_ID }" type="hidden" ></td>
			</tr>
			
			<tr>
				<td>用户名：</td>
				<td><input name="USERNAME" id="loginname" value="${pd.UserNo }" maxlength="32" class="easyui-textbox" data-options="required:true,prompt:'这里输入用户名'" style="width:100%;height:32px"></td>
			</tr>
			<%-- <tr>
				<td>所属机构：</td>
				<td><input name="OrganizationId" id="OrganizationId" value="${pd.OrganizationId }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入所属机构Id'" style="width:100%;height:32px"></td>
			</tr> --%>
			<tr>
				<td>密  码：</td>
				<td><input type="password" name="PASSWORD" id="password"  maxlength="32" class="easyui-textbox" data-options="required:true" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>确认密码：</td>
				<td><input type="password" name="chkpwd" id="chkpwd"  maxlength="32" class="easyui-textbox" data-options="required:true" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>姓  名：</td>
				<td><input name="NAME" id="name"  value="${pd.USERNAME }"  class="easyui-textbox" data-options="required:true,prompt:'这里输入姓名'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>手机号：</td>
				<td>
				<input name="PHONE" id="PHONE"  value="${pd.Telphone }"  maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入手机号码'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>邮  箱：</td>
				<td><input name="EMAIL" id="EMAIL"  value="${pd.Email }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入邮箱', validType:'email', invalidMessage:'邮箱格式不正确'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>备  注：</td>
				<td><input name="BZ" id="BZ"value="${pd.Comment }" class="easyui-textbox" maxlength="64" data-options="prompt:'这里输入备注'" style="width:100%;height:32px">
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<button type="button" class="btn btn-small btn-primary" onclick="saveBtn()">保存</button>
					<a class="btn btn-small btn-danger" onclick="cancel()">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
	</form>

	<script type="text/javascript">
	 
	 function saveBtn(){  
		var roleId=$("#role_id").val();
		var userNo=$("#loginname").val();
		var userName=$("#name").val();
		var password=$("#password").val();
		var checkpwd=$("#chkpwd").val();
		if((roleId==null||roleId=="")&&(userNo==null||userNo=="")&&(userName==null||userName=="")
			&&(password==null||password=="")&&(checkpwd==null||checkpwd=="")){
				alert("请填写必填项");
				return;
		}else{	 
			$.ajax({
				type:"post",
				url:"user/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#USER_ID").val(),
					"UserId":$("#USER_ID").val(),
					"RoleId":$("#role_id").val(),
					"UserNo":$("#loginname").val(),
					"UserName":$("#name").val(),
					"Password":$("#password").val(),
					"Email":$("#EMAIL").val(),
					/* "OrganizationId":$("#OrganizationId").val(), */
					"Telphone":$("#PHONE").val(),
					"Comment":$("#BZ").val(),
					"STATUS":1
				},
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}
					else if(data.msg == "success"){
						alert("保存成功");  
						//关闭父页面弹出窗口
						$("#userWindow").window('close'); 
						var pageUrl = 'user/listUsersPage'; 
						loadGrid($('#list_data'),pageUrl);  			 
					}
				},
				error:function(){ 
					alert("保存失败"); 
				} 
			});
		} 
	};
	
	//取消按钮 
	function cancel(){ 
		$("#userWindow").window('close');
	};

</script>	 
</body>
</html>