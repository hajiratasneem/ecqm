library ExclusiveBreastMilkFeeding version '8.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

codesystem "LOINC": 'http://loinc.org'

valueset "Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.27'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Galactosemia": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.35'
valueset "Neonatal Intensive Care Unit (NICU)": 'urn:oid:2.16.840.1.113762.1.4.1029.205'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Other Health Care Facility": 'urn:oid:2.16.840.1.113762.1.4.1029.67'
valueset "Parenteral Nutrition": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.38'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Single Live Born Newborn Born in Hospital": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.26'
valueset "Estimated Gestational Age at Birth": 'urn:oid:2.16.840.1.113762.1.4.1045.47'

code "Gestational age--at birth": '76516-4' from "LOINC" display 'Gestational age--at birth'

context Patient

define "Initial Population":
	"Single Live Birth Encounter With Gestational Age 37 Weeks or More"

define "Denominator":
	"Initial Population"

define "Single Live Birth Encounter With Newborn Fed Breast Milk Only Since Birth":
	"Single Live Birth Encounter With Gestational Age 37 Weeks or More" QualifyingEncounter
		with [MedicationAdministration: "Breast Milk"] BreastMilkFeeding
			such that BreastMilkFeeding.effective as Period starts during QualifyingEncounter.period
		without [MedicationAdministration: "Dietary Intake Other than Breast Milk"] OtherFeeding
			such that OtherFeeding.effective as Period starts during QualifyingEncounter.period

define "Single Live Birth Encounter With Newborn to NICU or Discharge to Acute Care or Other Health Care Facility or Expired":
	"Single Live Birth Encounter With Gestational Age 37 Weeks or More" QualifyingEncounter
		where exists ( QualifyingEncounter.location NICU
				where NICU.physicalType.coding.code in "Neonatal Intensive Care Unit (NICU)"
		)
			or QualifyingEncounter.hospitalization.dischargeDisposition as CodeableConcept in "Patient Expired"
			or QualifyingEncounter.hospitalization.dischargeDisposition as CodeableConcept in "Discharge To Acute Care Facility"
			or QualifyingEncounter.hospitalization.dischargeDisposition as CodeableConcept in "Other Health Care Facility"

define "Single Live Birth Encounter Without Galactosemia and Parenteral Nutrition":
	"Single Live Birth Encounter" SingleLiveBirthEncounter
		without [Procedure: "Parenteral Nutrition"] ParenteralNutrition
			such that ParenteralNutrition.performed as Period starts during SingleLiveBirthEncounter.period
		where not exists ( SingleLiveBirthEncounter.diagnosis BirthEncounterDiagnoses
				where BirthEncounterDiagnoses.condition.reference in "Galactosemia"
		)

define "Single Live Birth Encounter With Gestational Age 37 Weeks or More":
	"Single Live Birth Encounter Without Galactosemia and Parenteral Nutrition" QualifyingSingleNewbornEncounter
		with [Observation: "Estimated Gestational Age at Birth"] GestationalAge
			such that GestationalAge.effective as Period during QualifyingSingleNewbornEncounter.period
				and GestationalAge.value as Quantity >= 37 weeks

define "Numerator":
	"Single Live Birth Encounter With Newborn Fed Breast Milk Only Since Birth"

define "Denominator Exclusions":
	"Single Live Birth Encounter With Newborn to NICU or Discharge to Acute Care or Other Health Care Facility or Expired"

define "Single Live Birth Encounter":
	Global."Inpatient Encounter" InpatientEncounter
		where exists ( InpatientEncounter.diagnosis EncounterDiagnoses
				where EncounterDiagnoses.condition.reference in "Single Live Born Newborn Born in Hospital"
		)
