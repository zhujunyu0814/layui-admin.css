package com.xsl.middle_school_oa.controller;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.xsl.middle_school_oa.domain.*;
import com.xsl.middle_school_oa.mapper.*;
import com.xsl.middle_school_oa.utils.TableResult;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/article")
public class ArticleController {


    @SuppressWarnings("all")
    @Autowired
    private ArticleMapper articleMapper;

    @SuppressWarnings("all")
    @Autowired
    private DepartmentMapper departmentMapper;


    public void putCommonCode(ModelMap map, Integer type) {

        switch (type) {

            case 1: {
                map.put("title", "新建公告");
                map.put("typeName", "公告");
                break;
            }
            case 2: {
                map.put("title", "新建批办");
                map.put("typeName", "批办");
                break;
            }
            case 3: {
                map.put("title", "新建公文");
                map.put("typeName", "公文");
                break;
            }
            case 4: {
                map.put("title", "新建通知");
                map.put("typeName", "通知");
                break;
            }

        }

    }

    @RequestMapping("/list")
    public String articleList(Integer type, ModelMap map, Integer readStatus, String from) {

        putCommonCode(map, type);

        map.put("from", from);
        map.put("readStatus", readStatus);
        return "articleList";
    }

    @RequestMapping("/listData")
    @ResponseBody
    public Map<String, Object> userListData(String dateSpan,Integer readStatus,String title,Integer type, Integer page, Integer limit, HttpSession session, String from) throws ParseException {

        SysUser loginUser = (SysUser) session.getAttribute("loginUser");
        session.getId();
        String userId=session.getId();

        if (page == null) {
            page = 1;
        }
        if (limit == null) {
            limit = 20;
        }
        if (!"mine".equals(from)) {
            //查看通知列表。
            ArticleReceiverExample articleReceiverExample = new ArticleReceiverExample();
            ArticleReceiverExample.Criteria criteria = articleReceiverExample.createCriteria();
            //这里的type是接受的什么数据
            if (type != null) {
                criteria.andArticleTypeIdEqualTo(type);
            }else
                criteria.andArticleTypeIdEqualTo(type);

            if(StringUtils.isNotBlank(title)){
                criteria.andArticleTitleLike("%"+title+"%");
            }/*else
                criteria.andArticleTitleLike("%"+title+"%");*/

            if(readStatus!=null){
                criteria.andReadStatusEqualTo(readStatus);
            }

            if(StringUtils.isNotBlank(dateSpan)){

                DateFormat df=new SimpleDateFormat("yyyy-MM-dd");

                String begin=dateSpan.substring(0,10);
                String end=dateSpan.substring(13,23);

                criteria.andCreateTimeGreaterThanOrEqualTo(df.parse(begin));
                criteria.andCreateTimeLessThanOrEqualTo(df.parse(end));


            }

            criteria.andUserIdEqualTo(loginUser.getId());

            articleReceiverExample.setOffset((page - 1) * limit);
            articleReceiverExample.setLimit(limit);
            articleReceiverExample.setOrderByClause("create_time desc");

            List<ArticleReceiver> articleReceiverList = articleReceiverMapper.selectByExample(articleReceiverExample);
            List<Map<String, Object>> dataList = Lists.newArrayList();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

            articleReceiverList.forEach(articleReceiver -> {
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", articleReceiver.getId());
                map.put("articleId", articleReceiver.getArticleId());
                map.put("id", articleReceiver.getId());
                map.put("title", articleReceiver.getArticleTitle());


                map.put("articleTypeId", articleReceiver.getArticleTypeId());

                if (articleReceiver.getCreateTime() != null) {
                    map.put("createTime", dateFormat.format(articleReceiver.getCreateTime()));
                } else {
                    map.put("createTime", "");

                }
                map.put("author", articleReceiver.getArticleAuthor());
                map.put("status", articleReceiver.getReadStatus());


                int hasRead = commonMapper.selectCount("select count(*) from article_receiver where read_status=2 and article_id=" + articleReceiver.getArticleId());
                int notRead = commonMapper.selectCount("select count(*) from article_receiver where read_status=1 and article_id=" +articleReceiver.getArticleId());


                map.put("readCount", "" + hasRead + "/" + (hasRead + notRead));
                if((hasRead+notRead)!=0){
                    BigDecimal b=new BigDecimal(hasRead*100.0/(hasRead+notRead));
                    map.put("readRatio", b.setScale(2,   BigDecimal.ROUND_HALF_UP).doubleValue()+"%");

                }else{
                    map.put("readRatio", "0%");
                }


                dataList.add(map);
            });


            long count = articleReceiverMapper.countByExample(articleReceiverExample);
            return TableResult.buildResult(0, "ok", (int) count, dataList);


        } else {



            ArticleExample articleExample = new ArticleExample();

            ArticleExample.Criteria criteria = articleExample.createCriteria().andArticleTypeIdEqualTo(type).andCreateUserIdEqualTo(loginUser.getId())
                    .andIsDeleteEqualTo(1);

            if(StringUtils.isNotBlank(title)){
                criteria.andTitleLike("%"+title+"%");
            }

            DateFormat df=new SimpleDateFormat("yyyy-MM-dd");

            if(StringUtils.isNotBlank(dateSpan)){


                String begin=dateSpan.substring(0,10);
                String end=dateSpan.substring(13,23);

                criteria.andCreateTimeGreaterThanOrEqualTo(df.parse(begin));
                criteria.andCreateTimeLessThanOrEqualTo(df.parse(end));

            }



            articleExample.setOffset((page - 1) * limit);
            articleExample.setLimit(limit);


            articleExample.setOrderByClause("create_time desc");
            List<Article> articleList = articleMapper.selectByExample(articleExample);
            List<Map<String, Object>> dataList = Lists.newArrayList();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

            articleList.forEach(article -> {
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", article.getId());
                map.put("articleId", article.getId());
                map.put("title", article.getTitle());

                map.put("confirmStatus",article.getConfirmStatus());

                if (article.getCreateTime() != null) {
                    map.put("createTime", dateFormat.format(article.getCreateTime()));
                } else {
                    map.put("createTime", "");

                }
                map.put("author", article.getCreateUserName());

                int hasRead = commonMapper.selectCount("select count(*) from article_receiver where read_status=2 and article_id=" + article.getId());
                int notRead = commonMapper.selectCount("select count(*) from article_receiver where read_status=1 and article_id=" + article.getId());


                map.put("readCount", "" + hasRead + "/" + (hasRead + notRead));



                if((hasRead+notRead)!=0){
                    BigDecimal b=new BigDecimal(hasRead*100.0/(hasRead+notRead));
                    map.put("readRatio", b.setScale(2,   BigDecimal.ROUND_HALF_UP).doubleValue()+"%");

                }else{
                    map.put("readRatio", "0%");
                }
                map.put("status", "");
                dataList.add(map);

            });
            long count = articleMapper.countByExample(articleExample);
            return TableResult.buildResult(0, "ok", (int) count, dataList);


        }


    }


