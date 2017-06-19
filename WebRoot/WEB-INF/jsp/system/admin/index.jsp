<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
<%@ include file="top.jsp"%>
<script type="text/javascript" src="http://www.w3cschool.cc/try/jeasyui/datagrid-detailview.js"></script>
<script type="text/javascript">
	var _menus = {
	};
	//设置登录窗口
	function openPwd() {
		$('#w').window({
			title : '修改密码',
			width : 300,
			modal : true,
			shadow : true,
			closed : true,
			height : 160,
			resizable : false
		});
	}
	//关闭登录窗口
	function close() {
		$('#w').window('close');
	}

	//修改密码
	function serverLogin() {
		var $newpass = $('#txtNewPass');
		var $rePass = $('#txtRePass');

		if ($newpass.val() == '') {
			msgShow('系统提示', '请输入密码！', 'warning');
			return false;
		}
		if ($rePass.val() == '') {
			msgShow('系统提示', '请在一次输入密码！', 'warning');
			return false;
		}

		if ($newpass.val() != $rePass.val()) {
			msgShow('系统提示', '两次密码不一至！请重新输入', 'warning');
			return false;
		}

		$.post('/ajax/editpassword.ashx?newpass=' + $newpass.val(), function(
				msg) {
			msgShow('系统提示', '恭喜，密码修改成功！<br>您的新密码为：' + msg, 'info');
			$newpass.val('');
			$rePass.val('');
			close();
		});

	}

	$(function() {
		
		$('#tabs').tabs({
		    border:false,
		    onSelect:function(title,index){
		    	$("#menuPosition").html("当前位置：" + title);
		    }
		});

		openPwd();
		//
		$('#editpass').click(function() {
			$('#w').window('open');
		});

		$('#btnEp').click(function() {
			serverLogin();
		})

		$('#loginOut').click(function() {
			if(confirm("您确定要退出本次登录吗?")){
				location.href = 'logout';
			}
		})

	});
</script>

