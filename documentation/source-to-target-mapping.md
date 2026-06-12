# SOURCE TO TARGET MAPPING

## Dim_Recipient

### Business Purpose

Stores information about the award recipient organization.
| Dim_Recipient Column | Source Column |
| -------------------- | -------------------------------- |
| RecipientUEI | recipient_uei |
| RecipientDUNS | recipient_duns |
| RecipientName | recipient_name |
| DBAName | recipient_doing_business_as_name |
| CageCode | cage_code |
| OrganizationalType | organizational_type |
| RecipientStateCode | recipient_state_code |
| RecipientCountryCode | recipient_country_code |
| IsForProfit | for_profit_organization |
| IsNonProfit | nonprofit_organization |
| IsForeignOwned | foreign_owned |

SCD Columns:
RecipientKey
EffectiveStartDate
EffectiveEndDate
IsCurrent

## Dim_ParentRecipient

### Business Purpose

Stores parent company hierarchy.
| Dim_ParentRecipient Column | Source Column |
| -------------------------- | --------------------- |
| ParentUEI | recipient_parent_uei |
| ParentDUNS | recipient_parent_duns |
| ParentName | recipient_parent_name |

Generated:
ParentRecipientKey

## Dim_NAICS

### Business Purpose

Industry classification.
| Dim_NAICS Column | Source Column |
| ---------------- | ----------------- |
| NAICSCode | naics_code |
| NAICSDescription | naics_description |

Generated:
NAICSKey

## Dim_AwardingAgency

### Business Purpose

Awarding organization hierarchy.
| Dim_AwardingAgency Column | Source Column |
| ------------------------- | ------------------------ |
| AgencyCode | awarding_agency_code |
| AgencyName | awarding_agency_name |
| SubAgencyCode | awarding_sub_agency_code |
| SubAgencyName | awarding_sub_agency_name |
| OfficeCode | awarding_office_code |
| OfficeName | awarding_office_name |
| ParentAgencyID | parent_award_agency_id |
| ParentAgencyName | parent_award_agency_name |

Generated:
AwardingAgencyKey

## Dim_FundingAgency

### Business Purpose

Agency providing funds.
| Dim_FundingAgency Column | Source Column |
| ------------------------ | ----------------------- |
| AgencyCode | funding_agency_code |
| AgencyName | funding_agency_name |
| SubAgencyCode | funding_sub_agency_code |
| SubAgencyName | funding_sub_agency_name |
| OfficeCode | funding_office_code |
| OfficeName | funding_office_name |

Generated:
FundingAgencyKey

## Dim_State

Awards can be analyzed by both:

- Recipient State
- Place of Performance State
  | Dim_State Column | Source Column |
  | ---------------- | ------------------------------------------------- |
  | StateCode | recipient_state_code |
  | StateName | recipient_state_name |
  | StateFIPS | prime_award_transaction_recipient_state_fips_code |

Generated:
StateKey

## Dim_PlaceOfPerformance

### Business Purpose

Where contract work is performed.
| Dim_PlaceOfPerformance Column | Source Column |
| ----------------------------- | ------------------------------------------------------------- |
| CountryCode | primary_place_of_performance_country_code |
| CountryName | primary_place_of_performance_country_name |
| StateCode | primary_place_of_performance_state_code |
| StateName | primary_place_of_performance_state_name |
| CountyFIPS | prime_award_transaction_place_of_performance_county_fips_code |
| CountyName | primary_place_of_performance_county_name |
| CongressionalDistrict | prime_award_transaction_place_of_performance_cd_current |
| CityName | primary_place_of_performance_city_name |
| ZIPCode | primary_place_of_performance_zip_4 |

Generated:
PlaceOfPerformanceKey

## Dim_ProductServiceCode

### Business Purpose

Product/service categorization
| Dim_ProductServiceCode Column | Source Column |
| ----------------------------- | ----------------------------------- |
| PSCCode | product_or_service_code |
| PSCDescription | product_or_service_code_description |

Generated:
ProductServiceCodeKey

## Dim_AwardType

### Business Purpose

Contract vehicle classification
| Dim_AwardType Column | Source Column |
| -------------------- | ----------------------------- |
| AwardTypeCode | award_type_code |
| AwardType | award_type |
| IDVTypeCode | idv_type_code |
| IDVType | idv_type |
| PricingTypeCode | type_of_contract_pricing_code |
| PricingType | type_of_contract_pricing |
| ContractVehicleType | type_of_idc |

Generated:
AwardTypeKey

## Dim_Competition

### Business Purpose

Competition characteristics.
| Dim_Competition Column | Source Column |
| ------------------------------- | ------------------------------------ |
| ExtentCompetedCode | extent_competed_code |
| ExtentCompeted | extent_competed |
| SolicitationProcedures | solicitation_procedures |
| OtherThanFullAndOpenCompetition | other_than_full_and_open_competition |
| FairOpportunityLimitedSources | fair_opportunity_limited_sources |

