library BreastCancerScreening version '8.4.000'

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
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Bilateral Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Female": 'urn:oid:2.16.840.1.113883.3.560.100.2'
valueset "History of bilateral mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Left": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1036'
valueset "Mammography": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Right": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1035'
valueset "Status Post Left Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Status Post Right Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Unilateral Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1020'
valueset "Unilateral Mastectomy Left": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "Unilateral Mastectomy Right": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Unilateral Mastectomy, Unspecified Laterality": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1071'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240' 
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016' 
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001' 
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025' 
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023' 

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMED-CT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMED-CT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Bilateral Mastectomy Procedure":
	[Procedure: "Bilateral Mastectomy"] BilateralMastectomyPerformed
		where BilateralMastectomyPerformed.status.value='completed'
					and (BilateralMastectomyPerformed.performed as Period) ends before end of "Measurement Period"

define "Numerator":
	exists ( [DiagnosticReport: "Mammography"] Mammogram
			where (Mammogram.status.value='final' or Mammogram.status.value='amended' or Mammogram.status.value='corrected' or Mammogram.status.value='appended')
		    and ( (Mammogram.effective as Period) ends 27 months or less before day of end of "Measurement Period")
	)

define "Left Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy Left"] UnilateralMastectomyLeftPerformed
		where UnilateralMastectomyLeftPerformed.status.value='completed'
					and (UnilateralMastectomyLeftPerformed.performed as Period) ends before end of "Measurement Period"

define "Right Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy Right"] UnilateralMastectomyRightPerformed
		where UnilateralMastectomyRightPerformed.status.value='completed'
					and (UnilateralMastectomyRightPerformed.performed as Period) ends before end of "Measurement Period"

define "Unilateral Mastectomy Procedure":
	[Procedure: "Unilateral Mastectomy"] UnilateralMastectomy
		where UnilateralMastectomy.status.value='completed'
					and (UnilateralMastectomy.performed as Period) ends before end of "Measurement Period"

define "Bilateral Mastectomy Diagnosis":
	[Condition: "History of bilateral mastectomy"] BilateralMastectomyHistory
		where BilateralMastectomyHistory.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(BilateralMastectomyHistory.onset),FHIRHelpers.ToDateTime(BilateralMastectomyHistory.abatement)] starts before end of "Measurement Period"

define "Left Mastectomy Diagnosis":
	( ([Condition: "Status Post Left Mastectomy"]C where C.clinicalStatus.coding[0].code='active')
		union ( [Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
				where UnilateralMastectomyDiagnosis.clinicalStatus.coding[0].code='active'
					and UnilateralMastectomyDiagnosis.bodySite in "Left"
		) ) LeftMastectomy
		where Interval[FHIRHelpers.ToDateTime(LeftMastectomy.onset),FHIRHelpers.ToDateTime(LeftMastectomy.abatement)] starts before end of "Measurement Period"

define "Right Mastectomy Diagnosis":
	( ([Condition: "Status Post Right Mastectomy"] RightMastectomyProcedure where RightMastectomyProcedure.clinicalStatus.coding[0].code='active')
		union ( [Condition: "Unilateral Mastectomy, Unspecified Laterality"] UnilateralMastectomyDiagnosis
				where UnilateralMastectomyDiagnosis.clinicalStatus.coding[0].code='active'
					and UnilateralMastectomyDiagnosis.bodySite in "Right"
		) ) RightMastectomy
		where Interval[FHIRHelpers.ToDateTime(RightMastectomy.onset),FHIRHelpers.ToDateTime(RightMastectomy.abatement)] starts before end of "Measurement Period"

define "Initial Population":
	Patient.gender.value='female'
		and AgeInYearsAt(start of "Measurement Period")in Interval[51, 74 )
		and exists("Qualifying Encounters")

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or ( Count("Unilateral Mastectomy Procedure")= 2 )
		or ( ( exists ( "Right Mastectomy Diagnosis" )
					or exists ( "Right Mastectomy Procedure" )
			)
				and ( exists ( "Left Mastectomy Diagnosis" )
						or exists ( "Left Mastectomy Procedure" )
				)
		)
		or exists "Bilateral Mastectomy Diagnosis"
		or exists "Bilateral Mastectomy Procedure"
		or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Under Age 80"
		or ( (AgeInYearsAt(start of "Measurement Period")>= 65 )
					and FrailtyLTI."Has Spent More Than 90 Days in Long Term Care"
		)


define "Qualifying Encounters":
	( [Encounter: "Office Visit"]
		union [Encounter: "Annual Wellness Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Home Healthcare Services"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
					and ValidEncounter.period during "Measurement Period"
