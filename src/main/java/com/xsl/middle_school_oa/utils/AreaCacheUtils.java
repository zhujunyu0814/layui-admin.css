package com.xsl.middle_school_oa.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AreaCacheUtils {
    public static final Map<Integer,List<Integer>> map=new HashMap<>();
    public static List<Integer> get(Integer id){
        return map.get(id);
    }
    public static void put(Integer id,List<Integer> list){
        map.put(id,list);
    }
}
