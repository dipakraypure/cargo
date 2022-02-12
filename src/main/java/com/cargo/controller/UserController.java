package com.cargo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {

	@RequestMapping("/userHome")
	public String userHome() {
		return "master.userhome";
	}
	
	@RequestMapping("/userProfile")
	public String userMyProfile() {
		return "master.usermyprofile";
	}
	
	@RequestMapping("/userCompany")
	public String userMyCompany() {
		return "master.usermycompany";
	}
		
	@RequestMapping("/search_result")
	public String userTransDetailsSearchResult() {
		return "master.transsearchresult";
	}
	
	@RequestMapping("/userDashboard")
	public String userDashboard() {
		return "master.userdashboard";
	}
	
}
