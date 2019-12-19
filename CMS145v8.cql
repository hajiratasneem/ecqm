library CoronaryArteryDiseaseCADBetaBlockerTherapyPriorMyocardialInfarctionMIorLeftVentricularSystolicDysfunctionLVEF40 version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Allergy to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1177'
valueset "Arrhythmia": 'urn:oid:2.16.840.1.113883.3.526.3.366'
valueset "Asthma": 'urn:oid:2.16.840.1.113883.3.526.3.362'
valueset "Atrioventricular Block": 'urn:oid:2.16.840.1.113883.3.526.3.367'
valueset "Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1174'
valueset "Beta Blocker Therapy for LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1184'
valueset "Beta Blocker Therapy Ingredient": 'urn:oid:2.16.840.1.113883.3.526.3.1493'
valueset "Bradycardia": 'urn:oid:2.16.840.1.113883.3.526.3.412'
valueset "Cardiac Pacer": 'urn:oid:2.16.840.1.113883.3.526.3.1193'
valueset "Cardiac Pacer in Situ": 'urn:oid:2.16.840.1.113883.3.526.3.368'
valueset "Cardiac Surgery": 'urn:oid:2.16.840.1.113883.3.526.3.371'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Coronary Artery Disease No MI": 'urn:oid:2.16.840.1.113883.3.526.3.369'
valueset "Ejection Fraction": 'urn:oid:2.16.840.1.113883.3.526.3.1134'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Rate": 'urn:oid:2.16.840.1.113883.3.526.3.1176'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hypotension": 'urn:oid:2.16.840.1.113883.3.526.3.370'
valueset "Intolerance to Beta Blocker Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.1178'
valueset "Left Ventricular Systolic Dysfunction": 'urn:oid:2.16.840.1.113883.3.526.3.1091'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Moderate or Severe": 'urn:oid:2.16.840.1.113883.3.526.3.1092'
valueset "Moderate or Severe LVSD": 'urn:oid:2.16.840.1.113883.3.526.3.1090'
valueset "Myocardial Infarction": 'urn:oid:2.16.840.1.113883.3.526.3.403'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Patient Provider Interaction": 'urn:oid:2.16.840.1.113883.3.526.3.1012'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "System Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1009'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Face to Face Encounter During Measurement Period":
	( [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Nursing Facility Visit"] ) FaceToFaceEncounter
		where (FaceToFaceEncounter.status.value='in-progress' or FaceToFaceEncounter.status.value='finished')
            		    and FaceToFaceEncounter.period during "Measurement Period"

define "Qualifying CAD Encounter":
	"Coronary Artery Disease Encounter"
		union "History of Cardiac Surgery"

define "Qualifying CAD Encounter and Moderate or Severe LVSD":
	"Qualifying CAD Encounter" EncounterWithCADProxy
		with "Other Diagnosis" LVSDFindings
			such that Interval[FHIRHelpers.ToDateTime(LVSDFindings.onset),FHIRHelpers.ToDateTime(LVSDFindings.abatement)] starts before end of EncounterWithCADProxy.period
				or (LVSDFindings.effective as Period) starts before end of EncounterWithCADProxy.period

define "Other Diagnosis":
	( [Observation : "Ejection Fraction"] EjectionFraction
				where (EjectionFraction.status.value='final' or EjectionFraction.status.value='amended' or EjectionFraction.status.value='corrected')
				    and FHIRHelpers.ToInteger(EjectionFraction.value)< 40 '%'
				)
			union ([Condition: "Moderate or Severe LVSD"]D where D.clinicalStatus.coding[0].code='active')
			union ( [Condition: "Left Ventricular Systolic Dysfunction"] LVSD
					where LVSD.clinicalStatus.coding[0].code='active' and LVSD.severity in "Moderate or Severe"
			)

define "Arrhythmia with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Arrhythmia"] Arrhythmia
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that Arrhythmia.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Arrhythmia.onset),FHIRHelpers.ToDateTime(Arrhythmia.abatement)] overlaps CADEncounterModerateOrSevereLVSD.period

define "Arrhythmia with Qualifying CAD Encounter and Prior MI":
	[Condition: "Arrhythmia"] Arrhythmia
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that Arrhythmia.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Arrhythmia.onset),FHIRHelpers.ToDateTime(Arrhythmia.abatement)] overlaps CADEncounterMI.period

define "Asthma with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Asthma"] Asthma
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that Asthma.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Asthma.onset),FHIRHelpers.ToDateTime(Asthma.abatement)] overlaps CADEncounterModerateOrSevereLVSD.period

define "Asthma with Qualifying CAD Encounter and Prior MI":
	[Condition: "Asthma"] Asthma
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that Asthma.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Asthma.onset),FHIRHelpers.ToDateTime(Asthma.abatement)] overlaps CADEncounterMI.period

