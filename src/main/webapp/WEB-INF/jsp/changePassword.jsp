<%--
  User: iamxy Date: 2021/9/11 Time: 9:52
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
%>
<html>
<head>
    <title></title>


    <!-- 引入 layui.css -->
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">

    <!-- 引入 layui.js -->
    <script src="/layui-v2.6.8/layui/layui.js"></script>

    <style>
        form {
            padding: 30px;
        }


    </style>

</head>
<body>



<div class="layui-card">
    <div class="layui-card-header"  style="text-align: center">${title}</div>
    <div class="layui-card-body">

        <form class="layui-form layui-form-pane" lay-filter="example">



            <div class="layui-form-item">
                <label class="layui-form-label">原密码</label>
                <div class="layui-input-block">
                    <input type="password" name="oldPass" autocomplete="off"  placeholder="请输入原密码" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">新密码</label>
                <div class="layui-input-block">
                    <input type="password" name="new1" autocomplete="off"  placeholder="请输入新密码" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">确认新密码</label>
                <div class="layui-input-block">
                    <input type="password" name="new2" autocomplete="off"  placeholder="请再次输入新密码" class="layui-input">
                </div>
            </div>


            <div class="layui-form-item">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">提交</button>
            </div>
        </form>



    </div>
</div>





</body>

<script>

    layui.use(['form', 'layedit', 'laydate', 'tree', 'upload','element'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , upload = layui.upload
            ,element=layui.element;

        window.$ = layui.$;

        //监听提交
        form.on('submit(demo1)', function (data) {

            let oldPass=$("input[name='oldPass']").val();
            let new1=$("input[name='new1']").val();
            let new2=$("input[name='new2']").val();

            if(!oldPass){
                layer.alert("请输入原密码")
                return false;
            }

            if(!new1){
                layer.alert("请输入新密码");
                return false;/**/
            }

            if(!new2){
                layer.alert("请再次输入新密码");
                return false;
            }

            if(new1!=new2){
                layer.alert("两次密码输入不一致");
                return false;

            }

            $.post("/user/doChangePassword", data.field, function (res) {

                if(res.flag==1){
                    layer.msg(res.message);

                    window.location.href="/article/view?from=mine&articleId="+res.data.id+"&articleReceiverId="+res.data.id;

                }else{
                    layer.alert(res.message);
                }

            });

            return false;
        });


    });


</script>
</html>
