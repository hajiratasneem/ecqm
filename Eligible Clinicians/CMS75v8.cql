library ChildrenWhoHaveDentalDecayorCavities version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include Hospice_FHIR4 version '1.0.000' called Hospice

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Office Visit":'2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up":'2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17":'2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Clinical Oral Evaluation":'2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Dental Caries":'2.16.840.1.113883.3.464.1003.125.12.1004'

code "Birth date":'21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Numerator":
	exists ( [Condition: "Dental Caries"] DentalCaries
			where DentalCaries.clinicalStatus.coding[0].code.value='active'
				and Interval[FHIRHelpers.ToDateTime(DentalCaries.onset),FHIRHelpers.ToDateTime(DentalCaries.abatement)] overlaps "Measurement Period"
	)

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")

define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Clinical Oral Evaluation"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")< 20
			and exists ( "Qualifying Encounters" )
