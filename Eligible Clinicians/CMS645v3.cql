library AppropriateUseofDXAScansinWomenUnder65YearsWhoDoNotMeettheRiskFactorProfileforOsteoporoticFracture version '2.4.000'

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include DayMonthTimings version '1.2.000' called Timing
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Ankylosing Spondylitis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1045'
valueset "Aromatase Inhibitors": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1265'
valueset "Average Number of Drinks per Drinking Day": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1018'
valueset "BMI Ratio": 'urn:oid:2.16.840.1.113883.3.600.1.1490'
valueset "Chronic Liver Disease": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1035'
valueset "Chronic Malnutrition": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1036'
valueset "Current Tobacco Smoker": 'urn:oid:2.16.840.1.113883.3.600.2390'
valueset "Cushings Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1009'
valueset "DXA (Dual energy Xray Absorptiometry) Scan": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1051'
valueset "Ehlers Danlos Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1047'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Female": 'urn:oid:2.16.840.1.113883.3.560.100.2'
valueset "Gastric Bypass Surgery": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1050'
valueset "Glucocorticoids (oral only)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1266'
valueset "History of hip fracture in parent": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1040'
valueset "Hyperparathyroidism": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1016'
valueset "Hyperthyroidism": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1015'
valueset "Lupus": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1010'
valueset "Malabsorption Syndromes": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1050'
valueset "Marfan's Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1048'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Osteogenesis Imperfecta": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1044'
valueset "Osteopenia": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1049'
valueset "Osteoporosis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1038'
valueset "Osteoporotic Fractures": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1050'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services - Other": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1030'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psoriatic Arthritis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1046'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rheumatoid Arthritis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1005'
valueset "Tobacco Use Screening": 'urn:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Type 1 Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1020'
valueset "White": 'urn:oid:2.16.840.1.113883.3.464.1003.123.12.1007'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Every eight hours (qualifier value)": '307469008' from "SNOMEDCT" display 'Every eight hours (qualifier value)'
code "Every eight to twelve hours (qualifier value)": '396140003' from "SNOMEDCT" display 'Every eight to twelve hours (qualifier value)'
code "Every forty eight hours (qualifier value)": '396131002' from "SNOMEDCT" display 'Every forty eight hours (qualifier value)'
code "Every four hours (qualifier value)": '225756002' from "SNOMEDCT" display 'Every four hours (qualifier value)'
code "Every seventy two hours (qualifier value)": '396143001' from "SNOMEDCT" display 'Every seventy two hours (qualifier value)'
code "Every six hours (qualifier value)": '307468000' from "SNOMEDCT" display 'Every six hours (qualifier value)'
code "Every six to eight hours (qualifier value)": '396139000' from "SNOMEDCT" display 'Every six to eight hours (qualifier value)'
code "Every thirty six hours (qualifier value)": '396126004' from "SNOMEDCT" display 'Every thirty six hours (qualifier value)'
code "Every three to four hours (qualifier value)": '225754004' from "SNOMEDCT" display 'Every three to four hours (qualifier value)'
code "Every three to six hours (qualifier value)": '396127008' from "SNOMEDCT" display 'Every three to six hours (qualifier value)'
code "Every twelve hours (qualifier value)": '307470009' from "SNOMEDCT" display 'Every twelve hours (qualifier value)'
code "Every twenty four hours (qualifier value)": '396125000' from "SNOMEDCT" display 'Every twenty four hours (qualifier value)'
code "Every two to four hours (qualifier value)": '225752000' from "SNOMEDCT" display 'Every two to four hours (qualifier value)'
code "Four times daily (qualifier value)": '307439001' from "SNOMEDCT" display 'Four times daily (qualifier value)'
code "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment": '90265-0' from "LOINC" display 'Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment'
code "Once daily (qualifier value)": '229797004' from "SNOMEDCT" display 'Once daily (qualifier value)'
code "One to four times a day (qualifier value)": '396109005' from "SNOMEDCT" display 'One to four times a day (qualifier value)'
code "One to three times a day (qualifier value)": '396108002' from "SNOMEDCT" display 'One to three times a day (qualifier value)'
code "One to two times a day (qualifier value)": '396107007' from "SNOMEDCT" display 'One to two times a day (qualifier value)'
code "Three times daily (qualifier value)": '229798009' from "SNOMEDCT" display 'Three times daily (qualifier value)'
code "Twice a day (qualifier value)": '229799001' from "SNOMEDCT" display 'Twice a day (qualifier value)'
code "Two to four times a day (qualifier value)": '396111001' from "SNOMEDCT" display 'Two to four times a day (qualifier value)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"

define "Osteopenia Before Measurement Period":
	[Condition: "Osteopenia"] OsteopeniaDiagnosis
		where OsteopeniaDiagnosis.onset as Period starts before start "Measurement Period"