define "Atrioventricular Block with Qualifying CAD Encounter and Prior MI":
	[Condition: "Atrioventricular Block"] AtrioventricularBlock
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that AtrioventricularBlock.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(AtrioventricularBlock.onset),FHIRHelpers.ToDateTime(AtrioventricularBlock.abatement)] overlaps CADEncounterMI.period

define "Beta Blocker Therapy for LVSD Ordered":
	[MedicationRequest: "Beta Blocker Therapy for LVSD"] BetaBlockerForLVSDOrdered
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that BetaBlockerForLVSDOrdered.intent.value='order'
			and FHIRHelpers.ToDateTime(BetaBlockerForLVSDOrdered.authoredOn) during CADEncounterModerateOrSevereLVSD.period

define "Beta Blocker Therapy Ordered":
	[MedicationRequest: "Beta Blocker Therapy"] BetaBlockerOrdered
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that BetaBlockerOrdered.intent.value='order'
			and FHIRHelpers.ToDateTime(BetaBlockerOrdered.authoredOn) during CADEncounterMI.period

define "Bradycardia with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Bradycardia"] Bradycardia
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that Bradycardia.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Bradycardia.onset),FHIRHelpers.ToDateTime(Bradycardia.abatement)] overlaps CADEncounterModerateOrSevereLVSD.period

define "Bradycardia with Qualifying CAD Encounter and Prior MI":
	[Condition: "Bradycardia"] Bradycardia
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that Bradycardia.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Bradycardia.onset),FHIRHelpers.ToDateTime(Bradycardia.abatement)] overlaps CADEncounterMI.period

define "Hypotension with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Hypotension"] Hypotension
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that Hypotension.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Hypotension.onset),FHIRHelpers.ToDateTime(Hypotension.abatement)] overlaps CADEncounterModerateOrSevereLVSD.period

define "Hypotension with Qualifying CAD Encounter and Prior MI":
	[Condition: "Hypotension"] Hypotension
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that Hypotension.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(Hypotension.onset),FHIRHelpers.ToDateTime(Hypotension.abatement)] overlaps CADEncounterMI.period

define "Numerator 1":
	exists "Beta Blocker Therapy for LVSD Ordered"
		or exists "Currently Taking Beta Blocker Therapy for LVSD"

define "Numerator 2":
	exists "Beta Blocker Therapy Ordered"
		or exists "Currently Taking Beta Blocker Therapy"

define "Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[AllergyIntolerance: "Beta Blocker Therapy Ingredient"] BetaBlockerAllergyIntolerance
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that (BetaBlockerAllergyIntolerance.onset as Period) overlaps after CADEncounterModerateOrSevereLVSD.period

define "Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Prior MI":
	[AllergyIntolerance: "Beta Blocker Therapy Ingredient"] BetaBlockerAllergyIntolerance
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that (BetaBlockerAllergyIntolerance.onset as Period) overlaps after CADEncounterMI.period

define "Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Procedure : "Cardiac Pacer"] ImplantedCardiacPacer
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that ImplantedCardiacPacer.status.value='completed' and (ImplantedCardiacPacer.performed as Period) overlaps after CADEncounterModerateOrSevereLVSD.period

define "Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Prior MI":
	[Procedure : "Cardiac Pacer"] ImplantedCardiacPacer
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that ImplantedCardiacPacer.status.value='completed' and (ImplantedCardiacPacer.performed as Period) overlaps after CADEncounterMI.period

define "Currently Taking Beta Blocker Therapy":
	[MedicationStatement : "Beta Blocker Therapy"] ActiveBetaBlocker
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that ActiveBetaBlocker.status.value='active'
			and (ActiveBetaBlocker.effective as Period) overlaps after CADEncounterMI.period

define "Currently Taking Beta Blocker Therapy for LVSD":
	[MedicationStatement : "Beta Blocker Therapy for LVSD"] ActiveBetaBlockerForLVSD
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that ActiveBetaBlockerForLVSD.status.value='active'
			and (ActiveBetaBlockerForLVSD.effective as Period) overlaps after CADEncounterModerateOrSevereLVSD.period

define "Diagnosis of Allergy to Beta Blocker Therapy with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Allergy to Beta Blocker Therapy"] BetaBlockerAllergyDiagnosis
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that BetaBlockerAllergyDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(BetaBlockerAllergyDiagnosis.onset),FHIRHelpers.ToDateTime(BetaBlockerAllergyDiagnosis.abatement)] overlaps after CADEncounterModerateOrSevereLVSD.period

