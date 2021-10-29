<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/layui-v2.6.8/layui/css/layui.css">
    <link rel="stylesheet" href="/css/login.css">
    <link rel="icon" href="/favicon.ico">
    <title>管理后台</title>
</head>
<body class="login-wrap bgimg">
	<div class='login-left'>
		<p class="left-1">欢迎登录</p>
		<p class="login-line"></p>
		<h1 class="left-2">海州实验中学<br></br>办公平台</h1>
	</div>
    <div class="login-container">
    	<h1 class="rig-1">我要登录</h1>
        <form class="login-form">
            <div class="input-group">
                <input type="text" id="loginName" class="input-field" placeholder="输入用户名">
            </div>
            <div class="input-group"> 
                <input type="password" id="password" class="input-field" placeholder="输入登录密码">
            </div>
            <button type="button" class="login-button" id="btnLogin">登录</button>
        </form>
        <div class="rig-2">
        	<input type="checkbox" id="rememberUser"/>
        	<p>记住登录密码</p>
<%--        	<a href="javascript:openLayerWindowWH('申请试用','/manage/shenqingshiyong.do','30%', '60%');" style="margin-left: 215px;">申请试用</a>--%>
        </div>
    </div>
     <div class="bot">技术支持：连云港华舜网络科技有限公司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 客服电话：18961346896</div> 
</body>
<script src="/layui-v2.6.8/layui/layui.js"></script>

<script type="text/javascript">

    layui.use([],function(){
        var $=layui.$;

        if(top!= self){
            top.location.href=self.location.href;
        }

        $("#btnLogin").click(function(){

            var loginName=$("#loginName").val();
            var password=$("#password").val();

            if(loginName==''){
                layer.msg('请输入用户名！', {icon: 2});
                return;
            }
            if(password==''){
                layer.msg('请输入密码！', {icon: 2});
                return;
            }
            layer.msg('正在登陆...', {icon: 16,shade: 0.5,time: 20000});
            $.ajax({
                url:'/user/doLogin',
                type:'post',
                data:{loginName:loginName,password:password},
                dataType:'json',
                success: function (data) {
                    if (data.flag=='1'){

                        layer.msg(data.message, {icon: 1});
                        var url=document.location+'';
                        setTimeout("location.href='/index?target=notice'",1000);

                    }else{
                        layer.msg(data.message, {icon: 5});
                    }
                },
                error: function(){

                }
            });



        });


    });


</script>
</html>