library FunctionalStatusAssessmentforTotalKneeReplacement version '8.3.000'

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

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fracture - Lower Body": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1037'
valueset "Knee Injury and Osteoarthritis Outcome Score for Joint Replacement [KOOSJR]": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1218'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Primary TKA Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1007'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Activities of daily living score [KOOS]": '72100-1' from "LOINC" display 'Activities of daily living score [KOOS]'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Pain score [KOOS]": '72102-7' from "LOINC" display 'Pain score [KOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [KOOS]": '72098-7' from "LOINC" display 'Quality of life score [KOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [KOOS]": '72099-5' from "LOINC" display 'Sport-recreation score [KOOS]'
code "Symptoms score [KOOS]": '72101-9' from "LOINC" display 'Symptoms score [KOOS]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Total Knee Arthroplasty Procedure":
	[Procedure: "Primary TKA Procedure"] TKAProcedure
		where (TKAProcedure.performed as Period) starts 12 months or less before start of "Measurement Period"

define "Dementia Diagnosis":
	[Condition: "Severe dementia (disorder)"] Dementia
		where Dementia.clinicalStatus.coding[0].code = 'active'
					and Interval[FHIRHelpers.ToDateTime(Dementia.onset),FHIRHelpers.ToDateTime(Dementia.abatement)] overlaps "Measurement Period"

define "Denominator":
	"Initial Population"

define "Total Knee Arthroplasty with 2 or More Lower Body Fractures":
	"Total Knee Arthroplasty Procedure" TKAProcedure
		where Count([Condition: "Fracture - Lower Body"] LowerBodyFracture
				where LowerBodyFracture.clinicalStatus.coding[0].code = 'active'
					and Interval[FHIRHelpers.ToDateTime(LowerBodyFracture.onset),FHIRHelpers.ToDateTime(LowerBodyFracture.abatement)] starts less than 1 day on or before start of (TKAProcedure.performed as Period)
		)>= 2

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or exists "Total Knee Arthroplasty with 2 or More Lower Body Fractures"
		or exists "Dementia Diagnosis"

define "KOOS Total Assessment Scores":
	[Observation: "Quality of life score [KOOS]"] KOOSLifeQuality
		with [Observation: "Sport-recreation score [KOOS]"] KOOSSport
			such that (KOOSSport.status.value = 'final' or KOOSSport.status.value = 'amended' or KOOSSport.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(KOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KOOSSport.issued)
				and KOOSSport.value is not null
		with [Observation: "Activities of daily living score [KOOS]"] KOOSActivityScore
			such that (KOOSActivityScore.status.value = 'final' or KOOSActivityScore.status.value = 'amended' or KOOSActivityScore.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(KOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KOOSActivityScore.issued)
				and KOOSActivityScore.value is not null
		with [Observation: "Symptoms score [KOOS]"] KOOSSymptoms
			such that (KOOSSymptoms.status.value = 'final' or KOOSSymptoms.status.value = 'amended' or KOOSSymptoms.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(KOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KOOSSymptoms.issued)
				and KOOSSymptoms.value is not null
		with [Observation: "Pain score [KOOS]"] KOOSPain
			such that (KOOSPain.status.value = 'final' or KOOSPain.status.value = 'amended' or KOOSPain.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(KOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KOOSPain.issued)
				and KOOSPain.value is not null
		where (KOOSLifeQuality.status.value = 'final' or KOOSLifeQuality.status.value = 'amended' or KOOSLifeQuality.status.value = 'corrected')
					and KOOSLifeQuality.value is not null

define "PROMIS10 Total Assessment Scores":
	[Observation: "PROMIS-10 Global Mental Health (GMH) score T-score"] Promis10MentalScore
		with [Observation: "PROMIS-10 Global Physical Health (GPH) score T-score"] Promis10PhysicalScore
			such that (Promis10PhysicalScore.status.value = 'final' or Promis10PhysicalScore.status.value = 'amended' or Promis10PhysicalScore.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(Promis10MentalScore.issued) same day as FHIRHelpers.ToDateTime(Promis10PhysicalScore.issued)
				and Promis10PhysicalScore.value is not null
		where (Promis10MentalScore.status.value = 'final' or Promis10MentalScore.status.value = 'amended' or Promis10MentalScore.status.value = 'corrected')
					and Promis10MentalScore.value is not null

define "KOOSJr Total Assessment Scores":
	( [Observation: "Knee Injury and Osteoarthritis Outcome Score for Joint Replacement [KOOSJR]"] KOOSJr
			where (KOOSJr.status.value = 'final' or KOOSJr.status.value = 'amended' or KOOSJr.status.value = 'corrected')
					and KOOSJr.value is not null
	)

define "Qualifying Encounters":
	( [Encounter: "Outpatient Consultation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"] ) ValidEncounters
		where (ValidEncounters.status.value='in-progress' or ValidEncounters.status.value='finished')
		            and ValidEncounters.period during "Measurement Period"

define "Assessed Initial and Follow up KOOS with TKA":
	"Total Knee Arthroplasty Procedure" TotalKnee
		with "KOOS Total Assessment Scores" InitialKneeAssessmentKOOS
			such that FHIRHelpers.ToDateTime(InitialKneeAssessmentKOOS.issued) 90 days or less on or before start of (TotalKnee.performed as Period)
		with "KOOS Total Assessment Scores" FollowupKneeAssessmentKOOS
			such that FHIRHelpers.ToDateTime(FollowupKneeAssessmentKOOS.issued) between
			end of (TotalKnee.performed as Period) + 270 days and
			end of (TotalKnee.performed as Period) + 365 days

define "Assessed Initial and Follow up KOOSJr with TKA":
	"Total Knee Arthroplasty Procedure" TotalKnee
		with "KOOSJr Total Assessment Scores" InitialKneeAssessmentKOOSJr
			such that FHIRHelpers.ToDateTime(InitialKneeAssessmentKOOSJr.issued) 90 days or less on or before start of (TotalKnee.performed as Period)
		with "KOOSJr Total Assessment Scores" FollowupKneeAssessmentKOOSJr
			such that FHIRHelpers.ToDateTime(FollowupKneeAssessmentKOOSJr.issued) between
			end of (TotalKnee.performed as Period) + 270 days and
			end of (TotalKnee.performed as Period) + 365 days

define "VR12 Oblique Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12Mental
		where (VR12Mental.status.value = 'final' or VR12Mental.status.value = 'amended' or VR12Mental.status.value = 'corrected')
					and VR12Mental.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
					and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "VR12 Orthogonal Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
					and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
					and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "Initial Population":
	exists ( "Total Knee Arthroplasty Procedure" )
		and exists ( "Qualifying Encounters" )
		and AgeInYearsAt(start of "Measurement Period")>= 19

define "Assessed Initial and Follow up VR12 Orthogonal with TKA":
	"Total Knee Arthroplasty Procedure" TotalKnee
		with "VR12 Orthogonal Total Assessment Scores" InitialKneeAssessmentOrthogonal
			such that FHIRHelpers.ToDateTime(InitialKneeAssessmentOrthogonal.issued) 90 days or less on or before start of (TotalKnee.performed as Period)
		with "VR12 Orthogonal Total Assessment Scores" FollowupKneeAssessmentOrthogonal
			such that FHIRHelpers.ToDateTime(FollowupKneeAssessmentOrthogonal.issued) between
			end of (TotalKnee.performed as Period) + 270 days and
			end of (TotalKnee.performed as Period) + 365 days

define "Assessed Initial and Follow up PROMIS10 with TKA":
	"Total Knee Arthroplasty Procedure" TotalKnee
		with "PROMIS10 Total Assessment Scores" InitialKneeAssessmentPROMIS10
			such that FHIRHelpers.ToDateTime(InitialKneeAssessmentPROMIS10.issued) 90 days or less on or before start of (TotalKnee.performed as Period)
		with "PROMIS10 Total Assessment Scores" FollowupKneeAssessmentPROMIS10
			such that FHIRHelpers.ToDateTime(FollowupKneeAssessmentPROMIS10.issued) between
			end of (TotalKnee.performed as Period) + 270 days and
			end of (TotalKnee.performed as Period) + 365 days

define "Assessed Initial and Follow up VR12 Oblique with TKA":
	"Total Knee Arthroplasty Procedure" TotalKnee
		with "VR12 Oblique Total Assessment Scores" InitialKneeAssessmentOblique
			such that FHIRHelpers.ToDateTime(InitialKneeAssessmentOblique.issued) 90 days or less on or before start of (TotalKnee.performed as Period)
		with "VR12 Oblique Total Assessment Scores" FollowupKneeAssessmentOblique
			such that FHIRHelpers.ToDateTime(FollowupKneeAssessmentOblique.issued) between
			end of (TotalKnee.performed as Period) + 270 days and
			end of (TotalKnee.performed as Period) + 365 days

define "Numerator":
	exists ( "Assessed Initial and Follow up KOOS with TKA" )
		or exists ( "Assessed Initial and Follow up KOOSJr with TKA" )
		or exists ( "Assessed Initial and Follow up PROMIS10 with TKA" )
		or exists ( "Assessed Initial and Follow up VR12 Oblique with TKA" )
		or exists ( "Assessed Initial and Follow up VR12 Orthogonal with TKA" )

