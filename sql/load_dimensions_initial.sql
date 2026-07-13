/*
===============================================================================
Populate Dim_Date for U.S. Federal Fiscal Year 2025 in PostgreSQL
Fiscal Year 2025 = October 1, 2024 through September 30, 2025
===============================================================================

Assumptions:
- Table Dim_Date already exists.
- DateKey format = YYYYMMDD (integer).
- Federal Fiscal Year starts on October 1.
- Federal Fiscal Quarters:
    Q1 = Oct-Dec
    Q2 = Jan-Mar
    Q3 = Apr-Jun
    Q4 = Jul-Sep
===============================================================================
*/

BEGIN;

-- Optional: remove existing FY2025 rows
DELETE FROM Dim_Date
WHERE FiscalYear = 2025;

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
SELECT
    -- DateKey in YYYYMMDD format
    TO_CHAR(d::date, 'YYYYMMDD')::INT AS DateKey,

    -- Full date
    d::date AS FullDate,

    -- Day of month (1-31)
    EXTRACT(DAY FROM d)::SMALLINT AS DayNumber,

    -- Day name (trim removes padding spaces)
    TRIM(TO_CHAR(d, 'Day')) AS DayName,

    -- ISO week number (1-53)
    EXTRACT(WEEK FROM d)::SMALLINT AS WeekNumber,

    -- Month number (1-12)
    EXTRACT(MONTH FROM d)::SMALLINT AS MonthNumber,

    -- Month name
    TRIM(TO_CHAR(d, 'Month')) AS MonthName,

    -- Calendar quarter (1-4)
    EXTRACT(QUARTER FROM d)::SMALLINT AS QuarterNumber,

    -- Federal Fiscal Year
    CASE
        WHEN EXTRACT(MONTH FROM d) >= 10
            THEN (EXTRACT(YEAR FROM d) + 1)::INT
        ELSE EXTRACT(YEAR FROM d)::INT
    END AS FiscalYear,

    -- Federal Fiscal Quarter
    CASE
        WHEN EXTRACT(MONTH FROM d) IN (10, 11, 12) THEN 1
        WHEN EXTRACT(MONTH FROM d) IN (1, 2, 3)   THEN 2
        WHEN EXTRACT(MONTH FROM d) IN (4, 5, 6)   THEN 3
        WHEN EXTRACT(MONTH FROM d) IN (7, 8, 9)   THEN 4
    END::SMALLINT AS FiscalQuarter,

    -- Calendar year
    EXTRACT(YEAR FROM d)::INT AS CalendarYear,

    -- Weekend flag (Saturday=6, Sunday=0)
    CASE
        WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS IsWeekend

FROM generate_series(
        DATE '2024-10-01',
        DATE '2025-09-30',
        INTERVAL '1 day'
     ) AS gs(d);

COMMIT;

-- Validation
SELECT
    MIN(FullDate) AS StartDate,
    MAX(FullDate) AS EndDate,
    COUNT(*) AS NumberOfDays
FROM Dim_Date
WHERE FiscalYear = 2025;

/*
Expected Result:
 StartDate    | 2024-10-01
 EndDate      | 2025-09-30
 NumberOfDays | 365
*/




