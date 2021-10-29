<%--
  User: iamxy Date: 2021/9/11 Time: 9:52
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        .listItem{
            line-height: 28px;font-size:16px;
        }
    </style>
</head>
<body>
<%--查看功能--%>

<div class="layui-card">
    <div class="layui-card-header"  style="text-align: center;height: auto;padding: 50px">
        <div style="font-size: 36px;">${article.title}</div>
        <div>发布时间：<fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></div>
        <div>发布人：${article.createUserName}
        </div>
    </div>
    <div class="layui-card-body" style="padding: 50px;">
        <div>正文：</div>
        <div style="min-height: 200px;width: 80%;margin-left: auto;margin-right: auto;margin-top:20px;">
            ${article.content}
        </div>

        <hr style="margin-top: 20px;">
        <div style="margin-top:20px;">

            <div>相关附件</div>
            <ul style="margin-left:120px; " class="listItem">
                <c:forEach items="${fileList}" var="file">
                    <li>
                        <a target="_blank" href="${file.url}">${file.fileName}</a>
                    </li>
                </c:forEach>

            </ul>

            <c:if test="${article.articleTypeId eq 2}">

                <hr style="margin-top:20px;">
                <div>主办人</div>
                <div style="margin-left: 120px;" class="listItem">
                        ${host.userName} &nbsp;&nbsp;${host.readStatus==1?'<span style="color:#FF5722">未读</span>':'<span style="color:#5FB878">已读</span>'}
                </div>
            </c:if>
            <hr style="margin-top:20px;">
            <div>阅读情况：</div>

            <ul style="margin-left: 120px;display: flex;flex-wrap: wrap">
            <%--
                <c:forEach items="${articleReceiverList}" var="item">

                </c:forEach>--%>

                <c:forEach items="${articleReceiverList}" var="item">
                    <c:if test="${item.readStatus==1}">
                        <li class="listItem">
                            <span style="width: 60px;display: inline-block;color:#000000">${item.userName}</span>
                        </li>
                    </c:if>
                    <c:if test="${item.readStatus==2}">
                        <li class="listItem" style="">
                            <span style="width: 60px;display: inline-block;color:#0000ff">${item.userName}</span>
                        </li>
                    </c:if>

                </c:forEach>



            </ul>
        </div>


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


        layedit.set({
            uploadImage: {
                url: '/upload' //接口url
                , type: 'post' //默认post
            }
        });


        $("#hostUserSelect").click(function () {

            let windowId = layer.open({
                type: 2 // 0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                , title: '选择'
                , content: '/user/userSelect'
                , offset: ['200px', '300px']
                , area: ['600px', '480px']
            });

            window.closeUserSelectWindow = function () {
                layer.close(windowId);
            }

            window.sync_data = function () {
                form.val('example', {
                    hostName: userSelect.name,
                    hostId: userSelect.id
                })
            }


        });


        //多文件上传
        var uploadListIns = upload.render({
            elem: '#testList'
            , elemList: $('#demoList') //列表元素对象
            , url: '/upload' //此处用的是第三方的 http 请求演示，实际使用时改成您自己的上传接口即可。
            , accept: 'file'
            , multiple: true
            , number: 10
            , auto: false
            , bindAction: '#testListAction'
            , choose: function (obj) {
                var that = this;
                var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
                //读取本地文件
                obj.preview(function (index, file, result) {
                    var tr = $(['<tr id="upload-' + index + '">'
                        , '<td>' + file.name + '</td>'
                        , '<td>' + (file.size / 1014).toFixed(1) + 'kb</td>'
                        , '<td><div class="layui-progress" lay-filter="progress-demo-' + index + '"><div class="layui-progress-bar" lay-percent=""></div></div></td>'
                        , '<td>'
                        , '<button class="layui-btn layui-btn-xs demo-reload layui-hide">重传</button>'
                        , '<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete">删除</button>'
                        , '</td>'
                        , '</tr>'].join(''));

                    //单个重传
                    tr.find('.demo-reload').on('click', function () {
                        obj.upload(index, file);
                    });

                    //删除
                    tr.find('.demo-delete').on('click', function () {
                        delete files[index]; //删除对应的文件
                        tr.remove();
                        uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });

                    that.elemList.append(tr);

                    let url=res.data.src;
                    let fileName=res.data.
                    element.render('progress'); //渲染新加的进度条组件
                });
            }
            , done: function (res, index, upload) { //成功的回调


                console.log("upload success:",res);

                var that = this;
                //if(res.code == 0){ //上传成功
                var tr = that.elemList.find('tr#upload-' + index)
                    , tds = tr.children();
                tds.eq(3).html(''); //清空操作
                delete this.files[index]; //删除文件队列已经上传成功的文件
                return;
                //}
                this.error(index, upload);
            }
            , allDone: function (obj) { //多文件上传完毕后的状态回调
                console.log("全部上传成功",obj)
            }
            , error: function (index, upload) { //错误回调
                var that = this;
                var tr = that.elemList.find('tr#upload-' + index)
                    , tds = tr.children();
                tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
            }
            , progress: function (n, elem, e, index) { //注意：index 参数为 layui 2.6.6 新增

                element.progress('progress-demo-' + index, n + '%'); //执行进度条。n 即为返回的进度百分比
            }
        });


        //日期
        laydate.render({
            elem: '#date'
        });
        laydate.render({
            elem: '#date1'
        });

        let data2 = [{
            title: '早餐'
            , id: 1
            , children: [{
                title: '油条'
                , id: 5
            }, {
                title: '包子'
                , id: 6
            }, {
                title: '豆浆'
                , id: 7
            }]
        }, {
            title: '午餐'
            , id: 2
            , checked: true
            , children: [{
                title: '藜蒿炒腊肉'
                , id: 8
            }, {
                title: '西湖醋鱼'
                , id: 9
            }, {
                title: '小白菜'
                , id: 10
            }, {
                title: '海带排骨汤'
                , id: 11
            }]
        }];




        $.get("/user/userTreeData", function (res) {


            //渲染
            tree.render({
                elem: '#tree1'  //绑定元素
                , showCheckbox: true
                , data: res.data
                , oncheck: function (obj) {
                    console.log(obj.data); //得到当前点击的节点数据
                    console.log(obj.checked); //得到当前节点的展开状态：open、close、normal
                    console.log(obj.elem); //得到当前节点元素
                    //  alert(JSON.stringify(obj));
                }
                ,id:'userTree'
            });

        });


        //创建一个编辑器
        let editIndex = layedit.build('content');


        //自定义验证规则
        form.verify({
            title: function (value) {
                if (value.length < 5) {
                    return '标题至少得5个字符啊';
                }
            }
            , pass: [
                /^[\S]{6,12}$/
                , '密码必须6到12位，且不能出现空格'
            ]
            , content: function (value) {
                layedit.sync(editIndex);
            }
        });

        //监听指定开关
        form.on('switch(switchTest)', function (data) {
            layer.msg('开关checked：' + (this.checked ? 'true' : 'false'), {
                offset: '6px'
            });
            layer.tips('温馨提示：请注意开关状态的文字可以随意定义，而不仅仅是ON|OFF', data.othis)
        });

        //监听提交
        form.on('submit(demo1)', function (data) {

            console.log("submit data:", data);

            data.field.content = layedit.getContent(editIndex);

            var checkedItem=tree.getChecked("userTree");

            let checkedUserIds=[];

            for(let item of checkedItem){
                if(item.type=='department'){

                    if(item.children&&item.children.length>0){
                        for(let user of item.children){
                            checkedUserIds.push(user.id);
                        }
                    }

                }else {
                    checkedUserIds.push(item.id);
                }
            }

            console.log("checked user ids:",checkedUserIds);

            data.field.audienceIdsStr=checkedUserIds.join(",");


            layer.alert(JSON.stringify(data.field), {
                title: '最终的提交信息'
            })

            $.post("/article/save", data.field, function (res) {

                console.log(res);
            });

            return false;
        });

        //表单赋值
        layui.$('#LAY-component-form-setval').on('click', function () {
            form.val('example', {
                "username": "贤心" // "name": "value"
                , "password": "123456"
                , "interest": 1
                , "like[write]": true //复选框选中状态
                , "close": true //开关状态
                , "sex": "女"
                , "desc": "我爱 layui"
            });
        });

        //表单取值
        layui.$('#LAY-component-form-getval').on('click', function () {
            var data = form.val('example');
            alert(JSON.stringify(data));
        });

    });


</script>
</html>
