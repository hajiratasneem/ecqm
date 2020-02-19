library Bonedensityevaluationforpatientswithprostatecancerandreceivingandrogendeprivationtherapy version '3.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'

valueset "Androgen deprivation therapy for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.48'
valueset "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.38'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Male": 'urn:oid:2.16.840.1.113883.3.560.100.1'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Reason refused": 'urn:oid:2.16.840.1.113883.3.600.791'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Prostate Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.319'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Injection of leuprolide acetate for twelve month period (regime/therapy)": '456381000124102' from "SNOMEDCT" display 'Injection of leuprolide acetate for twelve month period (regime/therapy)'

parameter "Measurement Period" Interval<DateTime>

context Patient


define "Patient is Male":
	exists [Patient]P
		where P.gender = 'male'

define "Qualifying Encounter":
	[Encounter: "Office Visit"] Encounter
		where Encounter.period during "Measurement Period"

define "Initial Population":
	"Patient is Male"
		and exists "Qualifying Encounter"
		and "First Androgen Deprivation Therapy" is not null

define "Denominator":
	"Initial Population"

define "Numerator":
	exists "Baseline DEXA Scan Two Years Prior to the Start of or Less than Three Months After the Start of ADT"

define "Prostate Cancer Diagnosis":
	[Condition: "Prostate Cancer"] ProstateCancer
		where ProstateCancer.onset as Period starts same day or before 
		end "Measurement Period"

define "Bone Density Scan Ordered or Performed":
	[ServiceRequest: "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXAOrdered
		union ( [DiagnosticReport: "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXAPerformed
				return ServiceRequest { authoredOn: DEXAPerformed.effective as dateTime }
		)

define "Baseline DEXA Scan Two Years Prior to the Start of or Less than Three Months After the Start of ADT":
	"Bone Density Scan Ordered or Performed" DEXAScan
		with "First Androgen Deprivation Therapy" FirstADT
			such that FHIRHelpers.ToDateTime(DEXAScan.authoredOn) 3 months or less after FHIRHelpers.ToDateTime(FirstADT.effective as dateTime)
				or FHIRHelpers.ToDateTime(DEXAScan.authoredOn) 2 years or less before FHIRHelpers.ToDateTime(FirstADT.effective as dateTime)

define "First Androgen Deprivation Therapy":
	First([MedicationStatement: "Androgen deprivation therapy for Urology Care"] InitialADTTherapy
			with "Prostate Cancer Diagnosis" ProstateCancer
				such that InitialADTTherapy.effective as Period starts on or after FHIRHelpers.ToDateTime(ProstateCancer.onset as dateTime)
			with [ServiceRequest: "Injection of leuprolide acetate for twelve month period (regime/therapy)"] TwelveMonthADTTherapy
				such that InitialADTTherapy.effective as Period includes FHIRHelpers.ToDateTime(TwelveMonthADTTherapy.authoredOn)
					and InitialADTTherapy.effective as Period overlaps "Measurement Period"
	)

define "No Bone Density Scan Performed Due to Patient Refusal":
	from
		"First Androgen Deprivation Therapy" FirstADTTherapy,
		[Observation: "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXANotPerformed
		where ( FHIRHelpers.ToDateTime(DEXANotPerformed.issued) 3 months or less after FHIRHelpers.ToDateTime(FirstADTTherapy.effective as dateTime)
				and DEXANotPerformed.dataAbsentReason in "Patient Reason refused"
		)
		return FirstADTTherapy

define "No Bone Density Scan Ordered Due to Patient Refusal":
	from
		"First Androgen Deprivation Therapy" FirstADTTherapy,
		[Observation: "DEXA Dual Energy Xray Absorptiometry, Bone Density for Urology Care"] DEXANotOrdered
		where ( FHIRHelpers.ToDateTime(DEXANotOrdered.issued) 3 months or less after FHIRHelpers.ToDateTime(FirstADTTherapy.effective as dateTime)
				and DEXANotOrdered.dataAbsentReason in "Patient Reason refused"
		)
		return FirstADTTherapy

define "Denominator Exception":
	exists ( "No Bone Density Scan Ordered Due to Patient Refusal" )
		or exists ( "No Bone Density Scan Performed Due to Patient Refusal" )
