library PreventiveCareandScreeningScreeningforDepressionandFollowUpPlan version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Additional evaluation for depression - adolescent":'2.16.840.1.113883.3.600.1542'
valueset "Additional evaluation for depression - adult":'2.16.840.1.113883.3.600.1545'
valueset "Bipolar Diagnosis":'2.16.840.1.113883.3.600.450'
valueset "Depression diagnosis":'2.16.840.1.113883.3.600.145'
valueset "Depression medications - adolescent":'2.16.840.1.113883.3.600.469'
valueset "Depression medications - adult":'2.16.840.1.113883.3.600.470'
valueset "Depression Screening Encounter Codes":'2.16.840.1.113883.3.600.1916'
valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Follow-up for depression - adolescent":'2.16.840.1.113883.3.600.467'
valueset "Follow-up for depression - adult":'2.16.840.1.113883.3.600.468'
valueset "Medical or Other reason not done":'2.16.840.1.113883.3.600.1.1502'
valueset "Negative Depression Screening":'2.16.840.1.113883.3.600.2451'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Patient Reason refused":'2.16.840.1.113883.3.600.791'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Positive Depression Screening":'2.16.840.1.113883.3.600.2450'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Referral for Depression Adolescent":'2.16.840.1.113883.3.600.537'
valueset "Referral for Depression Adult":'2.16.840.1.113883.3.600.538'
valueset "Suicide Risk Assessment":'2.16.840.1.113883.3.600.559'

code "Adolescent depression screening assessment":'73831-0' from "LOINC" display 'Adolescent depression screening assessment'
code "Adult depression screening assessment":'73832-8' from "LOINC" display 'Adult depression screening assessment'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Follow up for Positive Adolescent Depression Screening":
	exists ( "Additional Evaluation for Depression as Follow Up for Adolescent" )
		or exists ( "Pharmacologic Depression Treatment as Follow Up for Adolescent" )
		or exists ( "Referral for Positive Adolescent Depression Screen" )
		or exists ( "Suicide Assessment as Follow Up for Adolescent" )
		or exists ( "Recommended Follow up for Positive Adolescent Depression Screen" )

define "Follow up for Positive Adult Depression Screening":
	exists ( "Additional Evaluation for Depression as Follow Up for Adult" )
		or exists ( "Pharmacologic Depression Treatment as Follow Up for Adult" )
		or exists ( "Referral for Positive Adult Depression Screen" )
		or exists ( "Suicide Assessment as Follow Up for Adult" )
		or exists ( "Recommended Follow up for Positive Adult Depression Screen" )


define "Initial Population":
	"Patient Age 12 Years or Older at Start of Measurement Period"
		and exists ( "Qualifying Encounter for Depression Screening" )

define "Has No Adult Depression Screening Due to Medical Reason":
	exists ( [Observation: "Adult depression screening assessment"] ScreeningNotPerfomedAdult
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (ScreeningNotPerfomedAdult.status.value='cancelled' or ScreeningNotPerfomedAdult.status.value='entered-in-error')
					and ScreeningNotPerfomedAdult.dataAbsentReason in "Medical or Other reason not done"
					and FHIRHelpers.ToDateTime(ScreeningNotPerfomedAdult.issued) during QualifyingEncounter.period
	)

define "Has Diagnosis of Bipolar Starting Before Qualifying Encounter":
	exists ( [Condition: "Bipolar Diagnosis"] DiagnosisBipolar
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that DiagnosisBipolar.clinicalStatus.coding[0].code = 'active'
					and Interval[FHIRHelpers.ToDateTime(DiagnosisBipolar.onset),FHIRHelpers.ToDateTime(DiagnosisBipolar.abatement)] overlaps before QualifyingEncounter.period
	)

define "Has Diagnosis of Depression Starting Before Qualifying Encounter":
	exists ( [Condition: "Depression diagnosis"] DiagnosisDepression
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that DiagnosisDepression.clinicalStatus.coding[0].code='active'
					and Interval[FHIRHelpers.ToDateTime(DiagnosisDepression.onset),FHIRHelpers.ToDateTime(DiagnosisDepression.abatement)] overlaps before QualifyingEncounter.period
	)

define "Qualifying Encounter for Depression Screening":
	[Encounter: "Depression Screening Encounter Codes"] ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Denominator Exclusions":
	"Has Diagnosis of Bipolar Starting Before Qualifying Encounter"
		or "Has Diagnosis of Depression Starting Before Qualifying Encounter"

define "Most Recent Adolescent Depression Screening Negative":
	"Most Recent Adolescent Depression Screening" RecentAdolescentScreening
		where RecentAdolescentScreening.value in "Negative Depression Screening"

define "Most Recent Adolescent Depression Screening Positive":
	"Most Recent Adolescent Depression Screening" RecentAdolescentScreening
		where RecentAdolescentScreening.value in "Positive Depression Screening"

define "Most Recent Adult Depression Screening Negative":
	"Most Recent Adult Depression Screening" RecentAdultScreening
		where RecentAdultScreening.value in "Negative Depression Screening"

