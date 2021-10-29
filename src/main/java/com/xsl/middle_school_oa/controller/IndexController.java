package com.xsl.middle_school_oa.controller;

import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.domain.ArticleReceiverExample;
import com.xsl.middle_school_oa.domain.SysUser;
import com.xsl.middle_school_oa.mapper.ArticleReceiverMapper;
import com.xsl.middle_school_oa.mapper.CommonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class IndexController {

    @Autowired
    private CommonMapper commonMapper;


    @RequestMapping("/index")
    public String index(){
        return "index";
    }

    @RequestMapping("/nav")
    public String nav(HttpSession session, ModelMap map){
        SysUser sysUser=(SysUser) session.getAttribute("loginUser");

        ArticleReceiverExample example=new ArticleReceiverExample();
        example.createCriteria().andUserIdEqualTo(sysUser.getId()).andReadStatusEqualTo(1);

        List<Map<String,Object>> dataList=commonMapper.getListBySql("select count(*) total,article_type_id type from article_receiver where read_status=1 and user_id="+sysUser.getId()+" GROUP BY article_type_id");

        Map<String,Object> countMap= Maps.newHashMap();

        countMap.put("t1",0);
        countMap.put("t2",0);
        countMap.put("t3",0);
        countMap.put("t4",0);

        dataList.forEach(m->{
            countMap.put("t"+(Integer)m.get("type"),(Long) m.get("total"));

        });




        map.put("countMap",countMap);



        return "nav";
    }



}
