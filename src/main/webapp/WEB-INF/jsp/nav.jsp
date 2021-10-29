<%--
  User: iamxy Date: 2020/4/13 Time: 9:30
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
%>
<html>
<head>
    <title>Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title></title>


    <!-- 引入 layui.css -->
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">

    <!-- 引入 layui.js -->
    <script src="/layui-v2.6.8/layui/layui.js"></script>

    <link rel="stylesheet" href="/css/layui-admin.css">

</head>
<body>


<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md6">
                    <div class="layui-card">
                        <div class="layui-card-header">快捷方式</div>
                        <div class="layui-card-body">

                            <div class="layui-carousel layadmin-carousel layadmin-shortcut" lay-anim=""
                                 lay-indicator="inside" lay-arrow="none" style="width: 100%; height: 280px;">
                                <div carousel-item="">
                                    <ul class="layui-row layui-col-space10 layui-this">

                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/edit?type=1">
                                                <i class="layui-icon layui-icon-user"></i>
                                                <cite>创建公告</cite>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/edit?type=2">
                                                <i class="layui-icon layui-icon-set"></i>
                                                <cite>创建批办</cite>
                                            </a>
                                        </li>

                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/edit?type=3">
                                                <i class="layui-icon layui-icon-console"></i>
                                                <cite>创建公文</cite>
                                            </a>
                                        </li>

                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/edit?type=4">
                                                <i class="layui-icon layui-icon-find-fill"></i>
                                                <cite>创建通知</cite>
                                            </a>
                                        </li>


                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/list?type=1">
                                                <i class="layui-icon layui-icon-chart"></i>
                                                <cite>我的公告</cite>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/list?type=2">
                                                <i class="layui-icon layui-icon-template-1"></i>
                                                <cite>我的批办</cite>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/list?type=3" >
                                                <i class="layui-icon layui-icon-chat"></i>
                                                <cite>我的公文</cite>
                                            </a>
                                        </li>

                                        <li class="layui-col-xs3">
                                            <a lay-href="/article/list?type=4">
                                                <i class="layui-icon layui-icon-survey"></i>
                                                <cite>我的通知</cite>
                                            </a>
                                        </li>
                                    </ul>

                                </div>
                                <div class="layui-carousel-ind">
                                    <ul>
                                        <li class=""></li>
                                        <li class="layui-this"></li>
                                    </ul>
                                </div>
                                <button class="layui-icon layui-carousel-arrow" lay-type="sub"></button>
                                <button class="layui-icon layui-carousel-arrow" lay-type="add"></button>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-card">
                        <div class="layui-card-header">待办事项</div>
                        <div class="layui-card-body">

                            <div class="layui-carousel layadmin-carousel layadmin-backlog" lay-anim=""
                                 lay-indicator="inside" lay-arrow="none" style="width: 100%; height: 280px;">
                                <div carousel-item="">
                                    <ul class="layui-row layui-col-space10 layui-this">
                                        <li class="layui-col-xs6">
                                            <a lay-href="/article/list?type=1&readStatus=1" class="layadmin-backlog-body">
                                                <h3>待办公告</h3>
                                                <p><cite id="documentCount">${countMap.t1}</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a lay-href="/article/list?type=2&readStatus=1" class="layadmin-backlog-body">
                                                <h3>待办批办</h3>
                                                <p><cite id="applyCount">${countMap.t2}</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a lay-href="/article/list?type=3&readStatus=1" class="layadmin-backlog-body">
                                                <h3>待办公文</h3>
                                                <p><cite id="noticeCount">${countMap.t3}</cite></p>
                                            </a>
                                        </li>
                                        <li class="layui-col-xs6">
                                            <a href="/article/list?type=4&readStatus=1"
                                               class="layadmin-backlog-body">
                                                <h3>待办通知</h3>
                                                <p><cite id="myCurrentApplyCount">${countMap.t4}</cite></p>
                                            </a>
                                        </li>
                                    </ul>
                                    <ul class="layui-row layui-col-space10">
                                        <li class="layui-col-xs6">
                                            <a href="javascript:;" class="layadmin-backlog-body">
                                                <h3>待审友情链接</h3>
                                                <p><cite style="color: #FF5722;">5</cite></p>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="layui-carousel-ind">
                                    <ul>
                                        <li class="layui-this"></li>
                                        <li class=""></li>
                                    </ul>
                                </div>
                                <button class="layui-icon layui-carousel-arrow" lay-type="sub"></button>
                                <button class="layui-icon layui-carousel-arrow" lay-type="add"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md12">

                    <div class="layui-card">
                        <div class="layui-tab layui-tab-brief layadmin-latestData">
                            <ul class="layui-tab-title">
                                <li class="layui-this">消息中心</li>
                                <%--                                <li class="">今日热帖</li>--%>
                            </ul>
                            <div class="layui-tab-content">
                                <div class="layui-tab-item" style="">

                                </div>
                                <table id="table_capital" lay-filter="capital_table"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>
</div>


<script type="text/javascript">
    layui.use(['element','table'], function () {

        var table=layui.table;

        var $=layui.$;

        $("a[lay-href]").click(function () {
            window.location.href = $(this).attr("lay-href");
        });


        $.get("${contextPath}/user/notice/todo_statistics",function(result){
            result=result.data;
            $("#documentCount").text(result.documentCount);


            $("#applyCount").text(result.applyCount);
            $("#noticeCount").text(result.noticeCount);
            $("#myCurrentApplyCount").text(result.myCurrentApplyCount);
            //   console.log(result);
        });


        var tableIns=table.render({
            elem: '#table_capital'
            ,height: 400
            ,even:true
            ,size:'md'
            ,url: '/article/listData' //数据接口
            ,page: true //开启分页
            ,cols: [[ //表头
                {field: 'id', title: 'ID', width:120,align: 'center'}
                ,{field: 'title', title: '标题',align: 'center'}

                ,{title: '类型',align:'center',templet:function(d) {


                        if (d.articleTypeId == 1) {
                            return "公告"
                        } else if (d.articleTypeId == 2) {
                            return "批办"
                        } else if (d.articleTypeId == 3) {
                            return "公文"
                        } else if (d.articleTypeId == 4) {
                            return "通知"
                        }



                    }
                    }

                ,{field: 'createTime', title: '创建时间', width:180,align: 'center'}
                ,{title: '状态',align:'center',width:100,templet:function(d){

                        if(d.status==1){
                            return "<span style='color:#FF5722'>未读</span>"
                        }else{
                            return "<span style='color:#5FB878'>已读</span>"
                        }

                    }}

                //   ,{toolbar:"#barDemo", title: '操作', width: 140,align:'center',fixed:'right'}
            ]]
        });


    });

</script>


</body>
</html>
