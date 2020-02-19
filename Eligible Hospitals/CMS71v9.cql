library AnticoagulationTherapyforAtrialFibrillationFlutter version '8.1.000'

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include TJC_Overall_FHIR4 version '4.0.000' called TJC
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Anticoagulant Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.200'
valueset "Atrial Ablation": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.203'
valueset "Atrial Fibrillation/Flutter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.202'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.209'
valueset "Left Against Medical Advice": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'

context Patient

define "Reason for Not Giving Anticoagulant at Discharge":
	[MedicationRequest: "Anticoagulant Therapy"] NoAnticoagulant
		where FHIRHelpers.ToBoolean(NoAnticoagulant.doNotPerform) = true
			and ((NoAnticoagulant.statusReason as CodeableConcept).coding.code in "Medical Reason"
				or (NoAnticoagulant.statusReason as CodeableConcept).coding.code in "Patient Refusal")

define "Anticoagulant Therapy at Discharge":
	[MedicationRequest: "Anticoagulant Therapy"]

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Encounter with Atrial Ablation Procedure":
	[Procedure: "Atrial Ablation"] AtrialAblation
		with TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
			such that AtrialAblation.performed as Period starts 1 day before start of IschemicStrokeEncounter.period
define "Numerator":
	"Denominator" Encounter
		with "Anticoagulant Therapy at Discharge" DischargeAnticoagulant
			such that FHIRHelpers.ToDateTime(DischargeAnticoagulant.authoredOn) during Encounter.period

define "Comfort Measures during Hospitalization":
	"Denominator" Encounter
		with TJC."Intervention Comfort Measures" ComfortMeasure
			such that FHIRHelpers.ToDateTime(ComfortMeasure.authoredOn) during Global."Hospitalization"(Encounter)

define "Current Diagnosis Atrial Fibrillation or Flutter":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where exists ( IschemicStrokeEncounter.diagnosis Diagnosis
				where Diagnosis.use as CodeableConcept in "Atrial Fibrillation/Flutter"
		)

define "Denominator":
	"Encounter with Atrial Ablation Procedure"
		union "History of Atrial Fibrillation or Flutter"
		union "Current Diagnosis Atrial Fibrillation or Flutter"

define "Denominator Exceptions":
	"Denominator" Encounter
		with "Reason for Not Giving Anticoagulant at Discharge" NoDischargeAnticoagulant
			such that FHIRHelpers.ToDateTime(NoDischargeAnticoagulant.authoredOn) during Encounter.period

define "History of Atrial Fibrillation or Flutter":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Condition: "Atrial Fibrillation/Flutter"] AtrialFibrillationFlutter
			such that AtrialFibrillationFlutter.onset as Period starts on or before end of IschemicStrokeEncounter.period

define "Denominator Exclusions":
	( "Denominator" Encounter
			where (Encounter.hospitalization.dischargeDisposition as CodeableConcept) in "Discharge To Acute Care Facility"
				or (Encounter.hospitalization.dischargeDisposition as CodeableConcept)in "Left Against Medical Advice"
				or (Encounter.hospitalization.dischargeDisposition as CodeableConcept)in "Patient Expired"
				or (Encounter.hospitalization.dischargeDisposition as CodeableConcept)in "Discharged to Home for Hospice Care"
				or (Encounter.hospitalization.dischargeDisposition as CodeableConcept)in "Discharged to Health Care Facility for Hospice Care"
	)
		union "Comfort Measures during Hospitalization"
