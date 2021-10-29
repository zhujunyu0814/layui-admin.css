package com.xsl.middle_school_oa.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface CommonMapper {
    @Select("${sql}")
    List<Map<String,Object>> getListBySql(String sql);


    @Select("${sql}")
    int selectCount(String sql);
}
