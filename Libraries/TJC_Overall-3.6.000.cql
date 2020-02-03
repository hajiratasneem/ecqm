library TJC_Overall_FHIR4 version '4.0.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'

valueset "Comfort Measures": '1.3.6.1.4.1.33895.1.3.0.45'
valueset "Discharge To Acute Care Facility": '2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": '2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": '2.16.840.1.113883.3.117.1.7.1.209'
valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Hemorrhagic Stroke": '2.16.840.1.113883.3.117.1.7.1.212'
valueset "Ischemic Stroke": '2.16.840.1.113883.3.117.1.7.1.247'
valueset "Left Against Medical Advice": '2.16.840.1.113883.3.117.1.7.1.308'
valueset "Non-Elective Inpatient Encounter": '2.16.840.1.113883.3.117.1.7.1.424'
valueset "Patient Expired": '2.16.840.1.113883.3.117.1.7.1.309'
valueset "Ticagrelor Therapy": '2.16.840.1.113762.1.4.1110.39'
valueset "Observation Services": '2.16.840.1.113762.1.4.1111.143'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Intervention Comfort Measures":
	(["ServiceRequest": "Comfort Measures"] P
		where P.intent.value = 'order')
		union
		(["Procedure": "Comfort Measures"] InterventionPerformed
		where InterventionPerformed.status.value = 'completed')

define "All Stroke Encounter":
	"Non Elective Inpatient Encounter" NonElectiveEncounter
    where 
    exists("Hemorrhagic Stroke" H where FHIRHelpers.ToString(Global.PrincipalDiagnosis(NonElectiveEncounter).code.coding[0].code) = H.code)
    //FHIRHelpers.ToConcept(Global.PrincipalDiagnosis(NonElectiveEncounter).code).codes[0] in "Hemorrhagic Stroke"
      //or FHIRHelpers.ToConcept(Global.PrincipalDiagnosis(NonElectiveEncounter).code).codes[0] in "Ischemic Stroke"

define "Ischemic Stroke Encounter":
	"Encounter with Principal Diagnosis and Age" EncounterWithAge
		where FHIRHelpers.ToConcept(Global.PrincipalDiagnosis(EncounterWithAge).code).codes[0] in "Ischemic Stroke"

define "Non Elective Inpatient Encounter":
	["Encounter": "Non-Elective Inpatient Encounter"] NonElectiveEncounter
		where Global."LengthInDays"(NonElectiveEncounter.period)<= 120
			and NonElectiveEncounter.period ends during "Measurement Period"

define "Ischemic Stroke Encounters with Discharge Disposition":
	( ( "Ischemic Stroke Encounter" IschemicStrokeEncounter
				where IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharge To Acute Care Facility"
					or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Left Against Medical Advice"
					or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Patient Expired"
					or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharged to Home for Hospice Care"
					or IschemicStrokeEncounter.hospitalization.dischargeDisposition in "Discharged to Health Care Facility for Hospice Care"
		)
	)

define "Comfort Measures during Hospitalization":
		"Ischemic Stroke Encounter" IschemicStrokeEncounter
	   	with "Intervention Comfort Measures" ComfortMeasure
	    	such that FHIRHelpers.ToDateTime(Coalesce(ComfortMeasure.performed as dateTime,ComfortMeasure.authoredOn)) during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

define "Encounter with Principal Diagnosis and Age":
	"All Stroke Encounter" AllStrokeEncounter
		where AgeInYearsAt(start of FHIRHelpers.ToInterval(AllStrokeEncounter.period)) >= 18

define function "CalendarDayOfOrDayAfter"(StartValue DateTime ):
	Interval(Global."ToDate"(StartValue), Global."ToDate"(StartValue + 2 days))
