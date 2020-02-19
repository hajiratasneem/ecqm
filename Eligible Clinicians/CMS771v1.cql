library InternationalProstateSymptomScoreIPSSorAmericanUrologicalAssociationSymptomIndexAUASIChange612MonthsAfterDiagnosisofBenignProstaticHyperplasia version '1.4.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "LOINC": 'http://loinc.org'
codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90'
codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Services for urology care": 'urn:oid:2.16.840.1.113762.1.4.1164.64'
valueset "Morbid Obesity": 'urn:oid:2.16.840.1.113762.1.4.1164.65'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Urinary retention": 'urn:oid:2.16.840.1.113762.1.4.1164.52'

code "American Urological Association Symptom Index [AUASI]": '80883-2' from "LOINC" display 'American Urological Association Symptom Index [AUASI]'
code "Benign prostatic hyperplasia with lower urinary tract symptoms": 'N40.1' from "ICD10CM" display 'Benign prostatic hyperplasia with lower urinary tract symptoms'
code "Estimated BMI greater than 40": '88087-2' from "LOINC" display 'Estimated BMI greater than 40'
code "If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]": '81090-3' from "LOINC" display 'If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]'
code "International Prostate Symptom Score [IPSS]": '80976-4' from "LOINC" display 'International Prostate Symptom Score [IPSS]'
code "Male": 'M' from "AdministrativeGender" display 'Male'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "AUA Symptom Index and Quality of Life Assessment Result":
	from
		[Observation: "American Urological Association Symptom Index [AUASI]"] AUASIAssessment,
		[Observation: "If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]"] QOLAssessment
		let AUASIAssessmentresult: FHIRHelpers.ToInteger( AUASIAssessment.value ) + FHIRHelpers.ToInteger( QOLAssessment.value )
		where FHIRHelpers.ToDateTime(AUASIAssessment.issued) same day as FHIRHelpers.ToDateTime(QOLAssessment.issued)
			and AUASIAssessment.value is not null
			and QOLAssessment.value is not null
		return {
			issued: FHIRHelpers.ToDateTime(AUASIAssessment.issued),
			value: AUASIAssessmentresult
		}

define "Documented IPSS Assessment Result":
	[Observation: "International Prostate Symptom Score [IPSS]"] IPSSAssessment
		where IPSSAssessment.value is not null
		return {
			issued: FHIRHelpers.ToDateTime( IPSSAssessment.issued ),
			value: FHIRHelpers.ToInteger( IPSSAssessment.value )
		}

define "Initial BPH Diagnosis Starts During or Within 30 Days After End of Hospitalization":
	"Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period" InitialBPHDiagnosis
		with [Encounter: "Hospital Services for urology care"] InHospitalServices
			such that FHIRHelpers.ToDateTime(InitialBPHDiagnosis.onset as dateTime) during Interval[(start of InHospitalServices.period),( 
				end of InHospitalServices.period
			) + 31 days )

define "Patient is Male":
	exists [Patient]P
		where P.gender = 'male'

define "Qualifying Encounter":
	[Encounter: "Office Visit"] ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Urinary Symptom Score":
	"Documented IPSS Assessment Result"
		union "AUA Symptom Index and Quality of Life Assessment Result"

define "Initial Population":
	( "Patient is Male" )
		and exists ( "Qualifying Encounter" )
		and exists ( "Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period" )
		and "Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis" is not null
		and "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" is not null

define "Denominator":
	"Initial Population"

define "Numerator":
	"Urinary Symptom Score Improvement Greater Than or Equal To 3"

define "Urinary Symptom Score Improvement Greater Than or Equal To 3":
	( "Urinary Symptom Score Improvement" USSImprovement
			where USSImprovement >= 3
	) is not null

define "Urinary Symptom Score Improvement":
	from
		"Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis" FirstUSSAssessment,
		"Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
		let USSChange: FirstUSSAssessment.value - FollowUpUSSAssessment.value
		return USSChange

define "Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis":
	First("Urinary Symptom Score" InitialUSSAssessment
			with "Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period" InitialBPHDiagnosis
				such that InitialUSSAssessment.issued 1 month or less on or after FHIRHelpers.ToDateTime(InitialBPHDiagnosis.onset as dateTime)
			//sort by issued
	)

define "Denominator Exclusions":
	exists ( "Urinary Retention Diagnosis Starts Within 1 Year After Initial BPH Diagnosis" )
		or exists ( "Initial BPH Diagnosis Starts During or Within 30 Days After End of Hospitalization" )
		or ( "Morbid Obesity Diagnosis or BMI Exam Result Greater Than 40 Starts On or Before Follow Up USS Assessment" )

define "Urinary Retention Diagnosis Starts Within 1 Year After Initial BPH Diagnosis":
	[Condition: "Urinary retention"] UrinaryRetention
		with "Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period" InitialBPHDiagnosis
			such that UrinaryRetention.onset as Period starts within 1 year of start of  FHIRHelpers.ToInterval(InitialBPHDiagnosis.onset as Period)
			
define "Morbid Obesity Diagnosis or BMI Exam Result Greater Than 40 Starts On or Before Follow Up USS Assessment":
	exists "Morbid Obesity Diagnosis On or Before Follow Up USS Assessment"
		or exists "BMI Exam Result Greater Than 40 During Measurement Period and On or Before Follow Up USS Assessment"

define "BMI Exam Result Greater Than 40 During Measurement Period and On or Before Follow Up USS Assessment":
	[Observation: "Estimated BMI greater than 40"] BMIExam
		with "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
			such that (FHIRHelpers.ToDateTime( BMIExam.issued) during "Measurement Period"
					and  FHIRHelpers.ToDateTime(BMIExam.issued) on or before FollowUpUSSAssessment.issued
			)
				and BMIExam.value as Quantity > 40 'kg/m2'

define "Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period":
	[Condition: "Benign prostatic hyperplasia with lower urinary tract symptoms"] NewBPHDiagnosis
		where NewBPHDiagnosis.onset as Period starts during Interval[start of "Measurement Period" - 6 months, 
		end of "Measurement Period"]

define "Morbid Obesity Diagnosis On or Before Follow Up USS Assessment":
	[Condition: "Morbid Obesity"] MorbidObesity
		with "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
			such that ( MorbidObesity.onset as Period overlaps "Measurement Period"
					and FHIRHelpers.ToDateTime(MorbidObesity.recordedDate) on or before FollowUpUSSAssessment.issued
			)

define "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis":
	Last("Urinary Symptom Score" LastUSSAssessment
			with "Initial BPH Diagnosis Within 6 Months Before or After Start of Measurement Period" InitialBPHDiagnosis
				such that months between FHIRHelpers.ToDateTime(InitialBPHDiagnosis.onset as dateTime) and LastUSSAssessment.issued in Interval[6, 12]
			sort by issued
	)
