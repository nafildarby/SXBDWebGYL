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
<div style="height:100%;">
    <div class="easyui-accordion" style="height:auto;">
        <div title="审批信息" style="overflow:auto;padding:10px;"> 
          <span style="font-size:14px;">审核人</span>
          <ul class="steps"> 
          	<c:forEach items="${aplist}" var="gd">
			  <li class="active">${gd.UserName}</li>
			</c:forEach>
		  </ul>
		  <div style="width:800px;height:1px;margin:0px auto;padding:0px;background-color:#D5D5D5;overflow:hidden;"></div>
         <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">审批信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="aply" data-options="iconCls:'icon-edit',toolbar:'#tb'">
					        <thead>
					            <tr>  
					                <th data-options="field:'FlowOrder',align:'center',width:fixWidth(0.105)" >审批步骤</th>
					                <th data-options="field:'ApplyNo',align:'center',width:fixWidth(0.18)">审批单号</th>
					                <th data-options="field:'ApplyTime',align:'center',width:fixWidth(0.15)">审批时间</th>
					                <th data-options="field:'UserName',align:'center',width:fixWidth(0.15)">操作人员</th> 
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.15)">审批意见</th>
					                <th data-options="field:'NodeName',align:'center',width:fixWidth(0.15)">审批名称</th>
					            </tr>
					        </thead>  
					        <tbody>
					   		<c:forEach items="${aplist}" var="gd">
					      		<tr>
					        		<td class="center" style="cursor:pointer">${gd.FlowOrder+1}</td>
					        		<td class="center" style="cursor:pointer">${gd.ApplyNo}</td>
					        		<td class="center" style="cursor:pointer">${gd.ApplyTime}</td>
					        		<td class="center" style="cursor:pointer">${gd.UserName}</td>
					        		<td class="center" style="cursor:pointer">${gd.Comment}</td>  
					        		<td class="center" style="cursor:pointer">${gd.NodeName}</td>  
					        	</tr>
					        </c:forEach>
					   	</tbody>
					    </table>   
					</div>
				</div>  
           </fieldset>
           	<c:if test="${isShow}">
           	<div style="margin:0px 10px 0px 10px;clear:both;">
         		<fieldset class="scheduler-border"> 
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table data-options="iconCls:'icon-edit',toolbar:'#tb'">
						<tr>
		                	<td class="tabAlign">审核意见：</td>
		                   	<td colspan="15">
		                		<textarea class="easyui-validatebox validatebox-text" id="common" cols="148" style="margin:10px auto;width:99%;height:80px;"></textarea>
		                    </td>
		                </tr>
		             	</table>
	                </div>
				  </div>  
				   <div style="text-align:center">
				  	<a  title="同意" class="btn btn-small btn-success"  style="width:60px;margin:5px auto;" onclick="appliBtn()">同意</a> 
				 	<a  title="拒绝" class="btn btn-small btn-danger"   style="width:60px;margin:5px auto;" onclick="repulseBtn()">拒绝</a>             	
			 	  </div>
                </fieldset>
              </div>  
              </c:if>
           </div>
       </div>
       <div title="明细信息" data-options="iconCls:'icon-help'" style="padding:10px;">
             	<form name="productForm" id="productForm" method="post">
		<input type="hidden" name="Id" id="Id" value="${pd.Id }"/>
		<input type="hidden" name="AskforPerson" id="askforPerson" value="${pd.AskforPerson }"/>
		<input type="hidden" name="AuditType" id="AuditType" value="${msg }"/>
		<div id="zhongxin">
		<table>
			<tr>
		        <td class="tabAlign">采购申请编号：</td>
			        <td colspan="10">
			        <input type="text" disabled="disabled" id="askforNo" cols="88" style="width:85%;height:20px;" value="${pd.AskforNo }"></input>
		        </td>
	        </tr>
			<tr>
		        <td class="tabAlign">备注：</td>
			        <td colspan="10">
			        <textarea disabled="disabled" class="easyui-validatebox validatebox-text" id="Comment" cols="88" style="width:85%;height:20px;">${pd.Comment}</textarea>
		        </td>
	        </tr>
		</table>
		<div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">采购物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div style="width: 100%; " title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="askProduct" data-options="singleSelect:true">
					        <thead>
					            <tr>
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.13)">物料名称</th>
					                <th data-options="field:'BarCode',align:'center',width:fixWidth(0.13)">物料编码</th>
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.12)">物料描述</th>
					                <th data-options="field:'Quantity',align:'center',width:fixWidth(0.10)" >数量</th>
					                <th data-options="field:'ComItemName',align:'center',width:fixWidth(0.10)">单位</th>
					                <th data-options="field:'Price',align:'center',width:fixWidth(0.10)">单价</th>
					                <th data-options="field:'EnterpriseName',align:'center',width:fixWidth(0.14)">供应商名称</th>
					                <th data-options="field:'AskforNo',align:'center'" hidden="true">采购申请编号</th>
					            </tr>
					        </thead>
					    </table>
					</div>
				</div>
           </fieldset>
        </div> 
		</div>
		</form>
      </div> 
    </div>
