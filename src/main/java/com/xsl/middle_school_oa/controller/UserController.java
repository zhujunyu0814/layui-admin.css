package com.xsl.middle_school_oa.controller;

import com.alibaba.excel.EasyExcel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.domain.*;
import com.xsl.middle_school_oa.listener.SysUserListener;
import com.xsl.middle_school_oa.mapper.ArticleReceiverMapper;
import com.xsl.middle_school_oa.mapper.DepartmentMapper;
import com.xsl.middle_school_oa.mapper.SysRoleMapper;
import com.xsl.middle_school_oa.mapper.SysUserMapper;
import com.xsl.middle_school_oa.utils.MyMapperUtils;
import com.xsl.middle_school_oa.utils.TableResult;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private MyMapperUtils mapperUtils;

    @Autowired
    private ArticleReceiverMapper articleReceiverMapper;

    @RequestMapping("/leading")
    public String userLeading(ModelMap map) {

        return "userleading";
    }

    @RequestMapping("/list")
    public String userList(ModelMap map) {

        DepartmentExample departmentExample = new DepartmentExample();
        departmentExample.createCriteria().andIsDeleteEqualTo(1);
        SysRoleExample sysRoleExample = new SysRoleExample();
        SysUserExample sysUserExample=new SysUserExample();
        sysUserExample.createCriteria().andIsDeleteEqualTo(1);

        List<Department> departments = departmentMapper.selectByExample(departmentExample);

        List<SysRole> sysRoles = sysRoleMapper.selectByExample(sysRoleExample);

        List<SysUser> sysUsers=sysUserMapper.selectByExample(sysUserExample);
        System.out.println(sysUsers);
        System.out.println(sysRoles);

        map.put("roleList", sysRoles);
        map.put("departmentList", departments);
        map.put("sysUserList",sysUsers);


        return "userList";

    }

    /**
     *
     */
    @RequestMapping("/doChangePassword")
    @ResponseBody
    public Map<String, Object> doChangePass(String oldPass, String new1, HttpSession session) {
        Map<String, Object> returnMap = Maps.newHashMap();

        SysUser loginUser = (SysUser) session.getAttribute("loginUser");

        SysUser sysUser = sysUserMapper.selectByPrimaryKey(loginUser.getId());

        if (!sysUser.getPassword().equals(oldPass)) {
            returnMap.put("flag", 0);
            returnMap.put("message", "修改失败，原密码错误");
        } else {

            sysUser.setPassword(new1);
            sysUserMapper.updateByPrimaryKey(sysUser);

            returnMap.put("flag", 1);
            returnMap.put("message", "密码修改成功");
        }

        return returnMap;
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "login";
    }

    @RequestMapping("/doLogin")
    @ResponseBody
    public Map<String, Object> doLogin(String loginName, String password, HttpSession session) {
        Map<String, Object> returnMap = Maps.newHashMap();

        SysUserExample sysUserExample = new SysUserExample();
        sysUserExample.createCriteria().andTelEqualTo(loginName).andPasswordEqualTo(password);

        List<SysUser> sysUsers = sysUserMapper.selectByExample(sysUserExample);

        if (sysUsers.size() == 1) {

            SysUser sysUser = sysUsers.get(0);

            session.setAttribute("loginUser", sysUser);

            Integer roleId = sysUser.getRoleId();

            SysRole sysRole = sysRoleMapper.selectByPrimaryKey(roleId);

            session.setAttribute("loginUserRole", sysRole);


            returnMap.put("flag", 1);
            returnMap.put("message", "登录成功");
        } else {
            returnMap.put("flag", 0);
            returnMap.put("message", "用户名或密码错误");
        }


        return returnMap;
    }


    @RequestMapping("/delete")
    @ResponseBody

    //人员管理中的删除
    public Map<String, Object> deleteUser(Integer id) {
        Map<String, Object> returnMap = Maps.newHashMap();

        SysUser sysUser = sysUserMapper.selectByPrimaryKey(id);
        sysUser.setIsDelete(2);
        sysUserMapper.updateByPrimaryKey(sysUser);
        returnMap.put("flag", 1);
        returnMap.put("message", "删除成功");

        return returnMap;
    }


    @RequestMapping("/changePassword")
    private String changePassword() {

        return "changePassword";

    }

    @RequestMapping("/save")
    //人员管理中的导入
    @ResponseBody
    public Map<String, Object> save(SysUser sysUser) {

        sysUser.setIsDelete(1);
        //sysUser.setRoleId(2);
        if (sysUser.getRoleId()==null){
            sysUser.setRoleId(2);
        }
        SysUser sysUser1 = sysUserMapper.selectByName(sysUser.getTel());

        Map<String, Object> returnMap = Maps.newHashMap();
   /*     if (sysUser.getPassword()!=null&&sysUser.getId() == null) {
            sysUserMapper.insert(sysUser);
            returnMap.put("msg", "操作成功");
        }*/

        if (sysUser.getId()==null) {
            if (sysUser1!=null&&sysUser.getTel().equals(sysUser1.getTel())) {
                returnMap.put("msg", "用户已存在");
                return returnMap;
            }else {
                sysUserMapper.insert(sysUser);
                returnMap.put("msg", "操作成功");
                return returnMap;
            }
        }


        if (sysUser.getId()!=null){
            sysUserMapper.updateByPrimaryKey(sysUser);
            returnMap.put("msg", "操作成功");
        }
        return returnMap;

    }



    @RequestMapping("/listData")
    @ResponseBody

    public Map<String,Object> userListData(Integer page,Integer  limit,SysUser user){

        //人员管理中的展示所有数据
        SysUserExample sysUserExample=new SysUserExample();
        SysUserExample.Criteria criteria = sysUserExample.createCriteria().andIsDeleteEqualTo(1);
        if(StringUtils.isNotEmpty(user.getName())){
            criteria.andNameLike("%"+user.getName()+"%");
        }
        if(user.getDeptId()!=null){
            criteria.andDeptIdEqualTo(user.getDeptId());
        }
        if(user.getRoleId()!=null){
            criteria.andRoleIdEqualTo(user.getRoleId());
        }
       /* if(user.getName()!=null){
            //criteria.andRoleIdEqualTo(user.getName());
        }*/

        long count = sysUserMapper.countByExample(sysUserExample);
        if(page==null){
            page=1;
        }
        if(limit==null){
            limit=10;
        }
        sysUserExample.setOffset((page-1)*limit);
        sysUserExample.setLimit(limit);
        sysUserExample.setOrderByClause("id desc");

        List<SysUser> sysUsers = sysUserMapper.selectByExample(sysUserExample);
        List<Map<String,Object>> dataList=new ArrayList<>();

        sysUsers.forEach(sysUser -> {
            Map<String,Object> map=new HashMap<>();
            map.put("name",sysUser.getName());
            map.put("id",sysUser.getId());
            map.put("tel",sysUser.getTel());
            if (sysUser.getDeptId() != null) {
                Department department = mapperUtils.getDepartment(sysUser.getDeptId());
                map.put("departmentName",department.getName());
                map.put("deptId",department.getId());
            }
            if(sysUser.getRoleId()!=null){

                SysRole sysRole=mapperUtils.getSysRole(sysUser.getRoleId());

                map.put("roleName",sysRole.getName());
                map.put("roleId",sysRole.getId());

            }
          /*  if(sysUser.getId()!=null){
                SysUser sysUsername= mapperUtils.getSysUser(sysUser.getId());

                map.put("userName",sysUsername.getName());
                map.put("nameId",sysUser.getId());

            }*/
            dataList.add(map);

        });

        return TableResult.buildResult(0,"ok",(int)count,dataList);

    }


    @RequestMapping("/userSelect")
    public String userSelect(){
        return "userSelect";
    }

    @RequestMapping("/userTreeData")
    @ResponseBody
    public Map<String,Object> userTreeData(){
        Map<String,Object> returnMap=Maps.newHashMap();

        DepartmentExample departmentExample=new DepartmentExample();

        departmentExample.createCriteria().andIsDeleteEqualTo(1);

        List<Department> departmentList = departmentMapper.selectByExample(departmentExample);

        SysUserExample sysUserExample=new SysUserExample();

        sysUserExample.createCriteria().andIsDeleteEqualTo(1).andDeptIdIsNotNull();

        List<SysUser> sysUsers = sysUserMapper.selectByExample(sysUserExample);

        List<Map<String,Object>> dataList= Lists.newArrayList();
        departmentList.forEach(d->{
            Map<String,Object> map=new HashMap<>();
            map.put("id","dept_"+d.getId());
            map.put("title",d.getName());
            map.put("type","department");
            List<Map<String,Object>> userList=Lists.newArrayList();
            sysUsers.forEach(u->{
                if(u.getDeptId().equals(d.getId())){
                    Map<String,Object> userMap=new HashMap<>();
                    userMap.put("id",u.getId());
                    userMap.put("title",u.getName());
                    userMap.put("type","user");
                    userList.add(userMap);
                }
            });
            map.put("children",userList);
            dataList.add(map);
        });
        Map<String,Object> m=new HashMap<>();
        m.put("id","root_0");
        m.put("title","全部");
        m.put("type","root");
        m.put("children",dataList);
        m.put("spread",true);
        final ArrayList<Object> treeList = new ArrayList<>();
        treeList.add(m);
        returnMap.put("data",treeList);
        return returnMap; 
    }




    @RequestMapping("/importExcel")
    //人员管理中的导入
    @ResponseBody
    public Map<String, Object> importExcel(@RequestParam("file") MultipartFile file)throws Exception{

        EasyExcel.read(file.getInputStream(),null,new SysUserListener(sysUserMapper,departmentMapper,sysRoleMapper)).sheet().doRead();

        Map<String,Object> returnMap= Maps.newHashMap();
        returnMap.put("msg","操作成功");
        return returnMap;
    }
}
