package com.xsl.middle_school_oa.excelModel;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.mybatis.logging.Logger;
import org.mybatis.logging.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class FileExport {
    private static final Logger logger = LoggerFactory.getLogger(FileExport.class);

    /** CSV文件列分隔符 */
    private static final String CSV_COLUMN_SEPARATOR = ",";

    private static final String CSV_COLUM_TABLE = "\t";

    /** CSV文件列分隔符 */
    private static final String CSV_RN = "\r\n";

    /**
     * 导出Excel文件
     *  @param excelHeader
     *            导出文件中表格头
     * @param sheetName
     * @param response
 *            HttpServletResponse对象，用来获得输出流向客户端写导出的文件
     */
    public static void exportExcel(String[] excelHeader, String sheetName, HttpServletResponse response, HttpServletRequest request) {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet(sheetName);
        HSSFRow row = sheet.createRow((int) 0);
        /******设置单元格是否显示网格线******/
        sheet.setDisplayGridlines(false);

        /******设置头单元格样式******/
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        Font fontHeader = wb.createFont();
        fontHeader.setBold(true);
        fontHeader.setFontHeight((short) 240);
        style.setFont(fontHeader);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);

        /******设置头内容******/
        for (int i = 0; i < excelHeader.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellValue("  " +excelHeader[i] + "  ");
            cell.setCellStyle(style);
        }

        /******设置内容单元格样式******/
       /* HSSFCellStyle styleCell = wb.createCellStyle();
        Font fontCell = wb.createFont();
      //  fontCell.setColor(HSSFColor.BLACK.index);
        styleCell.setAlignment(HorizontalAlignment.CENTER);
        styleCell.setFont(fontCell);
        styleCell.setBorderBottom(BorderStyle.THIN);
        styleCell.setBorderLeft(BorderStyle.THIN);
        styleCell.setBorderRight(BorderStyle.THIN);
        styleCell.setBorderTop(BorderStyle.THIN);*/
        /******设置单元格内容******/
       /* for (int i = 0; i < list.size(); i++) {
            row = sheet.createRow(i + 1);
            *//******设置行高******//*
            row.setHeightInPoints(20);
            Object[] obj = (Object[]) list.get(i);
            for (int j = 0; j < excelHeader.length; j++) {
                styleCell.setWrapText(false);
                HSSFCell cell = row.createCell(j);
                if (obj[j] != null){
                    cell.setCellValue(obj[j].toString());
                }else{
                    cell.setCellValue("");
                }
                //if(obj[j].toString().length()>20)
                //	styleCell.setWrapText(true);
                cell.setCellStyle(styleCell);
                sheet.autoSizeColumn(j);
            }
        }*/

        OutputStream ouputStream = null;
        try {

            String encoding = "UTF-8";
            /** 获取浏览器相关的信息 */
            String userAgent = request.getHeader("user-agent");
            /** 判断是否为msie浏览器 */
            if (userAgent.toLowerCase().indexOf("msie") != -1){
                encoding = "gbk";
            }

            response.setCharacterEncoding(encoding);
            response.setContentType("application/vnd.ms-excel");
            String fileName = sheetName;
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-HHMMSS");
            fileName += (dateFormat.format(new Date())).toString()+".xls";
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode(fileName, encoding));
            ouputStream = response.getOutputStream();
            wb.write(ouputStream);
            ouputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(ouputStream!=null) {
                    ouputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

