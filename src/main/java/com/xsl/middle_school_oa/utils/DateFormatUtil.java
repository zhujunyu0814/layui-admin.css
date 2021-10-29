package com.xsl.middle_school_oa.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatUtil {
    private static DateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
    private static DateFormat timeFormat=new SimpleDateFormat("HH:mm:ss");
    public static String formatDate(Date date){
        if(date==null){
            return "";
        }
        return dateFormat.format(date);
    }
    public static String formatTime(Date date){
        if(date==null){
            return "";
        }
        return timeFormat.format(date);
    }

    public static String dateTimeWithClass(Date date){
        if(date==null){
            return "";
        }
        String dateStr="<div class=\"date\">"+dateFormat.format(date)+"</div>";
        String timeStr="<div class=\"time\">"+timeFormat.format(date)+"</div>";
        return dateStr+timeStr;
    }
}
