package com.cargo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.stereotype.Controller;

@SpringBootApplication
@Controller
public class CargowebApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(CargowebApplication.class, args);
	}

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(CargowebApplication.class);
	}
}
