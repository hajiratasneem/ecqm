library Hospice_FHIR4 version '1.0.000'

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory": '2.16.840.1.113762.1.4.1108.15'

code "Discharge to healthcare facility for hospice care (procedure)": '428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'
//code "Hospital admission (procedure)": '32485007' from "SNOMEDCT:2017-09" display 'Hospital admission (procedure)'
code "Discharge to home for hospice care (procedure)": '428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'

context Patient

define function "Has Hospice"(MeasurementPeriod Interval<DateTime>):
exists (
   [Encounter:"Encounter Inpatient"] DischargeHospice
where
DischargeHospice.status.value= 'finished'
   and (
       FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to home for hospice care (procedure)"
   or FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to healthcare facility for hospice care (procedure)"
   )
and DischargeHospice.period ends during MeasurementPeriod
)
    or exists (
        [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            where HospiceOrder.intent.value = 'order'
                and FHIRHelpers.ToDateTime(HospiceOrder.authoredOn) during MeasurementPeriod
    )
    or exists (
        [Procedure: "Hospice care ambulatory"] HospicePerformed
            where HospicePerformed.status.value = 'completed'
                and Global."Normalize Interval"(HospicePerformed.performed) overlaps MeasurementPeriod
    )
