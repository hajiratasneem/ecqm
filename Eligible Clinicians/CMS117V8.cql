library ChildhoodImmunizationStatus version '8.3.000'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include Hospice_FHIR4 version '1.0.000' called Hospice
//include MATGlobalCommonFunctions version '4.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "CVX": 'urn:oid:2.16.840.1.113883.12.292'

valueset "Anaphylactic Reaction to Common Baker's Yeast": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1032'
valueset "Anaphylactic Reaction to DTaP Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1031'
valueset "Anaphylactic Reaction to Hepatitis A Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1026'
valueset "Anti Hepatitis A IgG Antigen Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1033'
valueset "Anti Hepatitis B Virus Surface Ab": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1073'
valueset "Disorders of the Immune System": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1001'
valueset "DTaP Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1214'
valueset "DTaP Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1022'
valueset "Encephalopathy due to Childhood Vaccination": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1007'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hepatitis A": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1024'
valueset "Hepatitis A Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1215'
valueset "Hepatitis A Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1041'
valueset "Hepatitis B": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1025'
valueset "Hepatitis B Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1216'
valueset "Hepatitis B Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1042'
valueset "HiB Vaccine (3 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1083'
valueset "HiB Vaccine (3 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1084'
valueset "HiB Vaccine (4 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1085'
valueset "HiB Vaccine (4 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1086'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Inactivated Polio Vaccine (IPV)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1219'
valueset "Inactivated Polio Vaccine (IPV) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1045'
valueset "Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1218'
valueset "Influenza Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1044'
valueset "Intussusception": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1056'
valueset "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1009'
valueset "Measles": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1053'
valueset "Measles Antibody Test (IgG Antibody presence)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1060'
valueset "Measles Antibody Test (IgG Antibody Titer)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1059'
valueset "Measles, Mumps and Rubella (MMR) Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1224'
valueset "Measles, Mumps and Rubella (MMR) Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1031'
valueset "Mumps": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1032'
valueset "Mumps Antibody Test (IgG Antibody presence)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1062'
valueset "Mumps Antibody Test (IgG Antibody Titer)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1061'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pneumococcal Conjugate Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1221'
valueset "Pneumococcal Conjugate Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1046'
valueset "Positive Finding": 'urn:oid:2.16.840.1.113883.3.464.1003.121.12.1016'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rotavirus Vaccine (2 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1048'
valueset "Rotavirus Vaccine (3 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1223'
valueset "Rotavirus Vaccine (3 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1047'
valueset "Rubella": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1037'
valueset "Rubella Antibody Test (IgG Antibody presence)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1064'
valueset "Rubella Antibody Test (IgG Antibody Titer)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1063'
valueset "Severe Combined Immunodeficiency": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1007'
valueset "Varicella Zoster": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1039'
valueset "Varicella Zoster Antibody Test (IgG Antibody Presence)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1067'
valueset "Varicella Zoster Antibody Test (IgG Antibody Titer)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1066'
valueset "Varicella Zoster Vaccine (VZV)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1170'
valueset "Varicella Zoster Vaccine (VZV) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1040'

code "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)": '433621000124101' from "SNOMEDCT" display 'Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)'
code "Anaphylaxis due to Hepatitis B vaccine (disorder)": '428321000124101' from "SNOMEDCT" display 'Anaphylaxis due to Hepatitis B vaccine (disorder)'
code "Anaphylaxis due to rotavirus vaccine (disorder)": '428331000124103' from "SNOMEDCT" display 'Anaphylaxis due to rotavirus vaccine (disorder)'
code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Influenza virus vaccine adverse reaction (disorder)": '420113004' from "SNOMEDCT" display 'Influenza virus vaccine adverse reaction (disorder)'
code "Neomycin adverse reaction (disorder)": '292927007' from "SNOMEDCT" display 'Neomycin adverse reaction (disorder)'
code "Pneumococcal vaccine adverse reaction (disorder)": '293116002' from "SNOMEDCT" display 'Pneumococcal vaccine adverse reaction (disorder)'
code "Poliomyelitis vaccine adverse reaction (disorder)": '293117006' from "SNOMEDCT" display 'Poliomyelitis vaccine adverse reaction (disorder)'
code "Polymyxin B adverse reaction (disorder)": '292992006' from "SNOMEDCT" display 'Polymyxin B adverse reaction (disorder)'
code "rotavirus, live, monovalent vaccine": '119' from "CVX" display 'rotavirus, live, monovalent vaccine'
code "Streptomycin adverse reaction (disorder)": '292925004' from "SNOMEDCT" display 'Streptomycin adverse reaction (disorder)'
code "Discharge to home for hospice care (procedure)":'428361000124107' from "SNOMEDCT" display 'Discharge to home for hospice care (procedure)'
code "Discharge to healthcare facility for hospice care (procedure)":'428371000124100' from "SNOMEDCT" display 'Discharge to healthcare facility for hospice care (procedure)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
	"Initial Population"
	
define "Rotavirus 2 Dose Immunizations or Procedures":
	( ([Immunization: "rotavirus, live, monovalent vaccine"]I where I.status.value = 'completed')
		union ( [Procedure: "Rotavirus Vaccine (2 dose schedule) Administered"] Rotavirus2Administration
				where Rotavirus2Administration.status.value = 'completed'
				return Immunization { recorded: Rotavirus2Administration.performed as dateTime }
		) ) TwoDoseRotavirus
	where FHIRHelpers.ToDateTime(TwoDoseRotavirus.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years]

define "Rotavirus 3 Dose Immunizations or Procedures":
	( ([Immunization: "Rotavirus Vaccine (3 dose schedule)"]R where R.status.value = 'completed')
		union ( [Procedure: "Rotavirus Vaccine (3 dose schedule) Administered"] Rotavirus3Administration
				where Rotavirus3Administration.status.value = 'completed'
				return Immunization { recorded: Rotavirus3Administration.performed as dateTime }
		) ) ThreeDoseRotavirus
		where FHIRHelpers.ToDateTime(ThreeDoseRotavirus.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years]

define "DTaP Immunizations or Procedures":
	( ([Immunization : "DTaP Vaccine"]D where D.status.value = 'completed')
		union ( [Procedure: "DTaP Vaccine Administered"] DtapAdministration
				where DtapAdministration.status.value = 'completed'
				return Immunization { recorded: DtapAdministration.performed as dateTime }
		) ) DTaPVaccination
		where ( FHIRHelpers.ToDateTime(DTaPVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years])
			
define "Rotavirus 2 Dose Vaccination Followed by Two Rotavirus 3 Dose Vaccinations":
	from
		"Rotavirus 2 Dose Immunizations or Procedures" Rotavirus233Vaccination1,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus233Vaccination2,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus233Vaccination3
		where FHIRHelpers.ToDateTime(Rotavirus233Vaccination2.recorded)  1 day or more after FHIRHelpers.ToDateTime(Rotavirus233Vaccination1.recorded)
			and FHIRHelpers.ToDateTime(Rotavirus233Vaccination3.recorded)  1 day or more after FHIRHelpers.ToDateTime(Rotavirus233Vaccination2.recorded) 
		return Rotavirus233Vaccination1
		
define "Rotavirus 3 Dose Vaccination Followed by A Rotavirus 2 Dose Vaccination and A Rotavirus 3 Dose Vaccination":
	from
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus323Vaccination1,
		"Rotavirus 2 Dose Immunizations or Procedures" Rotavirus323Vaccination2,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus323Vaccination3
		where FHIRHelpers.ToDateTime(Rotavirus323Vaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus323Vaccination1.recorded)
			and FHIRHelpers.ToDateTime(Rotavirus323Vaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus323Vaccination2.recorded) 
		return Rotavirus323Vaccination1
		
define "Rotavirus 3 Dose Vaccinations Followed by One Rotavirus 2 Dose Vaccination":
	from
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus332Vaccination1,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus332Vaccination2,
		"Rotavirus 2 Dose Immunizations or Procedures" Rotavirus332Vaccination3
		where FHIRHelpers.ToDateTime(Rotavirus332Vaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus332Vaccination1.recorded) 
			and FHIRHelpers.ToDateTime(Rotavirus332Vaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus332Vaccination2.recorded)
		return Rotavirus332Vaccination1
				

define "Rotavirus 2 or 3 Dose Vaccinations":
	( "Rotavirus 2 Dose Vaccination Followed by Two Rotavirus 3 Dose Vaccinations"
			union "Rotavirus 3 Dose Vaccination Followed by A Rotavirus 2 Dose Vaccination and A Rotavirus 3 Dose Vaccination"
			union "Rotavirus 3 Dose Vaccinations Followed by One Rotavirus 2 Dose Vaccination"
	)

define "Qualifying Encounter":
	( ([Encounter: "Office Visit"]OV where OV.status.value='in-progress' or OV.status.value='finished')
		union ([Encounter: "Home Healthcare Services"]HHS where HHS.status.value ='in-progress' or HHS.status.value='finished')
		union ([Encounter: "Preventive Care, Established Office Visit, 0 to 17"]PC where PC.status.value ='in-progress' or PC.status.value='finished')
		union ([Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]PCS where PCS.status.value ='in-progress' or PCS.status.value='finished')) ValidEncounter
		where ValidEncounter.period during "Measurement Period"
	

		
define "Four DTaP Vaccinations":
	from
		"DTaP Immunizations or Procedures" DTaPVaccination1,
		"DTaP Immunizations or Procedures" DTaPVaccination2,
		"DTaP Immunizations or Procedures" DTaPVaccination3,
		"DTaP Immunizations or Procedures" DTaPVaccination4
		where FHIRHelpers.ToDateTime(DTaPVaccination2.recorded) 1 day or more after day of FHIRHelpers.ToDateTime(DTaPVaccination1.recorded) 
			and FHIRHelpers.ToDateTime(DTaPVaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(DTaPVaccination2.recorded)
			and FHIRHelpers.ToDateTime(DTaPVaccination4.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(DTaPVaccination3.recorded) 
		return DTaPVaccination1

define "Denominator Exclusions":
	Hospice."Has Hospice"("Measurement Period")

define "Pneumococcal Conjugate Immunizations or Procedures":
	( ([Immunization : "Pneumococcal Conjugate Vaccine"]P where P.status.value = 'completed')
		union ( [Procedure: "Pneumococcal Conjugate Vaccine Administered"] PneumococcalAdministration
				where PneumococcalAdministration.status.value = 'completed'
				return "Immunization"{recorded: PneumococcalAdministration.performed as dateTime }
		) ) PneumococcalVaccination
		where ( FHIRHelpers.ToDateTime(PneumococcalVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Four Pneumococcal Conjugate Vaccinations":
	from
		"Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination1,
		"Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination2,
		"Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination3,
		"Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination4
		where FHIRHelpers.ToDateTime(PneumococcalVaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(PneumococcalVaccination1.recorded)
			and FHIRHelpers.ToDateTime(PneumococcalVaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(PneumococcalVaccination2.recorded) 
			and FHIRHelpers.ToDateTime(PneumococcalVaccination4.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(PneumococcalVaccination3.recorded) 
		return PneumococcalVaccination1



define "Rotavirus 2 Dose Vaccinations":
	from
		"Rotavirus 2 Dose Immunizations or Procedures" Rotavirus2Vaccination1,
		"Rotavirus 2 Dose Immunizations or Procedures" Rotavirus2Vaccination2
		where FHIRHelpers.ToDateTime(Rotavirus2Vaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus2Vaccination1.recorded)
		return Rotavirus2Vaccination1



define "Rotavirus 3 Dose Vaccinations":
	from
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus3Vaccination1,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus3Vaccination2,
		"Rotavirus 3 Dose Immunizations or Procedures" Rotavirus3Vaccination3
		where FHIRHelpers.ToDateTime(Rotavirus3Vaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus3Vaccination1.recorded) 
			and FHIRHelpers.ToDateTime(Rotavirus3Vaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(Rotavirus3Vaccination2.recorded)
		return Rotavirus3Vaccination1

define "Hepatitis B Immunizations or Procedures":
	( ([Immunization: "Hepatitis B Vaccine"]H where H.status.value = 'completed')
		union ( [Procedure: "Hepatitis B Vaccine Administered"] HepatitisBAdministration
				where HepatitisBAdministration.status.value = 'completed'
				return Immunization{ recorded: HepatitisBAdministration.performed as dateTime }
		) ) HepatitisBVaccination
		where ( FHIRHelpers.ToDateTime(HepatitisBVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Three Hepatitis B Vaccinations":
	from
		"Hepatitis B Immunizations or Procedures" HepatitisBVaccination1,
		"Hepatitis B Immunizations or Procedures" HepatitisBVaccination2,
		"Hepatitis B Immunizations or Procedures" HepatitisBVaccination3
		where FHIRHelpers.ToDateTime(HepatitisBVaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(HepatitisBVaccination1.recorded)
			and FHIRHelpers.ToDateTime(HepatitisBVaccination3.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(HepatitisBVaccination2.recorded)
		return HepatitisBVaccination1

define "Three Polio Vaccinations":
	from
		"Polio Immunizations or Procedures" PolioVaccination1,
		"Polio Immunizations or Procedures" PolioVaccination2,
		"Polio Immunizations or Procedures" PolioVaccination3
		where FHIRHelpers.ToDateTime(PolioVaccination2.recorded)  1 day or more after day of FHIRHelpers.ToDateTime(PolioVaccination1.recorded)
			and FHIRHelpers.ToDateTime(PolioVaccination3.recorded) 1 day or more after day of FHIRHelpers.ToDateTime(PolioVaccination2.recorded) 
		return PolioVaccination1

define "Two Influenza Vaccinations":
	from
		"Influenza Immunizations or Procedures" FluVaccination1,
		"Influenza Immunizations or Procedures" FluVaccination2
		where FHIRHelpers.ToDateTime(FluVaccination2.recorded) 1 day or more after day of FHIRHelpers.ToDateTime(FluVaccination1.recorded)
		return FluVaccination1

define "HiB 3 or 4 Dose Immunizations":
	"HiB 3 Dose Immunizations or Procedures"
		union "HiB 4 Dose Immunizations or Procedures"

define "Has Appropriate Number of HiB Immunizations":
	exists ( "All Hib Vaccinations" HiBImmunization //union of 3 and 4 dose immunizations
	//4 dose test
			let has_4_dose: Count("HiB 4 Dose Immunizations or Procedures")> 0
			where ( has_4_dose //if pt had at least one 4 dose code
					and Count(distinct("All Hib Vaccinations" HiBVaccinations
								return HiBVaccinations.recorded 
						)
					)>= 4 //pt must have 4 regimens (e.g., 3,3,4,4 or 4,3,4,4)
			)
				or ( has_4_dose is false //if pt did not have at least one 4 dose code
						and Count(distinct("All Hib Vaccinations" HiBVaccinations
									return HiBVaccinations.recorded 
							)
						)>= 3 //pt must have 3 regimens of 3 dose codes
				)
	)

define "DTaP Numerator Inclusion Conditions":
	( [Condition: "Anaphylactic Reaction to DTaP Vaccine"]
		union [Condition: "Encephalopathy due to Childhood Vaccination"] ) DTaPConditions
		where ( FHIRHelpers.ToDateTime(DTaPConditions.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Hepatitis A Numerator Inclusion Conditions":
	( ( [Observation: "Anti Hepatitis A IgG Antigen Test"] HepatitisAAntigenTest
			where HepatitisAAntigenTest.value as CodeableConcept in "Positive Finding"
	)
		union ( [Condition: "Anaphylactic Reaction to Hepatitis A Vaccine"] HepatitisAReaction
				return Observation {effective: HepatitisAReaction.onset as dateTime }
		)
		union ( [Condition: "Hepatitis A"] HepatitisADiagnosis
				return Observation {effective: HepatitisADiagnosis.onset as dateTime }
		) ) HepatitisAConditions
		where ( FHIRHelpers.ToDateTime(HepatitisAConditions.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])



define "Hepatitis B Numerator Inclusion Conditions":
	( ( [Observation: "Anti Hepatitis B Virus Surface Ab"] HepatitisBAntigenTest
			where HepatitisBAntigenTest.value as CodeableConcept in "Positive Finding"
	)
		union ( [Condition: "Anaphylaxis due to Hepatitis B vaccine (disorder)"] HepatitisBReaction
				return Observation { effective: HepatitisBReaction.onset as dateTime }
		)
		union ( [Condition: "Anaphylactic Reaction to Common Baker's Yeast"] YeastReaction
				return Observation { effective: YeastReaction.onset as dateTime }
		)
		union ( [Condition: "Hepatitis B"] HepatitisBDiagnosis
				return Observation { effective: HepatitisBDiagnosis.onset as dateTime }
		) ) HepBConditions
		where (FHIRHelpers.ToDateTime(HepBConditions.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Hepatitis B Immunizations or Procedures":
	( [Immunization: "Hepatitis B Vaccine"]
		union ( [Procedure: "Hepatitis B Vaccine Administered"] HepatitisBAdministration
				return Immunization{ recorded: start of (HepatitisBAdministration.performed as Period) }
		) ) HepatitisBVaccination
		where ( FHIRHelpers.ToDateTime(HepatitisBVaccination.recorded) during Interval[FHIRHelpers.ToDateTime(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])
		
define "HiB 3 Dose Immunizations or Procedures":
	( ([Immunization: "HiB Vaccine (3 dose schedule)"]Hi where Hi.status.value = 'completed')
		union ( [Procedure: "HiB Vaccine (3 dose schedule) Administered"] HiB3Administration
				where HiB3Administration.status.value = 'completed'
				return "Immunization"{ recorded: HiB3Administration.performed as dateTime}
		) ) ThreeDoseHiB
		where ( FHIRHelpers.ToDateTime(ThreeDoseHiB.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "HiB 4 Dose Immunizations or Procedures":
	( ([Immunization: "HiB Vaccine (4 dose schedule)"]H4 where H4.status.value = 'completed')
		union ( [Procedure: "HiB Vaccine (4 dose schedule) Administered"] HiB4Administration
				where HiB4Administration.status.value = 'completed'
				return Immunization {recorded: HiB4Administration.performed as dateTime}
		) ) FourDoseHiB
		where ( FHIRHelpers.ToDateTime(FourDoseHiB.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 42 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "HiB Numerator Inclusion Conditions":
	[Condition: "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)"] HibReaction
		where ( FHIRHelpers.ToDateTime(HibReaction.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Influenza Immunizations or Procedures":
	( ([Immunization: "Influenza Vaccine"]In where In.status.value = 'completed')
		union ( [Procedure: "Influenza Vaccine Administered"] InfluenzaAdministration
				where InfluenzaAdministration.status.value = 'completed'
				return "Immunization" { recorded: InfluenzaAdministration.performed as dateTime }
		) ) InfluenzaVaccination
		where ( FHIRHelpers.ToDateTime(InfluenzaVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate) + 180 days, FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Influenza Numerator Inclusion Conditions":
	( [Condition: "Influenza virus vaccine adverse reaction (disorder)"]
		union [Condition: "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"]
		union [Condition: "Neomycin adverse reaction (disorder)"]
		union [Condition: "HIV"]
		union [Condition: "Disorders of the Immune System"] ) InfluenzaConditions
		where ( FHIRHelpers.ToDateTime(InfluenzaConditions.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Measles Indicators":
	( ( [Observation: "Measles Antibody Test (IgG Antibody Titer)"] MeaslesTiter
			where MeaslesTiter.value as Quantity >= 1.10
	)
		union ( [Observation: "Measles Antibody Test (IgG Antibody presence)"] MeaslesIgGPresence
				where MeaslesIgGPresence.value as CodeableConcept in "Positive Finding"
		)
		union ( [Condition: "Measles"] MeaslesDiagnosis
				return "Observation" { effective: MeaslesDiagnosis.onset as dateTime }
		) ) Measles
		where ( FHIRHelpers.ToDateTime(Measles.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "MMR Numerator Inclusion Conditions":
	( [Condition: "Disorders of the Immune System"]
		union [Condition: "HIV"]
		union [Condition: "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"]
		union [Condition: "Neomycin adverse reaction (disorder)"] ) MMRConditions
		where ( FHIRHelpers.ToDateTime(MMRConditions.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Mumps Indicators":
	( ( [Observation: "Mumps Antibody Test (IgG Antibody Titer)"] MumpsTiter
			where MumpsTiter.value as Quantity >= 1.10
	)
		union ( [Observation: "Mumps Antibody Test (IgG Antibody presence)"] MumpsIgGPresence
				where MumpsIgGPresence.value as CodeableConcept in "Positive Finding"
		)
		union ( [Condition: "Mumps"] MumpsDiagnosis
				return "Observation" { effective: MumpsDiagnosis.onset as dateTime }
		) ) Mumps
		where ( FHIRHelpers.ToDateTime(Mumps.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "One Chicken Pox Vaccination":
	( ([Immunization: "Varicella Zoster Vaccine (VZV)"]VZ where VZ.status.value = 'completed')
		union ( [Procedure: "Varicella Zoster Vaccine (VZV) Administered"] ChickenPoxAdministration
				return "Immunization" { recorded: ChickenPoxAdministration.performed as dateTime }
		) ) ChickenPoxVaccination
		where ( FHIRHelpers.ToDateTime(ChickenPoxVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "One Hepatitis A Vaccinations":
	( ([Immunization: "Hepatitis A Vaccine"]HA where HA.status.value = 'completed')
		union ( [Procedure: "Hepatitis A Vaccine Administered"] HepatitisAAdministration
				where HepatitisAAdministration.status.value = 'completed'
				return Immunization { recorded: HepatitisAAdministration.performed as dateTime}
		) ) HepatitisAVaccination
		where ( FHIRHelpers.ToDateTime(HepatitisAVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "One MMR Vaccination":
	( ([Immunization: "Measles, Mumps and Rubella (MMR) Vaccine"]MMR where MMR.status.value = 'completed')
		union ( [Procedure: "Measles, Mumps and Rubella (MMR) Vaccine Administered"] MMRAdministration
				where  MMRAdministration.status.value = 'comppleted'
				return Immunization { recorded: MMRAdministration.performed as dateTime }
		) ) MMRVaccination
		where ( FHIRHelpers.ToDateTime(MMRVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Pneumococcal Conjugate Numerator Inclusion Conditions":
	[Condition: "Pneumococcal vaccine adverse reaction (disorder)"] PneumococcalReaction
		where ( FHIRHelpers.ToDateTime(PneumococcalReaction.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Polio Immunizations or Procedures":
	( ([Immunization: "Inactivated Polio Vaccine (IPV)"]IP where IP.status.value = 'completed')
		union ( [Procedure: "Inactivated Polio Vaccine (IPV) Administered"] PolioAdministration
				where PolioAdministration.status.value = 'completed'
				return Immunization{ recorded: PolioAdministration.performed as dateTime }
		) ) PolioVaccination
		where ( FHIRHelpers.ToDateTime(PolioVaccination.recorded) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Polio Numerator Inclusion Conditions":
	( [Condition: "Poliomyelitis vaccine adverse reaction (disorder)"]
		union [Condition: "Streptomycin adverse reaction (disorder)"]
		union [Condition: "Polymyxin B adverse reaction (disorder)"]
		union [Condition: "Neomycin adverse reaction (disorder)"] ) PolioConditions
		where ( FHIRHelpers.ToDateTime(PolioConditions.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Rotavirus Numerator Inclusion Conditions":
	( ( [Condition: "Anaphylaxis due to rotavirus vaccine (disorder)"]
			union [Condition: "Severe Combined Immunodeficiency"]
			union [Condition: "Intussusception"] ) RotavirusConditions
			where ( FHIRHelpers.ToDateTime(RotavirusConditions.onset as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])
	)

define "Rubella Indicators":
	( ( [Observation: "Rubella Antibody Test (IgG Antibody Titer)"] RubellaTiter
			where RubellaTiter.value as Quantity >= 1.10
	)
		union ( [Observation: "Rubella Antibody Test (IgG Antibody presence)"] RubellaIgGPresence
				where RubellaIgGPresence.value as CodeableConcept in "Positive Finding"
		)
		union ( [Condition: "Rubella"] RubellaDiagnosis
				return "Observation" { effective: RubellaDiagnosis.onset as dateTime}
		) ) Rubella
		where ( FHIRHelpers.ToDateTime(Rubella.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Varicella Zoster Numerator Inclusion Conditions":
	( ( [Observation: "Varicella Zoster Antibody Test (IgG Antibody Titer)"] ChickenPoxTiter
			where ChickenPoxTiter.value as Quantity >= 1.10
	)
		union ( [Observation: "Varicella Zoster Antibody Test (IgG Antibody Presence)"] ChickenPoxIgGPresence
				where ChickenPoxIgGPresence.value as CodeableConcept in "Positive Finding"
		)
		union ( [Condition: "Disorders of the Immune System"] ImmuneDisorder
				return Observation { effective: ImmuneDisorder.onset as dateTime }
		)
		union ( [Condition: "HIV"] HIV
				return Observation { effective: HIV.onset as dateTime }
		)
		union ( [Condition: "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"] LymphaticMalignantNeoplasm
				return Observation{ effective: LymphaticMalignantNeoplasm.onset as dateTime}
		)
		union ( [Condition: "Neomycin adverse reaction (disorder)"] NeomycinReaction
				return Observation { effective: NeomycinReaction.onset as dateTime }
		)
		union ( [Condition: "Varicella Zoster"] VaricellaZoster
				return Observation { effective: VaricellaZoster.onset as dateTime }
		) ) VaricellaZosterConditions
		where ( FHIRHelpers.ToDateTime(VaricellaZosterConditions.effective as dateTime) during Interval[FHIRHelpers.ToDate(Patient.birthDate), FHIRHelpers.ToDate(Patient.birthDate) + 2 years])

define "Initial Population":
	exists ( AgeInYearsAt(start of "Measurement Period") >= 1 and AgeInYearsAt(end of "Measurement Period") < 2
	)
		and exists ( "Qualifying Encounter" )



define "Numerator":
	( exists ( "Four DTaP Vaccinations" )
			or exists ( "DTaP Numerator Inclusion Conditions" )
	)
		and ( exists ( "Three Polio Vaccinations" )
				or exists ( "Polio Numerator Inclusion Conditions" )
		)
		and ( exists ( "One MMR Vaccination" )
				or exists ( "MMR Numerator Inclusion Conditions" )
				or ( exists ( "Measles Indicators" )
						and exists ( "Mumps Indicators" )
						and exists ( "Rubella Indicators" )
				)
		)
		and ( "Has Appropriate Number of HiB Immunizations"
				or exists ( "HiB Numerator Inclusion Conditions" )
		)
		and ( exists ( "Three Hepatitis B Vaccinations" )
				or exists ( "Hepatitis B Numerator Inclusion Conditions" )
		)
		and ( exists ( "One Chicken Pox Vaccination" )
				or exists ( "Varicella Zoster Numerator Inclusion Conditions" )
		)
		and ( exists ( "Four Pneumococcal Conjugate Vaccinations" )
				or exists ( "Pneumococcal Conjugate Numerator Inclusion Conditions" )
		)
		and ( exists ( "One Hepatitis A Vaccinations" )
				or exists ( "Hepatitis A Numerator Inclusion Conditions" )
		)
		and ( exists ( "Rotavirus 2 Dose Vaccinations" )
				or exists ( "Rotavirus Numerator Inclusion Conditions" )
				or exists ( "Rotavirus 2 or 3 Dose Vaccinations" )
				or exists ( "Rotavirus 3 Dose Vaccinations" )
		)
		and ( exists ( "Two Influenza Vaccinations" )
				or exists ( "Influenza Numerator Inclusion Conditions" )
		)

define "All Hib Vaccinations":
	"HiB 3 or 4 Dose Immunizations" AllHiBDoses1
		with "HiB 3 or 4 Dose Immunizations" AllHiBDoses2
			such that FHIRHelpers.ToDateTime(AllHiBDoses1.recorded) more than 1 day before FHIRHelpers.ToDateTime(AllHiBDoses2.recorded)
				or FHIRHelpers.ToDateTime(AllHiBDoses1.recorded)  more than 1 day after FHIRHelpers.ToDateTime((AllHiBDoses2.recorded) 
				
