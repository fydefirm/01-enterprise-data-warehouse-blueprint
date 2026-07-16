/******************************************************************************
    UNKNOWN MEMBER INITIALIZATION SCRIPT
    Kimball Best Practice
    Unknown Surrogate Key = -1

    Run once after creating all dimension tables.
******************************************************************************/

BEGIN;

------------------------------------------------------------
-- Dim_Date
------------------------------------------------------------
INSERT INTO Dim_Date
(
    DateKey,
    FullDate,
    DayNumber,
    DayName,
    WeekNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    FiscalYear,
    FiscalQuarter,
    CalendarYear,
    IsWeekend
)
VALUES
(
    -1,
    DATE '1900-01-01',
    0,
    'Unknown',
    0,
    0,
    'Unknown',
    0,
    0,
    0,
    0,
    B'0'
)
ON CONFLICT (DateKey) DO NOTHING;

------------------------------------------------------------
-- Dim_State
------------------------------------------------------------
INSERT INTO Dim_State
(
    StateKey,
    StateCode,
    StateName,
    StateFIPS,
    CensusRegion,
    CensusDivision
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UN',
    'Unknown',
    '00',
    'Unknown',
    'Unknown'
);

------------------------------------------------------------
-- Dim_NAICS
------------------------------------------------------------
INSERT INTO Dim_NAICS
(
    NAICSKey,
    NAICSCode,
    NAICSDescription,
    SectorCode,
    SectorDescription
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKNOWN',
    'Unknown',
    '00',
    'Unknown'
);

------------------------------------------------------------
-- Dim_ProductServiceCode
------------------------------------------------------------
INSERT INTO Dim_ProductServiceCode
(
    ProductServiceCodeKey,
    PSCCode,
    PSCDescription
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKNOWN',
    'Unknown'
);

------------------------------------------------------------
-- Dim_AwardType
------------------------------------------------------------
INSERT INTO Dim_AwardType
(
    AwardTypeKey,
    AwardTypeCode,
    AwardType
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'U',
    'Unknown'   
);

------------------------------------------------------------
-- Dim_IDVType
------------------------------------------------------------
INSERT INTO Dim_IDVType
(
    IDVTypeKey,
    IDVTypeCode,
    IDVType    
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'U',
    'Unknown'    
);

------------------------------------------------------------
-- Dim_PricingType
------------------------------------------------------------
INSERT INTO Dim_PricingType
(
    PricingTypeKey,
    PricingTypeCode,
    PricingType,
    ContractVehicleType
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,   
    '00',
    'Unknown',
    'Unknown'
);

------------------------------------------------------------
-- Dim_AwardingAgency
------------------------------------------------------------
INSERT INTO Dim_AwardingAgency
(
    AwardingAgencyKey,
    AgencyCode,
    AgencyName,
    SubAgencyCode,
    SubAgencyName,
    OfficeCode,
    OfficeName,
    ParentAgencyID,
    ParentAgencyName
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKN',
    'Unknown',
    'UNKN',
    'Unknown',
    'UNKNOWN',
    'Unknown',
    'UNKNOWN',
    'Unknown'
);

------------------------------------------------------------
-- Dim_FundingAgency
------------------------------------------------------------
INSERT INTO Dim_FundingAgency
(
    FundingAgencyKey,
    AgencyCode,
    AgencyName,
    SubAgencyCode,
    SubAgencyName,
    OfficeCode,
    OfficeName,
    ParentAgencyID,
    ParentAgencyName
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKN',
    'Unknown',
    'UNKN',
    'Unknown',
    'UNKNOWN',
    'Unknown',
    'UNKNOWN',
    'Unknown'
);

------------------------------------------------------------
-- Dim_Recipient
------------------------------------------------------------
INSERT INTO Dim_Recipient
(
    RecipientKey,
    RecipientUEI,
    RecipientDUNS,
    RecipientName,
    DBAName,
    CageCode,
    BusinessSize,
    OrganizationalType,
    RecipientStateCode,
    RecipientCountryCode,
    IsForProfit,
    IsNonProfit,
    IsForeignOwned,
    EffectiveStartDate,
    EffectiveEndDate,
    IsCurrent
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKNOWN',
    'UNKNOWN',
    'Unknown',
    'Unknown',
    'UNKNOWN',
    'U',
    'Unknown',
    'UN',
    'UNK',
    B'0',
    B'0',
    B'0',
    TIMESTAMP '1900-01-01 00:00:00',
    TIMESTAMP '9999-12-31 00:00:00',
    B'1'
);

------------------------------------------------------------
-- Dim_ParentRecipient
------------------------------------------------------------
INSERT INTO Dim_ParentRecipient
(
    ParentRecipientKey,
    ParentUEI,
    ParentDUNS,
    ParentName
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKNOWN',
    'UNKNOWN',
    'Unknown'
);

------------------------------------------------------------
-- Dim_PlaceOfPerformance
------------------------------------------------------------
INSERT INTO Dim_PlaceOfPerformance
(
    PlaceOfPerformanceKey,
    CountryCode,
    CountryName,
    StateCode,
    StateName,
    CountyFIPS,
    CountyName,
    CongressionalDistrict,
    CityName,
    ZIPCode
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNK',
    'Unknown',
    'UN',
    'Unknown',
    '00000',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown'
);

------------------------------------------------------------
-- Dim_Competition
------------------------------------------------------------
INSERT INTO Dim_Competition
(
    CompetitionKey,
    ExtentCompetedCode,
    ExtentCompeted,
    SolicitationProcedures,
    OtherThanFullAndOpenCompetition,
    FairOpportunityLimitedSources
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNK',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown'
);

------------------------------------------------------------
-- Dim_SetAside
------------------------------------------------------------
INSERT INTO Dim_SetAside
(
    SetAsideKey,
    TypeOfSetAsideCode,
    TypeOfSetAside,
    EvaluatedPreferenceCode,
    EvaluatedPreference,
    LocalAreaSetAside
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNK',
    'Unknown',
    'UNK',
    'Unknown',
    'UNK'
);

------------------------------------------------------------
-- Dim_ContractVehicle
------------------------------------------------------------
INSERT INTO Dim_ContractVehicle
(
    ContractVehicleKey,
    ParentAwardIDPIID,
    ParentAwardType,
    MultipleOrSingleAwardIDV,
    TypeOfIDC,
    OrderingPeriodEndDate
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    'UNKNOWN',
    'Unknown',
    'Unknown',
    'Unknown',
    DATE '1900-01-01'
);

------------------------------------------------------------
-- Dim_SocioEconomicFlags
------------------------------------------------------------
INSERT INTO Dim_SocioEconomicFlags
(
    SocioEconomicKey,
    VeteranOwnedBusiness,
    ServiceDisabledVeteranOwnedBusiness,
    WomanOwnedBusiness,
    SmallDisadvantagedBusiness,
    HUBZoneFirm,
    MinorityOwnedBusiness,
    BlackAmericanOwnedBusiness,
    HispanicAmericanOwnedBusiness,
    NativeAmericanOwnedBusiness,
    AlaskanNativeCorporationOwnedFirm,
    HistoricallyBlackCollege,
    TribalCollege
)
OVERRIDING SYSTEM VALUE
VALUES
(
    -1,
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0',
    B'0'
);

COMMIT;