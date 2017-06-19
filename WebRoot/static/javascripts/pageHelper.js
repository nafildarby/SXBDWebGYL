function loadGrid(dg,pageUrl){
	dg.datagrid({
		width:'auto',
		height:'auto',
        nowrap: false, 
        striped: true, 
        border: true, 
        collapsible:false,//是否可折叠的 
        //fit: true,//自动大小 
        url:pageUrl, 
        method: 'POST',
        //sortName: 'code', 
        //sortOrder: 'desc', 
        remoteSort:false,  
        pagination:true,//分页控件  
        rownumbers:true,//行号
        pageSize:10,
        pageNumber:1,
        rownumbers:true
    }); 
		//设置分页控件 
		 
	dg.datagrid('getPager').pagination({ 
	pageSize: 10,//每页显示的记录条数，默认为10 
	pageList: [10,50,100],//可以设置每页记录条数的列表 
	beforePageText: "第",//页数文本框前显示的汉字 
	afterPageText: "页    共 {pages} 页", 
	displayMsg: "当前显示 {from} - {to} 条记录   共 {total} 条记录", 
	/*onBeforeRefresh:function(){
	    $(this).pagination('loading');
	    alert('before refresh');
	    $(this).pagination('loaded');
	}*/
	
	}); 

}	

function pageData(list,total){
	var obj=new Object(); 
	obj.total=total; 
	obj.rows=list; 
	return obj; 
}
	
function find(dg, pageNumber, pageSize, pageUrl)
{
	dg.datagrid('getPager').pagination({pageSize : pageSize, pageNumber : pageNumber});//重置
	dg.datagrid("loading"); //加屏蔽
    $.ajax({
        type : "POST",
        dataType : "json",
        url : pageUrl,
        data : {
            'page' : pageNumber,
            'rows' : pageSize
        },
        success : function(data) {
        	dg.datagrid('loadData',pageData(data.rows,data.total));//这里的pageData是我自己创建的一个对象，用来封装获取的总条数，和数据，data.rows是我在控制器里面添加的一个map集合的键的名称
            var total =data.total;
            dg.datagrid("loaded"); //移除屏蔽
        },
        error : function(err) {
            $.messager.alert('操作提示', '获取信息失败...请联系管理员!', 'error');
            dg.datagrid("loaded"); //移除屏蔽
        }
    });
}


/**
 * 按百分比控制高度
 * @param percent
 * @returns {Number}
 */
function fixHeight(percent)
{
return (document.body.clientHeight) * percent ;
}


/**
 * 按百分比控制宽度
 * @param percent
 * @returns {Number}
 */
function fixWidth(percent)
{
return (document.body.clientWidth - 5) * percent ;
}


/**
 * 获取格式化后的Unix时间戳，并截取掉毫秒级以后的数据，然后调用转换方法
 * @param date
 * @param row
 * @param index
 * @returns
 */
function formatDate(date,row,index){
	if (date == undefined) {
        return "";
    }
    var datetime = getTime(date.toString().substring(0,10));
    return datetime;
    
}


/**
 * 将Unix时间戳转化为标准格式yyyy-MM-dd HH:mm:ss
 * @returns {String}
 */
function getTime(datetime) {
    var ts = arguments[0] || 0;
    var t, y, m, d, h, i, s;
    t = ts ? new Date(ts * 1000) : new Date();
    y = t.getFullYear();
    m = t.getMonth() + 1;
    d = t.getDate();
    h = t.getHours();
    i = t.getMinutes();
    s = t.getSeconds();
    // 可根据需要在这里定义时间格式  
    return y + '-' + (m < 10 ? '0' + m : m) + '-' + (d < 10 ? '0' + d : d) + ' ' + (h < 10 ? '0' + h : h) + ':' + (i < 10 ? '0' + i : i) + ':' + (s < 10 ? '0' + s : s);
}


/**
 * 将数据提交后的审核状态就行展示转换
 * @param data
 * @param row
 * @param index
 * @returns {String}
 */
function formatAudit(data,row,index){
	if(data == undefined){
		return "";
	}
	
	switch(data){
	case 0 : return "未提交审核"; break;
	case 1 : return "审核中"; break;
	case 2 : return "已完成"; break;
	case 3 : return "已拒绝"; break;
	default : return "";
	}
}
