library IntensiveCareUnitVenousThromboembolismProphylaxis version '8.2.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include VTEICU version '3.1.000' called VTEICU
include TJC_Overall_FHIR4 version '4.0.000' called TJC

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Atrial Fibrillation/Flutter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.202'
valueset "Comfort Measures": 'urn:oid:1.3.6.1.4.1.33895.1.3.0.45'
valueset "Direct Thrombin Inhibitor": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.205'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "General or Neuraxial Anesthesia": 'urn:oid:2.16.840.1.113883.3.666.5.1743'
valueset "General Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.255'
valueset "Glycoprotein IIb/IIIa Inhibitors": 'urn:oid:2.16.840.1.113762.1.4.1045.41'
valueset "Graduated compression stockings (GCS)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.256'
valueset "Gynecological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.257'
valueset "Hip Fracture Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.258'
valueset "Hip Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.259'
valueset "Injectable Factor Xa Inhibitor for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.211'
valueset "INR": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.213'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Intermittent pneumatic compression devices (IPC)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.214'
valueset "Intracranial Neurosurgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.260'
valueset "Intravenous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.222'
valueset "Knee Replacement Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.261'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1045.39'
valueset "Low Molecular Weight Heparin for VTE Prophylaxis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.219'
valueset "Low Risk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.400'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Obstetrics": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.263'
valueset "Obstetrics VTE": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.264'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.134'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Principal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.14'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Subcutaneous route": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.223'
valueset "Unfractionated Heparin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.218'
valueset "Urological Surgery": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.272'
valueset "Venous foot pumps (VFP)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.230'
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279'
valueset "Warfarin": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.232'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Risk for venous thromboembolism": '72136-5' from "LOINC" display 'Risk for venous thromboembolism'

context Patient

define "Intervention Comfort Measures":
	[ServiceRequest: "Comfort Measures"]
		union [Procedure: "Comfort Measures"]

define "Initial Population":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions"

define "Encounter With ICU Location":
	"Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions" QualifyingEncounter
		where exists ( QualifyingEncounter.location Location
				where Location.location.type in "Intensive Care Unit"
					and Location.period during QualifyingEncounter.period
		)

