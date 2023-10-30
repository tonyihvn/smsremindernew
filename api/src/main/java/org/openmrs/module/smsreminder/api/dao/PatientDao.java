/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder.api.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Nwokoma
 */

public class PatientDao {
	
	public List<Map<String, String>> getAllPatients(int program_id) throws SQLException {             
        
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Connection con = null;
        List<Map<String, String>> allPatients = new ArrayList<>();
        try {

            con = Database.connectionPool.getConnection();

            String query = " SELECT DISTINCT patient.patient_id, patient_identifier.identifier AS pepfar_id, hospno.identifier AS hospitalNumber, person_attribute.value AS phone_number, o.value_datetime AS next_date, patient_program.program_id AS program_id, COALESCE(consent.identifier, 'No') AS consent FROM patient "
                    + " LEFT JOIN patient_identifier ON patient_identifier.patient_id=patient.patient_id AND patient_identifier.identifier_type=4 "
                    + " JOIN patient_identifier hospno ON hospno.patient_id=patient.patient_id AND hospno.identifier_type=5 "
                    + " LEFT JOIN person_attribute ON person_attribute.person_id=patient.patient_id AND person_attribute.person_attribute_type_id=8 "
                    + " JOIN patient_program ON patient_program.patient_id=patient.patient_id AND patient_program.program_id=? "
                    + " LEFT JOIN patient_identifier consent ON consent.patient_id=patient.patient_id AND consent.identifier_type=99 "
                    + " JOIN obs o on patient.patient_id=o.person_id "
                    + " JOIN encounter e on patient.patient_id=e.patient_id "
                    + " WHERE (e.form_id=27 OR e.form_id=14) AND o.concept_id=5096 AND patient.voided=0 AND person_attribute.voided=0 AND o.voided=0 AND (DATEDIFF(o.value_datetime, CURDATE()) = 1 OR DATEDIFF(o.value_datetime, CURDATE()) = 2) ";

            // int i = 1;
            int i = 1;
            stmt = con.prepareStatement(query);

            stmt.setInt(i++, program_id);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> tempMap = new HashMap<>();
                tempMap.put("patient_id", rs.getString("patient_id"));
                tempMap.put("phone_number", rs.getString("phone_number"));
                tempMap.put("next_date", rs.getString("next_date"));
                tempMap.put("pepfar_id", rs.getString("pepfar_id"));
                tempMap.put("hospitalNumber", rs.getString("hospitalNumber"));
                tempMap.put("consent", rs.getString("consent"));
                allPatients.add(tempMap);
            }
            return allPatients;
            
        } catch (Exception ex) {
            Database.handleException(ex);
            return null;
        } finally {
            Database.cleanUp(rs, stmt, con);
        }
    }
	
	public List<Map<String, String>> getFilteredPatients(String startDate, String endDate, int program_id) {
        //indeed for some reason, doing a count was much slower than selecting the entire record and counting it.
        //pretty strange.

        PreparedStatement stmt = null;
        ResultSet rs = null;
        Connection con = null;
        List<Map<String, String>> allPatients = new ArrayList<>();


        try {

            //regimenData.put("optimal_regimen", new JSONObject());
            //regimenData.put("sub_optimal_regimen", new JSONObject());
            //regimenData.put("misc", new JSONObject());
            con = Database.connectionPool.getConnection();
            //stmt = Database.conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY, java.sql.ResultSet.CONCUR_READ_ONLY);

            //stmt = Database.conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY, java.sql.ResultSet.CONCUR_READ_ONLY);

            String query = "SELECT DISTINCT patient.patient_id, patient_identifier.identifier AS pepfar_id, hospno.identifier AS hospitalNumber, person_attribute.value AS phone_number, obs.value_datetime AS next_date, patient_program.program_id AS program_id, COALESCE(consent.identifier, 'No') AS consent FROM patient"
                    + " LEFT JOIN patient_identifier ON patient_identifier.patient_id=patient.patient_id AND patient_identifier.identifier_type=4 "
                    + " JOIN patient_identifier hospno ON hospno.patient_id=patient.patient_id AND hospno.identifier_type=5 "
                    + " LEFT JOIN person_attribute ON person_attribute.person_id=patient.patient_id AND person_attribute.person_attribute_type_id=8"
                    + " JOIN obs ON obs.person_id=patient.patient_id AND obs.concept_id=5096 AND obs.value_datetime BETWEEN ? AND ?"
                    + " RIGHT JOIN patient_program ON patient_program.patient_id=patient.patient_id AND patient_program.program_id=?"
                    + " LEFT JOIN patient_identifier consent ON consent.patient_id=patient.patient_id AND consent.identifier_type=99"
                    + " where patient.voided=0 AND person_attribute.voided=0";


            System.out.println(query);

            int i = 1;
            //DateTime now = new DateTime(new Date());
            //String nowString = now.toString("yyyy'-'MM'-'dd' 'HH':'mm");
            stmt = con.prepareStatement(query);
            stmt.setString(i++, startDate);
            stmt.setString(i++, endDate);
            stmt.setInt(i++, program_id);
            rs = stmt.executeQuery();


            while (rs.next()) {
                Map<String, String> tempMap = new HashMap<>();
                tempMap.put("patient_id", rs.getString("patient_id"));
                tempMap.put("phone_number", rs.getString("phone_number"));
                tempMap.put("next_date", rs.getString("next_date"));
                tempMap.put("pepfar_id", rs.getString("pepfar_id"));
                tempMap.put("hospitalNumber", rs.getString("hospitalNumber"));
                tempMap.put("consent", rs.getString("consent"));
                allPatients.add(tempMap);
            }

            return allPatients;
        } catch (Exception ex) {
            Database.handleException(ex);
            return null;
        } finally {
            Database.cleanUp(rs, stmt, con);
        }
    }
	
	public List<String> getAllPatientsPhoneNumbers() throws SQLException {             
        
            PreparedStatement stmt = null;
            ResultSet rs = null;
            Connection con = null;
            List<String> allPatientPhoneNumbers = new ArrayList<>();
            try {

                con = Database.connectionPool.getConnection();


                String query = "SELECT DISTINCT person_attribute.value AS phone_number FROM person_attribute"
                        +  " JOIN obs ON obs.person_id=person_attribute.person_id AND obs.concept_id=5096 AND DATE(obs.value_datetime) >= DATE(NOW()) - INTERVAL 30 DAY"                    
                        + " where person_attribute.voided=0";
                stmt = con.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    allPatientPhoneNumbers.add(rs.getString("phone_number"));
                }
                return allPatientPhoneNumbers;

            } catch (SQLException ex) {
                Database.handleException(ex);
                return null;
            } finally {
                Database.cleanUp(rs, stmt, con);
            }
        }
}
