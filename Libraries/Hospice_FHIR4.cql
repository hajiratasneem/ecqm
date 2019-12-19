library Hospice_FHIR4 version '1.0.000'

/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using FHIR version '4.0.0'

include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "SNOMEDCT:2017-09": 'http://snomed.info/sct/731000124108' version 'http://snomed.info/sct/731000124108/version/201709'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Hospice care ambulatory": 'urn:oid:2.16.840.1.113762.1.4.1108.15'

code "Discharge to healthcare facility for hospice care (procedure)": '428371000124100' from "SNOMEDCT:2017-09" display 'Discharge to healthcare facility for hospice care (procedure)'
//code "Hospital admission (procedure)": '32485007' from "SNOMEDCT:2017-09" display 'Hospital admission (procedure)'
code "Discharge to home for hospice care (procedure)": '428361000124107' from "SNOMEDCT:2017-09" display 'Discharge to home for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>
context Patient

define "Has Hospice":
exists (
   [Encounter:"Encounter Inpatient"] DischargeHospice
where
DischargeHospice.status.value= 'finished'
   and (
       FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to home for hospice care (procedure)"
   or FHIRHelpers.ToConcept(DischargeHospice.hospitalization.dischargeDisposition).codes[0] ~ "Discharge to healthcare facility for hospice care (procedure)"
   )
and DischargeHospice.period ends during day of "Measurement Period"
)
    or exists (
        [ServiceRequest: "Hospice care ambulatory"] HospiceOrder
            where HospiceOrder.intent.value = 'order'
                and FHIRHelpers.ToDateTime(HospiceOrder.authoredOn) in day of "Measurement Period"
    )
    or exists (
        [Procedure: "Hospice care ambulatory"] HospicePerformed
            where HospicePerformed.status.value = 'completed'
                and Global."Normalize Interval"(HospicePerformed.performed) overlaps "Measurement Period"
    )