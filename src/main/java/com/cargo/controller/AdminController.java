package com.cargo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {
  
	/******Open URLs for terms and condtion/privacy policy**********/
	
	@RequestMapping(value = {"/termscondition"})
	public String getTermsCondition() {
		return "user.termscondition";
	}
	
	@RequestMapping(value = {"/privacypolicy"})
	public String getPrivacyPolicy() {
		return "user.privacypolicy";
	}
	
	/******Open URLs for terms and condtion/privacy policy**********/
	
	@RequestMapping(value = {"/login"})
	public String adminLogin() {
		return "user.login";
	}
	
	
	@RequestMapping(value = {"/","/home"})
	public String adminLanding() {
		return "user.landing";
	}
	
	@RequestMapping(value="/register")
	public String signupUser() {
		return "user.register";
	}
	
	@RequestMapping("/uploadRate")
	public String adminUploadRate() {
		return "master.adminuploadrate";
	}
	
	@RequestMapping("/adminProfile")
	public String adminProfile() {
		return "master.adminProfile";
	}
	
	@RequestMapping("/uploadOffer")
	public String adminUploadOffer() {
		return "master.adminuploadoffer";
	}
	
	@RequestMapping("/loginLog")
	public String adminUserLoginLogs() {
		return "master.adminUserloginlog";
	}
	
	@RequestMapping("/adminDashboard")
	public String adminDashboard() {
		return "master.adminDashboard";
	}
	
	@RequestMapping("/uploadAds")
	public String adminLoadAds() {
		return "master.adminLoadAds";
	}
	
	@RequestMapping("/adminFeedback")
	public String adminFeedback() {
		return "master.adminFeedback";
	}
	
	@RequestMapping("/countryRequirement")
	public String adminCountryReq() {
		return "master.adminCountryReq";
	}
	
	@RequestMapping("/forwarderSetup")
	public String forwarderSetup() {
		return "master.forwarderSetup";
	}
	
	@RequestMapping("/carrierSetup")
	public String carrierSetup() {
		return "master.carrierSetup";
	}
}
