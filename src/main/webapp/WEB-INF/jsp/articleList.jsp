<%--
  User: iamxy Date: 2021/9/11 Time: 16:03
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
%>
<html>
<head>
    <title>Title</title>

    <!-- 引入 layui.css -->
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">

    <!-- 引入 layui.js -->
    <script src="/layui-v2.6.8/layui/layui.js"></script>




</head>
<body>

<%--<div class="breadcrumb" >您所在的位置：首页>我的事项>我的${typeName}</div>--%>


<%--在c标签中通过from是否有mine来判断该页面显示的是哪一个功能--%>
<div class="breadcrumb" >您所在的位置：首页>我的事项>我的<c:if test="${from ne 'mine'}">通知</c:if><c:if test="${not empty from}">发布</c:if>
</div>
<%--<div class="breadcrumb" >您所在的位置：首页>我的事项>我的
    <c:if test="${from ne 'mine'}"><c></c>
</div>--%>


<div class="layui-card" style="margin-top: 20px;padding-top:20px;">
    <%--        <div class="layui-card-header">卡片面板</div>--%>
    <div class="layui-card-body">

        <form lay-filter="search_form" class="layui-form layui-form-pane" action="">
            <input type="hidden" name="type" value="${param.type}">


            <div class="layui-form-item">

                <div class="layui-inline">
                    <label class="layui-form-label">标题</label>
                    <div class="layui-input-inline">
                        <input type="text" id="userNameTxt" name="title" autocomplete="off" class="layui-input">
                    </div>
                </div>



                <c:if test="${from ne 'mine'}">
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select  name="readStatus" value="1">
                                <option value="">全部</option>
                                <option value="2">已读</option>
                                <option value="1" >未读</option>
                            </select>
                        </div>
                    </div>
                </c:if>


                <div class="layui-inline">
                    <label class="layui-form-label">时间</label>
                    <div class="layui-input-inline">
                        <input type="text" name="dateSpan" class="layui-input" id="date">
                    </div>

                </div>



                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <button id="searchBtn" type="submit"  class="layui-btn layui-btn-sm" lay-submit="" lay-filter="demo1">
                            <i class="layui-icon layui-icon-search"></i>搜索</button>
                    </div>
                </div>

            </div>

        </form>


        <hr>
        <div>
            <script type="text/html" id="toolbar">
                <c:if test="${not empty from}">
                <div class="layui-btn-container">
                    <a class="layui-btn layui-btn-sm" lay-event="newArticle">发布</a>
                    <%--                    <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>--%>
                </div>
                </c:if>
            </script>
            <table id="table_user" lay-filter="user_table"></table>
        </div>


    </div>







</div>













