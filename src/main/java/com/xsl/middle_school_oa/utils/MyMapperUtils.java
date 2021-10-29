package com.xsl.middle_school_oa.utils;

import com.xsl.middle_school_oa.domain.*;
import com.xsl.middle_school_oa.mapper.DepartmentMapper;
import com.xsl.middle_school_oa.mapper.SysRoleMapper;
import com.xsl.middle_school_oa.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class MyMapperUtils {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    private Map<Integer, Department> departmentMap=new HashMap<>();

    private Map<Integer, SysRole> sysRoleMap=new HashMap<>();

    private Map<Integer, SysUser> sysUserMap=new HashMap<>();
    public Department getDepartment(Integer id){
        return this.departmentMap.get(id);
    }

    public SysRole getSysRole(Integer id){
        return this.sysRoleMap.get(id);
    }


    public SysUser getSysUser(Integer id){
        return this.getSysUser(id);
    }


    @PostConstruct
    public void init(){

        DepartmentExample departmentExample=new DepartmentExample();
        List<Department> departments = departmentMapper.selectByExample(departmentExample);

        departments.forEach(department -> {
            departmentMap.put(department.getId(),department);
        });

        SysRoleExample sysRoleExample=new SysRoleExample();
        List<SysRole> sysRoles = sysRoleMapper.selectByExample(sysRoleExample);

        sysRoles.forEach(sysRole -> {
            sysRoleMap.put(sysRole.getId(),sysRole);
        });

        SysUserExample sysUserExample=new SysUserExample();
        List<SysUser> sysUsers = sysUserMapper.selectByExample(sysUserExample);

        sysRoles.forEach(sysRole -> {
            sysRoleMap.put(sysRole.getId(),sysRole);
        });
    }


}
