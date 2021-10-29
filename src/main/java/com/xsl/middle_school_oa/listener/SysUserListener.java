package com.xsl.middle_school_oa.listener;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.fastjson.JSON;
import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.domain.*;
import com.xsl.middle_school_oa.mapper.DepartmentMapper;
import com.xsl.middle_school_oa.mapper.SysRoleMapper;
import com.xsl.middle_school_oa.mapper.SysUserMapper;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

public class SysUserListener extends AnalysisEventListener {

    private SysUserMapper sysUserMapper;
    private DepartmentMapper departmentMapper;
    private SysRoleMapper sysRoleMapper;

    public SysUserListener(SysUserMapper sysUserMapper,DepartmentMapper departmentMapper,SysRoleMapper sysRoleMapper){
        this.sysUserMapper=sysUserMapper;
        this.departmentMapper=departmentMapper;
        this.sysRoleMapper=sysRoleMapper;
    }


    @Override
    public void invoke(Object obj, AnalysisContext analysisContext) {
        System.out.println("-----------------------"+JSON.toJSONString(obj));
        //sysUserMapper.insert(sysUser);
        SysUser sysUser=new SysUser();
        Map userMap= (Map) obj;
        System.out.println(userMap.toString());
        //根据字段获取姓名 name
        sysUser.setName(userMap.get(0).toString());
        //获取账号 tel
        sysUser.setTel(userMap.get(1).toString());

        //默认密码123123
        sysUser.setPassword("123123");
        //获取部门名称
        String deptName=userMap.get(2).toString();
        //因为数据库的表角色 存放的是1 、2
        DepartmentExample departmentExample=new DepartmentExample();
        //
        departmentExample.createCriteria().andNameEqualTo(deptName);
        departmentExample.createCriteria().andIsDeleteEqualTo(1);
        List<Department> departments=departmentMapper.selectByExample(departmentExample);
        if(departments.size()>0){
            sysUser.setDeptId(departments.get(0).getId());
        }
        //获取角色
        String roleName=userMap.get(3).toString();
        SysRoleExample sysRoleExample=new SysRoleExample();
        sysRoleExample.createCriteria().andNameEqualTo(roleName);

        List<SysRole> sysRoleList=sysRoleMapper.selectByExample(sysRoleExample);
        if(sysRoleList.size()>0){
            sysUser.setRoleId(sysRoleList.get(0).getId());
        }
        sysUser.setIsDelete(1);
        String Tel=userMap.get(1).toString();
        SysUser sysUser1 = sysUserMapper.selectByName(userMap.get(1).toString());
       // System.out.println(sysUser1.getTel()+"#######################");

        if (sysUser.getId()==null) {
            if (sysUser1!=null&&Tel.equals(sysUser1.getTel())) {
                sysUserMapper.updateByPrimaryKeys(sysUser);
            }else {
                sysUserMapper.insert(sysUser);
            }
        }


    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        System.out.println("#################################******");
    }


}
