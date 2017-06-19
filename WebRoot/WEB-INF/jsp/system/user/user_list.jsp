<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
<%@ include file="../admin/top.jsp"%>
</head>
<body>

	<div class="container-fluid" id="main-container" style="height:700px;"> 
			<div style="height:10px"></div>
					<!-- 检索  -->
					<form action="user/listUsers.do" method="post" name="userForm" id="userForm">
						<table>
							<tr>
								<td align="center">
								 <input name="USERNAME" Id="UserName" class="easyui-searchbox" data-options="prompt:'请输入关键字姓名进行查询',searcher:searchUsers" style="width:100%">
								</td>
								
								<td align="center">
									<select class="easyui-combobox" Id="RoleId" name="ROLE_ID" label="请选择职位:" labelPosition="left">
										<option value=""></option>
										<option value="">全部</option>
										<c:forEach items="${roleList}" var="role">
											<option value="${role.ROLE_ID }"
												<c:if test="${pd.ROLE_ID==role.ROLE_ID}">selected</c:if>>${role.ROLE_NAME}</option>
										</c:forEach>
									</select>
								</td>
								<c:if test="${QX.cha == 1 }">
									<td style="vertical-align:top;">
										<button type = "button" class="btn btn-mini btn-light" onclick="searchUsers();" title="检索" style="height:28px;">
											<i id="nav-search-icon" class="icon-search"></i>
										</button></td>
									<td style="vertical-align:top;">
										<button	type = "button" class="btn btn-mini btn-light" onclick="toExcel();" title="导出到EXCEL" style="height:28px;">
											<i id="nav-search-icon" class="icon-download"></i>
										</button></td>
									<c:if test="${QX.edit == 1 }">
										<td style="vertical-align:top;">
											<button	type = "button" class="btn btn-mini btn-light" onclick="fromExcel();" title="从EXCEL导入" style="height:28px;">
												<i id="nav-search-icon" class="icon-upload"></i>
											</button></td>
									</c:if>
								</c:if>
							</tr>
						</table>
						<!-- 检索  --> 

						<div style="height:10px"></div> 
						<table  id="list_data" title="系统用户" data-options="singleSelect:true">
							<thead>
								<tr>
									<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
 									<th data-options="field:'Id',width:fixWidth(0.089),align:'center'">编号</th>
									<th data-options="field:'UserNo',width:fixWidth(0.15),align:'center'">用户名</th>
									<th data-options="field:'UserName',width:fixWidth(0.15),align:'center'">姓名</th>
									<th data-options="field:'ROLENAME',width:fixWidth(0.15),align:'center'">职位</th>
									<th data-options="field:'EMAIL',width:fixWidth(0.19),align:'center'">邮箱</th>
									<th data-options="field:'Telphone',width:fixWidth(0.19),align:'center'">电话</th>
								</tr>
							</thead>
						</table>
						

						<div class="page-header position-relative">
							<table style="width:100%;">
								<tr>
									<td style="vertical-align:top;">
										<c:if test="${QX.add == 1 }">
											<a class="btn btn-small btn-success" onclick="add();">新增</a>
										</c:if> <c:if test="${QX.edit == 1 }">
											<a class="btn btn-small btn-primary" onclick="edit();">修改</a>
										</c:if><c:if test="${QX.del == 1 }">
											<a title="删除" class="btn btn-small btn-danger"
												onclick="makeAll('确定要删除选中的数据吗?');">删除</a>
										</c:if></td>
									<td style="vertical-align:top;"></td>
								</tr>
							</table>
						</div>
					</form>
				</div> 
				
				<!-- <div id="userWindow" class="easyui-window" title="用户信息" 
					data-options="modal:true,closed:true,iconCls:'icon-save'" 
					style="width:500px;height:400px;padding:10px;">
					The window content.
				</div>
	  -->
	 
	 		<div id="userWindow" class="easyui-window" title="用户信息" 
				data-options="modal:true,closed:true,iconCls:'icon-save'" 
				style="width:340px;height:auto;padding:10px;">
				The window content.
			</div>
	<!--/.fluid-container#main-container-->

	<!-- 返回顶部  
	<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse"> <i
		class="icon-double-angle-up icon-only"></i>
	</a>
	-->

	<!--提示框-->
	<script type="text/javascript">
		
		
		
		
		
		<%-- //去发送电子邮件页面
		function sendEmail(EMAIL){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="发送电子邮件";
			 diag.URL = '<%=basePath%>head/goSendEmail.do?EMAIL='+EMAIL;
			 diag.Width = 660;
			 diag.Height = 470;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
			 };
			 diag.show();
		}
		
		//去发送短信页面
		function sendSms(phone){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="发送短信";
			 diag.URL = '<%=basePath%>head/goSendSms.do?PHONE='+phone+'&msg=appuser';
			 diag.Width = 600;
			 diag.Height = 265;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
			 };
			 diag.show();
		} --%>
	 	
	 	//新增
		function add(){   
			$("#userWindow").window({
				href:"user/goAddU"
			}); 
			$("#userWindow").window('open');  
		}
		 
		//修改
		function edit(){
		 	var row = $("#list_data").datagrid("getSelected");
		 	if(row==null) return;
		 	var user_id=row.Id; 
		    $("#userWindow").window({
				href:"user/goEditU?USER_ID="+user_id,
			}); 
			$("#userWindow").window('open');   
		}
		
		//删除
		function makeAll(){ 
			$.messager.confirm('提示', '确定要删除选中的数据吗?', function(r){
				if (r){
					var row = $("#list_data").datagrid("getSelected");
		 			if(row==null) return;
		 			var user_id=row.Id;
		 			var url = "<%=basePath%>user/deleteU.do?USER_ID="+user_id;
		 			$.get(url,function(data){
						 alert("删除成功");
						 $('#list_data').datagrid('reload');  
					}); 
				}; 
			}); 
	     };
		
		   
	<%-- 	//修改
		function editUser(user_id){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="资料";
			 diag.URL = '<%=basePath%>user/goEditU.do?USER_ID='+user_id;
			 diag.Width = 225;
			 diag.Height = 415;
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					nextPage('${page.page}');
				}
				diag.close();
			 };
			 diag.show();
		}
		
		//删除
		function delUser(userId,msg){
			bootbox.confirm("确定要删除["+msg+"]吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>user/deleteU.do?USER_ID="+userId+"&tm="+new Date().getTime();
					$.get(url,function(data){
						nextPage('${page.page}');
					});
				}
			});
		}
		
		//批量操作
		function makeAll(msg){
			bootbox.confirm(msg, function(result) {
				if(result) {
					var str = '';
					var emstr = '';
					var phones = '';
					for(var i=0;i < document.getElementsByName('ids').length;i++)
					{
						  if(document.getElementsByName('ids')[i].checked){
						  	if(str=='') str += document.getElementsByName('ids')[i].value;
						  	else str += ',' + document.getElementsByName('ids')[i].value;
						  	
						  	if(emstr=='') emstr += document.getElementsByName('ids')[i].id;
						  	else emstr += ';' + document.getElementsByName('ids')[i].id;
						  	
						  	if(phones=='') phones += document.getElementsByName('ids')[i].alt;
						  	else phones += ';' + document.getElementsByName('ids')[i].alt;
						  }
					}
					if(str==''){
						bootbox.dialog("您没有选择任何内容!", 
							[
							  {
								"label" : "关闭",
								"class" : "btn-small btn-success",
								"callback": function() {
									//Example.show("great success");
									}
								}
							 ]
						);
						
						$("#zcheckbox").tips({
							side:3,
				            msg:'点这里全选',
				            bg:'#AE81FF',
				            time:8
				        });
						
						return;
					}else{
						if(msg == '确定要删除选中的数据吗?'){
							top.jzts();
							$.ajax({
								type: "POST",
								url: '<%=basePath%>user/deleteAllU.do?tm='+new Date().getTime(),
						    	data: {USER_IDS:str},
								dataType:'json',
								//beforeSend: validateData,
								cache: false,
								success: function(data){
									 $.each(data.list, function(i, list){
											nextPage('${page.page}');
									 });
								}
							});
						}else if(msg == '确定要给选中的用户发送邮件吗?'){
							sendEmail(emstr);
						}else if(msg == '确定要给选中的用户发送短信吗?'){
							sendSms(phones);
						}
						
						
					}
				}
			});
		} --%>
		
		</script>

	<script type="text/javascript">
		
	
	
	//检索
	function searchUsers(){
		var params = {"UserName":$("#UserName").val(),
					  "RoleId": $("#RoleId").combobox("getValue")
						};
		$("#list_data").datagrid('load', params);
        //$("#list_data").datagrid('reload'); 
	}
	
		$(function() {
			//分页处理
			var pageUrl = 'user/listUsersPage';
			loadGrid($('#list_data'),pageUrl);
			
			
			//初始化用户信息弹出框
			$("#userWindow").window({
				 width: 350,
	            height: 450,
	            top: 50,
	            left:300,
	            collapsible: true,
	            minimizable: true,
	            maximizable: true,
	            resizable: false,
	            modal: true,
	            href: "",
			 });
			
			
		});
		
		//导出excel
		function toExcel(){
			var USERNAME = $("#nav-search-input").val();
			var lastLoginStart = $("#lastLoginStart").val();
			var lastLoginEnd = $("#lastLoginEnd").val();
			var ROLE_ID = $("#role_id").val();
			window.location.href='<%=basePath%>user/excel.do?USERNAME='+USERNAME+'&lastLoginStart='+lastLoginStart+'&lastLoginEnd='+lastLoginEnd+'&ROLE_ID='+ROLE_ID;
		}
		
		//打开上传excel页面
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = '<%=basePath%>user/goUploadExcel.do';
			diag.Width = 300;
			diag.Height = 150;
			diag.CancelEvent = function() { //关闭事件
				if (diag.innerFrame.contentWindow.document
						.getElementById('zhongxin').style.display == 'none') {
					if ('${page.page}' == '0') {
						top.jzts();
						setTimeout("self.location.reload()", 100);
					} else {
						nextPage('${page.page}');
					}
				}
				diag.close();
			};
			diag.show();
		};

	</script>

</body>
</html>

