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
<div style="height:100%;">
   <div class="easyui-accordion" style="height:auto;">
        <div title="审批信息" style="overflow:auto;padding:10px;"> 
          <span style="font-size:14px;">审核角色</span>
          <ul class="steps"> 
          	<c:forEach items="${plist}" var="p" varStatus="xh">
          		<c:choose>
	          		<c:when test="${currentStep == p.FlowOrder}">
	          			<li class="active">${p.NodeName}</li>
	          		</c:when>
	          		<c:otherwise>
	          			<li>${p.NodeName}</li>
	          		</c:otherwise>
          		</c:choose>
			</c:forEach>
		  </ul> 
		  <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">审批信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="aply" data-options="iconCls:'icon-edit'">
					        <thead>
					            <tr>  
					                <th data-options="field:'NodeName',align:'center',width:fixWidth(0.14)" >审批流程</th>
					                <th data-options="field:'ApplyNo',align:'center',width:fixWidth(0.208)">审批单号</th>
					                <th data-options="field:'ApplyTime',align:'center',width:fixWidth(0.17)">审批时间</th>
					                <th data-options="field:'UserName',align:'center',width:fixWidth(0.17)">审批人员</th> 
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.20)">审批意见</th> 
					            </tr>
					        </thead>  
					        <tbody>
					   		<c:forEach items="${aplist}" var="gd">
					      		<tr>
					        		<td class="center" style="cursor:pointer">${gd.NodeName}</td>
					        		<td class="center" style="cursor:pointer">${gd.ApplyNo}</td>
					        		<td class="center" style="cursor:pointer">${gd.ApplyTime}</td>
					        		<td class="center" style="cursor:pointer">${gd.UserName}</td>
					        		<td class="center" style="cursor:pointer">${gd.Common}</td>   
					        	</tr>
					        </c:forEach>
					   	</tbody>
					    </table>   
					</div>
				</div>  
           </fieldset>
		   <c:if test="${!isOver && isShow}">
           	<div style="margin:0px 10px 0px 10px;clear:both;">
         		<fieldset class="scheduler-border"> 
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table data-options="iconCls:'icon-edit',toolbar:'#tb'">
							<tr>
			                	<td class="tabAlign">审核意见：</td>
			                   	<td colspan="15">
			                		<textarea class="easyui-validatebox validatebox-text" id="common" cols="148" style="margin:10px auto;width:98%;height:80px;"></textarea>
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
        <div title="明细信息" style="padding:10px;">   
        <div class="info_innerframe" style="margin:0px 10px 0px 10px;clear:both;">
            <fieldset class="scheduler-border">
            <legend class="scheduler-border" style="font-size:14px;">基础信息</legend>
            <input id="Id" value="${pd.Id}"  style="width:230px;" hidden="true">					 
            <table class="tab" border="0" cellpadding="3px" cellspacing="0" width="100%">
             	<tbody> 
                     <tr>  
                        <td class="tabAlign">出库单号：</td>
                        <td>
                        	<input id="outCode" class="easyui-textbox" value="${pd.OutBoundNo}"  style="width:180px;" />
                        </td>
                        <td class="tabAlign">出库仓库：</td>
                        <td>
                        	<input id="outWHNo"  class="easyui-textbox" value="${pd.OutWarehouseName}"  style="width:180px;" />
                        </td>
                    </tr>
                    <tr> 
                        <td class="tabAlign">入库仓库：</td>
                        <td>
                        	<input id="inWHNo"   class="easyui-textbox" value="${pd.InWarehouseName}"  style="width:180px;" />
                        </td> 
                        <td class="tabAlign">出库时间：</td> 
                        <td>
                        	<input id="OutTime" class="easyui-textbox" value="${pd.OutBoundTime}"  style="width:180px;" />
                        </td>
                        <td class="tabAlign">操作人：</td>
                        <td>
                        	<input id="OpName" class="easyui-textbox" value="${pd.OutBoundPerson}"   style="width:180px;" />
                        </td> 
                    </tr> 
                    <tr>
                        <td class="tabAlign">备注：</td>
                        <td colspan="10">
                        	<textarea class="easyui-validatebox validatebox-text" id="Note" cols="88" style="width:99%;height:20px;">${pd.Comment}</textarea>
                        </td>
                    </tr>
                	</tbody>
            	</table> 
            </fieldset>
        </div>
        <div style="margin:0px 10px 0px 10px;clear:both;">
         	<fieldset class="scheduler-border">
                <legend class="scheduler-border" style="font-size:14px;">出库物料明细信息</legend>
                <div style="width: auto; background-color: rgb(222, 235, 250); margin: 2px;" class="panel datagrid">
					<div  title="" class="datagrid-wrap panel-body panel-body-noheader"> 
						<table id="outGoods">
					        <thead>
					            <tr>  
					                <th data-options="field:'ProductName',align:'center',width:fixWidth(0.19)">物料名称</th>
					                <th data-options="field:'BarCode',align:'center',width:fixWidth(0.19)">物料编码</th>
					                <th data-options="field:'OutNumber',align:'center',width:fixWidth(0.11)" >出库数量</th>
					                <th data-options="field:'DeployNum',align:'center',width:fixWidth(0.108)">调配数量</th>   
					                <th data-options="field:'Unit',align:'center',width:fixWidth(0.10)">单位</th>
					                <th data-options="field:'Comment',align:'center',width:fixWidth(0.19)">物料描述</th>
					            </tr>
					        </thead>
					        <tbody>
					   		<c:forEach items="${gdlist}" var="gd">
					      		<tr>
					        		<td class="center" style="cursor:pointer">${gd.ProductName}</td>
					        		<td class="center" style="cursor:pointer">${gd.BarCode}</td>
					        		<td class="center" style="cursor:pointer">${gd.OutNumber}</td>
					        		<td class="center" style="cursor:pointer">${gd.DeployNum}</td> 
					        		<td class="center" style="cursor:pointer">${gd.Unit}</td> 
					        		<td class="center" style="cursor:pointer">${gd.Comment}</td>
					        	</tr>
					        </c:forEach>
					   	</tbody>
					    </table>   
					</div>
				</div>
           </fieldset>
        </div>   
    </div>
  </div>
