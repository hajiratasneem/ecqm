library DischargedonStatinMedication version '8.1.000'

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include TJC_Overall_FHIR4 version '4.0.000' called TJC
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "LDL-c": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.215'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Statin Allergen": 'urn:oid:2.16.840.1.113762.1.4.1110.42'
valueset "Statin Grouper": 'urn:oid:2.16.840.1.113762.1.4.1110.19'

context Patient

define "Statin Allergy":
	[AllergyIntolerance: "Statin Allergen"]

define "Statin at Discharge":
	[MedicationRequest: "Statin Grouper"]

define "Statin Not Given at Discharge":
	[MedicationRequest: "Statin Grouper"] NoStatinDischarge
		where NoStatinDischarge.status = 'stopped'
			and (NoStatinDischarge.statusReason as CodeableConcept in "Medical Reason"
				or NoStatinDischarge.statusReason as CodeableConcept in "Patient Refusal")

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Numerator":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Statin at Discharge" DischargeStatin
			such that FHIRHelpers.ToDateTime(DischargeStatin.authoredOn) during IschemicStrokeEncounter.period

define "Encounter with Max LDL less than 70 mg per dL":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where Max([Observation: "LDL-c"] Ldl
				where FHIRHelpers.ToDateTime(Ldl.issued) during Interval[Global."ToDate"(start of IschemicStrokeEncounter.period - 30 days), 
				end of IschemicStrokeEncounter.period]
				return Ldl.value as Quantity
		)< 70 'mg/dL'

define "Denominator Exceptions":
	( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
			with "Statin Not Given at Discharge" NoDischargeStatin
				such that FHIRHelpers.ToDateTime(NoDischargeStatin.authoredOn) during IschemicStrokeEncounter.period
	)
		union ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
				with "Statin Allergy" StatinAllergy
					such that StatinAllergy.onset as Period starts on or before 
					end of IschemicStrokeEncounter.period
		)
		union "Encounter with Max LDL less than 70 mg per dL"

define "Denominator Exclusions":
	TJC."Ischemic Stroke Encounters with Discharge Disposition"
		union TJC."Comfort Measures during Hospitalization"
