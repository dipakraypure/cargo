package com.cargo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ForwarderController {
	
	@RequestMapping(value = {"/forwarderHome"})
	public String forwarderHome() {
		return "forwarder.forwarderHome";
	}
	
	@RequestMapping(value = {"/forwarderProfile"})
	public String forwarderMyProfile() {
		return "forwarder.myprofile";
	}
	
	@RequestMapping(value = {"/forwarderCompany"})
	public String forwarderMyCompany() {
		return "forwarder.mycompany";
	}
	
	@RequestMapping(value = {"/forwarderAlerts"})
	public String forwarderAlerts() {
		return "forwarder.myalerts";
	}
	
	@RequestMapping(value = {"/forwarderDashboard"})
	public String forwarderDashboard() {
		return "forwarder.mydashboard";
	}
	
}
