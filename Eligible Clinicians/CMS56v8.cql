library FunctionalStatusAssessmentforTotalHipReplacement version '8.1.000'

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
valueset "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1210'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Primary THA Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1006'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Activities of daily living score [HOOS]": '72095-3' from "LOINC" display 'Activities of daily living score [HOOS]'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Pain score [HOOS]": '72097-9' from "LOINC" display 'Pain score [HOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [HOOS]": '72093-8' from "LOINC" display 'Quality of life score [HOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [HOOS]": '72094-6' from "LOINC" display 'Sport-recreation score [HOOS]'
code "Symptoms score [HOOS]": '72096-1' from "LOINC" display 'Symptoms score [HOOS]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Dementia Diagnosis":
	[Condition: "Severe dementia (disorder)"] Dementia
		where Dementia.clinicalStatus.coding[0].code='active'
			and Interval[FHIRHelpers.ToDateTime(Dementia.onset),FHIRHelpers.ToDateTime(Dementia.abatement)] overlaps "Measurement Period"

define "Total Hip Arthroplasty with 2 or More Lower Body Fractures":
	"Total Hip Arthroplasty Procedure" THAProcedure
		where Count([Condition: "Fracture - Lower Body"] LowerBodyFracture
				where LowerBodyFracture.clinicalStatus.coding[0].code='active'
			    and Interval[FHIRHelpers.ToDateTime(LowerBodyFracture.onset),FHIRHelpers.ToDateTime(LowerBodyFracture.abatement)] starts 1 day or less before start of (THAProcedure.performed as Period)
		)>= 2

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or exists ( "Total Hip Arthroplasty with 2 or More Lower Body Fractures" )
		or exists ( "Dementia Diagnosis" )

define "Total Hip Arthroplasty Procedure":
	( [Procedure: "Primary THA Procedure"] THAProcedure
			where THAProcedure.status.value='completed'
			    and (THAProcedure.performed as Period) starts 12 months or less before start of "Measurement Period"
	)

