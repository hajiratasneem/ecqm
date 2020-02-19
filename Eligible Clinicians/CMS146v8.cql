library AppropriateTestingforChildrenwithPharyngitis version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include Hospice_FHIR4 version '1.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Acute Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1011'
valueset "Acute Tonsillitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1012'
valueset "Antibiotic Medications for Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Competing Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1017'
valueset "Discharge Services- Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1039'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Group A Streptococcus Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1012'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Medical Disability Exam": 'urn:oid:2.16.840.1.113883.3.464.1003.101.11.1233'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services - Other": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "In Hospice":
	"Initial Population" EligibleEncounters
		where Hospice."Has Hospice"("Measurement Period")

define "Encounter With Antibiotic Ordered Within Three Days":
	"Qualifying Encounter" EDOrAmbulatoryVisit
		with [MedicationRequest: "Antibiotic Medications for Pharyngitis"] AntibioticOrdered
			such that AntibioticOrdered.intent.value='order'
      and ( EDOrAmbulatoryVisit.period starts 3 days or less on or before FHIRHelpers.ToDateTime(AntibioticOrdered.authoredOn) )
		where EDOrAmbulatoryVisit.period during "Measurement Period"

define "Encounter With Pharyngitis or Tonsillitis":
	from
		"Encounter With Antibiotic Ordered Within Three Days" VisitWithAntibiotic,
		"Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
		where Interval[FHIRHelpers.ToDateTime(AcutePharyngitisTonsillitis.onset),FHIRHelpers.ToDateTime(AcutePharyngitisTonsillitis.abatement)] starts during VisitWithAntibiotic.period

define "Pharyngitis or Tonsillitis":
	( ([Condition: "Acute Pharyngitis"]C where C.clinicalStatus.coding[0].code.value='active')
			union ([Condition: "Acute Tonsillitis"]C where C.clinicalStatus.coding[0].code.value ='active')
	)

define "Denominator":
	"Initial Population"

define "Qualifying Encounter":
	( [Encounter: "Discharge Services- Observation Care"]
		union [Encounter: "Emergency Department Visit"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Hospital Observation Care - Initial"]
		union [Encounter: "Medical Disability Exam"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services - Group Counseling"]
		union [Encounter: "Preventive Care Services - Other"]
		union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care Services-Individual Counseling"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		    and ValidEncounter.period during "Measurement Period"

define "Group A Streptococcus Lab Test With Result":
	[Observation: "Group A Streptococcus Test"] GroupAStreptococcusTest
		where GroupAStreptococcusTest.value is not null

define "Encounter With Antibiotic Active In 30 Days Prior":
	"Encounter With Pharyngitis or Tonsillitis" EncounterWithPharyngitis
		with [MedicationStatement: "Antibiotic Medications for Pharyngitis"] ActiveAntibiotic
			such that ActiveAntibiotic.status.value='active'
        and (ActiveAntibiotic.effective as Period) overlaps Interval[Global."ToDate"((FHIRHelpers.ToDateTime(EncounterWithPharyngitis.AcutePharyngitisTonsillitis.onset))- 30 days), Global."ToDate"(FHIRHelpers.ToDateTime(EncounterWithPharyngitis.AcutePharyngitisTonsillitis.onset)))
		return EncounterWithPharyngitis.VisitWithAntibiotic

define "Denominator Exclusions":
	"In Hospice"
		union "Encounter With Antibiotic Active In 30 Days Prior"
		union "Competing Diagnosis for Upper Respiratory Infection"

define "Initial Population":
	"Encounter With Pharyngitis or Tonsillitis" EncounterWithPharyngitis
		where AgeInYearsAt(start of "Measurement Period") in Interval[3, 18 )
		return EncounterWithPharyngitis.VisitWithAntibiotic

define "Numerator":
	from
		"Group A Streptococcus Lab Test With Result" GroupAStreptococcusTest,
		"Encounter With Pharyngitis or Tonsillitis" EncounterWithPharyngitis
		where ( start of (GroupAStreptococcusTest.effective as Period) 3 days or less on or before day of
			end of EncounterWithPharyngitis.VisitWithAntibiotic.period
				or (GroupAStreptococcusTest.effective as Period) 3 days or less on or after day of
				end of EncounterWithPharyngitis.VisitWithAntibiotic.period
		)
		return EncounterWithPharyngitis.VisitWithAntibiotic

define "Competing Diagnosis for Upper Respiratory Infection":
	"Encounter With Pharyngitis or Tonsillitis" EncounterWithPharyngitis
		with [Condition: "Competing Conditions for Respiratory Conditions"] CompetingCondition
			such that CompetingCondition.clinicalStatus.coding[0].code.value='active'
        and EncounterWithPharyngitis.AcutePharyngitisTonsillitis !~ CompetingCondition
				and Interval[FHIRHelpers.ToDateTime(CompetingCondition.onset),FHIRHelpers.ToDateTime(CompetingCondition.abatement)] starts 3 days or less after FHIRHelpers.ToDateTime(EncounterWithPharyngitis.AcutePharyngitisTonsillitis.onset)
		return EncounterWithPharyngitis.VisitWithAntibiotic
