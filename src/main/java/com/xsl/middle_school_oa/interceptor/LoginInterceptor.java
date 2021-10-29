package com.xsl.middle_school_oa.interceptor;


import com.xsl.middle_school_oa.domain.SysUser;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import sun.util.PreHashedMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.concurrent.LinkedTransferQueue;

@Component
public class LoginInterceptor implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();

        SysUser loginUser=(SysUser) session.getAttribute("loginUser");

        if (loginUser == null) {

            response.sendRedirect("/login");

            return false;


        }



        return true;
    }
}
