<%--
  User: iamxy Date: 2021/9/8 Time: 11:37
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
%>





<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>海州实验中学办公平台</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">




    <!-- 引入 layui.css -->
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">

    <!-- 引入 layui.js -->
    <script src="/layui-v2.6.8/layui/layui.js"></script>




    <style>
	    /* 移动端 */
	    @media screen and (max-width: 768px) {
		    .layui-layout-admin .layui-layout-left,
		    .layui-layout-admin .layui-body,
		    .layui-layout-admin .layui-footer{left: 0;}
		    .layui-layout-admin .layui-side{left: -300px;}
	    }


	    iframe{
		    width: 100%;
		    height: 100%;
		    border: none;
	    }

    </style>

    <script>

        function toUrl(url){
            document.getElementById("iframe").src=url;
        }
    </script>

</head>
<body>

<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo layui-hide-xs layui-bg-black">海州实验中学办公平台</div>
        <!-- 头部区域（可配合layui 已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">
            <!-- 移动端显示 -->
            <li class="layui-nav-item layui-show-xs-inline-block layui-hide-sm" lay-header-event="menuLeft">
                <i class="layui-icon layui-icon-spread-left"></i>
            </li>

            <%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:toUrl('article/list?type=1');">我的公告</a></li>--%>
            <%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:toUrl('article/list?type=2');">我的批办</a></li>--%>
            <%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:toUrl('article/list?type=3');">我的公文</a></li>--%>
            <%--            <li class="layui-nav-item layui-hide-xs layui-this"><a href="javascript:toUrl('article/list?type=4');">我的通知</a></li>--%>

        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item layui-hide layui-show-md-inline-block">
                <a href="javascript:;">
                    <img src="/img/avatar.png" class="layui-nav-img">
                    ${sessionScope.loginUser.name}
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:toUrl('user/changePassword');">修改密码</a></dd>
                    <dd><a href="/user/logout">退出</a></dd>
                </dl>
            </li>
            <%--            <li class="layui-nav-item" lay-header-event="menuRight" lay-unselect>--%>
            <%--                <a href="javascript:;">--%>
            <%--                    <i class="layui-icon layui-icon-more-vertical"></i>--%>
            <%--                </a>--%>
            <%--            </li>--%>
        </ul>
    </div>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test" id="tests">

                <%--                <li class="layui-nav-item"><a href="javascript:toUrl('nav');">首页</a></li>--%>


                <li  class="layui-nav-item"><a href="javascript:toUrl('article/list?type=4');">通知公告</a></li>

                <li  class="layui-nav-item"><a href="javascript:toUrl('article/list?type=4&from=mine');">我的发布</a></li>







                <%--    <li class="layui-nav-item layui-nav-itemed">--%>
                <%--                    <a class="" href="javascript:;">发布通知</a>--%>
                <%--                    <dl class="layui-nav-child">--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=1&from=mine');">公告</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=2&from=mine');">批办</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=3&from=mine');">公文</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=4&from=mine');">通知</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/edit?type=1');">发布公告</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/edit?type=2');">发布批办</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/edit?type=3');">发布公文</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/edit?type=4');">发布通知</a></dd>--%>
                <%--                    </dl>--%>
                <%--                </li>--%>

                <%--                <li class="layui-nav-item layui-nav-itemed">--%>
                <%--                    <a class="" href="javascript:;">新增事项</a>--%>
                <%--                    <dl class="layui-nav-child">--%>
                <%--                       --%>
                <%--                    </dl>--%>
                <%--                </li>--%>




                <%--                <li class="layui-nav-item layui-nav-itemed">--%>
                <%--                    <a class="" href="javascript:;">阅读通知</a>--%>
                <%--                    <dl class="layui-nav-child">--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=1');">我的公告</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=2');">我的批办</a></dd>--%>
                <%--                        <dd><a href="javascript:toUrl('article/list?type=3');">我的公文</a></dd>--%>
                <%--                        <dd class="layui-this"><a href="javascript:toUrl('article/list?type=4');">我的通知</a></dd>--%>
                <%--                    </dl>--%>
                <%--                </li>--%>





                <c:if test="${sessionScope.loginUserRole.id==1}">
                    <li class="layui-nav-item">
                        <a href="javascript:;">系统管理</a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:toUrl('/user/list');">人员管理</a></dd>
                            <dd><a href="javascript:toUrl('/department/list');">部门管理</a></dd>
                        </dl>
                    </li>
                </c:if>



            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->


        <iframe id="iframe" src="article/list?type=4" STYLE="padding: 20px 20px 60px;background-color: #F2F2F2">
        </iframe>

        <%--        <iframe id="iframe1" src="article/list?type=5" STYLE="padding: 20px 20px 60px;background-color: #F2F2F2">--%>
        <%--        </iframe>--%>


    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        <div style="text-align: center">海州实验中学办公平台   copyright 2021</div>
    </div>
</div>
<script>
    //JS
    layui.use(['element', 'layer', 'util'], function(){
        var element = layui.element
            ,layer = layui.layer
            ,util = layui.util
            ,$ = layui.$;

        //头部事件
        util.event('lay-header-event', {
            //左侧菜单事件
            menuLeft: function(othis){
                layer.msg('展开左侧菜单的操作', {icon: 0});



            }
            ,menuRight: function(){
                layer.open({
                    type: 1
                    ,title: '更多'
                    ,content: '<div style="padding: 15px;">处理右侧面板的操作</div>'
                    ,area: ['260px', '100%']
                    ,offset: 'rt' //右上角
                    ,anim: 5
                    ,shadeClose: true
                    ,scrollbar: false
                });
            }
        });

    });
</script>

</body>
</html>