define "VTE Prophylaxis by Medication Administered or Device Applied":
	( [MedicationAdministration: "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
			where VTEMedication.dosage.route in "Subcutaneous route"
	)
		union [MedicationAdministration: "Low Molecular Weight Heparin for VTE Prophylaxis"]
		union [MedicationAdministration: "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]
		union [MedicationAdministration: "Warfarin"]
		union ([Procedure: "Intermittent pneumatic compression devices (IPC)"]IPC where IPC.status = 'not-done')
		union ([Procedure: "Venous foot pumps (VFP)"]VFP where VFP.status = 'not-done')
		union ([Procedure: "Graduated compression stockings (GCS)"]GCS where GCS.status = 'not-done')

define "No VTE Prophylaxis Medication Administered or Ordered":
	([MedicationAdministration: "Low Dose Unfractionated Heparin for VTE Prophylaxis"]LDU where LDU.status = 'not-done')
		union ([MedicationAdministration: "Low Molecular Weight Heparin for VTE Prophylaxis"]LMW where LMW.status = 'not-done')
		union ([MedicationAdministration: "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]IFX where IFX.status = 'not-done')
		union ([MedicationAdministration: "Warfarin"]W where W.status = 'not-done')
		union ([MedicationRequest: "Low Dose Unfractionated Heparin for VTE Prophylaxis"]LDU where LDU.status = 'cancelled')
		union ([MedicationRequest: "Low Molecular Weight Heparin for VTE Prophylaxis"]LMW where LMW.status = 'cancelled')
		union ([MedicationRequest: "Injectable Factor Xa Inhibitor for VTE Prophylaxis"]IFX where IFX.status = 'cancelled')
		union ([MedicationRequest: "Warfarin"]WA where WA.status = 'cancelled')

define "No VTE Prophylaxis Device Applied or Ordered":
	([Procedure: "Intermittent pneumatic compression devices (IPC)"]IPC where IPC.status = 'not-done')
		union ([Procedure: "Venous foot pumps (VFP)"]VFP where VFP.status = 'not-done')
		union ([Procedure: "Graduated compression stockings (GCS)"]GCS where GCS.status = 'not-done')
		union ([ServiceRequest: "Intermittent pneumatic compression devices (IPC)"]IPC where FHIRHelpers.ToBoolean(IPC.doNotPerform) = true)
		union ([ServiceRequest: "Venous foot pumps (VFP)"]VFP where FHIRHelpers.ToBoolean(VFP.doNotPerform) = true)
		union ([ServiceRequest: "Graduated compression stockings (GCS)"]GC where FHIRHelpers.ToBoolean(GC.doNotPerform) = true)

define "Denominator":
	"Encounter With ICU Location"

define "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery":
	"Encounter With ICU Location" QualifyingEncounterICU
		with ( [Procedure: "Hip Replacement Surgery"]
			union [Procedure: "Knee Replacement Surgery"] ) HipKneeProcedure
			such that HipKneeProcedure.performed as Period starts on or before 
			end of QualifyingEncounterICU.period

define "No VTE Prophylaxis Medication or Device Due to Patient Refusal":
	( "No VTE Prophylaxis Medication Administered or Ordered"
		union "No VTE Prophylaxis Device Applied or Ordered" ) NoVTEProphylaxis
		where NoVTEProphylaxis.statusReason as CodeableConcept in "Patient Refusal"

define "Admission Without VTE or Obstetrical Conditions":
	Global."Inpatient Encounter" InpatientEncounter
		//where not ( exists ( Global."EncounterDiagnosis"(InpatientEncounter) EncounterDiagnoses
					//where ( EncounterDiagnoses.condition.reference in "Obstetrics"
							//or EncounterDiagnoses.condition.reference in "Venous Thromboembolism"
							//or EncounterDiagnoses.condition.reference in "Obstetrics VTE"
					//)
			//)
		//)

define "Encounter With First ICU Location Stay Less Than 1 day":
	"Encounter With ICU Location" QualifyingEncounterICU
		where Global."LengthInDays"(VTEICU."FirstICULocationPeriod"(QualifyingEncounterICU))< 1

define "Encounter With ICU Location And Encounter Less Than 2 Days":
	"Encounter With ICU Location" QualifyingEncounterICU
		where Global."LengthInDays"(QualifyingEncounterICU.period)< 2

define "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE":
	( "Encounter With ICU Location" QualifyingEncounterICU
			with ["Condition": "Atrial Fibrillation/Flutter"] AtrialFibrillation
				such that AtrialFibrillation.onset as Period starts on or before 
				end of QualifyingEncounterICU.period
	)
		union ( "Encounter With ICU Location" QualifyingEncounterICU
				where exists ( QualifyingEncounterICU.diagnosis QualifyingEncounterDiagnoses
						where QualifyingEncounterDiagnoses.condition.reference in "Atrial Fibrillation/Flutter"
				)
		)
		union ( "Encounter With ICU Location" QualifyingEncounterICU
				with ["Condition": "Venous Thromboembolism"] VTEDiagnosis
					such that VTEDiagnosis.onset as Period starts before start of QualifyingEncounterICU.period
		)

define "Encounter With Low Risk for VTE or Anticoagulant Administered":
	"Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay"
		union "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure"

define "Encounter With Intervention Comfort Measures on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"Intervention Comfort Measures" ComfortMeasures
		where AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and start of ComfortMeasures.occurrence as Period overlaps TJC."CalendarDayOfOrDayAfter"(end of AnesthesiaProcedure.performed as Period)
		return QualifyingEncounterICU

define "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
		where NoVTEDevice.statusReason as CodeableConcept in "Medical Reason"
			and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and NoVTEDevice.authoredOn during TJC."CalendarDayOfOrDayAfter"(
				end of AnesthesiaProcedure.performed as Period
			)
		return QualifyingEncounterICU

define "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
		where AnesthesiaProcedure.performed as Period ends 1 day after VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and PatientRefusal.authoredOn during TJC."CalendarDayOfOrDayAfter"(
				end of AnesthesiaProcedure.performed as Period
			)
		return QualifyingEncounterICU

define "Low Risk for VTE or Anticoagulant Administered on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"Is In Low Risk for VTE or On Anticoagulant" LowRiskForVTE
		where AnesthesiaProcedure.performed as Period ends 1 day after VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and LowRiskForVTE.effective as Period during TJC."CalendarDayOfOrDayAfter"(
				end of AnesthesiaProcedure.performed as Period
			)
		return QualifyingEncounterICU

define "Encounter With Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure":
	( "Encounter With ICU Location" QualifyingEncounterICU
			with ["MedicationAdministration": "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
				such that FactorXaMedication.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))
	)
		union ( from
				"Encounter With ICU Location" QualifyingEncounterICU,
				[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
				[MedicationAdministration: "Oral Factor Xa Inhibitor for VTE Prophylaxis or VTE Treatment"] FactorXaMedication
				where AnesthesiaProcedure.performed as Period ends 1 day after start of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
					and FactorXaMedication.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(
						end of AnesthesiaProcedure.performed as Period
					)
				return QualifyingEncounterICU
		)

define "No VTE Prophylaxis Device Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "No VTE Prophylaxis Device Applied or Ordered" NoVTEDevice
			such that NoVTEDevice.statusReason as CodeableConcept in "Medical Reason"
				and FHIRHelpers.ToDateTime(NoVTEDevice.performed as dateTime) during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

define "Low Risk for VTE or Anticoagulant Administered From Day of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "Is In Low Risk for VTE or On Anticoagulant" LowRiskForVTE
			such that FHIRHelpers.ToDateTime(LowRiskForVTE.effective as dateTime) during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

define "No VTE Prophylaxis Due to Patient Refusal From Day Of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "No VTE Prophylaxis Medication or Device Due to Patient Refusal" PatientRefusal
			such that FHIRHelpers.ToDateTime(PatientRefusal.authoredOn) during VTEICU.FromDayOfStartOfHospitalizationToDayAfterFirstICU(QualifyingEncounterICU)

define "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedicaion
			such that NoVTEMedicaion.statusReason as CodeableConcept in "Medical Reason"
				and FHIRHelpers.ToDateTime(NoVTEMedicaion.authoredOn) during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

define "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure":
	from
		"Encounter With ICU Location" QualifyingEncounterICU,
		[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
		"No VTE Prophylaxis Medication Administered or Ordered" NoVTEMedication
		where NoVTEMedication.statusReason as CodeableConcept in "Medical Reason"
			and AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
			and NoVTEMedication.authoredOn during TJC."CalendarDayOfOrDayAfter"(
				end of AnesthesiaProcedure.performed as Period
			)
		return QualifyingEncounterICU

define "Numerator":
	"Encounter With VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure"
		union ( "Encounter With Medication Oral Factor Xa Inhibitor Administered on Day of or Day After First ICU Stay or Procedure"
				intersect ( "Encounter With Prior or Present Diagnosis of Atrial Fibrillation or VTE"
						union "Encounter With Prior or Present Procedure of Hip or Knee Replacement Surgery"
				)
		)
		union "Encounter With Low Risk for VTE or Anticoagulant Administered"
		union "Encounter With No VTE Prophylaxis Due to Medical Reason"
		union "Encounter With No VTE Prophylaxis Due to Patient Refusal"

define "Encounter With No VTE Prophylaxis Due to Medical Reason":
	( "No VTE Prophylaxis Medication Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay"
			intersect "No VTE Prophylaxis Device Due to Medical Reason From Day Of Start of Hospitalization To Day After First ICU Stay"
	)
		union ( "No VTE Prophylaxis Medication Due to Medical Reason on Day of or Day After Procedure"
				intersect "No VTE Prophylaxis Device Due to Medical Reason on Day of or Day After Procedure"
		)

define "Encounter With No VTE Prophylaxis Due to Patient Refusal":
	"No VTE Prophylaxis Due to Patient Refusal From Day Of Start of Hospitalization To Day After First ICU Stay"
		union "No VTE Prophylaxis Due to Patient Refusal on Day of or Day After Procedure"

define "Denominator Exception":
	"Encounter With First ICU Location Stay Less Than 1 day"

define "Encounter With Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay":
	"Encounter With ICU Location" QualifyingEncounterICU
		with "Intervention Comfort Measures" ComfortMeasures
			such that Coalesce(start of ComfortMeasures.effective as Period, ComfortMeasures.authoredOn)during VTEICU."FromDayOfStartOfHospitalizationToDayAfterFirstICU"(QualifyingEncounterICU)

define "Encounter With VTE Prophylaxis Received on Day of or Day After First ICU Stay or Procedure":
	( "Encounter With ICU Location" QualifyingEncounterICU
			with "VTE Prophylaxis by Medication Administered or Device Applied" VTEProphylaxis
				such that VTEProphylaxis.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))
	)
		union ( from
				"Encounter With ICU Location" QualifyingEncounterICU,
				[Procedure: "General or Neuraxial Anesthesia"] AnesthesiaProcedure,
				"VTE Prophylaxis by Medication Administered or Device Applied" VTEProphylaxis
				where AnesthesiaProcedure.performed as Period ends 1 day after day of VTEICU."StartOfFirstICU"(QualifyingEncounterICU)
					and VTEProphylaxis.effective as Period starts during TJC."CalendarDayOfOrDayAfter"(
						end of AnesthesiaProcedure.performed as Period
					)
				return QualifyingEncounterICU
		)

define "Encounter With Age Range and Without VTE Diagnosis or Obstetrical Conditions":
	( Global."Inpatient Encounter" InpatientEncounter
			with [Patient:"Birth date"] BirthDate
				such that AgeInYearsAt(start of InpatientEncounter.period)>= 18
	)
		intersect "Admission Without VTE or Obstetrical Conditions"

define "Is In Low Risk for VTE or On Anticoagulant":
	( [Observation: "Risk for venous thromboembolism"] VTERiskAssessment
			where VTERiskAssessment.value as CodeableConcept in "Low Risk"
	)
		union ( [Observation: "INR"] INRLabTest
				where INRLabTest.value as Quantity > 3.0
				//return "Observation" { id: INRLabTest.id, issued: INRLabTest.issued }
		)
		union ( ( ( [MedicationAdministration: "Unfractionated Heparin"] UnfractionatedHeparin
					where UnfractionatedHeparin.dosage.route in "Intravenous route"
			)
				union [MedicationAdministration: "Direct Thrombin Inhibitor"]
				union [MedicationAdministration: "Glycoprotein IIb/IIIa Inhibitors"] ) AnticoagulantMedication
				//return Observation { id: AnticoagulantMedication.id, issued: start of AnticoagulantMedication.effective as Period }
		)

define "Encounter With First ICU Stay With Principal Procedure of SCIP VTE Selected Surgery":
	"Encounter With ICU Location" QualifyingEncounterICU
		with ( "SCIP VTE Selected Surgery" Procedure
			where Procedure.ordinality in "Principal" ) SelectedSCIPProcedure
			such that SelectedSCIPProcedure.performed as Period ends during TJC."CalendarDayOfOrDayAfter"(VTEICU."StartOfFirstICU"(QualifyingEncounterICU))

define "Denominator Exclusions":
	"Encounter With ICU Location And Encounter Less Than 2 Days"
		union "Encounter With First ICU Stay With Principal Procedure of SCIP VTE Selected Surgery"
		union "Encounter With Intervention Comfort Measures From Day Of Start of Hospitalization To Day After First ICU Stay"
		union "Encounter With Intervention Comfort Measures on Day of or Day After Procedure"

define "SCIP VTE Selected Surgery":
	//'SCIP' stands for surgical care improvement Project
	[Procedure: "General Surgery"]
		union [Procedure: "Gynecological Surgery"]
		union [Procedure: "Hip Fracture Surgery"]
		union [Procedure: "Hip Replacement Surgery"]
		union [Procedure: "Intracranial Neurosurgery"]
		union [Procedure: "Knee Replacement Surgery"]
		union [Procedure: "Urological Surgery"]
