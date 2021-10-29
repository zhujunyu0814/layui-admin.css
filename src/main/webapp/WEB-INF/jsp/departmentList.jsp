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

<div class="breadcrumb">您所在的位置：首页>系统设置>部门管理</div>

<div class="layui-card"  style="margin-top: 20px;padding-top:20px;">
    <%--        <div class="layui-card-header">卡片面板</div>--%>
    <div class="layui-card-body">

        <form lay-filter="search_form" class="layui-form layui-form-pane" action="">
            <div class="layui-form-item">

                <%--<div class="layui-inline">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" id="userNameTxt" name="name" autocomplete="off" class="layui-input">
                    </div>
                </div>
--%>

                <div class="layui-inline">
                    <label class="layui-form-label">角色</label>
                    <div class="layui-input-inline">
                        <select  name="role.id">
                            <option value="">全部</option>
                            <c:forEach items="${roleList}" var="role">
                                <option value="${role.id}">${role.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">部门</label>
                    <div class="layui-input-inline">
                        <select  name="department.id">
                            <option value="">全部</option>
                            <c:forEach items="${departmentList}" var="dP">
                                <option value="${dP.id}">${dP.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <button id="searchBtn" type="submit"  class="layui-btn layui-btn-sm" lay-submit="" lay-filter="demo1"><i class="layui-icon layui-icon-search"></i>查询</button>
                    </div>
                </div>

            </div>

        </form>

        <hr>

        <div >
            <script type="text/html" id="toolbar">
                <div class="layui-btn-container">
                    <button id="btn_user_add" class="layui-btn layui-btn-sm">新增</button>
                </div>
            </script>
            <table id="table_user" lay-filter="user_table"></table>
        </div>


    </div>
</div>


<script type="text/html" id="barDemo">
    <%--    用模板完成定制--%>
    <div style="cursor:hand">
        <a class="" lay-event="edit">编辑</a>
        <a class="" lay-event="del">删除</a>
    </div>
</script>

<!--弹出层，新增用户-->
<div style="display:none" id="user_add_window">

    <form style="width:300px;margin-top: 20px;" class="layui-form" lay-filter="user_add_form">
        <input type="hidden" name="id">

        <div class="layui-form-item">
            <label class="layui-form-label">部门名称</label>
            <div class="layui-input-block">
                <input type="text" name="name" lay-reqText="请输入部门名称" lay-verify="required" placeholder="部门名称" autocomplete="off" class="layui-input">
            </div>
        </div>


        <div></div>




        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-sm" lay-submit lay-filter="add_user">保存</button>
                <button id="close_add_window_btn" class="layui-btn layui-btn-sm">关闭</button>
            </div>
        </div>
    </form>

</div>


<script type="text/javascript">
    //Demo
    layui.use(['form','upload','table','element'], function(){
        var form = layui.form;
        var upload=layui.upload;
        var table=layui.table;
        window.$=layui.$;



        $("input[name='username']").change(function(){
            var value=$(this).val();
            if(!new RegExp("^[a-zA-Z0-9_\\s·]+$").test(value)){
                layer.msg('用户名只能由大小写字母和数字组成！');
            }
            if(/(^\_)|(\__)|(\_+$)/.test(value)){
                layer.msg('用户名首尾不能出现下划线\'_\'');
            }
            if(/^\d+\d+\d$/.test(value)){
                layer.msg('用户名不能全为数字');
            }

            $.post("/admin/user/checkUserName",{username:value},function(d){
                if(!d){
                    layer.msg("用户名已存在");
                }
            })


        });

        form.verify({
            username: function(value, item){ //value：表单的值、item：表单的DOM对象
                if(!new RegExp("^[a-zA-Z0-9_\\s·]+$").test(value)){
                    return '用户名只能由大小写字母和数字组成！';
                }
                if(/(^\_)|(\__)|(\_+$)/.test(value)){
                    return '用户名首尾不能出现下划线\'_\'';
                }
                if(/^\d+\d+\d$/.test(value)){
                    return '用户名不能全为数字';
                }
            }

            //我们既支持上述函数式的方式，也支持下述数组的形式
            //数组的两个值分别代表：[正则匹配、匹配不符时的提示文字]
            ,pass: [
                /^[\S]{6,12}$/
                ,'密码必须6到12位，且不能出现空格'
            ]
        });


        var tableIns=table.render({
            elem: '#table_user'
            ,height: 670
            ,even:true
            ,size:'sm',
            limit:'20'
            ,toolbar:'#toolbar'
            ,url: '/department/listData' //数据接口
            ,page: true //开启分页
            ,cols: [[ //表头
                {field: 'id', title: '序号',align:'center'}
                ,{field: 'name', title: '部门名称',align:'center'}
                ,{toolbar:"#barDemo", title: '操作',align:'center'}
            ]]
        });


        //监听工具条
        table.on('tool(user_table)', function(obj){

            console.log(obj);

            var data = obj.data;
            if(obj.event === 'detail'){
                layer.msg('ID：'+ data.id + ' 的查看操作');
            } else if(obj.event === 'del'){
                layer.confirm('真的删除行么', function(index){
                    $.post("/department/delete",{id:data.id,deleted:true},function(data){
                        obj.del();
                        layer.msg(data.message);
                    });
                    layer.close(index);
                });
            } else if(obj.event === 'edit'){

                console.log(data);
                form.val('user_add_form',{
                    id:data.id,
                    name:data.name,
                    username:data.username,
                    'departmentId':data.departmentId,
                    'roleId':data.roleId,
                });
                var layer_id=layui.layer.open({
                    type: 1,
                    area: ['400','470'],
                    content: $("#user_add_window")
                });
                $("#close_add_window_btn").click(function(){
                    layer.close(layer_id);
                    return false;
                });
            }


        });


        //监听提交
        form.on('submit(add_user)', function(data){
            var hidden=$("input[name='id']");
            if(hidden.val()!=""){
                data.field.id=hidden.val();

            }

            $.post("/department/save",data.field,function (data) {
                layer.msg(data.message);
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