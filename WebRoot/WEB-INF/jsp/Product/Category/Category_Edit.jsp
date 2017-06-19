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
	<form action="wh/${msg }.do" name="cateForm" id="cateForm" method="post" style="width:340px;height:270px;">
		<input type="hidden" name="ID" id="id" value="${pd.Id }"/> 
		<div id="zhongxin">
		<table>  
			<tr class="info">
			<td>所属类型：</td>
				<td>
					<input id="combotree" value="${pd.ParentId}" class="easyui-combotree" style="width:100%;height:32px">					 
				</td>
			</tr> 
			<tr>
				<td>类型名称：</td>
				<td><input name="NAME" id="name"  value="${pd.CategoryName }"  class="easyui-textbox" 
					data-options="required:true,prompt:'这里输入类型名称'"  style="width:100%;height:32px"></td>
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
			url: 'cate/listCombotree',
			method: 'get',			
			valueField: 'Id',			
			textField: 'text',	
			prompt:'这里选择所属类型',		
		 	onSelect: function (node) {  
				$("#combotree").combotree('setValue',node.Id);   
			}  	  	 
		 }); 	
	  });    
	    
	    
	 
	 function  saveBtn(){   
		var name=$("#name").val(); 
		var parentId=$("#combotree").combobox("getValue");
		var Id=$("#id").val();
		if(name==""||name==null){
			alert("请填写必填项");
			return;
		}else{ 
		  	$.ajax({
				type:"post",
				url:"cate/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#id").val(), 
					"ParentId":$("#combotree").combobox("getValue"), 
					"CategoryName":$("#name").val(), 
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
		$("#cateWindow").window('close'); 			 
	};
	  
	 
		
	//取消
	function cancel() { 
		$("#cateWindow").window('close');
	};
	 
	

</script>	 
</body>
</html>