package com.xsl.middle_school_oa.model;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.format.NumberFormat;

import java.util.Date;

public class PharmacistExportModel {

    @ExcelProperty(value = "姓名", index = 0)
    private String name;

    @ExcelProperty(value = "角色", index = 1)
    private String roleName;

    @ExcelProperty(value = "昵称", index = 2)
    private String Tel;

    @ExcelProperty(value = "城市", index = 4)
    private String Password;


}
