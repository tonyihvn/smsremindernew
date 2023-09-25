/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.api.dao;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import org.openmrs.api.context.Context;

/**
 * @author Tony
 */
public class NumberChecksDao {
	
	PreparedStatement stmt = null;
	
	ResultSet rs = null;
	
	Connection con = null;
	
	public List<Map<String, String>> getAllNumbers() {

        List<Map<String, String>> allNumbers = new ArrayList<>();

        try {

            con = Database.connectionPool.getConnection();


            String query = "SELECT DISTINCT patient.patient_id, person_attribute.value AS phone_number, patient_identifier.identifier AS pepfar_id, consent.identifier AS Consent FROM patient"
                    + " LEFT JOIN patient_identifier ON patient_identifier.patient_id=patient.patient_id AND patient_identifier.identifier_type=4 "
                    + " LEFT JOIN person_attribute ON person_attribute.person_id=patient.patient_id AND person_attribute.person_attribute_type_id=8 "   
                    + " LEFT JOIN patient_identifier consent ON consent.patient_id=patient.patient_id AND consent.identifier_type=99"
                    + " where patient.voided=0 AND person_attribute.voided=0";
            // int i = 1;
            stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> tempMap = new HashMap<>();
                tempMap.put("patient_id", rs.getString("patient_id"));
                tempMap.put("phone_number", rs.getString("phone_number"));
                tempMap.put("pepfar_id", rs.getString("pepfar_id"));
                tempMap.put("consent", rs.getString("Consent"));
                allNumbers.add(tempMap);
            }
            return allNumbers;

        } catch (SQLException ex) {
            Database.handleException(ex);
            return null;
        } finally {
            Database.cleanUp(rs, stmt, con);
        }
    }
	
	public void addConsent(int patient_id, String consent) throws Exception {
		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		Connection con = null;
		String uuid = this.generateMDString().toString();
		
		Calendar now = Calendar.getInstance();
		
		String today = now.get(Calendar.YEAR) + "-" + (now.get(Calendar.MONTH) + 1) + "-" + now.get(Calendar.DATE);
		Context.getAdministrationService().setGlobalProperty("last_sms_reminder", today);
		
		try {
			
			con = Database.connectionPool.getConnection();
			String query;
			
			if (this.consentExist(patient_id)) {
				query = "INSERT INTO patient_identifier  (patient_id,identifier,identifier_type,preferred,location_id,creator,date_created,voided,uuid) VALUES (?,?,99,0,1,1,?,0,?)";
				System.out.println("INSERT STATEMENT OF CONSENT");
			} else {
				query = "UPDATE patient_identifier SET patient_id=" + patient_id + " WHERE identifier=99";
				System.out.println("UPDATE STATEMENT CHOSEN");
			}
			
			int i = 1;
			stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt.setInt(i++, patient_id);
			stmt.setString(i++, consent);
			stmt.setString(i++, today);
			stmt.setString(i++, uuid);
			stmt.executeUpdate();
			
			System.out.println("FINALLY INSERTED!");
		}
		catch (SQLException ex) {
			Database.handleException(ex);
		}
		finally {
			Database.cleanUp(rs, stmt, con);
		}
	}
	
	public boolean consentExist(int patient_id) {
		PreparedStatement stmt = null;
		ResultSet rs = null;
		Connection con = null;
		try {
			con = Database.connectionPool.getConnection();
			
			String query = "SELECT identifier FROM patient_identifier WHERE  patient_id = ? AND identifier_type=99";
			int i = 1;
			
			stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt.setInt(i++, patient_id);
			rs = stmt.executeQuery();
			
			return !rs.isBeforeFirst();
		}
		catch (SQLException ex) {
			Database.handleException(ex);
			return false;
		}
		finally {
			Database.cleanUp(rs, stmt, con);
		}
	}
	
	public boolean commentExist(int patient_id) {
		
		try {
			
			con = Database.connectionPool.getConnection();
			
			String query = "SELECT patient_id FROM phonechecks_comments WHERE  patient_id = ?";
			int i = 1;
			
			stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmt.setInt(i++, patient_id);
			rs = stmt.executeQuery();
			
			return !rs.isBeforeFirst();
		}
		catch (SQLException ex) {
			Database.handleException(ex);
			return false;
		}
		finally {
			// Database.cleanUp(rs, stmt, con);
		}
	}
	
	public UUID generateMDString() {
		UUID uuid = UUID.randomUUID();
		return uuid;
	}
}
