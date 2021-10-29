package com.xsl.middle_school_oa.utils;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * see https://www.layui.com/doc/modules/table.html#async
 * {
 *   "code": 0,
 *   "msg": "",
 *   "count": 1000,
 *   "data": [{}, {}]
 * }
 *
 */
public class TableResult {

    public static Map<String,Object> buildResult(Integer code,String msg,Integer count,List data){
        Map<String,Object> map=new HashMap<>();
        map.put("code",code);
        map.put("msg",msg);
        map.put("count",count);
        map.put("data",data);
        return map;
    }
}
