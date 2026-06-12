# USASpending.gov Dimensional Modeling

## Fact_Awards

### Purpose:

Stores all financial measures and foreign keys to dimensions.

### Grain:

One record per contract transaction (contract_transaction_unique_key).

| Column                       | Data Type          | Description               |
| ---------------------------- | ------------------ | ------------------------- |
| AwardFactKey                 | bigint identity PK | Surrogate key             |
| ContractTransactionKey       | varchar(100)       | Degenerate dimension      |
| ContractAwardKey             | varchar(100)       | Degenerate dimension      |
| AwardIDPIID                  | varchar(50)        | Degenerate dimension      |
| ModificationNumber           | varchar(25)        | Degenerate dimension      |
| TransactionNumber            | int                | Transaction sequence      |
| DateKey                      | int                | FK to Dim_Date            |
| RecipientKey                 | int                | FK to Dim_Recipient       |
| ParentRecipientKey           | int                | FK to Dim_ParentRecipient |
| AwardingAgencyKey            | int                | FK                        |
| FundingAgencyKey             | int                | FK                        |
| NAICSKey                     | int                | FK                        |
| ProductServiceCodeKey        | int                | FK                        |
| AwardTypeKey                 | int                | FK                        |
| CompetitionKey               | int                | FK                        |
| SetAsideKey                  | int                | FK                        |
| PlaceOfPerformanceKey        | int                | FK                        |
| ContractVehicleKey           | int                | FK                        |
| SocioEconomicKey             | int                | FK                        |
| FederalActionObligation      | decimal(20,2)      | Daily obligation amount   |
| TotalDollarsObligated        | decimal(20,2)      | Cumulative obligated      |
| TotalOutlayedAmount          | decimal(20,2)      | Total paid                |
| BaseAndExercisedOptionsValue | decimal(20,2)      | Award value               |
| CurrentTotalValueOfAward     | decimal(20,2)      | Current total             |
| BaseAndAllOptionsValue       | decimal(20,2)      | Full potential            |
| PotentialTotalValueOfAward   | decimal(20,2)      | Maximum value             |
| COVIDObligatedAmount         | decimal(20,2)      | COVID funding             |
| IIJAObligatedAmount          | decimal(20,2)      | Infrastructure funding    |
| NumberOfOffersReceived       | int                | Competition measure       |
| FileName                     | varchar(255)       | ETL audit                 |
| InitialReportDate            | datetime2          | ETL audit                 |
| LastModifiedDate             | datetime2          | Source audit              |

## CORE DIMENSIONS

## Dim_Date

| Column        | Data Type         |
| ------------- | ----------------- |
| DateKey       | int (YYYYMMDD) PK |
| FullDate      | date              |
| DayNumber     |                   |
| DayName       |                   |
| WeekNumber    |                   |
| MonthNumber   |                   |
| MonthName     |                   |
| QuarterNumber |                   |
| FiscalYear    |                   |
| FiscalQuarter |                   |
| CalendarYear  |                   |
| IsWeekend     |                   |

## Dim_Recipient

SCD Type 2 recommended
| Column | Data Type |
| -------------------- | --------------- |
| RecipientKey | int identity PK |
| RecipientUEI | varchar(20) |
| RecipientDUNS | varchar(15) |
| RecipientName | |
| DBAName | |
| CageCode | |
| BusinessSize | |
| OrganizationalType | |
| RecipientStateCode | |
| RecipientCountryCode | |
| IsForProfit | |
| IsNonProfit | |
| IsForeignOwned | |
| EffectiveStartDate | |
| EffectiveEndDate | |
| IsCurrent | |

## Dim_ParentRecipient

| Column             | Data Type |
| ------------------ | --------- |
| ParentRecipientKey | int PK    |
| ParentUEI          |           |
| ParentDUNS         |           |
| ParentName         |           |

## Dim_NAICS

