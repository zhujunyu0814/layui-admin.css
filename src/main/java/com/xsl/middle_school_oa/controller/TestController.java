package com.xsl.middle_school_oa.controller;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.context.AnalysisContext;
import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.listener.SysUserListener;
import com.xsl.middle_school_oa.mapper.DepartmentMapper;
import com.xsl.middle_school_oa.mapper.SysRoleMapper;
import com.xsl.middle_school_oa.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public class TestController {

    @Autowired
    SysRoleMapper sysRoleMapper;
    @Autowired
    SysUserMapper sysUserMapper;
    @Autowired
    DepartmentMapper departmentMapper;

    /**
     * 导入excel
     * @param file
     * @return
     * @throws Exception
     */
        public Map<String,Object> importExcel(@RequestParam("file")MultipartFile file)throws Exception {

        EasyExcel.read(file.getInputStream(), null, new SysUserListener(sysUserMapper, departmentMapper,sysRoleMapper)).sheet().doRead();

        Map<String, Object> returnMap = Maps.newHashMap();
        returnMap.put("msg", "操作成功");
        return returnMap;

        }

        public void invoke(Object obj, AnalysisContext analysisContext){

        }



}
