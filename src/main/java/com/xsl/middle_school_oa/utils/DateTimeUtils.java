package com.xsl.middle_school_oa.utils;


import org.joda.time.DateTime;

import java.util.Date;

/**
 * @author
 */
public class DateTimeUtils {
    public static long  daysPassed(Date date){
        Date now=new Date();
        if(date.getTime()>now.getTime()){
            return 0;
        }
        long time=now.getTime()-date.getTime();
        return time/(1000*60*60*24);
    }

    public static void main(String[] args) {
        DateTime d=new DateTime(2020,7,9,0,2);

        System.out.println(daysPassed(d.toDate()));
    }
}

