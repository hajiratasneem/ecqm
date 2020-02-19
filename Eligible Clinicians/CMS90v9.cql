library FunctionalStatusAssessmentsforCongestiveHeartFailure version '9.1.000'

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
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Severe Dementia": 'urn:oid:2.16.840.1.113883.3.526.3.1025'
valueset "Encounter Inpatient":'2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'

code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Clinical summary score [KCCQ]": '72188-6' from "LOINC" display 'Clinical summary score [KCCQ]'
code "Emotional score [MLHFQ]": '85609-6' from "LOINC" display 'Emotional score [MLHFQ]'
code "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]": '86923-0' from "LOINC" display 'Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]'
code "Overall summary score [KCCQ-12]": '86924-8' from "LOINC" display 'Overall summary score [KCCQ-12]'
code "Physical limitation score [KCCQ]": '72195-1' from "LOINC" display 'Physical limitation score [KCCQ]'
code "Physical score [MLHFQ]": '85618-7' from "LOINC" display 'Physical score [MLHFQ]'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "PROMIS-29 Anxiety score T-score": '71967-4' from "LOINC" display 'PROMIS-29 Anxiety score T-score'
code "PROMIS-29 Depression score T-score": '71965-8' from "LOINC" display 'PROMIS-29 Depression score T-score'
code "PROMIS-29 Fatigue score T-score": '71963-3' from "LOINC" display 'PROMIS-29 Fatigue score T-score'
code "PROMIS-29 Pain interference score T-score": '71961-7' from "LOINC" display 'PROMIS-29 Pain interference score T-score'
code "PROMIS-29 Physical function score T-score": '71959-1' from "LOINC" display 'PROMIS-29 Physical function score T-score'
code "PROMIS-29 Satisfaction with participation in social roles score T-score": '71957-5' from "LOINC" display 'PROMIS-29 Satisfaction with participation in social roles score T-score'
code "PROMIS-29 Sleep disturbance score T-score": '71955-9' from "LOINC" display 'PROMIS-29 Sleep disturbance score T-score'
code "Quality of life score [KCCQ]": '72189-4' from "LOINC" display 'Quality of life score [KCCQ]'
code "Self-efficacy score [KCCQ]": '72190-2' from "LOINC" display 'Self-efficacy score [KCCQ]'
code "Social limitation score [KCCQ]": '72196-9' from "LOINC" display 'Social limitation score [KCCQ]'
code "Total symptom score [KCCQ]": '72191-0' from "LOINC" display 'Total symptom score [KCCQ]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "VR-36 Mental component summary (MCS) score - oblique method T-score": '71990-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - oblique method T-score'
code "VR-36 Mental component summary (MCS) score - orthogonal method T-score": '72008-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-36 Physical component summary (PCS) score - oblique method T-score": '71989-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - oblique method T-score'
code "VR-36 Physical component summary (PCS) score - orthogonal method T-score": '72007-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - orthogonal method T-score'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Qualifying Encounters":
	[Encounter: "Office Visit"] ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")
		or exists ( [Condition: "Severe Dementia"] Dementia
				where Dementia.clinicalStatus.coding[0].code='active'
			and Interval[FHIRHelpers.ToDateTime(Dementia.onset),FHIRHelpers.ToDateTime(Dementia.abatement)] overlaps "Measurement Period"
		)

define "Congestive Heart Failure Followup Encounter":
	"Qualifying Encounters" OfficeVisit
		with "Initial Encounter" CHFInitial
			such that OfficeVisit.period starts 30 days or more after day of 
			end of CHFInitial.period
				and OfficeVisit.period starts 180 days or less after day of 
				end of CHFInitial.period

