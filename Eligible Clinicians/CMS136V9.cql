library FollowUpCareforChildrenPrescribedADHDMedicationADD version '9.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

include Hospice_FHIR4 version '1.0.000' called Hospice
include MATGlobalCommonFunctions_FHIR4 version '4.0.000'


codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'http://snomed.info/sct'


valueset "ADHD Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1171'
valueset "Ambulatory": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1003'
valueset "Behavioral Health Follow-up Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1054'
valueset "Discharge Services- Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1039'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Mental Health Diagnoses": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1004'
valueset "Narcolepsy": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychotherapy and Pharmacologic Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1055'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Substance Abuse": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1004'
valueset "Telehealth Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1031'
valueset "Telephone Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1053'
valueset "Hospice care ambulatory":'2.16.840.1.113762.1.4.1108.15'


code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'


parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
	"Initial Population 1"

define "Denominator 2":
	"Initial Population 2"

define "Qualifying Encounter":
	( ([Encounter: "Office Visit"]OV where OV.status.value='in-progress' or OV.status.value='finished')
		union ([Encounter: "Home Healthcare Services"]HHS where HHS.status.value ='in-progress' or HHS.status.value='finished')
		union ([Encounter: "Preventive Care, Established Office Visit, 0 to 17"]PC where PC.status.value ='in-progress' or PC.status.value='finished')
		union ([Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]PCS where PCS.status.value ='in-progress' or PCS.status.value='finished')) ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Qualifying Numerator Encounter":
	( ([Encounter: "Office Visit"]OV where OV.status.value= 'in-progress' or OV.status.value='finished')
			union ([Encounter: "Hospital Observation Care - Initial"]HOC where HOC .status.value = 'in-progress' or HOC.status.value='finished' )
			union ([Encounter: "Preventive Care Services - Group Counseling"]PCS where PCS.status.value = 'in-progress' or PCS.status.value='finished')
			union ([Encounter: "Behavioral Health Follow-up Visit"]BHF where BHF.status.value = 'in-progress' or BHF.status.value='finished')
			union ([Encounter: "Preventive Care Services-Individual Counseling"]PCS where PCS.status.value = 'in-progress' or PCS.status.value='finished')
			//union ( [Encounter: "Psychotherapy and Pharmacologic Management"] PsychPharmMgmt
					//where exists ( PsychPharmMgmt.facilityLocations Location
							//where Location.code in "Ambulatory"
					//)
			//)
			union ([Encounter: "Discharge Services- Observation Care"]DS where DS.status.value = 'in-progress' or DS.status.value='finished')
			union ([Encounter: "Outpatient Consultation"]OC where OC.status.value = 'in-progress' or OC.status.value='finished')
			union ([Encounter: "Home Healthcare Services"]HHS where HHS.status.value = 'in-progress' or HHS.status.value='finished')
			union ([Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]IOV where IOV.status.value = 'in-progress' or IOV.status.value='finished')
			union ([Encounter: "Preventive Care, Established Office Visit, 0 to 17"]EOF where EOF.status.value = 'in-progress' or EOF.status.value='finished')
			union ([Encounter: "Psych Visit - Diagnostic Evaluation"]DE where DE.status.value = 'in-progress' or DE.status.value='finished')
			union ([Encounter: "Psych Visit - Psychotherapy"]PY where PY.status.value = 'in-progress' or PY.status.value='finished')
	)

define "Narcolepsy Exclusion":
	[Condition: "Narcolepsy"] Narcolepsy
		where Narcolepsy.onset as Period starts before 
		end of "Measurement Period"

define "First ADHD Medication Dispensed":
	First([MedicationDispense: "ADHD Medications"] FirstADHDMedication
			where FHIRHelpers.ToDateTime(FirstADHDMedication.whenHandedOver) 60 days or less after start  of "Measurement Period"
				or FHIRHelpers.ToDateTime(FirstADHDMedication.whenHandedOver) 90 days or less on or before start of "Measurement Period"
	)

define function "GetId"(uri String):
Last(Split(uri, '/'))

define function "PrincipalDiagnosis"(Encounter Encounter):
(singleton from (Encounter.diagnosis D where FHIRHelpers.ToInteger(D.rank) = 1)) PD
return singleton from ([Condition]C where C.id.value= ("GetId"(PD.condition.reference.value)))