| Column            | Data Type    |
| ----------------- | ------------ |
| NAICSKey          | int PK       |
| NAICSCode         | varchar(10)  |
| NAICSDescription  | varchar(255) |
| SectorCode        | varchar(2)   |
| SectorDescription | varchar(100) |

## Dim_AwardingAgency

| Column            | Data Type |
| ----------------- | --------- |
| AwardingAgencyKey | int PK    |
| AgencyCode        |           |
| AgencyName        |           |
| SubAgencyCode     |           |
| SubAgencyName     |           |
| OfficeCode        |           |
| OfficeName        |           |
| ParentAgencyID    |           |
| ParentAgencyName  |           |

## Dim_FundingAgency

| Column           | Data Type |
| ---------------- | --------- |
| FundingAgencyKey | int PK    |
| AgencyCode       |           |
| AgencyName       |           |
| SubAgencyCode    |           |
| SubAgencyName    |           |
| OfficeCode       |           |
| OfficeName       |           |
| ParentAgencyID   |           |
| ParentAgencyName |           |

## Dim_State

| Column         | Data Type |
| -------------- | --------- |
| StateKey       | int PK    |
| StateCode      | char(2)   |
| StateName      |           |
| StateFIPS      |           |
| CensusRegion   |           |
| CensusDivision |           |

## Dim_PlaceOfPerformance

| Column                | Data Type |
| --------------------- | --------- |
| PlaceOfPerformanceKey | int PK    |
| CountryCode           |           |
| CountryName           |           |
| StateCode             |           |
| StateName             |           |
| CountyFIPS            |           |
| CountyName            |           |
| CongressionalDistrict |           |
| CityName              |           |
| ZIPCode               |           |

## Dim_ProductServiceCode

| Column                | Data Type    |
| --------------------- | ------------ |
| ProductServiceCodeKey | int PK       |
| PSCCode               | varchar(10)  |
| PSCDescription        | varchar(255) |

## Dim_AwardType

| Column              | Data Type |
| ------------------- | --------- |
| AwardTypeKey        | int PK    |
| AwardTypeCode       |           |
| AwardType           |           |
| IDVTypeCode         |           |
| IDVType             |           |
| PricingTypeCode     |           |
| PricingType         |           |
| ContractVehicleType |           |

## Dim_Competition

| Column                          | Data Type |
| ------------------------------- | --------- |
| CompetitionKey                  | int PK    |
| ExtentCompetedCode              |           |
| ExtentCompeted                  |           |
| SolicitationProcedures          |           |
| OtherThanFullAndOpenCompetition |           |
| FairOpportunityLimitedSources   |           |

## Dim_SetAside

| Column                  | Data Type |
| ----------------------- | --------- |
| SetAsideKey             | int PK    |
| TypeOfSetAsideCode      |           |
| TypeOfSetAside          |           |
| EvaluatedPreferenceCode |           |
| EvaluatedPreference     |           |
| LocalAreaSetAside       |           |

## Dim_ContractVehicle

| Column                   | Data Type |
| ------------------------ | --------- |
| ContractVehicleKey       | int PK    |
| ParentAwardIDPIID        |           |
| ParentAwardType          |           |
| MultipleOrSingleAwardIDV |           |
| TypeOfIDC                |           |
| OrderingPeriodEndDate    |           |

## Dim_SocioEconomicFlags

Contains recipient certifications
This avoids dozens of bit columns in the fact table.
| Column | Data Type |
| ----------------------------------- | --------- |
| SocioEconomicKey | int PK |
| VeteranOwnedBusiness | bit |
| ServiceDisabledVeteranOwnedBusiness | bit |
| WomanOwnedBusiness | bit |
| SmallDisadvantagedBusiness | bit |
| HUBZoneFirm | bit |
| MinorityOwnedBusiness | bit |
| BlackAmericanOwnedBusiness | bit |
| HispanicAmericanOwnedBusiness | bit |
| NativeAmericanOwnedBusiness | bit |
| AlaskanNativeCorporationOwnedFirm | bit |
| HistoricallyBlackCollege | bit |
| TribalCollege | bit |