</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
	<noscript>
		<div
			style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
			<img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
	<div region="north" split="true" border="false"
		style="overflow: hidden; height: 60px;
        background: url(images/layout-browser-hd-bg.png) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
		<span style="float:right; padding-right:20px;" class="head">欢迎
			${user.USERNAME} <a href="#" id="editpass">修改密码</a> <a href="javascript:void(0);" id="loginOut">安全退出</a>
		</span> <span style="padding-left:10px; font-size: 16px; "><img
			src="images/blocks.gif" width="20" height="20" align="absmiddle" />
			供应链管理系统</span>
	</div>
	<div region="south" split="true"
		style="height: 30px; background: #D2E0F2; ">
		<div class="footer">Copyrights© 2016-2017 陕西北斗晨昭科技有限公司</div>
	</div>
	<div region="west" split="true" title="导航菜单" style="width:180px;"
		id="west">
		<div class="easyui-accordion" fit="true" border="false">
			<!--  导航内容 -->
			<c:forEach items="${menuList}" var="menu">
				<c:if test="${menu.hasMenu}">
					<div title="${menu.MENU_NAME }"
						icon="${menu.MENU_ICON == null ? 'icon-desktop' : menu.MENU_ICON}"
						style="overflow:auto;">
						<ul>
							<c:forEach items="${menu.subMenu}" var="sub">
								<c:if test="${sub.hasMenu}">

									<li><div>
											<a target="mainFrame" menuUrl="${sub.MENU_URL }"><span
												class="${sub.MENU_ICON == null ? 'icon-search' : sub.MENU_ICON}"></span>${sub.MENU_NAME
												}</a>
										</div></li>

								</c:if>
							</c:forEach>
						</ul>
					</div>
				</c:if>
			</c:forEach>
		</div>

	</div>
	<div id="mainPanle" region="center"
		style="background: #eee; height:auto;">
		<div class="panel-header">
			<div id="menuPosition" class="panel-title panel-with-icon">首页</div>
			<div class="panel-icon main_desktop_win"></div>
			<div class="panel-tool">
				<a href="javascript:void(0)" class="main_desktop_positionhome"></a><a
					href="javascript:void(0)" class="main_panel-tool-max"></a>
			</div>
		</div>
		<div id="tabs" class="easyui-tabs" fit="true" border="false">
			<div title="待办事项" style="padding:20px;" id="home">
				<table  id="todolist" title="待办事项" class="easyui-datagrid" data-options="singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true,align:'middle',halign:'center'"></th>
 						<th data-options="field:'id',width:fixWidth(0.14),align:'center',halign:'center'">编号</th>
						<th data-options="field:'MenuName',width:fixWidth(0.18),align:'center',halign:'center'">待办事项名称</th>
						<th data-options="field:'ApplyNo',width:fixWidth(0.2),align:'center',halign:'center'">待办事项代号</th>
						<th data-options="field:'ApplyTime',width:fixWidth(0.2),align:'center',halign:'center',formatter:formatDate">申请日期</th>	
						<th data-options="field:'opt',align:'center',width:fixWidth(0.1), formatter:formatOpt">操作</th>				
					</tr>
				</thead>
			</table>
			</div>
		</div>
	</div>
	
	<div id="TodoWindow" class="easyui-window" title="流程信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:80%;height:400px;padding:10px;">
			
	</div> 

	<!--修改密码窗口-->
	<div id="w" class="easyui-window" closed="true" title="修改密码"
		collapsible="false" minimizable="false" maximizable="false"
		icon="icon-save"
		style="width: 300px; height: 150px; padding: 5px;
        background: #fafafa;">
		<div class="easyui-layout" fit="true">
			<div region="center" border="false"
				style="padding: 10px; background: #fff; border: 1px solid #ccc;">
				<table cellpadding=3>
					<tr>
						<td>新密码：</td>
						<td><input id="txtNewPass" type="Password" class="txt01" /></td>
					</tr>
					<tr>
						<td>确认密码：</td>
						<td><input id="txtRePass" type="Password" class="txt01" /></td>
					</tr>
				</table>
			</div>
			<div region="south" border="false"
				style="text-align: right; height: 30px; line-height: 30px;">
				<a id="btnEp" class="easyui-linkbutton" icon="icon-ok"
					href="javascript:void(0)"> 确定</a> <a class="easyui-linkbutton"
					icon="icon-cancel" href="javascript:void(0)" onclick="closeLogin()">取消</a>
			</div>
		</div>
	</div>

	<div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabclose">关闭</div>
		<div id="mm-tabcloseall">全部关闭</div>
		<div id="mm-tabcloseother">除此之外全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright">当前页右侧全部关闭</div>
		<div id="mm-tabcloseleft">当前页左侧全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-exit">退出</div>
	</div>
	<!--提示框-->
	<script type="text/javascript">
	$(function () {
		$('#todolist').datagrid({
			toolbar: '#tb'    //添加表格工具栏
	    });
		
		$.ajax({
			url:"applyAudit/findTodoList",
			success:function(data){ 
				var entities = data.entities;
				$('#todolist').datagrid('loadData',entities);
			}
		});
	});
	
 	//连接格式化
	function formatOpt(value,row,index){ 
		var ApplyNo = String(row.ApplyNo);
		return '<a href="javascript:void(0)" onclick="toAudit(\'' + ApplyNo +'\')">审核申请</a>';  
	}
 	
 	//分配审核申请事件
		function  toAudit(ApplyNo) {  
			$("#TodoWindow").window({ 
				href:"applyAudit/toAudit?ApplyNo="+ApplyNo,
				onClose:function(){
					
					$.ajax({
						url:"applyAudit/findTodoList",
						success:function(data){ 
							var entities = data.entities;
							$('#todolist').datagrid('loadData', entities);
						}
					});
					}
			});
			$('#TodoWindow').panel('open').panel('refresh'); 
		};  
	</script>

</body>
</html>