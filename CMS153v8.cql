library ChlamydiaScreeningforWomen version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include Hospice_FHIR4 version '1.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Carrier of Predominantly Sexually Transmitted Infection": 'urn:oid:2.16.840.1.113883.3.464.1003.112.11.1023'
valueset "Chlamydia": 'urn:oid:2.16.840.1.113883.3.464.1003.112.12.1003'
valueset "Chlamydia Screening": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1052'
valueset "Complications of Pregnancy, Childbirth and the Puerperium": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1012'
valueset "Contraceptive Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1080'
valueset "Delivery Live Births": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1015'
valueset "Diagnostic Studies During Pregnancy": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1008'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Female": 'urn:oid:2.16.840.1.113883.3.560.100.2'
valueset "Genital Herpes": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1049'
valueset "Gonococcal Infections and Venereal Diseases": 'urn:oid:2.16.840.1.113883.3.464.1003.112.12.1001'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Inflammatory Diseases of Female Reproductive Organs": 'urn:oid:2.16.840.1.113883.3.464.1003.112.12.1004'
valueset "Isotretinoin": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1143'
valueset "Lab Tests During Pregnancy": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1007'
valueset "Lab Tests for Sexually Transmitted Infections": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1051'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Other Female Reproductive Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1006'
valueset "Pap Test": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy Test": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1011'
valueset "Preventive Care - Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Procedures During Pregnancy": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1009'
valueset "Procedures Involving Contraceptive Devices": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1010'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Sexually Active": '2.16.840.1.113883.3.464.1003.121.12.1040'
valueset "Syphilis": 'urn:oid:2.16.840.1.113883.3.464.1003.112.12.1002'
valueset "X-Ray Study (all inclusive)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1034'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Initial Population":
	exists ("PatientAge")
		and exists ( "Qualifying Encounters" )
		and ( exists ( "Assessments Identifying Sexual Activity" )
				or exists ( "Diagnoses Identifying Sexual Activity" )
				or exists ( "Active Contraceptive Medications" )
				or exists ( "Ordered Contraceptive Medications" )
				or exists ( "Laboratory Tests Identifying Sexual Activity" )
				or exists ( "Diagnostic Studies Identifying Sexual Activity" )
				or exists ( "Procedures  Identifying Sexual Activity" )
		)

define "PatientAge":
	["Patient"]Patient
			where (Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 16
				and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")< 24)
					and Patient.gender = 'female'
		
define "Stratification 2":
	exists(["Patient"]Patient
		where(Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 20
			and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")< 24))

define "Stratification 1":
	exists(["Patient"]Patient
		where (Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")>= 16
			and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period")< 20))

define "Pregnancy Test Exclusion":
	( [ServiceRequest: "Pregnancy Test"] PregnancyTest
			with [ServiceRequest: "X-Ray Study (all inclusive)"] XrayOrder
				such that duration in days of Interval[FHIRHelpers.ToDateTime(XrayOrder.authoredOn) , FHIRHelpers.ToDateTime(PregnancyTest.authoredOn)] < 7 
					where FHIRHelpers.ToDateTime(PregnancyTest.authoredOn) during "Measurement Period"
	)
		//union ( [ServiceRequest: "Pregnancy Test"] PregnancyTestOrder
				//with [MedicationRequest: "Isotretinoin"] AccutaneOrder
					//such that AccutaneOrder.authoredOn occurs 7 days or less on or after day of PregnancyTestOrder.authoredOn
				//where PregnancyTestOrder.authoredOn during "Measurement Period"
		//)
define "Procedures  Identifying Sexual Activity":
	[Procedure: "Delivery Live Births"]
		union [Procedure: "Procedures During Pregnancy"]
		union [Procedure: "Procedures Involving Contraceptive Devices"]ProceduresForSexualActivity
			where (ProceduresForSexualActivity.performed as Period) during "Measurement Period"
			
define "Denominator":
	"Initial Population"

define "Valid Encounters":
	 [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care- Initial Office Visit, 0 to 17"]
		union [Encounter: "Preventive Care - Established Office Visit, 0 to 17"]
		union [Encounter: "Home Healthcare Services"] 

define "Qualifying Encounters":
	"Valid Encounters"ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Laboratory Tests Identifying Sexual Activity But Not Pregnancy":
	( [ServiceRequest: "Pap Test"]
		union [ServiceRequest: "Lab Tests During Pregnancy"]
		union [ServiceRequest: "Lab Tests for Sexually Transmitted Infections"] ) LabOrders
		where FHIRHelpers.ToDateTime(LabOrders.authoredOn) during "Measurement Period"
		
define "Assessments Identifying Sexual Activity":
	 [Observation: "Sexually Active"]SexualActivityAssessment
			where FHIRHelpers.ToConcept(SexualActivityAssessment.value) = "Yes (qualifier value)"
				and FHIRHelpers.ToDateTime(SexualActivityAssessment.issued) before end of "Measurement Period"

define "Diagnostic Studies Identifying Sexual Activity":
	[ServiceRequest: "Diagnostic Studies During Pregnancy"] SexualActivityDiagnostics
		where (SexualActivityDiagnostics.occurrence as Period) during "Measurement Period"
		

define "Numerator":
	exists ( [Observation: "Chlamydia Screening"] ChlamydiaTest
			where ChlamydiaTest.value is not null
				and ChlamydiaTest.effective as Period during "Measurement Period"
	)

define "Laboratory Tests Identifying Sexual Activity":
	( [ServiceRequest: "Pregnancy Test"]
		union "Laboratory Tests Identifying Sexual Activity But Not Pregnancy" ) AllLabOrders
		where FHIRHelpers.ToDateTime(AllLabOrders.authoredOn) during "Measurement Period"

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or ( exists ( "Pregnancy Test Exclusion" )
				and not exists ( "Diagnoses Identifying Sexual Activity" )
				and not exists ( "Active Contraceptive Medications" )
				and not exists ( "Laboratory Tests Identifying Sexual Activity But Not Pregnancy" )
				and not exists ( "Procedures  Identifying Sexual Activity" )
				and not exists ( "Assessments Identifying Sexual Activity" )
				and not exists ( "Ordered Contraceptive Medications" )
				and not exists ( "Diagnostic Studies Identifying Sexual Activity" )
		)

define "Active Contraceptive Medications":
	[MedicationStatement: "Contraceptive Medications"] ActiveContraceptives
		where ActiveContraceptives.effective overlaps "Measurement Period"

define "Ordered Contraceptive Medications":
	[MedicationRequest: "Contraceptive Medications"] OrderedContraceptives
		where FHIRHelpers.ToDateTime(OrderedContraceptives.authoredOn) during "Measurement Period"

define "Diagnoses Identifying Sexual Activity":
	( [Condition: "Other Female Reproductive Conditions"]
		union [Condition: "Genital Herpes"]
		union [Condition: "Gonococcal Infections and Venereal Diseases"]
		union [Condition: "Inflammatory Diseases of Female Reproductive Organs"]
		union [Condition: "Chlamydia"]
		union [Condition: "HIV"]
		union [Condition: "Syphilis"]
		union [Condition: "Carrier of Predominantly Sexually Transmitted Infection"]
		union [Condition: "Complications of Pregnancy, Childbirth and the Puerperium"] ) SexualActivityDiagnosis
		where (SexualActivityDiagnosis.onset as Period) overlaps "Measurement Period"