define "Numerator":
	exists [ServiceRequest: "DXA (Dual energy Xray Absorptiometry) Scan"] DXA
		where FHIRHelpers.ToDateTime(DXA.authoredOn) during "Measurement Period"

define "Osteoporotic Fracture From Patient History":
	( [Condition: "Osteoporotic Fractures"] PathologicalFracture
			where PathologicalFracture.onset as Period starts before start "Measurement Period"
	)

define "Qualifying Encounter":
	( [Encounter: "Office Visit"]
		union [Encounter: "Preventive Care Services - Established Office Visit, 18 and Up"]
		union [Encounter: "Preventive Care Services - Other"]
		union [Encounter: "Preventive Care Services-Initial Office Visit, 18 and Up"]
		union [Encounter: "Outpatient Consultation"] ) ValidEncounter
		where ValidEncounter.period during "Measurement Period"

define "Combination Risk Factors Applicable Any Time":
	( [Condition: "Rheumatoid Arthritis"]
		union [Condition: "Hyperthyroidism"]
		union [Condition: "Malabsorption Syndromes"]
		union [Condition: "Chronic Liver Disease"]
		union [Condition: "Chronic Malnutrition"] ) CombinationRiskDiagnosis
		where CombinationRiskDiagnosis.onset as Period starts before 
		end "Measurement Period"

define "Glucocorticoid Medication Active":
	[MedicationStatement: "Glucocorticoids (oral only)"] Glucocorticoid
		where Glucocorticoid.effective as Period starts before 
		end of "Measurement Period"

define "Independent Risk Factors Applicable Any Time":
	( [Condition: "Type 1 Diabetes"]
		union [Condition: "End Stage Renal Disease"]
		union [Condition: "Osteogenesis Imperfecta"]
		union [Condition: "Ankylosing Spondylitis"]
		union [Condition: "Psoriatic Arthritis"]
		union [Condition: "Ehlers Danlos Syndrome"]
		union [Condition: "Cushings Syndrome"]
		union [Condition: "Marfan's Syndrome"]
		union [Condition: "Hyperparathyroidism"]
		union [Condition: "Lupus"] ) IndependentRiskDiagnosis
		where IndependentRiskDiagnosis.onset as Period starts before 
		end "Measurement Period"

define "First Tobacco Use Screening Indicating Current Smoker":
	{ First([Observation: "Tobacco Use Screening"] TobaccoScreen
			where (TobaccoScreen.value as CodeableConcept) in "Current Tobacco Smoker"
				and FHIRHelpers.ToDateTime(TobaccoScreen.issued) during "Measurement Period"
			//sort by issued
	)}

define "First BMI Exam in Measurement Period":
	{ First([Observation: "BMI Ratio"] BMI
			where (BMI.effective as Period) during "Measurement Period"
				and BMI.value is not null
			sort by start of (effective as Period)
	)}

define "Independent Risk Factors Before Measurement Period":
	( ( [Procedure: "Gastric Bypass Surgery"]
			union [MedicationStatement: "Aromatase Inhibitors"]
			union [MedicationRequest: "Aromatase Inhibitors"] ) GastricBypassOrAromataseInhibitor
			where GastricBypassOrAromataseInhibitor.dispenseRequest.validityPeriod starts before start "Measurement Period"
	)
		union "Osteoporosis Fracture Probability Assessment"

define "Osteoporosis Before Measurement Period":
	[Condition: "Osteoporosis"] OsteoporosisDiagnosis
		where OsteoporosisDiagnosis.onset as Period overlaps before "Measurement Period"

define "Osteoporosis Fracture Probability Assessment":
	[Observation: "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment"] ProbabilityAssessment
		where FHIRHelpers.ToInteger(ProbabilityAssessment.value) >= 8.4 '%'
			and FHIRHelpers.ToDateTime(ProbabilityAssessment.issued) before start of "Measurement Period"

define "Parent History of Hip Fracture Assessment":
	[Observation: "History of hip fracture in parent"] ParentFractureHistory
		where FHIRHelpers.ToDateTime(ParentFractureHistory.issued) before start of "Measurement Period"

define "Age Dependent Combination Risk Factors":
	"Combination Risk Factors Applicable Any Time"
		union "Osteoporotic Fracture From Patient History"
		union "Parent History of Hip Fracture Assessment"
		union "Osteopenia Before Measurement Period"
		union "First Tobacco Use Screening Indicating Current Smoker"
		union "First Average Number of Drinks Assessments Indicating More Than Two Per Day"
		union "First BMI Exam in Measurement Period Less Than or Equal to 20 kg m2"
		union [Patient] 

define "First Average Number of Drinks Assessments Indicating More Than Two Per Day":
	{ First([Observation: "Average Number of Drinks per Drinking Day"] AverageDrinks
			where FHIRHelpers.ToDateTime(AverageDrinks.issued) during "Measurement Period"
				and FHIRHelpers.ToInteger(AverageDrinks.value) > 2 '{drinks}/d'
			//sort by issued
	)}

