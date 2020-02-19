library VTEICU version '3.1.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206' 

parameter "Measurement Period" Interval<DateTime>

context Patient

define function "FromDayOfStartOfHospitalizationToDayAfterAdmission"(Encounter Encounter ):
	Interval[Global."ToDate"(start of Global."HospitalizationWithObservation"(Encounter)), Global."ToDate"(start of Encounter.period + 2 days))

define function "StartOfFirstICU"(Encounter Encounter ):
	start of "FirstICULocationPeriod"(Encounter)

define function "FromDayOfStartOfHospitalizationToDayAfterFirstICU"(Encounter Encounter ):
	Interval[Global."ToDate"(start of Global."HospitalizationWithObservation"(Encounter)), Global."ToDate"(StartOfFirstICU(Encounter)+ 2 days))

define function "FirstICULocationPeriod"(Encounter Encounter ):
	"FirstInpatientIntensiveCareUnit"(Encounter).period

define function "FirstInpatientIntensiveCareUnit"(Encounter Encounter ):
	First((Encounter.location)HospitalLocation
			where HospitalLocation.physicalType as CodeableConcept in "Intensive Care Unit"
				and HospitalLocation.period during Encounter.period
			sort by start of period
	)

