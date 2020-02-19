library DiabetesHemoglobinA1cHbA1cPoorControl9 version '8.4.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include AdvancedIllnessandFrailtyExclusionECQM version '4.0.000' called FrailtyLTI
include Hospice_FHIR4 version '1.0.000' called Hospice

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Diabetes": '2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Ethnicity": '2.16.840.1.114222.4.11.837'
valueset "HbA1c Laboratory Test": '2.16.840.1.113883.3.464.1003.198.12.1013'
valueset "ONC Administrative Sex": '2.16.840.1.113762.1.4.1'
valueset "Payer": '2.16.840.1.114222.4.11.3591'
valueset "Race": '2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Annual Wellness Visit": '2.16.840.1.113883.3.526.3.1240'
valueset "Home Healthcare Services": '2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1023'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMED-CT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMED-CT" display 'Discharge to home for hospice care (procedure)'


parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Numerator":
	"Has Most Recent HbA1c Without Result"
		or "Has Most Recent Elevated HbA1c"
		or "Has No Record Of HbA1c"

define "Has Most Recent Elevated HbA1c":
	("Has Most Recent HbA1c".value as Quantity) > 9 '%{HemoglobinA1C}'

define "Has No Record Of HbA1c":
	not exists ( [Observation: "HbA1c Laboratory Test"] NoHbA1c
			where (NoHbA1c.effective as Period) during "Measurement Period"
	)

define "Has Most Recent HbA1c":
	Last([Observation: "HbA1c Laboratory Test"] RecentHbA1c
			where (RecentHbA1c.effective as Period) during "Measurement Period"
			sort by start of (effective as Period)
	)

define "Initial Population":
(AgeInYearsAt(start of "Measurement Period")in Interval[18, 75])
		and exists ( "Qualifying Encounters" )
		and exists ( [Condition: "Diabetes"] Diabetes
				where Diabetes.clinicalStatus.coding[0].code='active'
					and FHIRHelpers.ToDateTime(Diabetes.onset) during "Measurement Period"
		)

define "Has Most Recent HbA1c Without Result":
	"Has Most Recent HbA1c" is not null
		and ("Has Most Recent HbA1c".value as Quantity) is null

define "Denominator Exclusions":
	( (AgeInYearsAt(start of "Measurement Period")>= 65 )
				and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
	)
		or Hospice."Has Hospice"("Measurement Period")
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
					and ValidEncounter.period during "Measurement Period"