Generated:
CompetitionKey

## Dim_SetAside

### Business Purpose

Small business and preference programs.

| Dim_SetAside Column     | Source Column             |
| ----------------------- | ------------------------- |
| TypeOfSetAsideCode      | type_of_set_aside_code    |
| TypeOfSetAside          | type_of_set_aside         |
| EvaluatedPreferenceCode | evaluated_preference_code |
| EvaluatedPreference     | evaluated_preference      |
| LocalAreaSetAside       | local_area_set_aside      |

Generated:
SetAsideKey

## Dim_ContractVehicle

### Business Purpose

Parent contract information
| Dim_ContractVehicle Column | Source Column |
| -------------------------- | ---------------------------- |
| ParentAwardIDPIID | parent_award_id_piid |
| ParentAwardType | parent_award_type |
| MultipleOrSingleAwardIDV | multiple_or_single_award_idv |
| TypeOfIDC | type_of_idc |
| OrderingPeriodEndDate | ordering_period_end_date |

Generated:
ContractVehicleKey

## Dim_SocioEconomicFlags

This dimension absorbs 40+ business classification flags.
| Dim Column | Source Column |
| ----------------------------------- | ----------------------------------------------------- |
| VeteranOwnedBusiness | veteran_owned_business |
| ServiceDisabledVeteranOwnedBusiness | service_disabled_veteran_owned_business |
| WomanOwnedBusiness | woman_owned_business |
| SmallDisadvantagedBusiness | small_disadvantaged_business |
| HUBZoneFirm | historically_underutilized_business_zone_hubzone_firm |
| MinorityOwnedBusiness | minority_owned_business |
| BlackAmericanOwnedBusiness | black_american_owned_business |
| HispanicAmericanOwnedBusiness | hispanic_american_owned_business |
| NativeAmericanOwnedBusiness | native_american_owned_business |
| AlaskanNativeCorporationOwnedFirm | alaskan_native_corporation_owned_firm |
| HistoricallyBlackCollege | historically_black_college |
| TribalCollege | tribal_college |

Generated:
SocioEconomicKey

## Dim_Date

Already loaded from Action Date.
| Dim_Date Column | Source Column |
| --------------- | ----------------------- |
| DateKey | action_date |
| FullDate | action_date |
| FiscalYear | action_date_fiscal_year |

All remaining attributes are derived.

## Fact_Awards

### Grain

One contract transaction per action date.

### Degenerate Dimensions

| Fact Column            | Source Column                   |
| ---------------------- | ------------------------------- |
| ContractTransactionKey | contract_transaction_unique_key |
| ContractAwardKey       | contract_award_unique_key       |
| AwardIDPIID            | award_id_piid                   |
| ModificationNumber     | modification_number             |
| TransactionNumber      | transaction_number              |
| SolicitationIdentifier | solicitation_identifier         |
| USAspendingPermalink   | usaspending_permalink           |

### Foreign Keys

Resolved through dimension lookups.
| Fact Column | Lookup |
| --------------------- | ---------------------- |
| DateKey | Dim_Date |
| RecipientKey | Dim_Recipient |
| ParentRecipientKey | Dim_ParentRecipient |
| AwardingAgencyKey | Dim_AwardingAgency |
| FundingAgencyKey | Dim_FundingAgency |
| NAICSKey | Dim_NAICS |
| ProductServiceCodeKey | Dim_ProductServiceCode |
| AwardTypeKey | Dim_AwardType |
| CompetitionKey | Dim_Competition |
| SetAsideKey | Dim_SetAside |
| ContractVehicleKey | Dim_ContractVehicle |
| PlaceOfPerformanceKey | Dim_PlaceOfPerformance |
| SocioEconomicKey | Dim_SocioEconomicFlags |

### Measures

| Fact Measure                 | Source Column                                                  |
| ---------------------------- | -------------------------------------------------------------- |
| FederalActionObligation      | federal_action_obligation                                      |
| TotalDollarsObligated        | total_dollars_obligated                                        |
| TotalOutlayedAmount          | total_outlayed_amount_for_overall_award                        |
| BaseAndExercisedOptionsValue | base_and_exercised_options_value                               |
| CurrentTotalValueOfAward     | current_total_value_of_award                                   |
| BaseAndAllOptionsValue       | base_and_all_options_value                                     |
| PotentialTotalValueOfAward   | potential_total_value_of_award                                 |
| COVIDObligatedAmount         | obligated_amount_from_COVID_19_supplementals_for_overall_award |
| COVIDOutlayedAmount          | outlayed_amount_from_COVID_19_supplementals_for_overall_award  |
| IIJAObligatedAmount          | obligated_amount_from_IIJA_supplemental_for_overall_award      |
| IIJAOutlayedAmount           | outlayed_amount_from_IIJA_supplemental_for_overall_award       |
| NumberOfOffersReceived       | number_of_offers_received                                      |