define "Diagnosis of Allergy to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI":
	[Condition: "Allergy to Beta Blocker Therapy"] BetaBlockerAllergyDiagnosis
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that BetaBlockerAllergyDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(BetaBlockerAllergyDiagnosis.onset),FHIRHelpers.ToDateTime(BetaBlockerAllergyDiagnosis.abatement)] overlaps after CADEncounterMI.period

define "Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that CardiacPacerDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(CardiacPacerDiagnosis.onset),FHIRHelpers.ToDateTime(CardiacPacerDiagnosis.abatement)] overlaps after CADEncounterModerateOrSevereLVSD.period

define "Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Prior MI":
	[Condition: "Cardiac Pacer in Situ"] CardiacPacerDiagnosis
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that CardiacPacerDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(CardiacPacerDiagnosis.onset),FHIRHelpers.ToDateTime(CardiacPacerDiagnosis.abatement)] overlaps after CADEncounterMI.period

define "Diagnosis of Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Intolerance to Beta Blocker Therapy"] BetaBlockerIntoleranceDiagnosis
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that BetaBlockerIntoleranceDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(BetaBlockerIntoleranceDiagnosis.onset),FHIRHelpers.ToDateTime(BetaBlockerIntoleranceDiagnosis.abatement)] overlaps after CADEncounterModerateOrSevereLVSD.period

define "Diagnosis of Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI":
	[Condition: "Intolerance to Beta Blocker Therapy"] BetaBlockerIntoleranceDiagnosis
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that BetaBlockerIntoleranceDiagnosis.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(BetaBlockerIntoleranceDiagnosis.onset),FHIRHelpers.ToDateTime(BetaBlockerIntoleranceDiagnosis.abatement)] overlaps after CADEncounterMI.period

define "Qualifying Encounter":
	( [Encounter: "Office Visit"]
		union [Encounter: "Outpatient Consultation"]
		union [Encounter: "Nursing Facility Visit"]
		union [Encounter: "Care Services in Long-Term Residential Facility"]
		union [Encounter: "Home Healthcare Services"]
		union [Encounter: "Patient Provider Interaction"] ) ValidEncounter
		where (ValidEncounter.status.value='in-progress' or ValidEncounter.status.value='finished')
		            and ValidEncounter.period during "Measurement Period"

define "Qualifying CAD Encounter and Prior MI":
	"Qualifying CAD Encounter" EncounterWithCADProxy
		with [Condition: "Myocardial Infarction"] MyocardialInfarction
			such that MyocardialInfarction.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(MyocardialInfarction.onset),FHIRHelpers.ToDateTime(MyocardialInfarction.abatement)] ends 3 years or less before day of start of EncounterWithCADProxy.period

define "Denominator 1":
	"Initial Population"
		and exists "Qualifying CAD Encounter and Moderate or Severe LVSD"

define "Denominator 2":
	"Initial Population"
		and exists "Qualifying CAD Encounter and Prior MI"

define "Atrioventricular Block with Qualifying CAD Encounter and Prior MI without Cardiac Pacer":
	exists "Atrioventricular Block with Qualifying CAD Encounter and Prior MI"
		and not exists "Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Prior MI"
		and not exists "Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Prior MI"

define "Atrioventricular Block with Qualifying CAD Encounter and Moderate or Severe LVSD":
	[Condition: "Atrioventricular Block"] AtrioventricularBlock
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that AtrioventricularBlock.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(AtrioventricularBlock.onset),FHIRHelpers.ToDateTime(AtrioventricularBlock.abatement)] overlaps CADEncounterModerateOrSevereLVSD.period

define "Atrioventricular Block with Qualifying CAD Encounter and Moderate or Severe LVSD without Cardiac Pacer":
	exists "Atrioventricular Block with Qualifying CAD Encounter and Moderate or Severe LVSD"
		and not exists "Diagnosis of Cardiac Pacer in Situ with Qualifying CAD Encounter and Moderate or Severe LVSD"
		and not exists "Cardiac Pacer Device Implanted with Qualifying CAD Encounter and Moderate or Severe LVSD"

define "History of Cardiac Surgery":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with [Procedure: "Cardiac Surgery"] CardiacSurgery
			such that CardiacSurgery.status.value='completed'
				and (CardiacSurgery.performed as Period) starts before end of ValidFaceToFaceEncounter.period

define "Coronary Artery Disease Encounter":
	"Face to Face Encounter During Measurement Period" ValidFaceToFaceEncounter
		with [Condition: "Coronary Artery Disease No MI"] CoronaryArteryDisease
			such that CoronaryArteryDisease.clinicalStatus.coding[0].code='active' 
				and Interval[FHIRHelpers.ToDateTime(CoronaryArteryDisease.onset),FHIRHelpers.ToDateTime(CoronaryArteryDisease.abatement)] overlaps ValidFaceToFaceEncounter.period