</div> 

<script type="text/javascript"> 

	//页面加载时事件
 	$(document).ready(function(){ 
	 	$('#outGoods').datagrid({ 
	 		width:'auto',
			height:'300px',
	        nowrap: false, 
	        striped: true, 
	        border: true, 
	        collapsible:false,//是否可折叠的  
	        url:'', 
	        method: 'POST', 
	        remoteSort:false,
	        showFooter:true
	    });  
	    
	    $('#aply').datagrid({
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
	});     
	
	function appliBtn(){ 
		$.ajax({
			type:"post",
			url:"common/saveApplyData",
			dataType:"json",
			data:{ 
				"ApplyNo": '${pd.OutBoundNo}',
				"Common":$("#common").val()
			}, 
			success:function(data){ 
				if(data.msg == "failed"){
					alert("已审核"); 
				}else if(data.msg == "success"){
					alert("审核成功");  		
					$("#TodoWindow").window('close');
					$('#todolist').datagrid('reload'); 			 
					//关闭父页面弹出窗口
					$("#commonlist").datagrid("reload");
					$("#SelectcomWindow").window('close');
				};
			},
			error:function(){ 
				alert("审核失败"); 
			}
		});   
	};
	
	function repulseBtn() {  
		$.ajax({
			type:"post",
			url:"common/saveApplyDataRepulse",
			dataType:"json",
			data:{ 
				"ApplyNo": '${pd.OutBoundNo}',
				"Common":$("#common").val()
			}, 
			success:function(data){ 
				if(data.msg == "failed"){
					alert("保存失败");  
				}else if(data.msg == "success"){
					alert("保存成功");  		
					$("#TodoWindow").window('close');
					$('#todolist').datagrid('reload'); 			 
					//关闭父页面弹出窗口
					$("#commonlist").datagrid("reload");
					$("#SelectcomWindow").window('close');
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