define "HOOS Total Assessment Scores":
	[Observation: "Quality of life score [HOOS]"] HOOSLifeQuality
		with [Observation: "Sport-recreation score [HOOS]"] HOOSSport
			such that (HOOSSport.status.value = 'final' or HOOSSport.status.value = 'amended' or HOOSSport.status.value = 'corrected')
			and FHIRHelpers.ToDateTime(HOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(HOOSSport.issued)
				and HOOSSport.value is not null
		with [Observation: "Activities of daily living score [HOOS]"] HOOSActivityScore
			such that (HOOSActivityScore.status.value = 'final' or HOOSActivityScore.status.value = 'amended' or HOOSActivityScore.status.value = 'corrected')
			    and FHIRHelpers.ToDateTime(HOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(HOOSActivityScore.issued)
				and HOOSActivityScore.value is not null
		with [Observation: "Symptoms score [HOOS]"] HOOSSymptoms
			such that (HOOSSymptoms.status.value = 'final' or HOOSSymptoms.status.value = 'amended' or HOOSSymptoms.status.value = 'corrected')
			    and FHIRHelpers.ToDateTime(HOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(HOOSSymptoms.issued)
				and HOOSSymptoms.value is not null
		with [Observation: "Pain score [HOOS]"] HOOSPain
			such that (HOOSPain.status.value = 'final' or HOOSPain.status.value = 'amended' or HOOSPain.status.value = 'corrected')
			    and FHIRHelpers.ToDateTime(HOOSLifeQuality.issued) same day as FHIRHelpers.ToDateTime(HOOSPain.issued)
				and HOOSPain.value is not null
		where (HOOSLifeQuality.status.value = 'final' or HOOSLifeQuality.status.value = 'amended' or HOOSLifeQuality.status.value = 'corrected')
		and HOOSLifeQuality.value is not null

define "HOOSJr Total Assessment Scores":
	( [Observation: "Hip Dysfunction and Osteoarthritis Outcome Score for Joint Replacement [HOOSJR]"] HOOSJr
			where (HOOSJr.status.value = 'final' or HOOSJr.status.value = 'amended' or HOOSJr.status.value = 'corrected')
			and HOOSJr.value is not null
	)

define "PROMIS10 Total Assessment Scores":
	[Observation: "PROMIS-10 Global Mental Health (GMH) score T-score"] Promis10MentalScore
		with [Observation: "PROMIS-10 Global Physical Health (GPH) score T-score"] Promis10PhysicalScore
			such that (Promis10PhysicalScore.status.value = 'final' or Promis10PhysicalScore.status.value = 'amended' or Promis10PhysicalScore.status.value = 'corrected')
			    and FHIRHelpers.ToDateTime(Promis10MentalScore.issued) same day as FHIRHelpers.ToDateTime(Promis10PhysicalScore.issued)
				and Promis10PhysicalScore.value is not null
		where (Promis10MentalScore.status.value = 'final' or Promis10MentalScore.status.value = 'amended' or Promis10MentalScore.status.value = 'corrected')
			    and Promis10MentalScore.value is not null

define "Qualifying Encounter":
	( [Encounter: "Outpatient Consultation"]
		union [Encounter: "Office Visit"]
		union [Encounter: "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"] ) ValidEncounters
		where (ValidEncounters.status.value='in-progress' or ValidEncounters.status.value='finished')
		    and ValidEncounters.period during "Measurement Period"

define "Assessed Initial and Followup HOOSJr with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "HOOSJr Total Assessment Scores" InitialHipAssessment
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of FHIRHelpers.ToDateTime(InitialHipAssessment.issued)
		with "HOOSJr Total Assessment Scores" FollowupHipAssessment
			such that FHIRHelpers.ToDateTime(FollowupHipAssessment.issued) 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FHIRHelpers.ToDateTime(FollowupHipAssessment.issued) 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup HOOS with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "HOOS Total Assessment Scores" InitialHipAssessmentHOOS
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of FHIRHelpers.ToDateTime(InitialHipAssessmentHOOS.issued)
		with "HOOS Total Assessment Scores" FollowupHipAssessmentHOOS
			such that FHIRHelpers.ToDateTime(FollowupHipAssessmentHOOS.issued) 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FHIRHelpers.ToDateTime(FollowupHipAssessmentHOOS.issued) 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup PROMIS10 with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "PROMIS10 Total Assessment Scores" InitialHipAssessmentPROMIS10
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of FHIRHelpers.ToDateTime(InitialHipAssessmentPROMIS10.issued)
		with "PROMIS10 Total Assessment Scores" FollowupHipAssessmentPROMIS10
			such that FHIRHelpers.ToDateTime(FollowupHipAssessmentPROMIS10.issued) 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FHIRHelpers.ToDateTime(FollowupHipAssessmentPROMIS10.issued) 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup VR12 Oblique with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "VR12 Oblique Total Assessment Scores" InitialHipAssessmentOblique
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of FHIRHelpers.ToDateTime(InitialHipAssessmentOblique.issued)
		with "VR12 Oblique Total Assessment Scores" FollowupHipAssessmentOblique
			such that FHIRHelpers.ToDateTime(FollowupHipAssessmentOblique.issued) 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FHIRHelpers.ToDateTime(FollowupHipAssessmentOblique.issued) 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Assessed Initial and Followup VR12 Orthogonal with THA":
	"Total Hip Arthroplasty Procedure" TotalHip
		with "VR12 Orthogonal Total Assessment Scores" InitialHipAssessmentOrthogonal
			such that (TotalHip.performed as Period) starts 90 days or less on or after day of FHIRHelpers.ToDateTime(InitialHipAssessmentOrthogonal.issued)
		with "VR12 Orthogonal Total Assessment Scores" FollowupHipAssessmentOrthogonal
			such that FHIRHelpers.ToDateTime(FollowupHipAssessmentOrthogonal.issued) 270 days or more after day of
			end of (TotalHip.performed as Period)
				and FHIRHelpers.ToDateTime(FollowupHipAssessmentOrthogonal.issued) 365 days or less after day of
				end of (TotalHip.performed as Period)

define "Numerator":
	exists ( "Assessed Initial and Followup HOOS with THA" )
		or exists ( "Assessed Initial and Followup HOOSJr with THA" )
		or exists ( "Assessed Initial and Followup PROMIS10 with THA" )
		or exists ( "Assessed Initial and Followup VR12 Oblique with THA" )
		or exists ( "Assessed Initial and Followup VR12 Orthogonal with THA" )

define "VR12 Orthogonal Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalOrthogonal
		where (VR12MentalOrthogonal.status.value = 'final' or VR12MentalOrthogonal.status.value = 'amended' or VR12MentalOrthogonal.status.value = 'corrected')
			    and VR12MentalOrthogonal.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalOrthogonal
			where (VR12PhysicalOrthogonal.status.value = 'final' or VR12PhysicalOrthogonal.status.value = 'amended' or VR12PhysicalOrthogonal.status.value = 'corrected')
			    and VR12PhysicalOrthogonal.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "VR12 Oblique Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
			    and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
			    and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "Initial Population":
	exists ( "Total Hip Arthroplasty Procedure" )
		and exists ( "Qualifying Encounter" )
			and AgeInYearsAt(start of "Measurement Period")>= 19


