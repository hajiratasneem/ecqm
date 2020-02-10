library ControllingHighBloodPressure version '8.5.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include AdvancedIllnessandFrailtyExclusionECQM version '4.0.000' called FrailtyLTI
include Hospice_FHIR4 version '1.0.000' called Hospice

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Chronic Kidney Disease, Stage 5": 'urn:oid:2.16.840.1.113883.3.526.3.1002'
valueset "Dialysis Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "ED": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1085'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "ESRD Monthly Outpatient Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Essential Hypertension": 'urn:oid:2.16.840.1.113883.3.464.1003.104.12.1011'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Kidney Transplant": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Kidney Transplant Recipient": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1029'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.526.3.378'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Vascular Access for Dialysis": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1011'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Blood pressure": '85354-9' from "LOINC" display 'blood pressure'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Numerator": 
	"Has Diastolic Blood Pressure Less Than 90"
		and "Has Systolic Blood Pressure Less Than 140"

define "Pregnancy Or Renal Diagnosis Exclusions":
	( [Condition: "Pregnancy"]
		union [Condition: "End Stage Renal Disease"]
		union [Condition: "Kidney Transplant Recipient"]
		union [Condition: "Chronic Kidney Disease, Stage 5"] ) PregnancyESRDDiagnosis
		where PregnancyESRDDiagnosis.clinicalStatus.coding[0].code.value='active'
			and (PregnancyESRDDiagnosis.onset as Period) overlaps "Measurement Period"

define "Denominator":
	"Initial Population"

define "End Stage Renal Disease Encounter":
	[Encounter: "ESRD Monthly Outpatient Services"] ESRDEncounter
		where (ESRDEncounter.status.value='in-progress' or ESRDEncounter.status.value='finished')
		            and ESRDEncounter.period starts before end of "Measurement Period"

define "End Stage Renal Disease Procedures":
	( [Procedure: "Vascular Access for Dialysis"]
		union [Procedure: "Kidney Transplant"]
		union [Procedure: "Dialysis Services"] ) ESRDProcedure
		where ESRDProcedure.status.value='completed'
			and (ESRDProcedure.performed as Period) starts before end of "Measurement Period"

define "Essential Hypertension Diagnosis":
	[Condition: "Essential Hypertension"] Hypertension
		where Hypertension.clinicalStatus.coding[0].code.value='active'
			and (Interval[FHIRHelpers.ToDateTime(Hypertension.onset),FHIRHelpers.ToDateTime(Hypertension.abatement)] starts 6 months or less on or after start of "Measurement Period"
				or Interval[FHIRHelpers.ToDateTime(Hypertension.onset),FHIRHelpers.ToDateTime(Hypertension.abatement)] overlaps "Measurement Period")


define "Has Diastolic Blood Pressure Less Than 90":
	if "Lowest Diastolic Reading on Most Recent Blood Pressure Day"!= null then
	("Lowest Diastolic Reading on Most Recent Blood Pressure Day".value.value < 90 'mm[Hg]') else false

define "Has Systolic Blood Pressure Less Than 140":
	if "Lowest Systolic Reading on Most Recent Blood Pressure Day"!= null then
	("Lowest Systolic Reading on Most Recent Blood Pressure Day".value.value < 140 'mm[Hg]') else false

define "Lowest Diastolic Reading on Most Recent Blood Pressure Day":
	if exists("Qualifying Diastolic Blood Pressure Reading") then
	First(
    "Qualifying Diastolic Blood Pressure Reading" DBPReading
		  where FHIRHelpers.ToDateTime(DBPReading.effective as dateTime) same day as "Most Recent Blood Pressure Day"
      return singleton from (
        DBPReading.component C
          where FHIRHelpers.ToConcept(C.code).codes[0] ~ "Diastolic blood pressure"
          return C.value as Quantity
      )
			sort by value.value ascending
	)
	else null

define "Lowest Systolic Reading on Most Recent Blood Pressure Day":
	if exists("Qualifying Systolic Blood Pressure Reading") then
	First(
    "Qualifying Systolic Blood Pressure Reading" SBPReading
		  where FHIRHelpers.ToDateTime(SBPReading.effective as dateTime) same day as "Most Recent Blood Pressure Day"
      return singleton from (
        SBPReading.component C
          where FHIRHelpers.ToConcept(C.code).codes[0] ~ "Systolic blood pressure"
          return C.value as Quantity 
      )
      sort by value.value ascending
	)

	else null

define "Blood Pressure Days":
	( ( "Qualifying Diastolic Blood Pressure Reading" DBPExam
				return date from FHIRHelpers.ToDateTime(DBPExam.issued)
		)
			intersect ( "Qualifying Systolic Blood Pressure Reading" SBPExam
					return date from FHIRHelpers.ToDateTime(SBPExam.issued)
			)
	)

define "Most Recent Blood Pressure Day":
	Max("Blood Pressure Days")

define "Initial Population":
	(AgeInYearsAt(start of "Measurement Period") in Interval[18, 85 ))
			and exists "Essential Hypertension Diagnosis"
			and exists "Qualifying Encounters"

define "Qualifying Diastolic Blood Pressure Reading":
	["Observation"]BloodPressure where FHIRHelpers.ToConcept(BloodPressure.code).codes[0] ~ "Blood pressure"
	  and (BloodPressure.status.value='final' or  BloodPressure.status.value='amended')
      and FHIRHelpers.ToDateTime(BloodPressure.effective as dateTime) during "Measurement Period"
      and exists (
        BloodPressure.component DiastolicBP
          where FHIRHelpers.ToConcept(DiastolicBP.code).codes[0] ~ "Diastolic blood pressure"
            and (DiastolicBP.value as Quantity).unit.value = 'mm[Hg]')
            

define "Qualifying Systolic Blood Pressure Reading":
	["Observation"]BloodPressure where FHIRHelpers.ToConcept(BloodPressure.code).codes[0] ~ "Blood pressure"
	  and (BloodPressure.status.value='final' or  BloodPressure.status.value='amended')
      and FHIRHelpers.ToDateTime(BloodPressure.effective as dateTime) during "Measurement Period"
      and exists (
        BloodPressure.component SystolicBP
          where FHIRHelpers.ToConcept(SystolicBP.code).codes[0] ~ "Systolic blood pressure"
            and (SystolicBP.value as Quantity).unit.value = 'mm[Hg]')

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or exists "Pregnancy Or Renal Diagnosis Exclusions"
		or ( exists "End Stage Renal Disease Procedures"
				or exists "End Stage Renal Disease Encounter"
		)
		or ( AgeInYearsAt(start of "Measurement Period")>= 65
					and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
		)
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Over Age 80"


define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		            and ValidEncounter.period during "Measurement Period"
