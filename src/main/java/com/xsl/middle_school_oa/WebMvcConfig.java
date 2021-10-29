package com.xsl.middle_school_oa;

import com.xsl.middle_school_oa.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {



    @Value("${file.staticAccessPath}")
    private String staticAccessPath;

    @Value("${file.uploadFolder}")
    private String uploadFolder;




    @SuppressWarnings("all")
    @Autowired
    private LoginInterceptor loginInterceptor;



    @Override
    public void addInterceptors(InterceptorRegistry registry) {


        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/**.ico","/layui*/**", "/js/**", "/img/**", "/css/**", "/logout", "/login","/user/doLogin");





    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {



        registry.addResourceHandler(staticAccessPath).addResourceLocations("file:///"+uploadFolder);


    }
}