define "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense":
	[Encounter: "Encounter Inpatient"] InpatientStay
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that FHIRHelpers.ToInterval(InpatientStay.period) starts 30 days or less after FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)
				 where ( "PrincipalDiagnosis"(InpatientStay).code in "Mental Health Diagnoses"
					or "PrincipalDiagnosis"(InpatientStay).code in "Substance Abuse"
					)

define "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense":
	[Encounter: "Encounter Inpatient"] InpatientStay
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that InpatientStay.period starts 300 days or less on or after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)
		where ( "PrincipalDiagnosis"(InpatientStay).code in "Mental Health Diagnoses"
				or "PrincipalDiagnosis"(InpatientStay).code in "Substance Abuse"
		)

define "ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed":
	[MedicationStatement: "ADHD Medications"] ActiveADHDMedications
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that (ActiveADHDMedications.effective as Period) starts 300 days or less on or after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenPrepared)

define "Encounter 30 Days after Initial ADHD Medication":
	( "Qualifying Numerator Encounter" ValidNumeratorEncounter
			with "First ADHD Medication Dispensed" InitialADHDMedication
				such that ValidNumeratorEncounter.period starts 30 days or less on or after FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)
	)

define "Encounters 300 Days after Initial ADHD Medication":
	"Qualifying Numerator Encounter" ValidNumeratorEncounter
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that ValidNumeratorEncounter.period starts 31 days or more after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)
				and ValidNumeratorEncounter.period starts 300 days or less after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)

define "Previously on ADHD Medication Exclusion":
	[MedicationAdministration: "ADHD Medications"] ActiveADHDMedication
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that ActiveADHDMedication.effective as Period starts 120 days or less before FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)

define "Telehealth Services or Telephone Management Encounter":
	( [Encounter: "Telehealth Services"]
		union [Encounter: "Telephone Management"] ) TelehealthEncounter
		with "First ADHD Medication Dispensed" InitialADHDMedication
			such that TelehealthEncounter.period starts 31 days or more after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)
				and TelehealthEncounter.period starts 300 days or less after day of FHIRHelpers.ToDateTime(InitialADHDMedication.whenHandedOver)

define "Two or More Followup Encounters":
	Count("Encounters 300 Days after Initial ADHD Medication")>= 2

define "Denominator Exclusions 1":
	Hospice."Has Hospice"("Measurement Period")
		or exists ( "Narcolepsy Exclusion" )
		or exists ( "Inpatient Stay with Qualifying Diagnosis within 30 Days of Initial ADHD Dispense" )
		or exists ( "Previously on ADHD Medication Exclusion" )

define "Denominator Exclusions 2":
	Hospice."Has Hospice"("Measurement Period")
		or exists ( "Narcolepsy Exclusion" )
		or exists ( "Inpatient Stay with Qualifying Diagnosis within 300 Days of Initial ADHD Dispense" )
		or exists ( "Previously on ADHD Medication Exclusion" )
		
define function "Cumulative Medication Duration"(Medication MedicationStatement):
	Sum((Medication.effective as Period) MedicationPeriod
			return all duration in days of MedicationPeriod
	)

define "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days":
	"Cumulative Medication Duration"("ADHD Medications Taken within 300 Days after First ADHD Medication Dispensed")>= 210

define "Numerator 2":
	exists ( "Encounter 30 Days after Initial ADHD Medication" )
		and ( ( "Two or More Followup Encounters" )
				or ( exists ( "Encounters 300 Days after Initial ADHD Medication" )
						and exists ( "Telehealth Services or Telephone Management Encounter" )
				)
		)

define "Numerator 1":
	exists ( "Encounter 30 Days after Initial ADHD Medication" )

define "Initial Population":
	AgeInYearsAt(start of "Measurement Period") in Interval[6,12]
			and exists ( "Qualifying Encounter" )
			and "First ADHD Medication Dispensed" is not null

define "Initial Population 2":
	AgeInYearsAt(start of "Measurement Period") in Interval[6,12]
			and exists ( "Qualifying Encounter" )
			and "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days"
			and "First ADHD Medication Dispensed" is not null


