/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.smsreminder;

import org.openmrs.BaseOpenmrsObject;

import java.io.Serializable;

/**
 * @author Tony
 */
public class Smsreminder extends BaseOpenmrsObject implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Integer smsreminderId;
	
	private String patientId;
	
	private String comments;
	
	public Integer getSmsreminderId() {
		return smsreminderId;
	}
	
	public void setSmsreminderId(Integer smsreminderId) {
		this.smsreminderId = smsreminderId;
	}
	
	public String getPatientId() {
		return patientId;
	}
	
	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}
	
	public String getComments() {
		return comments;
	}
	
	public void setComments(String comments) {
		this.comments = comments;
	}
	
	@Override
	public Integer getId() {
		return getSmsreminderId();
	}
	
	@Override
	public void setId(Integer id) {
		setSmsreminderId(id);
	}
	
}
