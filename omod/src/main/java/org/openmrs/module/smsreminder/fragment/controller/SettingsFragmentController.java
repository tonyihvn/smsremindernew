/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.fragment.controller;

import org.openmrs.api.context.Context;
import org.openmrs.ui.framework.fragment.FragmentModel;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Tony
 */
public class SettingsFragmentController {
	
	public void controller(FragmentModel model) {
		
		String gateway_url = "";
		
		gateway_url = Context.getAdministrationService().getGlobalProperty("gateway_url");
		
		model.addAttribute("gateway_url", gateway_url);
	}
	
	public String setSmsGatewayProps(HttpServletRequest request) {
		
		Context.getAdministrationService().setGlobalProperty("gateway_url", request.getParameter("gateway_url"));
		Context.getAdministrationService().setGlobalProperty("gateway_user", request.getParameter("gateway_user"));
		Context.getAdministrationService().setGlobalProperty("gateway_pass", request.getParameter("gateway_pass"));
		Context.getAdministrationService().setGlobalProperty("gateway_message", request.getParameter("gateway_message"));
		Context.getAdministrationService().setGlobalProperty("gateway_title", request.getParameter("gateway_title"));
		Context.getAdministrationService().setGlobalProperty("gateway_phoneno", request.getParameter("gateway_phoneno"));
		Context.getAdministrationService().setGlobalProperty("gateway_other_params",
		    request.getParameter("gateway_other_params"));
		
		return "SMS Gateway Properties Saved in Global Properties!";
	}
}
