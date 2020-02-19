library MedianAdmitDecisionTimetoEDDepartureTimeforAdmittedPatients version '8.0.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

valueset "Decision to Admit to Hospital Inpatient": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.295'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Settings": 'urn:oid:2.16.840.1.113762.1.4.1111.126'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psychiatric/Mental Health Diagnosis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.299'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'

context Patient


define "Measure Population":
	"Initial Population"
	
define "ED Visit":
    singleton from (
        [Encounter: "Emergency Department Visit"] EDVisit
            where EDVisit.status.value = 'finished'
    )
	
define "ED Visit with Admit Order":
	"ED Visit" EDVisit
		with [ServiceRequest: "Decision to Admit to Hospital Inpatient"] AdmitOrder
			such that FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) during EDVisit.period
				and FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) before or on "DepartureTime"(EDVisit)

define "Initial Population":
	/*Emergency Department visit with a Decision to Admit inpatient followed by an Inpatient encounter within or at an hour of the ED Visit*/
	Global."Inpatient Encounter" EncounterInpatient
		with "ED Visit with Admit Order" EDAdmitOrder
			such that (EDAdmitOrder.period) ends 1 hour or less before or on start of EncounterInpatient.period
			
define function "PrincipalDiagnosis"(Encounter Encounter):
(singleton from (Encounter.diagnosis D where FHIRHelpers.ToInteger(D.rank) = 1)) PD
return singleton from ([Condition: id in "GetId"(PD.condition.reference)])

define function "GetId"(uri String):
Last(Split(uri, '/'))

define "Stratification 1":
	/*Encounters of patients without a principal diagnosis in the "Psychiatric/Mental Health Diagnosis" value set*/
	Global."Inpatient Encounter" EncounterInpatient
		where "PrincipalDiagnosis"(EncounterInpatient) is null
			or not ( "PrincipalDiagnosis"(EncounterInpatient).code in "Psychiatric/Mental Health Diagnosis" )
			
define "Stratification 2":
	/*Encounters of patients with a principal diagnosis that is in the "Psychiatric/Mental Health Diagnosis" value set*/
	Global."Inpatient Encounter" EncounterInpatient
		where "PrincipalDiagnosis"(EncounterInpatient).code in "Psychiatric/Mental Health Diagnosis"

define "Measure Population Exclusions":
	/* Exclude ED encounters with an admission source in "Hospital Setting"(any different facility, even if part of the same hospital system) resulting in an inpatient stay */
	Global."Inpatient Encounter" EncounterInpatient
		with "ED Visit" EDVisit
			such that EDVisit.period ends 1 hour or less before or on start of EncounterInpatient.period
				and EDVisit.hospitalization.admitSource in "Hospital Settings"



define function "DepartureTime"(Encounter "Encounter"):
	/* The time the patient physically departed the Emergency Department*/
	Last(Encounter.location Location
			return 
			end of Location.period
			sort ascending
	)

define function "AdmitDecision"(Encounter "Encounter"):
	/*Decision to admit order that was during the ED visit that is being referenced*/
	Last([ServiceRequest: "Decision to Admit to Hospital Inpatient"] AdmitOrder
			where FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) during "RelatedEDVisit"(Encounter).period
	)

define function "MeasureObservation"(Encounter "Encounter"):
	/* the duration from the Decision to Admit to the departure from the Emergency Department*/
	duration in minutes of Interval[FHIRHelpers.ToDateTime("AdmitDecision"(Encounter).authoredOn), "DepartureTime"("RelatedEDVisit"(Encounter))]

define function "RelatedEDVisit"(Encounter "Encounter"):
	/*ED visit with a Decision to admit order that preceded an inpatient encounter*/
	Last("ED Visit" EDVisit
			with ["ServiceRequest": "Decision to Admit to Hospital Inpatient"] AdmitOrder
				such that FHIRHelpers.ToDateTime(AdmitOrder.authoredOn) during EDVisit.period
			where EDVisit.period ends 1 hour or less before or on start of Encounter.period
	)
