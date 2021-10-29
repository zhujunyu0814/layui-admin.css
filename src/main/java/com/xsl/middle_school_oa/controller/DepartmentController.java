package com.xsl.middle_school_oa.controller;

import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.domain.*;
import com.xsl.middle_school_oa.mapper.DepartmentMapper;
import com.xsl.middle_school_oa.utils.TableResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author iamxy
 */
@Controller
@RequestMapping("/department")
public class DepartmentController {

    @Autowired
    private DepartmentMapper departmentMapper;


    @RequestMapping("/save")
    @ResponseBody
    public Map<String,Object> save(Department department){
        Map<String,Object> returnMap= Maps.newHashMap();

        department.setIsDelete(1);
        if(department.getId()!=null){
            departmentMapper.updateByPrimaryKey(department);
        }else{
            departmentMapper.insert(department);
        }

        returnMap.put("flag",1);
        returnMap.put("message","操作成功");

        return returnMap;
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Map<String,Object> delete(Integer id){
        Department department = departmentMapper.selectByPrimaryKey(id);
        department.setIsDelete(2);
        departmentMapper.updateByPrimaryKey(department);
        Map<String,Object> returnMap=Maps.newHashMap();
        returnMap.put("flag",1);
        returnMap.put("message","删除成功");
        return returnMap;

    }

    @RequestMapping("/list")
    public String departmentList(){
        return "departmentList";
    }


    @RequestMapping("/listData")
    @ResponseBody
    public Map<String,Object> departmentListData(Integer page,Integer limit){

        if(page==null){
            page=1;
        }
        if(limit==null){
            limit=20;
        }


        DepartmentExample departmentExample=new DepartmentExample();

        departmentExample.createCriteria().andIsDeleteEqualTo(1);
        departmentExample.setOffset((page-1)*limit);
        departmentExample.setLimit(limit);
        departmentExample.setOrderByClause("id desc");
        long count = departmentMapper.countByExample(departmentExample);
        List<Department> departmentList=departmentMapper.selectByExample(departmentExample);

        return TableResult.buildResult(0,"ok",(int)count,departmentList);

    }






}
