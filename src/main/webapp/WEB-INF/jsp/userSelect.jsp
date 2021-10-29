
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>

    <!-- 引入 layui.css -->
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">

    <!-- 引入 layui.js -->
    <script src="/layui-v2.6.8/layui/layui.js"></script>



    <style type="text/css">

        .layui-table-view .layui-form-radio{
            line-height: 28px;
        }

        .layui-table-cell .layui-form-checkbox[lay-skin="primary"]{
            top: 50%;
            transform: translateY(-50%);
        }
        .layui-form-label{
            /*width:100px;*/
        }
        #searchBtn{
            margin-left: 30px;
        }
        #file_name_lbl{
            width: 100px;
        }
        .table_area{
            margin-left: 30px;
            margin-right: 30px;
        }
        form{
            margin-top:10px;
        }

        .layui-form-item .layui-input-inline{
            width:100px;
        }
    </style>
</head>
<body>

<form class="layui-form" action="">
    <input type="hidden" name="id">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-inline">
                <input id="capitalNameTxt" style="width:100px" type="text"  name="name" placeholder="姓名" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-inline">
            <div class="layui-input-inline">

                <button id="searchBtn" type="submit" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>

            </div>
        </div>
    </div>

    <div class="layui-form-item">



    </div>


</form>


<div class="table_area">
    <div >
        <script type="text/html" id="toolbar">
            <div class="layui-btn-container">
                <button id="capital_select_save_btn" class="layui-btn layui-btn-radius layui-btn-sm" >保存</button>
                <button id="window_close_btn" class="layui-btn layui-btn-radius layui-btn-sm" lay-event="getCheckData">关闭</button>
            </div>
        </script>
        <table class="layui-hide" id="table_capital" lay-filter="capital_table" lay-data="{id: 'capital_tb'}" ></table>
    </div>
</div>


<script type="text/javascript">


    layui.use(['form','table'],function(){
        var $=layui.$;
        var table=layui.table;


        var tableIns=table.render({
            elem: '#table_capital'
            ,height: 400
            ,toolbar:'#toolbar'
            ,size:'sm'
            ,even:true
            ,url: '/user/listData' //数据接口
            //只查已经确认的资金指标
            ,where:{

            }
            ,page: true //开启分页
            ,method:'post'
            ,cols: [[ //表头
                {type:'radio'}
                ,{field: 'id', title: '序号',width:58}
                ,{field: 'name', title: '姓名'}
                ,{field: 'departmentName', title: '部门'}
            ]]
        });


        table.on('radio(capital_table)', function(obj){
            console.log(obj.checked); //当前是否选中状态
            console.log(obj.data.id); //选中行的相关数据
            $("#capital_select_save_btn").attr("data-project-id",obj.data.id);
            //单选的时候将数据保存到父页面
            window.parent.userSelect=obj.data;
            console.log(obj.type); //如果触发的是全选，则为：all，如果触发的是单选，则为：one
        });

        $("#searchBtn").click(function(){

            tableIns.reload({
                where:{
                    fileTitle:$("#fileNameTxt").val(),
                    departmentId:$("#departmentIdSelect").val(),
                    name:$("#capitalNameTxt").val()
                },
                page:{
                    curr:1
                }
            });

            bindEvent();

            return false;
        });

        function bindEvent(){
            //要放在layui.use里，等待table渲染完毕进行绑定
            //table.reload后，重新绑定
            //保存选择
            $("#capital_select_save_btn").click(function(){

                var projectId=$(this)[0].dataset['projectId'];
                if(projectId==null || ""==projectId){
                    layer.msg("请选择指标");
                }else{

                    //window.parent.$("#capital_select_input").val(capitalId);
                    //保存的时候将父页面的capital_data填写到表格中
                    window.parent.sync_data();
                    layer.msg("保存成功");
                }

            });

            //关闭选择窗口
            $("#window_close_btn").click(function () {
                console.log(window.parent.closeUserSelectWindow());
                // window.parent.closeCapitalSelectWindow();
            });
        }

        bindEvent();

    });


</script>

</body>
</html>
