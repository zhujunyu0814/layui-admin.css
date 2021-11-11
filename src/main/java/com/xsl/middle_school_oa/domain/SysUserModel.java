package com.xsl.middle_school_oa.domain;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;


@Data
@EqualsAndHashCode(callSuper = false)
public class SysUserModel implements Serializable {
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "姓名", index = 0)
    private String name;


    @ExcelProperty(value = "名称", index = 1)
    private String tel;


    @ExcelProperty(value = "角色", index = 2)
    private String roleName;


    @ExcelProperty(value = "部门", index = 3)
    private String deptName;


}