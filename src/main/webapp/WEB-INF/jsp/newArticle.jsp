<%--
  User: iamxy Date: 2021/9/11 Time: 9:38
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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




<button class="layui-btn layui-btn-primary" id="btn1">新建批办</button>
<button class="layui-btn layui-btn-danger" id="btn2">btn</button>
<button class="layui-btn layui-btn-normal">btn</button>


</body>

<script>


    layui.use(function(){

        alert('layui');

        window.$=layui.$;

        $("#btn1").click(function (){

            window.location.href="/article/edit";
        });


    });



</script>
</html>
