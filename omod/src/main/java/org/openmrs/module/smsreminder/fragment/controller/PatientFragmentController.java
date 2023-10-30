/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.fragment.controller;

import com.google.gson.Gson;
import org.joda.time.DateTime;
import org.openmrs.api.context.Context;
import org.openmrs.module.smsreminder.ParameterStringBuilder;
import org.openmrs.module.smsreminder.api.dao.Database;
import org.openmrs.module.smsreminder.api.dao.DateFormatter;
import org.openmrs.module.smsreminder.api.dao.PatientDao;
import org.openmrs.module.smsreminder.api.dao.NumberChecksDao;
import org.openmrs.ui.framework.fragment.FragmentModel;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.TimeUnit;
import okhttp3.*;

/**
 * @author Nwokoma
 */
public class PatientFragmentController {


	PatientDao patientDao = new PatientDao();
	
	public void controller(FragmentModel model) throws Exception {
		
		String lastSentDate = "";
		Database.initConnection();
		List<Map<String, String>> allPatients = patientDao.getAllPatients(1);
		String pjson = new Gson().toJson(allPatients);
		// System.out.println(pjson);
		
		lastSentDate = Context.getAdministrationService().getGlobalProperty("last_sms_reminder");
		if (lastSentDate == null) {
			lastSentDate = "1990-01-01";
			this.updateIdentifierType();
		}
		
		model.addAttribute("patients", allPatients);
		model.addAttribute("lastSentDate", lastSentDate);
		model.addAttribute("dformatter", DateFormatter.class);
		model.addAttribute("pjson", pjson);
	}
	
	public String sendSms(HttpServletRequest request) throws Exception {
		String result = "";
		try {
			
			String phoneNumbers1 = request.getParameter("phoneNumbers1");
			String messages = request.getParameter("messages");
			String Route = request.getParameter("route");
			String cmessage = request.getParameter("message");
			String title = request.getParameter("title");
			
			String[] allPhoneNumbers = phoneNumbers1.split(",");
			String[] allMessages = messages.split(",");
			
			for (int i = 0; i < allPhoneNumbers.length; i++) {
				result = this.postSMS(allMessages[i], allPhoneNumbers[i], Route, cmessage, title);
				System.out.println(result);
			}
			if (result.equals("Successful")) {
				this.updateSentStatus();
			}
			
			return result;
		}
		catch (Exception ex) {
			System.out.println(ex.toString());
			//Logger.getLogger(PatientFragmentController.class.getName()).log(Level.SEVERE, null, ex);
			return result;
		}
		
	}
	
	private String postSMS(String message, String phoneNumbers, String Route, String cmessage, String title)
	        throws Exception {
		String result = "";
		String facilityDatimCode = Context.getAdministrationService().getGlobalProperty("facility_datim_code");
		try {
			String appId = Long.toString(new Date().getTime());
			message = String.valueOf(message);
			
			if (!cmessage.trim().equals("")) {
				message = cmessage;
				// System.out.println(message);
			}
			
			if (Route.trim().equals("second")) {

				Properties props;

				props = Context.getRuntimeProperties();

				String smsAuth = props.getProperty("connection.smsAuth");
				
				OkHttpClient client = new OkHttpClient();
				
				OkHttpClient.Builder builder = new OkHttpClient.Builder();
				builder.connectTimeout(60, TimeUnit.SECONDS);
				builder.readTimeout(60, TimeUnit.SECONDS);
				builder.writeTimeout(60, TimeUnit.SECONDS);
				client = builder.build();
				
				MediaType mediaType = MediaType.parse("application/*+json");
				RequestBody body = RequestBody.create(mediaType, "{\"senderID\":\"Forward\",\"messageText\":\"" + message
				        + " F:" + facilityDatimCode + "\",\"mobileNumber\":\"" + phoneNumbers + "\",\"route\":\"1\"}");
				Request request = new Request.Builder().url("https://api.smslive247.com/api/v4/sms").post(body)
				        .addHeader("accept", "application/json").addHeader("content-type", "application/*+json")
				        .addHeader("Authorization", smsAuth).build();
				
				Response response = client.newCall(request).execute();
				
				// System.out.println("Response: " + response.code());
				if (response.code() == 200) {
					System.out.println("RESPONSE AFTER SENT MESSAGE: " + response);
					result = "Successful";
				} else {
					result = "Unsuccessful";
				}
				
			} else {
				URL url = new URL("http://google.com");

				StringBuilder strBuf = new StringBuilder();
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("GET");
				con.setRequestProperty("Accept", "application/json");

				Map<String, String> parameters = new HashMap<String, String>();
				con.setDoOutput(true);
				DataOutputStream out = new DataOutputStream(con.getOutputStream());

				out.writeBytes(ParameterStringBuilder.getParamsString(parameters));
				System.out.println(con.getResponseCode());

				BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String output;
				while ((output = reader.readLine()) != null)
					strBuf.append(output);

				// System.out.println(strBuf.toString());
				out.flush();
				out.close();

				result = "Successful";
			}
		}
		catch (Exception e) {
			System.out.println(e.toString());
			result = "Error! Please check your internet connection and try again";
		}
		return result;
		
	}
	
