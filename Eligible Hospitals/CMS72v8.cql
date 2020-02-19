library AntithromboticTherapyByEndofHospitalDay2 version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include TJC_Overall_FHIR4 version '4.0.000' called TJC

valueset "Antithrombotic Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.201'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "INR": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival": 'urn:oid:2.16.840.1.113762.1.4.1110.21'
valueset "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113762.1.4.1045.21'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.226'
valueset "Ticagrelor Therapy": 'urn:oid:2.16.840.1.113762.1.4.1110.39'

context Patient

define "Numerator":
	"Encounter with Antithrombotic Therapy"

define "Denominator":
	TJC."Ischemic Stroke Encounter"

define "Initial Population":
	TJC."Encounter with Principal Diagnosis and Age"

define "Thrombolytic Medication":
	["MedicationAdministration": "Thrombolytic (t-PA) Therapy"]

define "Thrombolytic Therapy Medication or Procedures":
	"Thrombolytic Medication"
		union ["Procedure": "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy"]

define "No Antithrombotic Administered":
	["MedicationAdministration": "Antithrombotic Therapy"] NoAntithromboticGiven
		where NoAntithromboticGiven.status = 'stopped'
			and (NoAntithromboticGiven.statusReason in "Medical Reason"
				or NoAntithromboticGiven.statusReason in "Patient Refusal")

define "No Antithrombotic Ordered for Medical Reason or Patient Refusal":
	["MedicationRequest": "Antithrombotic Therapy"] NoAntithromboticOrder
		where NoAntithromboticOrder.status = 'stopped'
		and (NoAntithromboticOrder.statusReason as CodeableConcept in "Medical Reason"
			or NoAntithromboticOrder.statusReason as CodeableConcept in "Patient Refusal")

define "No Antithrombotic Ordered":
	"No Antithrombotic Ordered for Medical Reason or Patient Refusal"
		union "No Antithrombotic Administered"

define "Encounter with Comfort Measures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with TJC."Intervention Comfort Measures" ComfortMeasures
			such that FHIRHelpers.ToDateTime(ComfortMeasures.authoredOn) during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "Encounter with Thrombolytic Medication":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Medication" Thrombolytic
			such that Thrombolytic.effective as Period starts during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

define "Encounter with Thrombolytic Therapy Medication or Procedures":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Thrombolytic Therapy Medication or Procedures" ThrombolyticTherapy
			such that ThrombolyticTherapy.effective as Period starts 24 hours before start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
define "Encounter Less Than Two Days":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where "HospitalizationWithObservationLengthofStay"(IschemicStrokeEncounter)< 2 days

define function "HospitalizationWithObservationLengthofStay"(Encounter "Encounter" ):
	Global."LengthInDays"(Global."HospitalizationWithObservation"(Encounter))
	
define "Encounter With Thrombolytic Therapy Prior to Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		where exists IschemicStrokeEncounter.diagnosis Diagnosis
			where Diagnosis.condition.reference in "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"

define "Denominator Exclusions":
	"Encounter Less Than Two Days"
		union "Encounter with Thrombolytic Therapy Medication or Procedures"
		union "Encounter with Thrombolytic Medication"
		union "Encounter with Comfort Measures"
		union "Encounter With An INR Greater Than 3.5"
		union "Encounter With Thrombolytic Therapy Prior to Arrival"
		union "Encounter With Thrombolytic Therapy Documented As Already Given"

define "Encounter With An INR Greater Than 3.5":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Observation: "INR"] INR
			such that FHIRHelpers.ToDateTime(INR.issued) during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))
				and FHIRHelpers.ToInteger(INR.value) > 3.5

define "Encounter with Antithrombotic Therapy":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": "Antithrombotic Therapy"] Antithrombotic
			such that Antithrombotic.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "No Antithrombotic Ordered Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "No Antithrombotic Ordered" NoAntithrombotic
			such that FHIRHelpers.ToDateTime(NoAntithrombotic.authoredOn) during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with ["MedicationAdministration": "Ticagrelor Therapy"] Ticagrelor
			such that Ticagrelor.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(start of Global."HospitalizationWithObservation"(IschemicStrokeEncounter))

define "Denominator Exceptions":
	"No Antithrombotic Ordered Day Of or Day After Hospital Arrival"
		union "Encounter With Ticagrelor Therapy Given Day Of or Day After Hospital Arrival"

define "Encounter With Thrombolytic Therapy Documented As Already Given":
	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with [Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
			such that (PriorTPA.onset as Period) during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)
