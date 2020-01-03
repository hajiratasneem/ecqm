library InitiationandEngagementofAlcoholandOtherDrugDependenceTreatment version '8.5.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include Hospice_FHIR4 version '1.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'


valueset "Alcohol and Drug Dependence": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1001'
valueset "Alcohol and Drug Dependence Treatment": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1005'
valueset "Detoxification Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1059'
valueset "Discharge Services - Hospital Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1007'
valueset "Discharge Services - Hospital Inpatient Same Day Discharge": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1006'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Inpatient Visit - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1004'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Opiate Antagonists": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1132'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telehealth Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1031'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014' 
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012' 
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'


code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Denominator":
	"Initial Population"

define "Prior Diagnosis of Dependence":
	[Condition: "Alcohol and Drug Dependence"] PriorDependenceDiagnosis
		with ( "First Dependence Diagnosis" ) FirstDiagnosed
			such that (PriorDependenceDiagnosis.onset as Period) starts 60 days or less before start of (FirstDiagnosed.onset as Period)

define "Denominator Exclusions":
	Hospice."Has Hospice"
		or exists "Prior Diagnosis of Dependence"

define "Numerator":
	exists "Dependence Treatment Intervention Initiated"
		or exists "Treatment Initiation With Medication Order"

define "Stratification 1":
	 AgeInYearsAt(start of "Measurement Period") >= 13 and AgeInYearsAt(start of "Measurement Period") < 18
	

define "Stratification 2":
	AgeInYearsAt(start of "Measurement Period") >= 18
	

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period") >= 13
		and "First Dependence Diagnosis" is not null

define "First Dependence Diagnosis":
	First([Condition: "Alcohol and Drug Dependence"] InitialDependenceDiagnosis
			with("Qualifying Encounters")ValidEncounter
				such that InitialDependenceDiagnosis.onset as Period starts during ValidEncounter.period
					and InitialDependenceDiagnosis.onset as Period starts 47 days or more before day of 
					end of "Measurement Period"
	)

define "Treatment Initiation With Medication Order":
	[MedicationRequest: "Opiate Antagonists"] InitiatedMedicationTreatment
		with "First Dependence Diagnosis" FirstDiagnosed
				such that duration in days of Interval[start of (FirstDiagnosed.onset as Period),FHIRHelpers.ToDateTime(InitiatedMedicationTreatment.authoredOn)] < 14 days

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Emergency Department Visit"]
		union [Encounter: "Detoxification Visit"]
		union [Encounter: "Hospital Observation Care - Initial"]
		union [Encounter: "Hospital Inpatient Visit - Initial"]
		union [Encounter: "Discharge Services - Hospital Inpatient Same Day Discharge"]
		union [Encounter: "Discharge Services - Hospital Inpatient"]
		union [Encounter: "Telehealth Services"] ) ValidEncounters
		where ValidEncounters.period during "Measurement Period"

define "Treatment with Single Medication Order":
	[MedicationRequest: "Opiate Antagonists"] MedicationOrderOpiate
		where FHIRHelpers.ToDateTime(MedicationOrderOpiate.authoredOn) during "Measurement Period"

define "Continuation of Treatment Event":
	( [Procedure: "Alcohol and Drug Dependence Treatment"]
		union [Procedure: "Psych Visit - Psychotherapy"]
		union [Encounter: "Telehealth Services"] ) ContinuedTreatment
			with ( "Treatment Initiation With Medication Order" ) TreatmentEvent
				such that duration in days of Interval[FHIRHelpers.ToDateTime(TreatmentEvent.authoredOn),start of (ContinuedTreatment.period)] < 34 days

define "Dependence Treatment Intervention Continued":
	Count(([Procedure: "Alcohol and Drug Dependence Treatment"]
			union [Procedure: "Psych Visit - Psychotherapy"]
			union [Encounter: "Telehealth Services"])ContinuedTreatment
			with("Dependence Treatment Intervention Initiated")InitiatedTreatment
				such that duration in days of Interval[start of (InitiatedTreatment.performed as Period),start of (ContinuedTreatment.period)] < 34 days
	)>= 2

define "Treatment Initiation With Medication and Continuation of Treatment with Encounters":
	Count(([Procedure: "Alcohol and Drug Dependence Treatment"]
			union [Procedure: "Psych Visit - Psychotherapy"]
			union [Encounter: "Telehealth Services"])ContinuedTreatment
			with("Treatment Initiation With Medication Order")InitiatedTreatment
				such that duration in days of Interval[FHIRHelpers.ToDateTime(InitiatedTreatment.authoredOn), start of (ContinuedTreatment.period)] < 34 days)>= 2

define "Numerator 2":
	"Dependence Treatment Intervention Continued"
		or exists ( "Treatment with Single Medication Order" ContinuedTreatment
				with "Dependence Treatment Intervention Initiated" InitiatedMedicationTreatment
					such that duration in days of Interval[start of (InitiatedMedicationTreatment.performed as Period),FHIRHelpers.ToDateTime(ContinuedTreatment.authoredOn)] < 34 days
		)
		or "Treatment Initiation With Medication and Continuation of Treatment with Encounters"
		or ( exists "Continuation of Treatment Event"
				and exists ( "Treatment with Single Medication Order" ContinuedTreatment
						with ( "Treatment Initiation With Medication Order" ) InitiatedTreatment
							such that duration in days of Interval[ FHIRHelpers.ToDateTime(InitiatedTreatment.authoredOn),FHIRHelpers.ToDateTime(ContinuedTreatment.authoredOn)] < 34 days
				)
		)

define "Dependence Treatment Intervention Initiated":
	( ( [Procedure: "Alcohol and Drug Dependence Treatment"]
			union [Procedure: "Psych Visit - Psychotherapy"]
			union [Encounter: "Telehealth Services"] ) InitiatedTreatment
			with ( "First Dependence Diagnosis" ) FirstDiagnosed
				such that InitiatedTreatment.period starts 14 days or less after start of (FirstDiagnosed.onset as Period)
	)