define "First BMI Exam in Measurement Period Less Than or Equal to 20 kg m2":
	"First BMI Exam in Measurement Period" FirstBMI
		where FirstBMI.value as Quantity <= 20 'kg/m2'

define "Initial Population":
	exists [Patient] P
		where P.gender = 'female'
			and AgeInYearsAt(start of "Measurement Period")>= 50
			and AgeInYearsAt(start of "Measurement Period")< 64
			and exists "Qualifying Encounter"

define "Denominator Exclusions":
	"Has Age Dependent Combination Risk Factors"
		or exists "Osteoporosis Before Measurement Period"
		or exists "Independent Risk Factors Applicable Any Time"
		or exists "Independent Risk Factors Before Measurement Period"

define "Has Age Dependent Combination Risk Factors":
	singleton from ( [Patient] P
			let Age: AgeInYearsAt(start of "Measurement Period"),
			NumberOfRiskFactors: Count("Age Dependent Combination Risk Factors")+ ( if "Glucocorticoids Greater Than 5 MG per Day for 90 or More Days" then 1 
					else 0
			)
			return ( ( Age between 50 and 54
						and NumberOfRiskFactors >= 4
				)
					or ( Age between 55 and 59
							and NumberOfRiskFactors >= 3
					)
					or ( Age between 60 and 63
							and NumberOfRiskFactors >= 2
					)
			)
	)

define "Glucocorticoids Dosage Per Day":
	( distinct(flatten("Glucocorticoids Daily Dosage Per Medication" GlucocorticoidsDailyDosage
				return all GlucocorticoidsDailyDosage.daysInPeriod
		)
	)) Day
		return {
			medicationDay: Day,
			totalDailyDosage: Sum("Glucocorticoids Daily Dosage Per Medication" GlucocorticoidsDailyDosagePerDay
					where Day in GlucocorticoidsDailyDosagePerDay.daysInPeriod
					return all GlucocorticoidsDailyDosagePerDay.dailyDosage
			)
		}

define "Glucocorticoids Greater Than 5 MG per Day for 90 or More Days":
	Count("Glucocorticoids Dosage Per Day" GlucocorticoidsDosage
			where GlucocorticoidsDosage.totalDailyDosage >= 5 'mg/d'
	)>= 90

define "Glucocorticoids Daily Dosage Per Medication":
	"Glucocorticoid Medication Active" MedicationGlucocorticoid
		let dosesPerDay: "DosesPerDay"(MedicationGlucocorticoid.dosage.timing.code.coding[0].code)
		//dailyDosage: "GetMedicationDailyDose"(MedicationGlucocorticoid.dosage, dosesPerDay),
		//medPeriod: MedicationGlucocorticoid.effective as Period
			//intersect Interval[start of MedicationGlucocorticoid.effective as Period, 
			//end of "Measurement Period"]
		//return Tuple {
			//code: MedicationGlucocorticoid.code,
			//daysInPeriod: Timing."DaysInPeriod"(medPeriod),
			//dailyDosage: dailyDosage
		//}

define function "GetMedicationDailyDose"(dosage Quantity, dosesPerDay Decimal):
	dosage * Quantity { value: dosesPerDay, unit: '/d' }

define function "DosesPerDay"(code Code):
	case
		when code ~ "Once daily (qualifier value)" then 1.0
		when code ~ "Twice a day (qualifier value)" then 2.0
		when code ~ "Three times daily (qualifier value)" then 3.0
		when code ~ "Four times daily (qualifier value)" then 4.0
		when code ~ "Every twenty four hours (qualifier value)" then 1.0
		when code ~ "Every twelve hours (qualifier value)" then 2.0
		when code ~ "Every thirty six hours (qualifier value)" then 0.67
		when code ~ "Every eight hours (qualifier value)" then 3.0
		when code ~ "Every four hours (qualifier value)" then 6.0
		when code ~ "Every six hours (qualifier value)" then 4.0
		when code ~ "Every seventy two hours (qualifier value)" then 0.34
		when code ~ "Every forty eight hours (qualifier value)" then 0.5
		when code ~ "Every eight to twelve hours (qualifier value)" then 2.0
		when code ~ "Every six to eight hours (qualifier value)" then 3.0
		when code ~ "Every three to four hours (qualifier value)" then 6.0
		when code ~ "Every three to six hours (qualifier value)" then 4.0
		when code ~ "Every two to four hours (qualifier value)" then 6.0
		when code ~ "One to four times a day (qualifier value)" then 4.0
		when code ~ "One to three times a day (qualifier value)" then 3.0
		when code ~ "One to two times a day (qualifier value)" then 2.0
		when code ~ "Two to four times a day (qualifier value)" then 4.0 
		else null 
	end