define "Denominator Exceptions 1":
	exists "Arrhythmia with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Asthma with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Bradycardia with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Hypotension with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Diagnosis of Allergy to Beta Blocker Therapy with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Diagnosis of Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Moderate or Severe LVSD"
		or exists "Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD"
		or "Atrioventricular Block with Qualifying CAD Encounter and Moderate or Severe LVSD without Cardiac Pacer"

define "Denominator Exceptions 2":
	exists "Arrhythmia with Qualifying CAD Encounter and Prior MI"
		or exists "Asthma with Qualifying CAD Encounter and Prior MI"
		or exists "Bradycardia with Qualifying CAD Encounter and Prior MI"
		or exists "Hypotension with Qualifying CAD Encounter and Prior MI"
		or exists "Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Prior MI"
		or exists "Allergy or Intolerance to Beta Blocker Therapy Ingredient with Qualifying CAD Encounter and Prior MI"
		or exists "Diagnosis of Allergy to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI"
		or exists "Diagnosis of Intolerance to Beta Blocker Therapy with Qualifying CAD Encounter and Prior MI"
		or exists "Medical Patient or System Reason for Not Ordering Beta Blocker Therapy"
		or "Atrioventricular Block with Qualifying CAD Encounter and Prior MI without Cardiac Pacer"

define "Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Moderate or Severe LVSD":
	from
		[Observation : "Heart Rate"] HeartRate,
		"Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
		let PriorHeartRate: Last([Observation : "Heart Rate"] MostRecentPriorHeartRate
				where (MostRecentPriorHeartRate.effective as Period) during CADEncounterModerateOrSevereLVSD.period
					and (MostRecentPriorHeartRate.effective as Period) starts before start of (HeartRate.effective as Period)
				sort by start of (effective as Period)
		)
		where (HeartRate.effective as Period) during CADEncounterModerateOrSevereLVSD.period
			and FHIRHelpers.ToInteger(HeartRate.value) < 50 '{Beats}/min'
			and FHIRHelpers.ToInteger(PriorHeartRate.value) < 50 '{Beats}/min'

define "Consecutive Heart Rates Less than 50 with Qualifying CAD Encounter and Prior MI":
	from
		[Observation : "Heart Rate"] HeartRate,
		"Qualifying CAD Encounter and Prior MI" CADEncounterMI
		let PriorHeartRate: Last([Observation : "Heart Rate"] MostRecentPriorHeartRate
				where (MostRecentPriorHeartRate.effective as Period) during CADEncounterMI.period
					and (MostRecentPriorHeartRate.effective as Period) starts before start of (HeartRate.effective as Period)
				sort by start of (effective as Period)
		)
		where (HeartRate.effective as Period) during CADEncounterMI.period
			and FHIRHelpers.ToInteger(HeartRate.value) < 50 '{Beats}/min'
			and FHIRHelpers.ToInteger(PriorHeartRate.value) < 50 '{Beats}/min'

define "Medical Patient or System Reason for Not Ordering Beta Blocker for LVSD":
	[MedicationRequest: "Beta Blocker Therapy for LVSD"] NoBetaBlockerForLVSDOrdered
		with "Qualifying CAD Encounter and Moderate or Severe LVSD" CADEncounterModerateOrSevereLVSD
			such that NoBetaBlockerForLVSDOrdered.intent.value!='order'
			and FHIRHelpers.ToBoolean(NoBetaBlockerForLVSDOrdered.doNotPerform) =true 
			and FHIRHelpers.ToDateTime(NoBetaBlockerForLVSDOrdered.authoredOn) during CADEncounterModerateOrSevereLVSD.period
		where ( NoBetaBlockerForLVSDOrdered.reasonCode in "Medical Reason"
				or NoBetaBlockerForLVSDOrdered.reasonCode in "Patient Reason"
				or NoBetaBlockerForLVSDOrdered.reasonCode in "System Reason"
		)

define "Medical Patient or System Reason for Not Ordering Beta Blocker Therapy":
	[MedicationRequest: "Beta Blocker Therapy"] NoBetaBlockerOrdered
		with "Qualifying CAD Encounter and Prior MI" CADEncounterMI
			such that NoBetaBlockerOrdered.intent.value!='order'
			and FHIRHelpers.ToBoolean(NoBetaBlockerOrdered.doNotPerform) =true 
			and FHIRHelpers.ToDateTime(NoBetaBlockerOrdered.authoredOn) during CADEncounterMI.period
		where ( NoBetaBlockerOrdered.reasonCode in "Medical Reason"
				or NoBetaBlockerOrdered.reasonCode in "Patient Reason"
				or NoBetaBlockerOrdered.reasonCode in "System Reason"
		)

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period")>= 18
		and Count("Qualifying Encounter")>= 2
		and ( exists "Qualifying CAD Encounter" )