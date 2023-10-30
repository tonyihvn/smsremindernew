/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.fragment.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.smsreminder.api.dao.Database;
import org.openmrs.module.smsreminder.api.dao.PatientDao;
import org.openmrs.ui.framework.fragment.FragmentModel;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Properties;

/**
 * @author Tony
 */
public class SentmessagesFragmentController {
	
	PatientDao patientDao = new PatientDao();
	
	public void controller(FragmentModel model) throws Exception {
		Database.initConnection();
		List<String> allPatientsPhoneNumbers = patientDao.getAllPatientsPhoneNumbers();
		// System.out.println("All Phone Numbers: " + allPatientsPhoneNumbers);
		String facilityDatimCode = Context.getAdministrationService().getGlobalProperty("facility_datim_code");
		model.addAttribute("facilityDatimCode", facilityDatimCode);
		model.addAttribute("allPatientsPhoneNumbers", allPatientsPhoneNumbers);
	}
	
	public String getSentMessages(HttpServletRequest request) throws Exception {
		
		LocalDate dateObj = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String today = dateObj.format(formatter);
		String pageNumber = "1";

		Properties props;

		props = Context.getRuntimeProperties();

		String smsAuth = props.getProperty("connection.smsAuth");
		
		if (request.getParameter("pageNumber") != "") {
			pageNumber = request.getParameter("pageNumber");
		}
		
		LocalDate thirtyDaysAgo = dateObj.minusDays(30);
		System.out.println("30 days Ago: " + thirtyDaysAgo);
		// String url = "https://api.smslive247.com/api/v4/sms?PageNo=1&PageSize=500&DateFrom="+thirtyDaysAgo+"&DateTo=" + today;
		String url = "https://api.smslive247.com/api/v4/sms?PageNumber=" + pageNumber + "&PageSize=500";
		
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		// optional default is GET
		con.setRequestMethod("GET");
		con.setRequestProperty("Content-Type", "application/json");
		
		//add request header
		con.setRequestProperty("User-Agent", "Mozilla/5.0");
		con.setRequestProperty("Authorization", smsAuth);
		int responseCode = con.getResponseCode();
		System.out.println("\nSending 'GET' request to URL : " + url);
		System.out.println("Response Code : " + responseCode);
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
		
		//print in String
		// System.out.println(response.toString());
		//Read JSON response and print
		// JSONObject myResponse = new JSONObject(response.toString());
		// System.out.println("result after Reading JSON Response");
		// System.out.println("origin- "+myResponse.getString("origin"));
		//return "hello";
		
		// String SentMessages = new Gson().toJson(response);
		// JSONObject allSentMessages = new JSONObject(response.toString());
		// String json = new Gson().toJson(response.toString());
		//return "hello";
		return response.toString();
	}
	
}
