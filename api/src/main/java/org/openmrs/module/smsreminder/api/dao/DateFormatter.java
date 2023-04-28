/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.api.dao;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author Tony
 */
public class DateFormatter {
	
	/**
	 * @param myDate
	 * @return
	 * @throws java.text.ParseException
	 */
	public static String formatDate(String myDate) throws java.text.ParseException {
		
		Date newDate = new SimpleDateFormat("yyyy-MM-dd").parse(myDate);
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd MMMM, yyyy");
		String strDate = formatter.format(newDate);
		
		return strDate;
	}
	
	public static boolean isNumeric(String strNum) {
		if (strNum == null) {
			return false;
		}
		try {}
		catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}
	
}
