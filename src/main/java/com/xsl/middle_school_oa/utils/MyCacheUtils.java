package com.xsl.middle_school_oa.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * @author
 */
public class MyCacheUtils {
    public static Map<String,Object> map=new HashMap<>();
    public static void put(String key,Object value){
        map.put(key,value);
    }
    public Object get(String key){
        return map.get(key);
    }
}
