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
		<input type="hidden" name="Id" id="product_Id" value="${pd.Id }"/>
		<div id="zhongxin">
		<table>
			<tr>
				<td>商品编号：</td>
				<td><input name="ProductNo" id="PNo" value="${pd.ProductNo }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入商品编号'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>商品名称：</td>
				<td><input name="ProductName" id="PName" value="${pd.ProductName }"  maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入商品编号'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>商品编码：</td>
				<td><input name="BarCode" id="BCode"  maxlength="32" value="${pd.BarCode }" class="easyui-textbox" data-options="prompt:'这里输入商品条码'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>
					<tr class="info">
					<td>商品类别：</td>
						<td>
						<select class="chzn-select" name="CategoryId" id="CategoryId" data-placeholder="请选择商品类别" style="vertical-align:top;">
						<option value=""></option>
						<c:forEach items="${CategoryList}" var="category">
							<option value="${category.Id }" <c:if test="${category.Id == pd.CategoryId}">selected</c:if>>${category.CategoryName}</option>
						</c:forEach>
						</select>
						</td>
					</tr>
			<tr>
				<td>
					<tr class="info">
					<td>商品单位：</td>
						<td>
						<select class="chzn-select" name="ComboItemId" id="ComboItemId" data-placeholder="请选择商品单位" style="vertical-align:top;">
						<option value=""></option>
						<c:forEach items="${ComboItemList}" var="comboItem">
							<option value="${comboItem.Id }" <c:if test="${comboItem.Id == pd.ComboItemId}">selected</c:if>>${comboItem.ComItemName}</option>
						</c:forEach>
						</select>
						</td>
			</tr>
			<tr>
				<td>
					<tr class="info">
					<td>供应单位：</td>
						<td>
						<select class="chzn-select" name="SupplierId" id="SupplierId" data-placeholder="请选择商品供应单位" style="vertical-align:top;">
						<option value=""></option>
						<c:forEach items="${SupplierList}" var="Supplier">
							<option value="${Supplier.Id }" <c:if test="${Supplier.Id == pd.SupplierId}">selected</c:if>>${Supplier.EnterpriseName}</option>
						</c:forEach>
						</select>
						</td>
			</tr>
			<tr>
				<td>商品价格：</td>
				<td><input name="Price" id="Price"  value="${pd.Price }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入商品价格'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td>商品税率：</td>
				<td><input name="TaxRate" id="TaxRate" value="${pd.TaxRate }" maxlength="32" class="easyui-textbox" data-options="prompt:'这里输入商品税率'" style="width:100%;height:32px"></td>
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<button type="button" class="btn btn-small btn-primary" id="saveBtn">保存</button>
					<a class="btn btn-small btn-danger" id="cancel">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
	</form>

	<script type="text/javascript">
	 
	$(function(){  
		
		$("#saveBtn").click(function(){
			var Id = $("#product_Id").val();
			var CategoryId=$("#CategoryId").val();
			var ComboItemId=$("#ComboItemId").val();
			var ProductNo=$("#PNo").val();
			alert(ProductNo);
			var ProductName=$("#PName").val();
			alert(ProductName);
			var BarCode=$("#BCode").val();
			alert(BarCode);
			var TaxRate=$("#TaxRate").val();
			var SupplierId=$("#SupplierId").val();
			if((CategoryId==null||CategoryId=="")&&(ComboItemId==null||ComboItemId=="")&&(ProductNo==null||ProductNo=="")
				&&(ProductName==null||ProductName=="")&&(BarCode==null||BarCode=="")&&(SupplierId==null||SupplierId=="")&&(TaxRate==null||TaxRate=="")){
					alert("请填写必填项");
					return;
			}else{
			$.ajax({
				type:"post",
				url:"product/" + '${msg }',
				dataType:"json",
				data:{ 
					"Id":$("#product_Id").val(),
					"ProductNo":$("#PNo").val(),
					"ProductName":$("#PName").val(),
					"BarCode":$("#BCode").val(),
					"CategoryId":$("#CategoryId").val(),
					"ComboItemId":$("#ComboItemId").val(),
					"Price":$("#Price").val(),
					"SupplierId":$("#SupplierId").val(),
					"STATUS":1,
					"TaxRate":TaxRate=$("#TaxRate").val()
				},
				success:function(data){ 
					if(data.msg == "failed"){
						alert("保存失败");
					}
					else if(data.msg == "success"){
						alert("保存成功");  
					}
				},
				error:function(){ 
					alert("保存失败"); 
				}
			});
		}
			//关闭父页面弹出窗口
			$("#productWindow").window('close'); 
		 	var pageUrl = "product/listProductPage";
			loadGrid($('#productList'),pageUrl); 
		});
		
		//取消按钮
		$("#cancel").click(function(){
			$("#productWindow").window('close');
		});
	});
	

</script>	 
</body>
</html>