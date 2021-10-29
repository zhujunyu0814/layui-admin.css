package com.xsl.middle_school_oa.utils;

import java.math.BigDecimal;
import java.text.NumberFormat;

public class mNumberUtils {
    private static NumberFormat format=null;

    private static NumberFormat yuanFormant=null;

    static {
        format=NumberFormat.getNumberInstance();
        format.setMinimumFractionDigits(0);//设置小数部分允许的最小位数
        format.setMaximumFractionDigits(6);//设置小数部分允许的最大位数

        yuanFormant=NumberFormat.getNumberInstance();
        yuanFormant.setMinimumFractionDigits(0);//设置小数部分允许的最小位数
        yuanFormant.setMaximumFractionDigits(2);//设置小数部分允许的最大位数
    }

    public static String format(BigDecimal bigDecimal){
        return format.format(bigDecimal);
    }

    public static String formatYuan(BigDecimal bigDecimal){
        return yuanFormant.format(bigDecimal);
    }

    public static String formatWanToYuan(BigDecimal bigDecimal){
        return format.format(bigDecimal.multiply(BigDecimal.valueOf(10000)));
    }


}