	public String updateSentStatus() {
		
		Calendar now = Calendar.getInstance();
		
		String today = now.get(Calendar.YEAR) + "-" + (now.get(Calendar.MONTH) + 1) + "-" + now.get(Calendar.DATE);
		Context.getAdministrationService().setGlobalProperty("last_sms_reminder", today);
		return "complete";
	}
	
	//	public List<String[]> readAll(Reader reader) throws Exception {
	//		CSVReader csvReader = new CSVReader(reader);
	//		List<String[]> list = new ArrayList<String[]>();
	//		list = csvReader.readAll();
	//		reader.close();
	//		csvReader.close();
	//		return list;
	//	}
	
	public String getFilteredPatientsList(HttpServletRequest request) {
		
		Database.initConnection();
		//int adultsTestedPositive = htsDao.getAllAdultPatientsTestedPositieForHIV(startDate, endDate);
		
		DateTime startDateTime = new DateTime(new Date());
		DateTime endDateTime = new DateTime(new Date()).plusDays(1);
		
		int program_id = Integer.parseInt(request.getParameter("program_id"));
		
		if (request.getParameter("startDate") != null && !request.getParameter("startDate").equalsIgnoreCase("")) {
			startDateTime = new DateTime(request.getParameter("startDate"));
			endDateTime = new DateTime(request.getParameter("endDate"));
		}
		String startDate = startDateTime.toString("yyyy'-'MM'-'dd");
		String endDate = endDateTime.toString("yyyy'-'MM'-'dd");
		
		// System.out.println("TONY OSUNA!");
		List<Map<String, String>> allPatients = patientDao.getFilteredPatients(startDate, endDate, program_id);
		
		String json = new Gson().toJson(allPatients);
		//return "hello";
		return json;
		
	}
	
	public String getSession(String url) throws IOException {
		HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
		//add headers to the connection, or check the status if desired..
		
		// handle error response code it occurs
		int responseCode = connection.getResponseCode();
		InputStream inputStream;
		if (200 <= responseCode && responseCode <= 299) {
			inputStream = connection.getInputStream();
		} else {
			inputStream = connection.getErrorStream();
		}
		
		BufferedReader in = new BufferedReader(new InputStreamReader(inputStream));
		
		StringBuilder response = new StringBuilder();
		String currentLine;
		
		while ((currentLine = in.readLine()) != null)
			response.append(currentLine);
		
		in.close();
		
		return response.toString();
	}
	
	public String updateIdentifierType() throws SQLException {
		NumberChecksDao numberChecksDao = new NumberChecksDao();
		PreparedStatement stmt;
		java.sql.Connection con = Database.connectionPool.getConnection();
		String uuid = numberChecksDao.generateMDString().toString();
		Calendar now = Calendar.getInstance();
		String today = now.get(Calendar.YEAR) + "-" + (now.get(Calendar.MONTH) + 1) + "-" + now.get(Calendar.DATE);
		// JSON
		String query = "REPLACE INTO patient_identifier_type  (patient_identifier_type_id,name,description,check_digit,creator,date_created,required,retired,uuid) VALUES (99,'Consent','Permission for SMS Reminder',0,1,?,0,0,?)";
		int i = 1;
		stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmt.setString(i++, today);
		stmt.setString(i++, uuid);
		stmt.executeUpdate();
		System.out.println("INSERTED IDENTIFIER TYPE!");
		return "INSERTED IDENTIFIER TYPE!";
	}
	
}
