package com.xsl.middle_school_oa.utils;

import java.util.HashMap;
import java.util.Map;

public class MyJsonResult {
    public static Map<String,Object> buildResult(int code,String msg,Object data){
        Map map=new HashMap();
        map.put("code",code);
        map.put("msg",msg);
        map.put("data",data);
        return map;
    }


    public static Map<String,Object> buildSuccessResult(String msg,Object data){
        Map map=new HashMap();
        map.put("code",0);
        map.put("msg",msg);
        map.put("data",data);
        return map;
    }

    public static Map<String,Object> buildFailResult(String msg){
        Map map=new HashMap();
        map.put("code",1);
        map.put("msg",msg);
        return map;
    }
}
