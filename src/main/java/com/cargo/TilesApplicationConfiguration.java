package com.cargo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.cargo.controller")
public class TilesApplicationConfiguration  implements WebMvcConfigurer  {

	
	/*
	 * @Bean public UrlBasedViewResolver tilesViewResolver() { UrlBasedViewResolver
	 * tilesViewResolver = new UrlBasedViewResolver();
	 * tilesViewResolver.setViewClass(TilesView.class); return tilesViewResolver; }
	 * 
	 * public TilesConfigurer tilesConfigurer() { TilesConfigurer tilesConfigurer =
	 * new TilesConfigurer(); String[] defs = { "WEB-INF/views/tiles/tiles.xml" };
	 * tilesConfigurer.setDefinitions(defs); return tilesConfigurer; }
	 */

/*	@Bean
    public TilesConfigurer tilesConfigurer() {
        TilesConfigurer tilesConfigurer = new TilesConfigurer();
        tilesConfigurer.setDefinitions(
  */    //    new String[] { "/WEB-INF/views/**/tiles.xml" });
	/*
	 * tilesConfigurer.setCheckRefresh(true);
	 * 
	 * return tilesConfigurer; }
	 */

	/*
	 * @Override public void configureViewResolvers(ViewResolverRegistry registry) {
	 * TilesViewResolver viewResolver = new TilesViewResolver();
	 * registry.viewResolver(viewResolver); }
	 */
    
	@Value("${file.upload-dir}")
	private String uploadLocation;
    
    @Bean(name = "viewResolver")
    public ViewResolver getViewResolver() {
        UrlBasedViewResolver viewResolver = new UrlBasedViewResolver();
 
        // TilesView 3
        viewResolver.setViewClass(TilesView.class);
 
        return viewResolver;
    }
 
    @Bean(name = "tilesConfigurer")
    public TilesConfigurer getTilesConfigurer() {
        TilesConfigurer tilesConfigurer = new TilesConfigurer();
 
        // TilesView 3
        tilesConfigurer.setDefinitions(
                new String[] { "/WEB-INF/views/**/tiles.xml" });
 
        return tilesConfigurer;
    }
    
    
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	
    	String userDir = System.getProperty("user.dir");

		int index=userDir.lastIndexOf("\\");
	    String userDirWithoutName = userDir.substring(0,index);
	    
    	String offerUploadLocation = userDirWithoutName+""+uploadLocation;
    	System.out.println(offerUploadLocation);
    	
        registry.addResourceHandler("/static/**")
        .addResourceLocations("/static/");
        
        registry.addResourceHandler("/offer/**")
        .addResourceLocations("file:"+offerUploadLocation);	
        
    }
	
}