    @Autowired
    private CommonMapper commonMapper;

    @RequestMapping("/new")
    public String newArticle() {

        return "newArticle";
    }


    @RequestMapping("/edit")
    public String articleEdit(Integer type, ModelMap map, Integer id) {
        if (id != null) {
            //编辑
            Article article = articleMapper.selectByPrimaryKey(id);
            type = article.getArticleTypeId();
            if (article.getHostId() != null) {
                SysUser hostUser = sysUserMapper.selectByPrimaryKey(article.getHostId());
                map.put("hostName", hostUser.getName());
            }
            map.put("article", article);
        }
        putCommonCode(map, type);
        map.put("type", type);
        return "articleEdit";
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteArticle(Integer id) {

        Article article = articleMapper.selectByPrimaryKey(id);
        article.setIsDelete(2);
        articleMapper.updateByPrimaryKey(article);

        ArticleReceiverExample articleReceiverExample=new ArticleReceiverExample();
        articleReceiverExample.createCriteria().andArticleIdEqualTo(id);
        articleReceiverMapper.deleteByExample(articleReceiverExample);

        Map<String, Object> returnMap = Maps.newHashMap();

        returnMap.put("flag", 1);
        returnMap.put("message", "操作成功");

        return returnMap;


    }

    @RequestMapping("/confirm")
    @ResponseBody
    public Map<String, Object> confirmArticle(Integer id) {

        Article article = articleMapper.selectByPrimaryKey(id);
        article.setConfirmStatus(2);
        //确认后，发送到每个人
        articleMapper.updateByPrimaryKey(article);



        if (article.getHostId()!=null) {

            ArticleReceiver articleReceiver = new ArticleReceiver();
            articleReceiver.setArticleId(article.getId());
            articleReceiver.setArticleTypeId(articleReceiver.getArticleTypeId());
            articleReceiver.setUserId(article.getHostId());
            articleReceiver.setCreateTime(new Date());
            SysUser sysUser = sysUserMapper.selectByPrimaryKey(article.getHostId());
            articleReceiver.setUserName(sysUser.getName());
            articleReceiver.setReadCount(0);
            articleReceiver.setReadStatus(1);
            articleReceiver.setArticleTypeId(article.getArticleTypeId());
            articleReceiver.setArticleTitle(article.getTitle());
            articleReceiver.setArticleAuthor(article.getCreateUserName());
            //
            articleReceiver.setType((short) 1);

            articleReceiverMapper.insert(articleReceiver);
        }
        if (StringUtils.isNotEmpty(article.getAudienceIdsStr())) {

            String[] split = article.getAudienceIdsStr().split(",");
            for (String idStr : split) {
                int userId = Integer.valueOf(idStr);

                ArticleReceiver articleReceiver = new ArticleReceiver();
                articleReceiver.setArticleId(article.getId());
                articleReceiver.setArticleTypeId(articleReceiver.getArticleTypeId());
                articleReceiver.setUserId(userId);
                articleReceiver.setCreateTime(new Date());
                SysUser sysUser = sysUserMapper.selectByPrimaryKey(userId);
                articleReceiver.setUserName(sysUser.getName());
                articleReceiver.setReadCount(0);
                articleReceiver.setReadStatus(1);

                articleReceiver.setType((short) 2);

                articleReceiver.setArticleTypeId(article.getArticleTypeId());

                articleReceiver.setArticleTitle(article.getTitle());
                articleReceiver.setArticleAuthor(article.getCreateUserName());

                articleReceiverMapper.insert(articleReceiver);

            }

        }


        Map<String, Object> returnMap = Maps.newHashMap();

        returnMap.put("flag", 1);
        returnMap.put("message", "操作成功");

        return returnMap;


    }

    @Autowired
    private SysUserMapper sysUserMapper;


    @RequestMapping("/view")
    //from判断是所有通知还是我的发布 ， 操作（查看，编辑，删除）当前选择的人的id ，
    public String articleView(String from, Integer articleId, Integer articleReceiverId, ModelMap modelMap) {

        Assert.notNull(articleId, "articleId must not be null");
        Assert.notNull(articleId, "articleReceiverId must not be null");


        SysUserExample userExample=new SysUserExample();
        userExample.createCriteria().andIsDeleteEqualTo(1);


        //当前用户发的文件
        Article article = articleMapper.selectByPrimaryKey(articleId);
        article.setConfirmStatus(2);
        //
        articleMapper.updateByPrimaryKey(article);
        //根据当前用户的用户id查用户表中的当前用户的数据
        //SysUser createUser=sysUserMapper.selectByPrimaryKey(article.getCreateUserId());
        modelMap.put("article", article);
        if ((!"mine".equals(from))) {
            //从待办事项里

            //更新已读状态   查询当前用户发送了给那些人
            ArticleReceiver articleReceiver = articleReceiverMapper.selectByPrimaryKey(articleReceiverId);
            //设为已读
            articleReceiver.setReadStatus(2);
            articleReceiver.setReadTime(new Date());
            articleReceiverMapper.updateByPrimaryKey(articleReceiver);
            //获取所有读者列表，已读状态。
            modelMap.put("articleReceiver", articleReceiver);
            //获取接受者列表。
            ArticleReceiverExample articleReceiverExample = new ArticleReceiverExample();
            articleReceiverExample.createCriteria().andArticleIdEqualTo(articleId);

           // articleReceiverExample.setOrderByClause("dept_id asc");
            articleReceiverExample.setOrderByClause("dept_id asc,user_id asc");

           // articleReceiverExample.setOrderByClause("dept_id asc");

            //articleReceiverExample.setOrderByClause("user_id asc");
            List<ArticleReceiver> articleReceiverList = articleReceiverMapper.selectByExample(articleReceiverExample);

            List<ArticleReceiver> articleReceiverList11=new ArrayList<>();
          //  List<ArticleReceiver> articleReceiverList22=new ArrayList<>();

            long begin=System.currentTimeMillis();

            articleReceiverList.forEach(articleReceiver1 -> {
                if (articleReceiver1.getType() == 1) {
                    modelMap.put("host", articleReceiver1);
                }

                articleReceiverList11.add(articleReceiver1);

            });
           // articleReceiverList11.addAll(articleReceiverList22);

            modelMap.put("articleReceiverList", articleReceiverList11);

            System.out.println((System.currentTimeMillis()-begin)/1000);

        } else {
            //不是从待办事项。是从我发起的里面
            //这个时候还没真实发送，所以接受者列表得查询出来。

            if(article.getConfirmStatus()==2){
                //已经确认的，显示真实的已读未读数据
                //获取接受者列表。
                ArticleReceiverExample articleReceiverExample = new ArticleReceiverExample();
                articleReceiverExample.createCriteria().andArticleIdEqualTo(articleId);
               // articleReceiverExample.setOrderByClause("user_id asc");
               // articleReceiverExample.setOrderByClause("dept_id asc");
                articleReceiverExample.setOrderByClause("dept_id asc,user_id asc");
                //articleReceiverExample.setOrderByClause("dept_id asc");
                List<ArticleReceiver> articleReceiverList = articleReceiverMapper.selectByExample(articleReceiverExample);


                List<ArticleReceiver> articleReceiverList1=new ArrayList<>();
                //List<ArticleReceiver> articleReceiverList2=new ArrayList<>();

                articleReceiverList.forEach(articleReceiver1 -> {
                    if (articleReceiver1.getType() == 1) {
                        modelMap.put("host", articleReceiver1);
                    }
                    System.out.println(articleReceiver1.getUserName());

                    articleReceiverList1.add(articleReceiver1);

                });


                modelMap.put("articleReceiverList", articleReceiverList1);

            }else{
                // 已读未读数据填充为0
                Integer hostId = article.getHostId();
                if (hostId != null) {
                    SysUser sysUser = sysUserMapper.selectByPrimaryKey(hostId);
                    Map<String, Object> hostMap = new HashMap<>();
                    hostMap.put("userName", sysUser.getName());
                    hostMap.put("readStatus", "1");
                    modelMap.put("host", hostMap);
                }
                String audienceIdsStr = article.getAudienceIdsStr();
                if (StringUtils.isNoneBlank(audienceIdsStr)) {
                    SysUserExample sysUserExample = new SysUserExample();
                    String[] split = audienceIdsStr.split(",");
                    List<Integer> ids = Lists.newArrayList();
                    for (String s : split) {
                        if (StringUtils.isNotEmpty(s)) {
                            ids.add(Integer.valueOf(s));
                        }
                    }
                    sysUserExample.createCriteria().andIdIn(ids);
                    List<SysUser> sysUsers = sysUserMapper.selectByExample(sysUserExample);
                    List<Map<String, Object>> articleReceiverList = Lists.newArrayList();

                    sysUsers.forEach(u -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("userName", u.getName());
                        map.put("readStatus", 1);
                        articleReceiverList.add(map);
                    });
                    modelMap.put("articleReceiverList", articleReceiverList);

                }
            }
        }
        List<Map<String, String>> fileList = Lists.newArrayList();
        String fileUrls = article.getFileUrls();
        String fileNames = article.getFileNames();
        if (StringUtils.isNoneBlank(fileUrls)) {
            String[] splitUrl = fileUrls.split(",");
            String[] splitFileName = fileNames.split(",");
            for (int i = 0; i < splitUrl.length; i++) {
                String url = splitUrl[i];
                String fileName = splitFileName[i];
                Map<String, String> fileMap = new HashMap<>();
                fileMap.put("url", url);
                fileMap.put("fileName", fileName);

                fileList.add(fileMap);
            }

        }
        modelMap.put("fileList", fileList);

        return "articleView";

    }
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }


    @PostMapping("/save")
    @ResponseBody
    public Map<String, Object> articleSave(HttpSession session, Integer articleTypeId, Article article) {

        Map<String, Object> returnMap = Maps.newHashMap();


        try {

            SysUser loginUser = (SysUser) session.getAttribute("loginUser");


            if (article.getId() == null) {
                article.setCreateTime(new Date());
                article.setUpdateTime(new Date());
                article.setViewCount(0);
                article.setCreateUserName(loginUser.getName());
                article.setCreateUserId(loginUser.getId());
                article.setConfirmStatus(2);
                article.setIsDelete(1);

                returnMap.put("flag", 1);
                returnMap.put("message", "保存成功");
                articleMapper.insert(article);

            } else {

                Article oldArticle = articleMapper.selectByPrimaryKey(article.getId());
                article.setCreateTime(oldArticle.getCreateTime());
                article.setUpdateTime(new Date());
                article.setViewCount(0);
                article.setCreateUserName(loginUser.getName());
                article.setCreateUserId(loginUser.getId());
                article.setConfirmStatus(2);
                article.setIsDelete(1);

                returnMap.put("flag", 1);
                returnMap.put("message", "更新成功");
                articleMapper.updateByPrimaryKey(article);


                //将articleReveiver删除，重新添加。因为这个时候可能选了新的人。

                ArticleReceiverExample articleReceiverExample=new ArticleReceiverExample();

                articleReceiverExample.createCriteria().andArticleIdEqualTo(article.getId());

                articleReceiverMapper.deleteByExample(articleReceiverExample);


            }



            if (article.getHostId()!=null) {

                ArticleReceiver articleReceiver = new ArticleReceiver();
                articleReceiver.setArticleId(article.getId());
                articleReceiver.setArticleTypeId(articleReceiver.getArticleTypeId());
                articleReceiver.setUserId(article.getHostId());
                articleReceiver.setCreateTime(new Date());

                SysUser sysUser = sysUserMapper.selectByPrimaryKey(article.getHostId());

                articleReceiver.setUserName(sysUser.getName());
                articleReceiver.setReadCount(0);
                articleReceiver.setReadStatus(1);
                articleReceiver.setArticleTypeId(article.getArticleTypeId());
                articleReceiver.setArticleTitle(article.getTitle());
                articleReceiver.setArticleAuthor(article.getCreateUserName());



                //
                articleReceiver.setType((short) 1);

                articleReceiverMapper.insert(articleReceiver);

            }

            if (StringUtils.isNotEmpty(article.getAudienceIdsStr())) {

                String[] split = article.getAudienceIdsStr().split(",");

                Arrays.stream(split).parallel().forEach(idStr->{

                    int userId = Integer.valueOf(idStr);

                    ArticleReceiver articleReceiver = new ArticleReceiver();
                    articleReceiver.setArticleId(article.getId());
                    articleReceiver.setArticleTypeId(articleReceiver.getArticleTypeId());
                    articleReceiver.setUserId(userId);
                    articleReceiver.setCreateTime(new Date());
                    SysUser sysUser = sysUserMapper.selectByPrimaryKey(userId);
                    articleReceiver.setUserName(sysUser.getName());
                    articleReceiver.setReadCount(0);
                    articleReceiver.setReadStatus(1);

                    articleReceiver.setType((short) 2);

                    articleReceiver.setArticleTypeId(article.getArticleTypeId());

                    articleReceiver.setArticleTitle(article.getTitle());
                    articleReceiver.setArticleAuthor(article.getCreateUserName());

                    articleReceiver.setDeptId(sysUser.getDeptId());


                    articleReceiverMapper.insert(articleReceiver);
                });

//                for (String idStr : split) {
//                    int userId = Integer.valueOf(idStr);
//
//                    ArticleReceiver articleReceiver = new ArticleReceiver();
//                    articleReceiver.setArticleId(article.getId());
//                    articleReceiver.setArticleTypeId(articleReceiver.getArticleTypeId());
//                    articleReceiver.setUserId(userId);
//                    articleReceiver.setCreateTime(new Date());
//                    SysUser sysUser = sysUserMapper.selectByPrimaryKey(userId);
//                    articleReceiver.setUserName(sysUser.getName());
//                    articleReceiver.setReadCount(0);
//                    articleReceiver.setReadStatus(1);
//
//                    articleReceiver.setType((short) 2);
//
//                    articleReceiver.setArticleTypeId(article.getArticleTypeId());
//
//                    articleReceiver.setArticleTitle(article.getTitle());
//                    articleReceiver.setArticleAuthor(article.getCreateUserName());
//
//                    articleReceiverMapper.insert(articleReceiver);
//
//                }


            }






            returnMap.put("data", article);


        } catch (Exception e) {

            e.printStackTrace();
            returnMap.put("flag", 0);
            returnMap.put("message", "操作失败，请联系管理员");
        }


        return returnMap;

    }

    @Autowired
    private ArticleReceiverMapper articleReceiverMapper;




}
