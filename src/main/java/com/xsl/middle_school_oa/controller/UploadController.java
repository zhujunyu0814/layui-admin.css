package com.xsl.middle_school_oa.controller;

import com.google.common.collect.Maps;
import org.apache.catalina.manager.util.SessionUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
public class UploadController {


    @Value("${file.uploadFolder}")
    private String uploadFolder;



    @PostMapping("/upload")
    @ResponseBody
    public Map<String,Object> uploadFile(@RequestParam("file") MultipartFile file)throws Exception{
        Map<String,Object> returnMap= Maps.newHashMap();
        //获取当前文件的名称
        String originalFilename = file.getOriginalFilename();
        originalFilename = originalFilename.replace(",","");


        originalFilename=originalFilename.substring(originalFilename.lastIndexOf(File.separator)+1);
        String uuid = UUID.randomUUID().toString();

        int i = originalFilename.lastIndexOf(".");
        String subfix=originalFilename.substring(i);
        //
        //String newFileName=uuid+subfix;
       /* if (originalFilename.substring(i)=="txt"){
            String filename=new String("originalFilename".getBytes(StandardCharsets.UTF_8),"iso-8859-1");

        }*/
        Calendar calendar = Calendar.getInstance();
        String year = calendar.get(Calendar.YEAR)+"";
        String month=calendar.get(Calendar.MONTH)+1+"";
        File dir=new File(this.uploadFolder+File.separator+year+File.separator+month);


        String path="/file/"+year+"/"+month+"/"+originalFilename;
        System.out.println(path);

        if(dir.exists()==false){
            dir.mkdirs();
        }
        File newFile=new File(dir,originalFilename);
        file.transferTo(newFile);


        returnMap.put("code",0);
        returnMap.put("message","");

        Map<String,String> data=new HashMap<>();
        data.put("src",path);
        data.put("title",originalFilename);
        returnMap.put("data",data);

        return returnMap;
    }


}