define "Most Recent Adult Depression Screening Positive":
	"Most Recent Adult Depression Screening" RecentAdultScreening
		where RecentAdultScreening.value in "Positive Depression Screening"

define "Numerator":
	( "Patient Age 12 to 17 Years at Start of Measurement Period"
			and ( "Most Recent Adolescent Depression Screening Negative" is not null
					or "Follow up for Positive Adolescent Depression Screening"
			)
	)
		or ( "Patient Age 18 Years or Older at Start of Measurement Period"
				and ( "Most Recent Adult Depression Screening Negative" is not null
						or "Follow up for Positive Adult Depression Screening"
				)
		)

define "Has Adolescent Depression Screening":
	exists ( [Observation: "Adolescent depression screening assessment"] AdolescentScreening
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (AdolescentScreening.status.value = 'final' or AdolescentScreening.status.value = 'amended' or AdolescentScreening.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(AdolescentScreening.issued) 14 days or less before or on day of start of QualifyingEncounter.period
					and AdolescentScreening.value is not null
	)

define "Has Adult Depression Screening":
	exists ( [Observation: "Adult depression screening assessment"] AdultScreening
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (AdultScreening.status.value = 'final' or AdultScreening.status.value = 'amended' or AdultScreening.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(AdultScreening.issued) 14 days or less before or on day of start of QualifyingEncounter.period
					and AdultScreening.value is not null
	)

define "Most Recent Adolescent Depression Screening":
	Last([Observation: "Adolescent depression screening assessment"] LastAdolescentScreen
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (LastAdolescentScreen.status.value = 'final' or LastAdolescentScreen.status.value = 'amended' or LastAdolescentScreen.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(LastAdolescentScreen.issued) 14 days or less before or on day of start of QualifyingEncounter.period
					and LastAdolescentScreen.value is not null
			sort by FHIRHelpers.ToDateTime(issued)
	)

define "Most Recent Adult Depression Screening":
	Last([Observation: "Adult depression screening assessment"] LastAdultScreen
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (LastAdultScreen.status.value = 'final' or LastAdultScreen.status.value = 'amended' or LastAdultScreen.status.value = 'corrected')
					and FHIRHelpers.ToDateTime(LastAdultScreen.issued) 14 days or less before or on day of start of QualifyingEncounter.period
					and LastAdultScreen.value is not null
			sort by FHIRHelpers.ToDateTime(issued)
	)

define "Has No Adolescent Depression Screening Due to Patient Reason":
	exists ( [Observation: "Adolescent depression screening assessment"] ScreeningNotPerformedAdolescent
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (ScreeningNotPerformedAdolescent.status.value = 'cancelled' or ScreeningNotPerformedAdolescent.status.value = 'entered-in-error')
					and ScreeningNotPerformedAdolescent.dataAbsentReason in "Patient Reason refused"
					and FHIRHelpers.ToDateTime(ScreeningNotPerformedAdolescent.issued) during QualifyingEncounter.period
	)

define "Has No Adult Depression Screening Due to Patient Reason":
	exists ( [Observation: "Adult depression screening assessment"] ScreeningNotPerformedAdult
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (ScreeningNotPerformedAdult.status.value = 'cancelled' or ScreeningNotPerformedAdult.status.value = 'entered-in-error')
					and ScreeningNotPerformedAdult.dataAbsentReason in "Patient Reason refused"
					and FHIRHelpers.ToDateTime(ScreeningNotPerformedAdult.issued) during QualifyingEncounter.period
	)

define "Denominator Exceptions":
	( ( "Has No Adolescent Depression Screening Due to Medical Reason"
				or "Has No Adolescent Depression Screening Due to Patient Reason"
		)
			and not "Has Adolescent Depression Screening"
	)
		or ( ( "Has No Adult Depression Screening Due to Medical Reason"
					or "Has No Adult Depression Screening Due to Patient Reason"
			)
				and not "Has Adult Depression Screening"
		)

define "Patient Age 12 to 17 Years at Start of Measurement Period":
	AgeInYearsAt(start of "Measurement Period") < 18

define "Patient Age 12 Years or Older at Start of Measurement Period":
	AgeInYearsAt(start of "Measurement Period")>= 12

define "Patient Age 18 Years or Older at Start of Measurement Period":
	AgeInYearsAt(start of "Measurement Period")>= 18

define "Encounter Associated with Most Recent Positive Adolescent Depression Screening":
	"Qualifying Encounter for Depression Screening" QualifyingEncounter
		with "Most Recent Adolescent Depression Screening Positive" AdolescentScreening
			such that FHIRHelpers.ToDateTime(AdolescentScreening.issued) 14 days or less before or on day of start of QualifyingEncounter.period

define "Encounter Associated with Most Recent Positive Adult Depression Screening":
	"Qualifying Encounter for Depression Screening" QualifyingEncounter
		with "Most Recent Adult Depression Screening Positive" AdultScreening
			such that FHIRHelpers.ToDateTime(AdultScreening.issued) 14 days or less before or on day of start of QualifyingEncounter.period

define "Additional Evaluation for Depression as Follow Up for Adolescent":
	[Procedure: "Additional evaluation for depression - adolescent"] AdditionalEvalAdolescent
		with "Encounter Associated with Most Recent Positive Adolescent Depression Screening" PositiveAdolescentScreeningEncounter
			such that start of (AdditionalEvalAdolescent.performed as Period) same day as start of PositiveAdolescentScreeningEncounter.period

define "Additional Evaluation for Depression as Follow Up for Adult":
	[Procedure: "Additional evaluation for depression - adult"] AdditionalEvalAdult
		with "Encounter Associated with Most Recent Positive Adult Depression Screening" PositiveAdultScreeningEncounter
			such that start of (AdditionalEvalAdult.performed as Period) same day as start of PositiveAdultScreeningEncounter.period

define "Pharmacologic Depression Treatment as Follow Up for Adolescent":
	[MedicationRequest: "Depression medications - adolescent"] DepressionMedicationOrderAdolescent
		with "Encounter Associated with Most Recent Positive Adolescent Depression Screening" PositiveAdolescentScreeningEncounter
			such that DepressionMedicationOrderAdolescent.intent.value = 'order'
				and FHIRHelpers.ToDateTime(DepressionMedicationOrderAdolescent.authoredOn) same day as start of PositiveAdolescentScreeningEncounter.period

define "Pharmacologic Depression Treatment as Follow Up for Adult":
	[MedicationRequest: "Depression medications - adult"] MedicationOrderAdult
		with "Encounter Associated with Most Recent Positive Adult Depression Screening" PositiveAdultScreeningEncounter
			such that MedicationOrderAdult.intent.value = 'order'
				and FHIRHelpers.ToDateTime(MedicationOrderAdult.authoredOn) same day as start of PositiveAdultScreeningEncounter.period

define "Referral for Positive Adolescent Depression Screen":
	[ServiceRequest: "Referral for Depression Adolescent"] ReferralForAdolescent
		with "Encounter Associated with Most Recent Positive Adolescent Depression Screening" PositiveAdolescentScreenEncounter
			such that  ReferralForAdolescent.intent.value = 'order'
				and FHIRHelpers.ToDateTime(ReferralForAdolescent.authoredOn) same day as start of PositiveAdolescentScreenEncounter.period

define "Referral for Positive Adult Depression Screen":
	[ServiceRequest: "Referral for Depression Adult"] ReferralForAdult
		with "Encounter Associated with Most Recent Positive Adult Depression Screening" PositiveAdultScreenEncounter
			such that  ReferralForAdult.intent.value = 'order'
				and FHIRHelpers.ToDateTime(ReferralForAdult.authoredOn) same day as start of PositiveAdultScreenEncounter.period

define "Suicide Assessment as Follow Up for Adolescent":
	[Observation: "Suicide Risk Assessment"] AssessSuicideRisk
		with "Encounter Associated with Most Recent Positive Adolescent Depression Screening" PositiveAdolescentScreenEncounter
			such that (AssessSuicideRisk.status.value = 'final' or AssessSuicideRisk.status.value = 'amended' or AssessSuicideRisk.status.value = 'corrected')
				and FHIRHelpers.ToDateTime(AssessSuicideRisk.issued) same day as start of PositiveAdolescentScreenEncounter.period

define "Suicide Assessment as Follow Up for Adult":
	[Observation: "Suicide Risk Assessment"] AssessSuicideRisk
		with "Encounter Associated with Most Recent Positive Adult Depression Screening" PositiveAdultScreenEncounter
			such that (AssessSuicideRisk.status.value = 'final' or AssessSuicideRisk.status.value = 'amended' or AssessSuicideRisk.status.value = 'corrected')
				and FHIRHelpers.ToDateTime(AssessSuicideRisk.issued) same day as start of PositiveAdultScreenEncounter.period

define "Recommended Follow up for Positive Adolescent Depression Screen":
	[Procedure: "Follow-up for depression - adolescent"] FollowupAdolescent
		with "Encounter Associated with Most Recent Positive Adolescent Depression Screening" PositiveAdolescentScreenEncounter
			such that start of (FollowupAdolescent.performed as Period) same day as start of PositiveAdolescentScreenEncounter.period

define "Recommended Follow up for Positive Adult Depression Screen":
	[Procedure: "Follow-up for depression - adult"] FollowupAdult
		with "Encounter Associated with Most Recent Positive Adult Depression Screening" PositiveAdultScreenEncounter
			such that start of (FollowupAdult.performed as Period) same day as start of PositiveAdultScreenEncounter.period

define "Has No Adolescent Depression Screening Due to Medical Reason":
	exists ( [Observation: "Adolescent depression screening assessment"] ScreeningNotPerformedAdolescent
			with "Qualifying Encounter for Depression Screening" QualifyingEncounter
				such that (ScreeningNotPerformedAdolescent.status.value = 'cancelled' or ScreeningNotPerformedAdolescent.status.value = 'entered-in-error')
					and ScreeningNotPerformedAdolescent.dataAbsentReason in "Medical or Other reason not done"
					and FHIRHelpers.ToDateTime(ScreeningNotPerformedAdolescent.issued) during QualifyingEncounter.period
	)
