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
	<form>
		<input type="hidden" name="USER_ID" id="supplierid" value="${pd.Id }"/>
		<div id="zhongxin">
		<table> 
			<tr>
				<td>企业名称：</td>
				<td><input name="EnterpriseName" id="enterName" value="${pd.EnterpriseName }" maxlength="32" class="easyui-textbox" data-options="required:true,prompt:'这里输入企业名称'" style="width:100%;height:32px"></td>
				<td>联系人名称：</td>
				<td><input  name="LinkmanName" id="manName" value="${pd.LinkmanName }"  maxlength="32" class="easyui-textbox" data-options="required:true,prompt:'这里输入联系人名称'" style="width:100%;height:32px"></td>
			</tr>  
			<tr>
				<td>联系电话：</td>
				<td><input  name="Telephone" id="telephone" value="${pd.Telephone }"  maxlength="32" class="easyui-textbox" data-options="required:true,prompt:'这里输入联系电话'" style="width:100%;height:32px"></td>
				<td>法人代表：</td>
				<td><input name="LealPerson" id="person"  value="${pd.LealPerson }"  class="easyui-textbox" data-options="required:true,prompt:'这里输入法人代表'" style="width:100%;height:32px"></td>
			</tr> 
			<tr>
				<td>传真号码：</td>
				<td><input name="PHONE" id="fax"  value="${pd.Fax }"  maxlength="32" class="easyui-textbox" data-options="required:true,prompt:'这里输入传真号码'" style="width:100%;height:32px"></td>
				<td>邮箱地址：</td>
				<td><input name="EMAIL" id="email"  value="${pd.Email }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入邮箱', validType:'email', invalidMessage:'邮箱格式不正确'" style="width:100%;height:32px"></td>
			</tr> 
			<tr>
				<td>开户银行：</td>
				<td><input name="EMAIL" id="openingBank"  value="${pd.OpeningBank }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入开户银行'" style="width:100%;height:32px"></td>
				<td>开户账号：</td>
				<td><input name="BZ" id="accountNo"value="${pd.AccountNo }" class="easyui-textbox" maxlength="64" data-options="prompt:'这里输入开户账号'" style="width:100%;height:32px">
			</tr>
			<tr>
				<td>公司地址：</td>
				<td><input name="EMAIL" id="address"  value="${pd.Address }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入邮箱'" style="width:100%;height:32px"></td>
				<td>公司网址：</td>
				<td><input name="BZ" id="webSite"value="${pd.WebSite }" class="easyui-textbox" maxlength="64" data-options="required:true,required:true,prompt:'这里输入备注'" style="width:100%;height:32px">
			</tr>
			<tr>
				<td class="tabAlign">备注：</td>
            	<td colspan="10">
                	<textarea class="easyui-validatebox validatebox-text" id="comment" cols="88" style="width:99%;height:60px;">${pd.Comment}</textarea>
                </td>	 
            </tr>
		</table>
		</div>
		<div style="text-align:center;">
			<a title="保存" class="btn btn-small btn-danger" onclick="saveBtn();">保存</a>
			<a title="取消" class="btn btn-small btn-primary" onclick="cancel();">取消</a>
		</div> 
	</form>

	<script type="text/javascript">
	 
	 function saveBtn(){   
		var enterName=$("#enterName").val(); 
		var linkName=$("#manName").val();
		alert(linkName);
		var telephone=$("#telephone").val(); 
		var person=$("#person").val();  
		var fax=$("#fax").val();  
		var webSite=$("#webSite").val();
		if((enterName==null||enterName=="")&&(linkName==null||linkName=="")&&(telephone==null||telephone=="")
		   &&(person==null||person=="")&&(fax==null||fax=="")&&(webSite==null||webSite=="")){
				alert("请填写必填项"); 
		}else{	 
			$.ajax({
				type:"post",
				url:"supplier/" + '${msg }',
				dataType:"json",
				data:{  
					"Id":$("#supplierid").val(),  
					"EnterpriseName":$("#enterName").val(),
					"LinkmanName":$("#manName").val(),
					"Telephone":$("#telephone").val(),
 					"LealPerson":$("#person").val(),
					"Fax":$("#fax").val(),
					"Email":$("#email").val(),
					"OpeningBank":$("#openingBank").val(),
					"AccountNo":$("#accountNo").val(),
					"Address":$("#address").val(),
					"WebSite":$("#webSite").val(), 
					"Comment":$("#comment").val(),
					"Status":1
				},
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}
					else if(data.msg == "success"){
						alert("保存成功");   
						$('#supplierlist').datagrid('reload');  
						$("#supplierWindow").window('close');  
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
		$("#supplierWindow").window('close');
	};

</script>	 
</body>
</html>