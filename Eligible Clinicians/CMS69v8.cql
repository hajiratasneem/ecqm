library BMIScreeningandFollowupPlan version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'
codesystem "RXNORM" : 'http://www.nlm.nih.gov/research/umls/rxnorm'

valueset "Above Normal Follow-up":'2.16.840.1.113883.3.600.1.1525'
valueset "Above Normal Medications":'2.16.840.1.113883.3.600.1.1498'
valueset "Below Normal Follow up":'2.16.840.1.113883.3.600.1.1528'
valueset "Below Normal Medications":'2.16.840.1.113883.3.600.1.1499'
valueset "BMI Encounter Code Set":'2.16.840.1.113883.3.600.1.1751'
valueset "Ethnicity":'2.16.840.1.114222.4.11.837'
valueset "Medical or Other reason not done":'2.16.840.1.113883.3.600.1.1502'
valueset "ONC Administrative Sex":'2.16.840.1.113762.1.4.1'
valueset "Overweight or Obese":'2.16.840.1.113762.1.4.1047.502'
valueset "Palliative care encounter":'2.16.840.1.113883.3.600.1.1575'
valueset "Palliative or Hospice Care":'2.16.840.1.113883.3.600.1.1579'
valueset "Patient Reason refused":'2.16.840.1.113883.3.600.791'
valueset "Payer":'2.16.840.1.114222.4.11.3591'
valueset "Pregnancy Dx":'2.16.840.1.113883.3.600.1.1623'
valueset "Race":'2.16.840.1.114222.4.11.836'
valueset "Referrals where weight assessment may occur":'2.16.840.1.113883.3.600.1.1527'
valueset "Underweight":'2.16.840.1.113883.3.600.2388'


code "Birth date":'21112-8' from "LOINC" display 'Birth date'
code "Body mass index (BMI) [Ratio]":'39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Pregnancy During Measurement Period":
	[Condition: "Pregnancy Dx"] Pregnancy
		where Pregnancy.clinicalStatus.coding[0].code='active'
				and Interval[FHIRHelpers.ToDateTime(Pregnancy.onset),FHIRHelpers.ToDateTime(Pregnancy.abatement)] overlaps "Measurement Period"

define "Numerator":
	"Has Normal BMI" is not null
		or "Has High BMI with Follow Up"
		or "Has Low BMI with Follow Up"

define "Denominator Exceptions":
	exists ( "No BMI Due to Medical Reason" )
		or exists ( "No Medication Order For High BMI Due to Medical Reason" )
		or exists ( "No Follow Up For High BMI Due to Medical Reason" )
		or exists ( "No Medication Order For Low BMI Due to Medical Reason" )
		or exists ( "No Follow Up For Low BMI Due to Medical Reason" )
		or exists ( "No BMI Referral Due to Medical Reason" )

define "Has Normal BMI":
	"Most Recent Documented BMI" BMIValue
		where FHIRHelpers.ToInteger(BMIValue.value) included in Interval[18.5 'kg/m2', 25 'kg/m2' )

define "Palliative Care Encounter Performed":
	[Encounter: "Palliative care encounter"] PalliativeCareEncounter
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that (PalliativeCareEncounter.status.value='in-progress' or PalliativeCareEncounter.status.value='finished')
		            and PalliativeCareEncounter.period starts on or before
			end of QualifyingEncounter.period

define "No BMI Due to Patient Refusal":
	[Observation: "Body mass index (BMI) [Ratio]"] NoBMI
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that (NoBMI.status.value = 'cancelled' or NoBMI.status.value = 'entered-in-error')
					and NoBMI.dataAbsentReason in "Patient Reason refused"
				and FHIRHelpers.ToDateTime(NoBMI.issued) during QualifyingEncounter.period

define "Has High BMI with Follow Up":
	FHIRHelpers.ToInteger(Last([Observation: "Body mass index (BMI) [Ratio]"] LastBMI
			with "High BMI Follow Up Encounters" HighBMIEncounter
				such that (LastBMI.effective as Period) starts 12 months or less on or before
				end of HighBMIEncounter.period
			sort by FHIRHelpers.ToDateTime(issued)
	).value) >= 25 'kg/m2'

define "Has Low BMI with Follow Up":
	FHIRHelpers.ToInteger(Last([Observation: "Body mass index (BMI) [Ratio]"] LastBMI
			with "Low BMI Follow Up Encounters" LowBMIEncounter
				such that (LastBMI.effective as Period) starts 12 months or less on or before
				end of LowBMIEncounter.period
			sort by FHIRHelpers.ToDateTime(issued)
	).value) < 18.5 'kg/m2'

define "No BMI Due to Medical Reason":
	[Observation: "Body mass index (BMI) [Ratio]"] NoBMI
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that (NoBMI.status.value = 'cancelled' or NoBMI.status.value = 'entered-in-error')
					and NoBMI.dataAbsentReason in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(NoBMI.issued) 12 months or less on or before day of start of QualifyingEncounter.period

define "No BMI Referral Due to Medical Reason":
	[ServiceRequest: "Referrals where weight assessment may occur"] NoReferral
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that NoReferral.intent.value!='order'
				and FHIRHelpers.ToBoolean(NoReferral.doNotPerform) =true
				and "NoSR"(NoReferral) in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(NoReferral.authoredOn) 12 months or less on or before day of start of QualifyingEncounter.period