/*
===============================================================================
Populate Dim_State 
===============================================================================

Assumptions:

===============================================================================
*/
INSERT INTO Dim_State
SELECT CASE statename
		WHEN 'ALABAMA' THEN 'AL'
		WHEN 'ALASKA' THEN 'AK'
		WHEN 'ARIZONA' THEN 'AZ'
		WHEN 'ARKANSAS' THEN 'AR'
		WHEN 'CALIFORNIA' THEN 'CA'
		WHEN 'COLORADO' THEN 'CO'
		WHEN 'CONNECTICUT' THEN 'CT'
		WHEN 'DELAWARE' THEN 'DE'
		WHEN 'DISTRICT OF COLUMBIA' THEN 'DC'
		WHEN 'FLORIDA' THEN 'FL'
		WHEN 'GEORGIA' THEN 'GA'
		WHEN 'HAWAII' THEN 'HI'
		WHEN 'IDAHO' THEN 'ID'
		WHEN 'ILLINOIS' THEN 'IL'
		WHEN 'INDIANA' THEN 'IN'
		WHEN 'IOWA' THEN 'IA'
		WHEN 'KANSAS' THEN 'KS'
		WHEN 'KENTUCKY' THEN 'KY'
		WHEN 'LOUISIANA' THEN 'LA'
		WHEN 'MAINE' THEN 'ME'
		WHEN 'MARYLAND' THEN 'MD'
		WHEN 'MASSACHUSETTS' THEN 'MA'
		WHEN 'MICHIGAN' THEN 'MI'
		WHEN 'MINNESOTA' THEN 'MN'
		WHEN 'MISSISSIPPI' THEN 'MS'
		WHEN 'MISSOURI' THEN 'MO'
		WHEN 'MONTANA' THEN 'MT'
		WHEN 'NEBRASKA' THEN 'NE'
		WHEN 'NEVADA' THEN 'NV'
		WHEN 'NEW HAMPSHIRE' THEN 'NH'
		WHEN 'NEW JERSEY' THEN 'NJ'
		WHEN 'NEW MEXICO' THEN 'NM'
		WHEN 'NEW YORK' THEN 'NY'
		WHEN 'NORTH CAROLINA' THEN 'NC'
		WHEN 'NORTH DAKOTA' THEN 'ND'
		WHEN 'OHIO' THEN 'OH'
		WHEN 'OKLAHOMA' THEN 'OK'
		WHEN 'OREGON' THEN 'OR'
		WHEN 'PENNSYLVANIA' THEN 'PA'
		WHEN 'RHODE ISLAND' THEN 'RI'
		WHEN 'SOUTH CAROLINA' THEN 'SC'
		WHEN 'SOUTH DAKOTA' THEN 'SD'
		WHEN 'TENNESSEE' THEN 'TN'
		WHEN 'TEXAS' THEN 'TX'
		WHEN 'UTAH' THEN 'UT'
		WHEN 'VERMONT' THEN 'VT'
		WHEN 'VIRGINIA' THEN 'VA'
		WHEN 'WASHINGTON' THEN 'WA'
		WHEN 'WEST VIRGINIA' THEN 'WV'
		WHEN 'WISCONSIN' THEN 'WI'
		WHEN 'WYOMING' THEN 'WY'
	  END AS statecode, 
	 statename, fipscode as statefips,
	 CASE
	 	WHEN statename in ('CONNECTICUT','MAINE','MASSACHUSETTS','NEW HAMPSHIRE','RHODE ISLAND','VERMONT','NEW JERSEY','NEW YORK','PENNSYLVANIA' )
		THEN 'Northeast'
		WHEN statename in ('ILLINOIS','INDIANA','MICHIGAN','OHIO','WISCONSIN','IOWA','KANSAS','MINNESOTA','MISSOURI','NEBRASKA','NORTH DAKOTA','SOUTH DAKOTA')
		THEN 'Midwest'
		WHEN statename in ('DELAWARE','DISTRICT OF COLUMBIA','FLORIDA','GEORGIA','MARYLAND','NORTH CAROLINA','SOUTH CAROLINA','VIRGINIA','WEST VIRGINIA',
						  'ALABAMA','KENTUCKY','MISSISSIPPI','TENNESSEE','ARKANSAS','LOUISIANA','OKLAHOMA','TEXAS')
		THEN 'South'
		WHEN statename in ('ARIZONA','COLORADO','IDAHO','MONTANA','NEVADA','NEW MEXICO','UTAH','WYOMING','ALASKA','CALIFORNIA','HAWAII','OREGON','WASHINGTON')
		THEN 'West'
	END AS censusregion,
	CASE
		WHEN statename in ('CONNECTICUT','MAINE','MASSACHUSETTS','NEW HAMPSHIRE','RHODE ISLAND','VERMONT')
		THEN 'New England'
		WHEN statename in ('NEW JERSEY','NEW YORK','PENNSYLVANIA')
		THEN 'Middle Atlantic'
		WHEN statename in ('ILLINOIS','INDIANA','MICHIGAN','OHIO','WISCONSIN')
		THEN 'East North Central'
		WHEN statename in ('IOWA','KANSAS','MINNESOTA','MISSOURI','NEBRASKA','NORTH DAKOTA','SOUTH DAKOTA')
		THEN 'West North Central'
		WHEN statename in ('DELAWARE','DISTRICT OF COLUMBIA','FLORIDA','GEORGIA','MARYLAND','NORTH CAROLINA','SOUTH CAROLINA','VIRGINIA','WEST VIRGINIA')
		THEN 'South Atlantic'
		WHEN statename in ('ALABAMA','KENTUCKY','MISSISSIPPI','TENNESSEE')
		THEN 'East South Central'
		WHEN statename in ('ARKANSAS','LOUISIANA','OKLAHOMA','TEXAS')
		THEN 'West South Central'
		WHEN statename in ('ARIZONA','COLORADO','IDAHO','MONTANA','NEVADA','NEW MEXICO','UTAH','WYOMING')
		THEN 'Mountain'
		WHEN statename in ('ALASKA','CALIFORNIA','HAWAII','OREGON','WASHINGTON')
		THEN 'Pacific'
	END AS censusdivision		
