package com.xsl.middle_school_oa.utils;

import java.util.Arrays;
import java.util.Date;

public class DateUtils {

    public static Date getLastDateOfMonth(int year,int month){

        int date;
        int[] array1=new int[]{1,3,5,7,8,10,12};
        int i = Arrays.binarySearch(array1, month);
        if(i>=0){
            date=31;
        }else if(month==2){
            if(year%400==0||(year%4==0&&year%100!=0)){
                date=29;
            }else{
                date=28;
            }
        }else{
            date=30;
        }

        Date d=new Date(year-1900,month-1,date);

        return d;


    }


    public static void main(String[] args) {
        System.out.println(getLastDateOfMonth(2008, 2));

        System.out.println(getLastDateOfMonth(2009,2));
        System.out.println(getLastDateOfMonth(2010,7));
        System.out.println(getLastDateOfMonth(2010,6));
    }
}