define "No Medication Order For High BMI Due to Medical Reason":
	[MedicationRequest: "Above Normal Medications"] HighBMINoMedications
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that HighBMINoMedications.intent.value!='order'
				and FHIRHelpers.ToBoolean(HighBMINoMedications.doNotPerform) =true
				and HighBMINoMedications.reasonCode in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(HighBMINoMedications.authoredOn) 12 months or less on or before day of start of QualifyingEncounter.period

define "No Medication Order For Low BMI Due to Medical Reason":
	[MedicationRequest: "Below Normal Medications"] LowBMINoMedications
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that LowBMINoMedications.intent.value!='order'
				and FHIRHelpers.ToBoolean(LowBMINoMedications.doNotPerform) =true
				and LowBMINoMedications.reasonCode in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(LowBMINoMedications.authoredOn) 12 months or less on or before day of start of QualifyingEncounter.period

define "Most Recent Documented BMI":
	Last([Observation: "Body mass index (BMI) [Ratio]"] LastBMI
			with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
				such that ((LastBMI.effective as Period) starts 12 months or less on or before start of QualifyingEncounter.period
						or (LastBMI.effective as Period) starts during QualifyingEncounter.period
				)
					and LastBMI.value is not null
			sort by FHIRHelpers.ToDateTime(issued)
	)

define "Initial Population":
	exists ( "Qualifying Encounters During the Measurement Period" )

define "High BMI Follow Up Encounters":
	"Qualifying Encounters During the Measurement Period" QualifyingEncounter
		with ( ([ServiceRequest: "Above Normal Follow-up"]SR where SR.intent.value='order')
			union [Procedure: "Above Normal Follow-up"]
			union ( [ServiceRequest: "Referrals where weight assessment may occur"] Referral
					where Referral.intent.value='order' and Referral.reasonCode in "Overweight or Obese"
			)
			union ([MedicationRequest: "Above Normal Medications"] MR where MR.intent.value='order')) HighBMIInterventions
			such that Coalesce(start of (HighBMIInterventions.occurrence as Period), FHIRHelpers.ToDateTime(HighBMIInterventions.authoredOn))12 months or less on or before
			end of QualifyingEncounter.period

define "Low BMI Follow Up Encounters":
	"Qualifying Encounters During the Measurement Period" QualifyingEncounter
		with (([ServiceRequest: "Below Normal Follow up"]SR where SR.intent.value='order')
			union [Procedure: "Below Normal Follow up"]
			union ( [ServiceRequest: "Referrals where weight assessment may occur"] Referral
					where Referral.intent.value='order' and Referral.reasonCode in "Underweight")
			union ([MedicationRequest: "Below Normal Medications"]MR where MR.intent.value='order')
			) LowBMIInterventions
			such that Coalesce(start of (LowBMIInterventions.occurrence as Period), FHIRHelpers.ToDateTime(LowBMIInterventions.authoredOn))12 months or less on or before
			end of QualifyingEncounter.period

define "No Follow Up For High BMI Due to Medical Reason":
	( ([ServiceRequest: "Above Normal Follow-up"]SR where SR.intent.value!='order' and FHIRHelpers.ToBoolean(SR.doNotPerform) =true)
		union ([Procedure: "Above Normal Follow-up"]P where P.status.value!='in-progress' and P.status.value!='completed') ) HighBMINoFollowup
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that "NoSR"(HighBMINoFollowup) in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(HighBMINoFollowup.authoredOn) 12 months or less on or before day of start of QualifyingEncounter.period

define "Denominator Exclusions":
	exists ( "Palliative or Hospice Care Order or Encounter" )
		or exists ( "No BMI Due to Patient Refusal" )
		or exists ( "Pregnancy During Measurement Period" )

define "Palliative or Hospice Care Order or Encounter":
	"Palliative or Hospice Care Ordered"
		union "Palliative Care Encounter Performed"

define "Qualifying Encounters During the Measurement Period":
	[Encounter: "BMI Encounter Code Set"] BMIEncounter
		 where (BMIEncounter.status.value='in-progress' or BMIEncounter.status.value='finished')
		            and AgeInYearsAt(start of BMIEncounter.period)>= 18
		and BMIEncounter.period during "Measurement Period"
		sort by start of period

define "No Follow Up For Low BMI Due to Medical Reason":
	( ([ServiceRequest: "Below Normal Follow up"]SR where SR.intent.value!='order' and FHIRHelpers.ToBoolean(SR.doNotPerform) =true)
		union [Procedure: "Below Normal Follow up"]P where P.status.value='not-done' ) LowBMINoFollowUp
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that "NoSR"(LowBMINoFollowUp) in "Medical or Other reason not done"
				and FHIRHelpers.ToDateTime(LowBMINoFollowUp.authoredOn) 12 months or less on or before day of start of QualifyingEncounter.period

define "Palliative or Hospice Care Ordered":
	[ServiceRequest: "Palliative or Hospice Care"] PalliativeOrHospiceCareOrder
		with "Qualifying Encounters During the Measurement Period" QualifyingEncounter
			such that PalliativeOrHospiceCareOrder.intent.value='order'
				and FHIRHelpers.ToDateTime(PalliativeOrHospiceCareOrder.authoredOn) on or before
			end of QualifyingEncounter.period

define function "NoSR"(SR ServiceRequest):
	(singleton from (SR.extension e where e.url='http://hl7.org/fhir/StructureDefinition/request-statusReason')).value as Coding

