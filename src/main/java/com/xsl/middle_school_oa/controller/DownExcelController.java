package com.xsl.middle_school_oa.controller;

import com.xsl.middle_school_oa.utils.ExcelUtil;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Controller
@RequestMapping(value = "/report")
public class DownExcelController {

    /**
     * 导出报表
     * @return
     */
    @RequestMapping(value = "/export")
    @ResponseBody
    public void export( HttpServletResponse response) throws Exception {
        //获取数据
        //List<PageData> list = reportService.bookList(page);

        //excel标题
        String[]  title = {"名称","昵称","角色","部门"};

         //excel文件名
        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("utf-8");
        // 这里URLEncoder.encode可以防止中文乱码
        //excel文件名
        String fileName = URLEncoder.encode("人员导入模板", "UTF-8");
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xls");

        //String fileName = "人员导入模板"+".xls";
        //String fileName = "人员导入模板"+".xlsx";
        //sheet名
        String sheetName = "人员导入表";

        //创建HSSFWorkbook
        HSSFWorkbook wb = ExcelUtil.getHSSFWorkbook(sheetName, title, null);

        //响应到客户端
            try {
                //this.setResponseHeader(response, fileName);
                OutputStream os = response.getOutputStream();
                wb.write(os);
                os.flush();
                os.close();
                } catch (Exception e) {
                e.printStackTrace();
                }
            }

}