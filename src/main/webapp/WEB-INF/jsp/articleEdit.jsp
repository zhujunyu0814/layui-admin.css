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

            <input type="hidden" name="articleTypeId" value="${type}">
            <input type="hidden" name="fileUrls">
            <input type="hidden" name="id" value="${article.id}">
            <input type="hidden" name="fileNames">

            <div class="layui-form-item">
                <label class="layui-form-label">${typeName}标题</label>
                <div class="layui-input-block">
                    <input type="text" name="title" autocomplete="off" value="${article.title}" placeholder="请输入标题" class="layui-input">
                </div>
            </div>

            <%--            只有批办才有主办人--%>
            <c:if test="${type eq 2}">
                <div class="layui-form-item">
                    <label class="layui-form-label">主办人</label>
                    <div class="layui-input-inline">
                        <input type="text" id="hostUserSelect" name="hostName" value="${hostName}" lay-verify="required" placeholder="请选择"
                               autocomplete="off" class="layui-input">
                        <input type="hidden" name="hostId" value="${article.hostId}">
                    </div>
                </div>
            </c:if>
            <div class="layui-form-item">
                <label class="layui-form-label">收件人</label>
                <%--<input type="text" name="audienceIdsStr">--%>
                <div class="layui-input-inline">
                    <div id="tree1"></div>
                </div>
            </div>
            <div class="layui-form-item">

                <div class="layui-upload">
                    <button type="button" class="layui-btn layui-btn-normal" id="testList">选择多文件</button>
                    <div class="layui-upload-list" style="max-width: 1000px;">
                        <table class="layui-table">
                            <colgroup>
                                <col>
                                <col width="150">
                                <col width="260">
                                <col width="150">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>文件名</th>
                                <th>大小</th>
                                <th>上传进度</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody id="demoList">
                            <c:forEach items="${article.fileNames.split(',')}" var="item">
                                <c:if test="${not empty item}">
                                    <tr>
                                        <td>${item}</td>
                                        <td></td>
                                        <td><div class="layui-progress" ><div class="layui-progress-bar" lay-percent="100%"></div></div></td>
                                        <td> <button class="layui-btn layui-btn-xs layui-btn-danger delete-remote">删除</button> </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <button type="button" class="layui-btn" id="testListAction">开始上传</button>
                </div>


            </div>


            <%--    <div class="layui-form-item">--%>
            <%--        <div class="layui-inline">--%>
            <%--            <label class="layui-form-label">日期选择</label>--%>
            <%--            <div class="layui-input-block">--%>
            <%--                <input type="text" name="date" id="date1" autocomplete="off" class="layui-input">--%>
            <%--            </div>--%>
            <%--        </div>--%>
            <%--        <div class="layui-inline">--%>
            <%--            <label class="layui-form-label">行内表单</label>--%>
            <%--            <div class="layui-input-inline">--%>
            <%--                <input type="text" name="number" autocomplete="off" class="layui-input">--%>
            <%--            </div>--%>
            <%--        </div>--%>
            <%--    </div>--%>

            <div class="layui-form-item" style="display: none">
                <label class="layui-form-label">创建日期</label>
                <div class="layui-input-block">
                    <input type="text" name="createTime" id="date1" autocomplete="off" value="<fmt:formatDate value="${article.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>
" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item layui-form-text">
                <label class="layui-form-label">内容</label>
                <div class="layui-input-block">
                    <textarea id="content" name="content" placeholder="请输入内容" class="layui-textarea">
                        ${article.content}
                    </textarea>
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

        if(!window.fileUrlArray){
            window.fileUrlArray=[];
            if('${article.fileUrls}'){
                window.fileUrlArray='${article.fileUrls}'.split(",");
            }
        }
        if(!window.fileNameArray){
            window.fileNameArray=[];
            if('${article.fileNames}'){
                window.fileNameArray='${article.fileNames}'.split(",");
            }
        }


        $('.delete-remote').on('click', function () {


            let index=$(this).parent().parent().prevAll().length;

            window.fileNameArray.splice(index,1);
            window.fileUrlArray.splice(index,1);


            $(this).parent().parent().remove();


            return false;
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
                    element.render('progress'); //渲染新加的进度条组件
                });
            }
            , done: function (res, index, upload) { //成功的回调


                console.log("upload-index:"+index,"result",res);



                fileUrlArray.push(res.data.src);

                fileNameArray.push(res.data.title);

                var that = this;
                //if(res.code == 0){ //上传成功
                var tr = that.elemList.find('tr#upload-' + index)
                    , tds = tr.children();
                tds.eq(3).html(''); //清空操作
                tds.eq(3).html('<button class="layui-btn layui-btn-xs layui-btn-danger delete-remote">删除</button>'); //

                $('.delete-remote').on('click', function () {
                    let index=$(this).parent().parent().prevAll().length;
                    window.fileNameArray.splice(index,1);
                    window.fileUrlArray.splice(index,1);
                    $(this).parent().parent().remove();
                    return false;
                });


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
            elem: '#date1',
            type:'datetime',
            value:new Date()
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
            if('${article.audienceIdsStr}'){
                let ids='${article.audienceIdsStr}';
                tree.setChecked('userTree', ids.split(","));

            }



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







            data.field.content = layedit.getContent(editIndex);

            if(window.fileUrlArray){
                data.field.fileUrls=window.fileUrlArray.join(",");
            }
            if(window.fileNameArray){
                data.field.fileNames=window.fileNameArray.join(",");
            }




            var checkedItem=tree.getChecked("userTree");

            let checkedUserIds=[];


            console.log("checked items:",checkedItem);





            function getCheckedUser(item){

                if(item.type=='root'){

                    if(item.children&&item.children.length>0){

                        if(item.children&&item.children.length>0){
                            for(let child of item.children){
                                getCheckedUser(child);
                            }
                        }
                    }

                }else if(item.type=='department'){

                    if(item.children&&item.children.length>0){
                        for(let user of item.children){
                            checkedUserIds.push(user.id);
                        }
                    }

                }else if(item.type=='user') {
                    checkedUserIds.push(item.id);
                }

            }

            for(let item of checkedItem){
                getCheckedUser(item);

            }

            data.field.audienceIdsStr=checkedUserIds.join(",");


            // layer.alert(JSON.stringify(data.field), {
            //     title: '最终的提交信息'
            // })


            let loadIndex= window.parent.layer.load(1);

            $.post("/article/save", data.field, function (res) {

                window.parent.layer.close(loadIndex);

                if(res.flag==1){
                    layer.msg(res.message);

                    // window.location.href="/article/view?from=mine&articleId="+res.data.id+"&articleReceiverId="+res.data.id;
                    window.location.href="/article/list?type=4&from=mine";

                }else{
                    layer.alert(res.message);
                }

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