define "KCCQ Total Assessment Scores":
	[Observation: "Quality of life score [KCCQ]"] KCCQLifeQuality
		with [Observation: "Clinical summary score [KCCQ]"] KCCQClinical
			such that (KCCQClinical.status.value = 'final' or KCCQClinical.status.value = 'amended' or KCCQClinical.status.value = 'corrected')
			and FHIRHelpers.ToDateTime(KCCQLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KCCQClinical.issued)
				and KCCQClinical.value is not null
		with [Observation: "Self-efficacy score [KCCQ]"] KCCQSelfEfficacy
			such that (KCCQSelfEfficacy.status.value = 'final' or KCCQSelfEfficacy.status.value = 'amended' or KCCQSelfEfficacy.status.value = 'corrected')
			and FHIRHelpers.ToDateTime(KCCQLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KCCQSelfEfficacy.issued)
				and KCCQSelfEfficacy.value is not null
		with [Observation: "Total symptom score [KCCQ]"] KCCQSymptoms
			such that(KCCQSymptoms.status.value = 'final' or KCCQSymptoms.status.value = 'amended' or KCCQSymptoms.status.value = 'corrected')
			and  FHIRHelpers.ToDateTime(KCCQLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KCCQSymptoms.issued)
				and KCCQSymptoms.value is not null
		with [Observation: "Physical limitation score [KCCQ]"] KCCQPhysicalLimits
			such that (KCCQPhysicalLimits.status.value = 'final' or KCCQPhysicalLimits.status.value = 'amended' or KCCQPhysicalLimits.status.value = 'corrected')
			and FHIRHelpers.ToDateTime(KCCQLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KCCQPhysicalLimits.issued)
				and KCCQPhysicalLimits.value is not null
		with [Observation: "Social limitation score [KCCQ]"] KCCQSocialLimits
			such that(KCCQSocialLimits.status.value = 'final' or KCCQSocialLimits.status.value = 'amended' or KCCQSocialLimits.status.value = 'corrected')
			and  FHIRHelpers.ToDateTime(KCCQLifeQuality.issued) same day as FHIRHelpers.ToDateTime(KCCQSocialLimits.issued)
				and KCCQSocialLimits.value is not null
		where (KCCQLifeQuality.status.value = 'final' or KCCQLifeQuality.status.value = 'amended' or KCCQLifeQuality.status.value = 'corrected')
		and KCCQLifeQuality.value is not null