FROM statefips
ORDER BY fipscode

/*
===============================================================================
Populate Dim_NAICS
===============================================================================

Assumptions:
1. You need a NAICS_Staging where the Sector transformation is already done
2. Otherwise generate a INSERT seed script
3. You need an UNKNOWN row in the dimension

===============================================================================
*/
INSERT INTO Dim_NAICS (NAICSCode, NAICSDescription, SectorCode, SectorDescription)
SELECT DISTINCT Naics_Code, 
				Naics_Description,
				LEFT(Naics_Code, 2) AS SectorCode,
				CASE LEFT(Naics_Code, 2)
					WHEN '11' THEN 'Agriculture, Forestry, Fishing and Hunting'
					WHEN '21' THEN 'Mining, Quarrying, and Oil and Gas Extraction'
					WHEN '22' THEN 'Utilities'
					WHEN '23' THEN 'Construction'
					WHEN '31' THEN 'Manufacturing'
					WHEN '32' THEN 'Manufacturing'
					WHEN '33' THEN 'Manufacturing'
					WHEN '42' THEN 'Wholesale Trade'
					WHEN '44' THEN 'Retail Trade'
					WHEN '45' THEN 'Retail Trade'
					WHEN '48' THEN 'Transportation and Warehousing'
					WHEN '49' THEN 'Transportation and Warehousing'
					WHEN '51' THEN 'Information'
					WHEN '52' THEN 'Finance and Insurance'
					WHEN '53' THEN 'Real Estate and Rental and Leasing'
					WHEN '54' THEN 'Professional, Scientific, and Technical Services'
					WHEN '55' THEN 'Management of Companies and Enterprises'
					WHEN '56' THEN 'Administrative and Support and Waste Management and Remediation Services'
					WHEN '61' THEN 'Educational Services'
					WHEN '62' THEN 'Health Care and Social Assistance'
					WHEN '71' THEN 'Arts, Entertainment, and Recreation'
					WHEN '72' THEN 'Accommodation and Food Services'
					WHEN '81' THEN 'Other Services (except Public Administration)'
					WHEN '92' THEN 'Public Administration'
				END AS SectorDescription
FROM awarddata2025_staging
WHERE NAICS_CODE IS NOT NULL

/*
===============================================================================
Populate Dim_ProductServiceCode
===============================================================================

Assumptions:
Product_or_Service_Code:
The code that best identifies the product or service procured. Codes are 
defined in the Product and Service Codes Manual. 
See https://www.acquisition.gov/psc-manual
===============================================================================
*/
INSERT INTO Dim_ProductServiceCode (psccode, pscdescription)
SELECT DISTINCT product_or_service_code, product_or_service_code_description
FROM awarddata2025_staging
WHERE product_or_service_code IS NOT NULL