</div> 

	
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
		<div id="selectProductWindow" class="easyui-window" title="选择商品信息" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:800px;height:400px;padding:10px;">
		</div> 

<script type="text/javascript">	 
		$(document).ready(function(){
		    $('#aply').datagrid({
		 		toolbar: '#tb1',
		 		width:'auto',
				height:'auto',
		        nowrap: false, 
		        striped: true, 
		        border: true, 
		        collapsible:false,//是否可折叠的  
		        url:'', 
		        method: 'POST', 
		        remoteSort:false,
		        showFooter:true
		    }); 
		 	var dg = $('#askProduct').datagrid({
		 		toolbar: '#tb1',
		 		width:'auto',
				height:'auto',
		        nowrap: false, 
		        striped: true, 
		        border: true, 
		        collapsible:false,//是否可折叠的 
		        //fit: true,//自动大小 
		        url:'', 
		        method: 'POST',
		        //sortName: 'code', 
		        //sortOrder: 'desc', 
		        remoteSort:false,
			}); 
		 	dg.datagrid('enableCellEditing');
  			dg.datagrid('loadData',${askProduct});
		});
		
		function appliBtn(){
			var rows = $("#aply").datagrid('getRows');   
			var NodeName=null;
			var FlowOrder=0;
			for(i = 0;i< rows.length;i++){
				FlowOrder=rows[i].FlowOrder; 
			}
			$.ajax({
				type:"post",
				url:"Askfor/saveApply",
				dataType:"json",
				data:{ 
					"ApplyNo":$("#askforNo").val(),
					"Common":$("#Comment").val(), 
					"FlowOrder":FlowOrder 
				}, 
				success:function(data){ 
					if(data.msg == "failed"){
						alert("已审核");
					}else if(data.msg == "success"){
						alert("审核成功");  
						$("#TodoWindow").window('close');
						$('#todolist').datagrid('reload');  
						//关闭父页面弹出窗口
						$('#askforList').datagrid('reload');  
						$("#askforWindow").window('close');
					};
				},
				error:function(){
					alert("未知错误");
				}
			}); 
		}
		
		function repulseBtn() {  
			$.ajax({
				type:"post",
				url:"Askfor/saveApplyDataRepulse",
				dataType:"json",
				data:{ 
					"ApplyNo":$("#askforNo").val(),
					"Common":$("#common").val()
				}, 
				success:function(data){ 
					if(data.msg == "success"){
						alert("保存成功");  			
						$("#TodoWindow").window('close');
						$('#todolist').datagrid('reload');  
						//关闭父页面弹出窗口
						$('#askforList').datagrid('reload');  
						$("#askforWindow").window('close');
					}else  if(data.msg == "failed"){
						alert("保存失败"); 
					}
				},
				error:function(data){ 
					alert(data.msg);
					alert("保存失败"); 
				}
			});   
		};
</script>	 
</body>
</html>