define "KCCQ12 Total Assessment Scores":
	[Observation: "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]"] KCCQ
		with [Observation: "Overall summary score [KCCQ-12]"] KCCQSum
			such that (KCCQ.status.value = 'final' or KCCQ.status.value = 'amended' or KCCQ.status.value = 'corrected')
		and (KCCQSum.status.value = 'final' or KCCQSum.status.value = 'amended' or KCCQSum.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(KCCQ.issued) same day as FHIRHelpers.ToDateTime(KCCQSum.issued)
				and KCCQSum.value is not null
				and KCCQ.value is not null

define "MLHFQ Total Assessment Scores":
	[Observation: "Physical score [MLHFQ]"] MLHFQPhysical
		with [Observation: "Emotional score [MLHFQ]"] MLHFQEmotional
			such that (MLHFQPhysical.status.value = 'final' or MLHFQPhysical.status.value = 'amended' or MLHFQPhysical.status.value = 'corrected')
		and (MLHFQEmotional.status.value = 'final' or MLHFQEmotional.status.value = 'amended' or MLHFQEmotional.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(MLHFQPhysical.issued) same day as FHIRHelpers.ToDateTime(MLHFQEmotional.issued)
				and MLHFQEmotional.value is not null
				and MLHFQPhysical.value is not null

define "PROMIS10 Total Assessment Scores":
	[Observation: "PROMIS-10 Global Mental Health (GMH) score T-score"] PROMIS10MentalScore
		with [Observation: "PROMIS-10 Global Physical Health (GPH) score T-score"] PROMIS10PhysicalScore
			such that (PROMIS10MentalScore.status.value = 'final' or PROMIS10MentalScore.status.value = 'amended' or PROMIS10MentalScore.status.value = 'corrected')
		and (PROMIS10PhysicalScore.status.value = 'final' or PROMIS10PhysicalScore.status.value = 'amended' or PROMIS10PhysicalScore.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(PROMIS10MentalScore.issued) same day as FHIRHelpers.ToDateTime(PROMIS10PhysicalScore.issued)
				and PROMIS10PhysicalScore.value is not null
		where PROMIS10MentalScore.value is not null

define "PROMIS29 Total Assessment Scores":
	[Observation: "PROMIS-29 Sleep disturbance score T-score"] Promis29Sleep
		with [Observation: "PROMIS-29 Satisfaction with participation in social roles score T-score"] Promis29SocialRoles
			such that (Promis29SocialRoles.status.value = 'final' or Promis29SocialRoles.status.value = 'amended' or Promis29SocialRoles.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29SocialRoles.issued)
				and Promis29SocialRoles.value is not null
		with [Observation: "PROMIS-29 Physical function score T-score"] Promis29Physical
			such that (Promis29Physical.status.value = 'final' or Promis29Physical.status.value = 'amended' or Promis29Physical.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29Physical.issued)
				and Promis29Physical.value is not null
		with [Observation: "PROMIS-29 Pain interference score T-score"] Promis29Pain
			such that (Promis29Pain.status.value = 'final' or Promis29Pain.status.value = 'amended' or Promis29Pain.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29Pain.issued)
				and Promis29Pain.value is not null
		with [Observation: "PROMIS-29 Fatigue score T-score"] Promis29Fatigue
			such that (Promis29Fatigue.status.value = 'final' or Promis29Fatigue.status.value = 'amended' or Promis29Fatigue.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29Fatigue.issued)
				and Promis29Fatigue.value is not null
		with [Observation: "PROMIS-29 Depression score T-score"] Promis29Depression
			such that (Promis29Depression.status.value = 'final' or Promis29Depression.status.value = 'amended' or Promis29Depression.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29Depression.issued)
				and Promis29Depression.value is not null
		with [Observation: "PROMIS-29 Anxiety score T-score"] Promis29Anxiety
			such that (Promis29Anxiety.status.value = 'final' or Promis29Anxiety.status.value = 'amended' or Promis29Anxiety.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(Promis29Sleep.issued) same day as FHIRHelpers.ToDateTime(Promis29Anxiety.issued)
				and Promis29Anxiety.value is not null
		where (Promis29Sleep.status.value = 'final' or Promis29Sleep.status.value = 'amended' or Promis29Sleep.status.value = 'corrected')
		and Promis29Sleep.value is not null

define "VR12 Oblique Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12MentalAssessment.issued) during "Measurement Period"
			and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12PhysicalAssessment.issued) during "Measurement Period"
				and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "VR12 Orthogonal Total Assessment Scores":
	( [Observation: "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12MentalAssessment.issued) during "Measurement Period"
			and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12PhysicalAssessment.issued) during "Measurement Period"
				and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "VR36 Oblique Total Assessment Scores":
	( [Observation: "VR-36 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12MentalAssessment.issued) during "Measurement Period"
			and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-36 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12PhysicalAssessment.issued) during "Measurement Period"
				and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "VR36 Orthogonal Total Assessment Scores":
	( [Observation: "VR-36 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment
		where (VR12MentalAssessment.status.value = 'final' or VR12MentalAssessment.status.value = 'amended' or VR12MentalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12MentalAssessment.issued) during "Measurement Period"
			and VR12MentalAssessment.value is not null ) VR12MentalScore
		with ( [Observation: "VR-36 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
			where (VR12PhysicalAssessment.status.value = 'final' or VR12PhysicalAssessment.status.value = 'amended' or VR12PhysicalAssessment.status.value = 'corrected')
		and FHIRHelpers.ToDateTime(VR12PhysicalAssessment.issued) during "Measurement Period"
				and VR12PhysicalAssessment.value is not null ) VR12PhysicalScore
			such that FHIRHelpers.ToDateTime(VR12MentalScore.issued) same day as FHIRHelpers.ToDateTime(VR12PhysicalScore.issued)

define "Initial Encounter":
	First("Qualifying Encounters" QualifyingEncounter
			where QualifyingEncounter.period ends 185 days or less after start of "Measurement Period"
			sort by start of period
	)

define "Assessed Initial and Followup VR36 Orthogonal":
	"Initial Encounter" Encounter
		with "VR36 Orthogonal Total Assessment Scores" InitialVR36Orthogonal
			such that FHIRHelpers.ToDateTime(InitialVR36Orthogonal.issued) 14 days or less on or before start of Encounter.period
		with "VR36 Orthogonal Total Assessment Scores" FollowupVR36Orthogonal
			such that FHIRHelpers.ToDateTime(FollowupVR36Orthogonal.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupVR36Orthogonal.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup MLHFQ":
	"Initial Encounter" Encounter
		with "MLHFQ Total Assessment Scores" InitialMLHFQ
			such that FHIRHelpers.ToDateTime(InitialMLHFQ.issued) 14 days or less on or before start of Encounter.period
		with "MLHFQ Total Assessment Scores" FollowupMLHFQ
			such that FHIRHelpers.ToDateTime(FollowupMLHFQ.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupMLHFQ.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup KCCQ":
	"Initial Encounter" Encounter
		with "KCCQ Total Assessment Scores" InitialKCCQ
			such that FHIRHelpers.ToDateTime(InitialKCCQ.issued) 14 days or less on or before start of Encounter.period
		with "KCCQ Total Assessment Scores" FollowupKCCQ
			such that FHIRHelpers.ToDateTime(FollowupKCCQ.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupKCCQ.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup KCCQ12":
	"Initial Encounter" Encounter
		with "KCCQ12 Total Assessment Scores" InitialKCCQ12
			such that FHIRHelpers.ToDateTime(InitialKCCQ12.issued) 14 days or less on or before start of Encounter.period
		with "KCCQ12 Total Assessment Scores" FollowupKCCQ12
			such that FHIRHelpers.ToDateTime(FollowupKCCQ12.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupKCCQ12.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup PROMIS10":
	"Initial Encounter" Encounter
		with "PROMIS10 Total Assessment Scores" InitialPROMIS10
			such that FHIRHelpers.ToDateTime(InitialPROMIS10.issued) 14 days or less on or before start of Encounter.period
		with "PROMIS10 Total Assessment Scores" FollowupPROMIS10
			such that FHIRHelpers.ToDateTime(FollowupPROMIS10.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupPROMIS10.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup PROMIS29":
	"Initial Encounter" Encounter
		with "PROMIS29 Total Assessment Scores" InitialPROMIS29
			such that FHIRHelpers.ToDateTime(InitialPROMIS29.issued) 14 days or less on or before start of Encounter.period
		with "PROMIS29 Total Assessment Scores" FollowupPROMIS29
			such that FHIRHelpers.ToDateTime(FollowupPROMIS29.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupPROMIS29.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup VR12 Oblique":
	"Initial Encounter" Encounter
		with "VR12 Oblique Total Assessment Scores" InitialVR12Oblique
			such that FHIRHelpers.ToDateTime(InitialVR12Oblique.issued) 14 days or less on or before start of Encounter.period
		with "VR12 Oblique Total Assessment Scores" FollowupVR12Oblique
			such that FHIRHelpers.ToDateTime(FollowupVR12Oblique.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupVR12Oblique.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup VR12 Orthogonal":
	"Initial Encounter" Encounter
		with "VR12 Orthogonal Total Assessment Scores" InitialVR12Orthogonal
			such that FHIRHelpers.ToDateTime(InitialVR12Orthogonal.issued) 14 days or less on or before start of Encounter.period
		with "VR12 Orthogonal Total Assessment Scores" FollowupVR12Orthogonal
			such that FHIRHelpers.ToDateTime(FollowupVR12Orthogonal.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupVR12Orthogonal.issued) 180 days or less after day of 
				end of Encounter.period

define "Assessed Initial and Followup VR36 Oblique":
	"Initial Encounter" Encounter
		with "VR36 Oblique Total Assessment Scores" InitialVR36Oblique
			such that FHIRHelpers.ToDateTime(InitialVR36Oblique.issued) 14 days or less on or before start of Encounter.period
		with "VR36 Oblique Total Assessment Scores" FollowupVR36Oblique
			such that FHIRHelpers.ToDateTime(FollowupVR36Oblique.issued) 30 days or more after day of 
			end of Encounter.period
				and FHIRHelpers.ToDateTime(FollowupVR36Oblique.issued) 180 days or less after day of 
				end of Encounter.period

define "Numerator":
	( "Assessed Initial and Followup PROMIS10" ) is not null
		or ( "Assessed Initial and Followup PROMIS29" ) is not null
		or ( "Assessed Initial and Followup VR12 Oblique" ) is not null
		or ( "Assessed Initial and Followup VR12 Orthogonal" ) is not null
		or ( "Assessed Initial and Followup VR36 Oblique" ) is not null
		or ( "Assessed Initial and Followup VR36 Orthogonal" ) is not null
		or ( "Assessed Initial and Followup MLHFQ" ) is not null
		or ( "Assessed Initial and Followup KCCQ12" ) is not null
		or ( "Assessed Initial and Followup KCCQ" ) is not null

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 18
		and exists ( [Condition: "Heart Failure"] HeartFailure
				where HeartFailure.clinicalStatus.coding[0].code='active'
			and Interval[FHIRHelpers.ToDateTime(HeartFailure.onset),FHIRHelpers.ToDateTime(HeartFailure.abatement)] overlaps "Measurement Period"
		)
		and exists ( "Congestive Heart Failure Followup Encounter" )
		