/*
===============================================================================
Populate Dim_AwardType
===============================================================================

Assumptions:
-- AwardType: The type of award being entered by this transaction. Types of awards include Purchase Orders (PO), Delivery Orders (DO), Blanket Purchase Agreements (BPA) Calls and Definitive Contracts.
--------------- A = BPA Call, B = Purchase Order, C = Delivery Order, D = Definitive Contract
-- IDVType: The type of Indefinite Delivery Vehicle being (IDV) loaded by this transaction. IDV Types include Government-Wide Acquisition Contract (GWAC), Multi-Agency Contract, Other Indefinite Delivery Contract (IDC), Federal Supply Schedule (FSS), Basic Ordering Agreement (BOA), and Blanket Purchase Agreements (BPA).
------------- A = GWAC, B = IDC, C = FSS, D = BOA, E = BPA
Type of contract pricing: 
A = FIXED PRICE REDETERMINATION
B = FIXED PRICE LEVEL OF EFFORT
J = FIRM FIXED PRICE
K = FIXED PRICE WITH ECONOMIC PRICE ADJUSTMENT
L = FIXED PRICE INCENTIVE
M = FIXED PRICE AWARD FEE
R = COST PLUS AWARD FEE
S = COST NO FEE
T = COST SHARING
U = COST PLUS FIXED FEE
V = COST PLUS INCENTIVE FEE
Y = TIME AND MATERIALS
Z = LABOR HOURS
1 = ORDER DEPENDENT (IDV ALLOWS PRICING ARRANGEMENT TO BE DETERMINED SEPARATELY FOR EACH ORDER)
2 = COMBINATION (APPLIES TO AWARDS WHERE TWO OR MORE OF THE ABOVE APPLY)
3 = OTHER (APPLIES TO AWARDS WHERE NONE OF THE ABOVE APPLY)
===============================================================================
*/
INSERT INTO Dim_AwardType (AwardTypeCode, AwardType, IDVTypeCode, IDVType, PricingTypeCode, PricingType)
select distinct award_type_code, award_type, idv_type_code, idv_type, type_of_contract_pricing_code, type_of_contract_pricing
from awarddata2025_staging



/*
===============================================================================
Populate Dim_AwardingAgency
===============================================================================

Assumptions:

===============================================================================
*/

INSERT INTO Dim_AwardingAgency (agencycode, agencyname, subagencycode, subagencyname, officecode, officename, parentagencyid, parentagencyname)
SELECT DISTINCT
       awarding_agency_code,
       awarding_agency_name,
       awarding_sub_agency_code,
       awarding_sub_agency_name,
       awarding_office_code,
       awarding_office_name,
       parent_award_agency_id,
       parent_award_agency_name
FROM AwardData2025_Staging


/*
===============================================================================
Populate Dim_Funding_Agency
===============================================================================

Assumptions:

===============================================================================
*/

INSERT INTO Dim_FundingAgency(AgencyCode, AgencyName, SubAgencyCode, SubAgencyName, OfficeCode,OfficeName)
SELECT DISTINCT
       funding_agency_code,
       funding_agency_name,
       funding_sub_agency_code,
       funding_sub_agency_name,
       funding_office_code,
       funding_office_name
FROM AwardData2025_Staging;


/*
===============================================================================
Populate Dim_Competition
===============================================================================

Assumptions:

===============================================================================
*/

INSERT INTO Dim_Competition(ExtentCompetedCode, ExtentCompeted, SolicitationProcedures, OtherThanFullAndOpenCompetition, FairOpportunityLimitedSources)
SELECT DISTINCT
       extent_competed_code,
       extent_competed,
       solicitation_procedures,
       other_than_full_and_open_competition,
       fair_opportunity_limited_sources
FROM AwardData2025_Staging
WHERE extent_competed_code is not null;


/*
===============================================================================
Populate Dim_Recipient
===============================================================================

Assumptions:
SCD Type 2
===============================================================================
*/

INSERT INTO Dim_Recipient(RecipientUEI, RecipientDUNS, RecipientName, DBAName, CageCode, OrganizationalType, RecipientStateCode, RecipientCountryCode, IsForProfit,
    IsNonProfit,IsForeignOwned)
SELECT DISTINCT
       recipient_uei,
       recipient_duns,
       recipient_name,
       recipient_doing_business_as_name,
       cage_code,
       organizational_type,
       recipient_state_code,
       recipient_country_code,
       for_profit_organization,
       nonprofit_organization,
       foreign_owned
FROM AwardData2025_Staging;

INSERT INTO Dim_PlaceOfPerformance(CountryCode,CountryName,StateCode,StateName,CountyFIPS,CountyName,CongressionalDistrict,CityName,ZIPCode)
SELECT DISTINCT
       primary_place_of_performance_country_code,
       primary_place_of_performance_country_name,
       primary_place_of_performance_state_code,
       primary_place_of_performance_state_name,
       prime_award_transaction_place_of_performance_county_fips_code,
       primary_place_of_performance_county_name,
       prime_award_transaction_place_of_performance_cd_current,
       primary_place_of_performance_city_name,
       primary_place_of_performance_zip_4
FROM AwardData2025_Staging
WHERE primary_place_of_performance_country_code is not null; --109149 |109148

