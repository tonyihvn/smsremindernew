/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.fragment.controller;

import org.openmrs.module.smsreminder.api.dao.Database;
import org.openmrs.module.smsreminder.api.dao.DateFormatter;
import org.openmrs.module.smsreminder.api.dao.NumberChecksDao;
import org.openmrs.ui.framework.fragment.FragmentModel;

import java.util.List;
import java.util.Map;

/**
 * @author Tony
 */
public class InvalidnumbersFragmentController {
	
	NumberChecksDao numbersDao = new NumberChecksDao();
	
	public void controller(FragmentModel model) {
		
		Database.initConnection();
		List<Map<String, String>> allNumbers = numbersDao.getAllNumbers();
		model.addAttribute("numbers", allNumbers);
		model.addAttribute("dformatter", DateFormatter.class);
	}
}