<script type="text/html" id="barDemo">

    <a class="layui-btn layui-btn-radius layui-btn-primary layui-btn-sm " lay-event="view">查看</a>


    <c:if test="${not empty from}">

        <a class="layui-btn layui-btn-radius  layui-btn-sm" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-radius layui-btn-danger layui-btn-sm" lay-event="delete">删除</a>

    </c:if>



    {{#  if(d.confirmStatus==1){ }}

    {{#  } else { }}


    {{#  } }}

</script>


<script type="text/javascript">
    //Demo
    layui.use(['form','upload','table','element','laydate'], function(){
        var form = layui.form;
        var upload=layui.upload;
        var table=layui.table;
        var laydate=layui.laydate;
        window.$=layui.$;


        laydate.render({
            elem: '#date'
            ,type: 'date'
            ,range: true
            ,format:'yyyy-MM-dd'
        });


        var tableIns=table.render({
            elem: '#table_user'
            ,height: 670
            ,even:true
            ,size:'lg'
            ,toolbar: '#toolbar'
            ,url: '/article/listData?from=${from}' //数据接口
            ,page: true //开启分页
            ,where:{
                type:${param.type}
            }
            ,cols: [[ //表头
                // {field: 'id', title: '序号',align:'center'}
                {field: 'author', title: '发布人',align:'center'}
                ,{field: 'title', title: '标题',align:'center',event:'setSign',width:800}

                ,{field: 'createTime',title: '发布时间',align:'center'}
                <c:if test="${empty from}">
                ,{title: '状态',align:'center',templet:function(d){

                        if(d.status == 1){
                            return "<span style='color:#FF5722'>未读</span>"
                        }else{
                            return "<span style='color:#5FB878'>已读</span>"
                        }
                    }}
                </c:if>
                ,{field: 'readRatio', title: '阅读率',align:'center',width:100}
                <c:if test="${not empty from}">
                ,{field: 'readCount', title: '已读/总数',align:'center',width:100}

                </c:if>
                ,{toolbar:"#barDemo", title: '操作',align:'center'}
            ]]
            ,skin:'nob'
        });
        table.on('toolbar(user_table)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'newArticle':
                {
                    window.location.href="/article/edit?type=4";
                    break;
                }
            };
        });
        //监听工具条
        table.on('tool(user_table)', function(obj){
            console.log(obj);
            var data = obj.data;
            if(obj.event === 'view'||obj.event === 'setSign'){
                // layer.msg('ID：'+ data.articleId + ' 的查看操作');

               /* $.ajax({
                    type:"post",
                    url:"/article/view",
                    async:false,
                    data:{'articleId':data.articleId,'articleReceiverId':data.id,'from':${from},data},
                    success:function (data){

                        if('mine'=='${from}'){
                            window.location.href="/article/view?from=mine"
                            /!* window.location.href="/article/view?from=mine&articleId="+data.articleId+"&articleReceiverId="+data.id;*!/
                        }else{
                            window.location.href="/article/view"
                            /!* window.location.href="/article/view?articleId="+data.articleId+"&articleReceiverId="+data.id;*!/
                        }
                    }

                });*/

           if('mine'=='${from}'){
                    window.location.href="/article/view?from=mine&articleId="+data.articleId+"&articleReceiverId="+data.id;
                }else {
               window.location.href = "/article/view?articleId=" + data.articleId + "&articleReceiverId=" + data.id;
           }

                /*if('mine'=='${from}'){
                $.ajax({
                        type:"POST",
                        url:"/article/view",
                        async:true,
                        data:{'articleId':data.articleId,'articleReceiverId':data.id,'from':${from},data},
                        success:function (articleView) {
                            /!window.location.href="/article/view";!/
                            window.location.href="/article/view?from=mine&articleId="+data.articleId+"&articleReceiverId="+data.id;
                        }
                        });
                }else{
                    $.ajax({
                        type:"POST",
                        async:true,
                        url:"/article/view",
                        data:{'articleId':data.articleId,'articleReceiverId':data.id,data},
                        success:function (articleView) {

                           /!* window.location.href = "/article/view";*!/
                            window.location.href="/article/view?articleId="+data.articleId+"&articleReceiverId="+data.id;
                        }
                    });
                }*/
            }else if(obj.event=='edit'){
                window.location.href="/article/edit?id="+data.articleId;

            }else if(obj.event=='delete'){
                layer.confirm("确认删除吗？", function(index){
                    $.post("/article/delete",{id:data.id,isDelete:true},function(data){
                        if(data.flag==1){
                            obj.del();
                            layer.msg("删除成功");
                        }else{
                            console.log(data.code);
                            layer.msg("操作失败，请稍后重试");
                        }
                    });
                    layer.close(index);
                });
            }else if(obj.event=='confirm'){
                layer.confirm("确认后将下发，并且不可撤回？", function(index){
                    $.post("/article/confirm",{id:data.id,isDelete:true},function(data){

                        if(data.flag==1){
                            layer.msg("确认成功");
                            tableIns.reload();
                        }else{
                            console.log(data.code);
                            layer.msg("操作失败，请稍后重试");
                        }
                    });
                    layer.close(index);
                });
            }
        });

        //监听提交
        form.on('submit(add_user)', function(data){
            var hidden=$("input[name='id']");
            if(hidden.val()!=""){
                data.field.id=hidden.val();

            }
            $.post("/user/save",data.field,function (data) {
                layer.msg(data.msg);
                tableIns.reload();
                bindEvent();
            });

            return false;
        });

        function bindEvent(){

            $("#btn_user_add").click(function () {

                $("#user_add_window form input").val("");
                $("#user_add_window form select").val("");

                var layer_id=layui.layer.open({
                    type: 1,
                    area: ['400','470'],
                    content: $("#user_add_window")
                });

                $("#close_add_window_btn").click(function(){
                    layer.close(layer_id);
                    return false;
                });

            });

        }

        bindEvent();
        $("#searchBtn").click(function(){

            tableIns.reload({
                where:form.val('search_form'),
                page:{
                    curr:1
                }
            });

            bindEvent();

            return false;
        });

    });

</script>

</body>
</html>