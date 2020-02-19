library AssessedforRehabilitation version '7.1.000'

using FHIR version '4.0.0'

include TJC_Overall_FHIR4 version '4.0.000' called TJC
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.209'
valueset "Discharged to Rehabilitation Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.132'
valueset "Left Against Medical Advice": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.308'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Rehabilitation Assessment": 'urn:oid:2.16.840.1.113762.1.4.1045.18'
valueset "Rehabilitation Therapy": 'urn:oid:2.16.840.1.113762.1.4.1045.19'

context Patient


define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Rehabilitation Assessment or Therapy":
	[Procedure: "Rehabilitation Assessment"]
		union [Procedure: "Rehabilitation Therapy"]

define "No Rehabilitation Assessment or Therapy":
	( [Procedure: "Rehabilitation Assessment"]
		union [Procedure: "Rehabilitation Therapy"] ) NoRehabProcedure
		where NoRehabProcedure.statusReason in "Medical Reason"
			or NoRehabProcedure.statusReason in "Patient Refusal"

define "Denominator":
	"Initial Population"

define "Numerator":
	( TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
			with "No Rehabilitation Assessment or Therapy" NoRehabProcedure
				such that NoRehabProcedure.performed as Period overlaps EncounterWithAge.period
	)
		union ( TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
				with "Rehabilitation Assessment or Therapy" RehabAssessment
					such that RehabAssessment.performed as Period starts during EncounterWithAge.period
		)
		union "Encounter with Discharge to Rehabilitation Facility"

define "Encounter with Discharge to Rehabilitation Facility":
	TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
		where EncounterWithAge.hospitalization.dischargeDisposition in "Discharged to Rehabilitation Facility"

define "Discharge Status With Comfort Measures During Hospitalization":
	TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
		with TJC."Intervention Comfort Measures" ComfortMeasures
			such that FHIRHelpers.ToDateTime(ComfortMeasures.occurrence as dateTime) during Global."Hospitalization"(EncounterWithAge)

define "Denominator Exclusions":
	( TJC."Encounter with Principal Diagnosis and Age" EncounterWithAge
			where (EncounterWithAge.hospitalization.dischargeDisposition as CodeableConcept) in "Discharge To Acute Care Facility"
				or (EncounterWithAge.hospitalization.dischargeDisposition as CodeableConcept) in "Left Against Medical Advice"
				or (EncounterWithAge.hospitalization.dischargeDisposition as CodeableConcept)in "Discharged to Home for Hospice Care"
				or (EncounterWithAge.hospitalization.dischargeDisposition as CodeableConcept)in "Patient Expired"
				or (EncounterWithAge.hospitalization.dischargeDisposition as CodeableConcept)in "Discharged to Health Care Facility for Hospice Care"
	)
		union "Discharge Status With Comfort Measures During Hospitalization"
