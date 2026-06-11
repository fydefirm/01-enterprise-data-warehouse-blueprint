DROP TABLE IF EXISTS Dim_Date;
DROP TABLE IF EXISTS Dim_Recipient;
DROP TABLE IF EXISTS Dim_ParentRecipient;
DROP TABLE IF EXISTS Dim_AwardingAgency;
DROP TABLE IF EXISTS Dim_FundingAgency;
DROP TABLE IF EXISTS Dim_NAICS;
DROP TABLE IF EXISTS Dim_ProductServiceCode;
DROP TABLE IF EXISTS Dim_AwardType;
DROP TABLE IF EXISTS Dim_Competition;
DROP TABLE IF EXISTS Dim_PlaceOfPerformance;
DROP TABLE IF EXISTS Dim_State;
DROP TABLE IF EXISTS Dim_Country;
DROP TABLE IF EXISTS Dim_ContractVehicle;
DROP TABLE IF EXISTS Dim_SetAside;
DROP TABLE IF EXISTS Dim_SocioEconomicFlags;

-- Dim_Date (Standard Date Dimension)
CREATE TABLE Dim_Date (
	DateKey		int not null,
	FullDate	date not null,
	DayNumber	smallint not null,
	DayName		varchar(20) not null,
	WeekNumber	smallint not null,
	MonthNumber	smallint not null,
	MonthName	varchar(20) not null,
	QuarterNumber smallint not null,
	FiscalYear int not null,
	FiscalQuarter smallint not null,
	CalendarYear int not null,
	IsWeekend bit not null,
	Constraint PK_Dim_Date Primary Key (DateKey)
);

-- Dim_State
CREATE TABLE Dim_State (
	StateKey int GENERATED ALWAYS AS IDENTITY not null,
	StateCode char(2) not null,
	StateName varchar(50) not null,
	StateFIPS char(2) not null,
	CensusRegion varchar(20) not null,
	CensusDivision varchar(20) not null,
	CONSTRAINT PK_Dim_State PRIMARY KEY (StateKey)
);

-- Dim_NAICS
CREATE TABLE Dim_NAICS (
	NAICSKey int GENERATED ALWAYS AS IDENTITY not null,
	NAICSCode varchar(10) not null,
	NAICSDescription varchar(255) not null,
	SectorCode	varchar(2) not null,
	SectorDescription varchar(100) not null,
	CONSTRAINT PK_Dim_NAICS PRIMARY KEY (NAICSKey)
);

-- Dim_ProductServiceCode
CREATE TABLE Dim_ProductServiceCode (
	ProductServiceCodeKey int GENERATED ALWAYS AS IDENTITY not null,
	PSCCode	varchar(10) not null,
	PSCDescription varchar(255) not null,
	CONSTRAINT PK_Dim_ProductServiceCode PRIMARY KEY (ProductServiceCodeKey)
);

-- Dim_AwardType
-- AwardType: The type of award being entered by this transaction. Types of awards include Purchase Orders (PO), Delivery Orders (DO), Blanket Purchase Agreements (BPA) Calls and Definitive Contracts.
--------------- A = BPA Call, B = Purchase Order, C = Delivery Order, D = Definitive Contract
-- IDVType: The type of Indefinite Delivery Vehicle being (IDV) loaded by this transaction. IDV Types include Government-Wide Acquisition Contract (GWAC), Multi-Agency Contract, Other Indefinite Delivery Contract (IDC), Federal Supply Schedule (FSS), Basic Ordering Agreement (BOA), and Blanket Purchase Agreements (BPA).
------------- A = GWAC, B = IDC, C = FSS, D = BOA, E = BPA
/* Type of contract pricing: A = FIXED PRICE REDETERMINATION
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
*/
CREATE TABLE Dim_AwardType (
	AwardTypeKey int GENERATED ALWAYS AS IDENTITY not null,
	AwardTypeCode char(1) not null,
	AwardType varchar(50) not null,
	IDVTypeCode char(1) not null,
	IDVType varchar(10) not null,
	PricingTypeCode varchar(2) not null,
	PricingType varchar(200) not null,
	ContractVehicleType varchar(200) not null,
	CONSTRAINT PK_Dim_AwardType PRIMARY KEY (AwardTypeKey)
);

-- Dim_AwardingAgency
CREATE TABLE Dim_AwardingAgency (
	AwardingAgencyKey int GENERATED ALWAYS AS IDENTITY not null,
	AgencyCode varchar(5) not null,
	AgencyName varchar(200) not null,
	SubAgencyCode varchar(5) not null,
	SubAgencyName varchar(200) not null,
	OfficeCode varchar(10) not null,
	OfficeName varchar(200) not null,
	ParentAgencyID varchar(10),
	ParentAgencyName varchar(200),
	CONSTRAINT PK_Dim_AwardingAgency PRIMARY KEY (AwardingAgencyKey)
);

-- Dim_FundingAgency
CREATE TABLE Dim_FundingAgency (
	FundingAgencyKey int GENERATED ALWAYS AS IDENTITY not null,
	AgencyCode varchar(5) not null,
	AgencyName varchar(200) not null,
	SubAgencyCode varchar(5) not null,
	SubAgencyName varchar(200) not null,
	OfficeCode varchar(10) not null,
	OfficeName varchar(200) not null,
	ParentAgencyID varchar(10),
	ParentAgencyName varchar(200),
	CONSTRAINT PK_Dim_FundingAgency PRIMARY KEY (FundingAgencyKey)
);

-- Dim_Recipient (Recipient Organization) SCD Type 2 Recommended
/*
OrganizationalType (Values):
2A
CORPORATE NOT TAX EXEMPT
CORPORATE TAX EXEMPT
FOREIGN GOVERNMENT
INTERNATIONAL ORG
OTHER
PARTNERSHIP
SOLE PROPRIETORSHIP
US GOVERNMENT ENTITY
*/
CREATE TABLE Dim_Recipient (
	RecipientKey int GENERATED ALWAYS AS IDENTITY not null,
	RecipientUEI varchar(20) not null,
	RecipientDUNS varchar(15),
	RecipientName	varchar(255) not null,
	DBAName varchar(255),
	CageCode varchar(15),
	BusinessSize char(1),-- S = Small Business, O = Other Than Small Business
	OrganizationalType varchar(50),	-- The structure of the entity as defined by the IRS.
	RecipientStateCode	char(2) not null,
	RecipientCountryCode char(3) not null,	
	IsForProfit	bit,
	IsNonProfit	bit,
	IsForeignOwned bit,
	EffectiveStartDate timestamp default current_timestamp not null,
	EffectiveEndDate timestamp,	
	IsCurrent bit not null,
	CONSTRAINT PK_Dim_Recipient PRIMARY KEY (RecipientKey)
	
);

-- Dim_ParentRecipient (Parent company hierarchy)
CREATE TABLE Dim_ParentRecipient (
	ParentRecipientKey int GENERATED ALWAYS AS IDENTITY not null,
	ParentUEI varchar(20) not null,	
	ParentDUNS varchar(15),	
	ParentName varchar(255) not null,
	CONSTRAINT PK_DimParentRecipient PRIMARY KEY (ParentRecipientKey)
);

-- Dim_PlaceOfPerformance
CREATE TABLE Dim_PlaceOfPerformance (
	PlaceOfPerformanceKey int GENERATED ALWAYS AS IDENTITY not null,
	CountryCode	char(3) not null,
	CountryName	varchar(255) not null,
	StateCode char(2) not null,	
	StateName varchar(50) not null,	
	CountyFIPS char(5) not null,	
	CountyName varchar(255) not null,
	CongressionalDistrict varchar(255),	
	CityName varchar(255),	
	ZIPCode varchar(20),
	CONSTRAINT PK_Dim_PlaceOfPerformance PRIMARY KEY (PlaceOfPerformanceKey)
);

-- Dim_Competition
/*
ExtentCompetedCode = ExtentCompeted	
A = FULL AND OPEN COMPETITION
B = NOT AVAILABLE FOR COMPETITION
C = NOT COMPETED
D = FULL AND OPEN COMPETITION AFTER EXCLUSION OF SOURCES
E = FOLLOW ON TO COMPETED ACTION
F = COMPETED UNDER SAP
G = NOT COMPETED UNDER SAP
CDO = COMPETITIVE DELIVERY ORDER
NDO = NON-COMPETITIVE DELIVERY ORDER

SolicitationProcedures
NP = NEGOTIATED PROPOSAL/QUOTE
SB = SEALED BID
TS = TWO STEP
SP1 = SIMPLIFIED ACQUISITION
AE = ARCHITECT-ENGINEER FAR 6.102
BR = BASIC RESEARCH
AS = ALTERNATIVE SOURCES
SSS = ONLY ONE SOURCE
MAFO = SUBJECT TO MULTIPLE AWARD FAIR OPPORTUNITY

OtherThanFullAndOpenCompetition
UNQ = UNIQUE SOURCE (FAR 6.302-1(B)(1))
FOC = FOLLOW-ON CONTRACT (FAR 6.302-1(A)(2)(II/III))
UR = UNSOLICITED RESEARCH PROPOSAL (FAR 6.302-1(A)(2)(I))
PDR = PATENT OR DATA RIGHTS (FAR 6.302-1(B)(2))
UT = UTILITIES (FAR 6.302-1(B)(3))
STD = STANDARDIZATION (FAR 6.302-1(B)(4))
ONE = ONLY ONE SOURCE-OTHER (FAR 6.302-1 OTHER)
URG = URGENCY (FAR 6.302-2)
MES = MOBILIZATION, ESSENTIAL R&D (FAR 6.302-3)
IA = INTERNATIONAL AGREEMENT (FAR 6.302-4)
OTH = AUTHORIZED BY STATUTE (FAR 6.302-5(A)(2)(I))
RES = AUTHORIZED RESALE (FAR 6.302-5(A)(2)(II))
NS = NATIONAL SECURITY (FAR 6.302-6)
PI = PUBLIC INTEREST (FAR 6.302-7)
MPT = LESS THAN OR EQUAL TO THE MICRO-PURCHASE THRESHOLD
SP2 = SAP NON-COMPETITION (FAR 13)
BND = BRAND NAME DESCRIPTION (FAR 6.302-1(C))

FairOpportunityLimitedSources
URG = URGENCY
ONE = ONLY ONE SOURCE - OTHER
FOO = FOLLOW-ON ACTION FOLLOWING COMPETITIVE INITIAL ACTION
MG = MINIMUM GUARANTEE
OSA = OTHER STATUTORY AUTHORITY
FAIR = FAIR OPPORTUNITY GIVEN
CSA = COMPETITIVE SET ASIDE
SS = SOLE SOURCE


*/
CREATE TABLE Dim_Competition (
	CompetitionKey int GENERATED ALWAYS AS IDENTITY not null,
	ExtentCompetedCode varchar(3) not null,	
	ExtentCompeted	varchar(100) not null, -- A code that represents the competitive nature of the contract.
	SolicitationProcedures varchar(100) not null, -- The designator for competitive solicitation procedures available.	
	OtherThanFullAndOpenCompetition varchar(100) not null, -- The designator for solicitation procedures other than full and open competition pursuant to FAR 6.3.	
	FairOpportunityLimitedSources varchar(100) not null, -- The type of statutory exception to Fair Opportunity.
	CONSTRAINT PK_Dim_Competition PRIMARY KEY (CompetitionKey)
);

-- Dim_SetAside
/*
TypeOfSetAside
NONE = NO SET ASIDE USED
SBA = SMALL BUSINESS SET ASIDE - TOTAL
8A = 8A COMPETED
SBP = SMALL BUSINESS SET ASIDE - PARTIAL
HMT = HBCU OR MI SET-ASIDE -- TOTAL
HMP = HBCU OR MI SET-ASIDE - PARTIAL
VSB = VERY SMALL BUSINESS
ESB = EMERGING SMALL BUSINESS SET-ASIDE
HZC = HUBZONE SET-ASIDE
SDVOSBC = SERVICE DISABLED VETERAN OWNED SMALL BUSINESS SET-ASIDE
BI = BUY INDIAN
IEE = INDIAN ECONOMIC ENTERPRISE
ISBEE = INDIAN SMALL BUSINESS ECONOMIC ENTERPRISE
HZS = HUBZONE SOLE SOURCE
SDVOSBS = SDVOSB SOLE SOURCE
8AN = 8(A) SOLE SOURCE
RSB = RESERVED FOR SMALL BUSINESS
8AC = SDB Set-Aside 8(a)-(Will be deprecated in future)
HS2 = Combination HUBZone and 8(a)-(Will be deprecated in future)
HS3 = 8(A) WITH HUB ZONE PREFERENCE
VSA = VETERAN SET ASIDE
VSS = VETERAN SOLE SOURCE
WOSB = WOMEN OWNED SMALL BUSINESS
EDWOSB = ECONOMICALLY DISADVANTAGED WOMEN OWNED SMALL BUSINESS
WOSBSS = WOMEN OWNED SMALL BUSINESS SOLE SOURCE
EDWOSBSS = ECONOMICALLY DISADVANTAGED WOMEN OWNED SMALL BUSINESS SOLE SOURCE

EvaluatedPreferenceCode	
NONE = NO PREFERENCE USED
SDA = SDB PRICE EVALUATION ADJUSTMENT
SPS = SDB PREFERENTIAL CONSIDERATION PARTIAL SB SET ASIDE
HZE = HUBZONE PRICE EVALUATION
HSD = COMBINED HUB/SDB PREFERENCE

LocalAreaSetAside (YES | NO)
When awarding emergency response contracts during the term of a major disaster or emergency declaration by the President of the United States under the authority of the Robert T. Stafford Disaster Relief 
and Emergency Assistance Act (42 U.S.C. 5121, et seq.), preference shall be given, to the extent feasible and practicable, to local firms. Preference may be given through a local area set-aside or 
an evaluation preference. Note: When the value for the data element 'Multiple or Single Award IDV' is 'Single' on the Referenced IDV, the value for 'Local Area Set Aside' is propagated from the BPA. 
When the value is 'Multiple' user input is required.

*/
CREATE TABLE Dim_SetAside (
	SetAsideKey	int GENERATED ALWAYS AS IDENTITY not null,
	TypeOfSetAsideCode 	varchar(10) not null,
	TypeOfSetAside varchar(100) not null, -- The designator for type of set aside determined for the contract action.	
	EvaluatedPreferenceCode	varchar(5) not null,
	EvaluatedPreference varchar(100) not null,	-- The designator for type of preference determined for the contract action.
	LocalAreaSetAside varchar(3) not null, -- YES | NO
	CONSTRAINT PK_Dim_SetAside PRIMARY KEY (SetAsideKey)
);

-- Dim_ContractVehicle
/*
MultipleOrSingleAwardIDV(M = MULTIPLE AWARD, S = SINGLE AWARD )
Indicates whether the contract is one of many that resulted from a single solicitation, all of the contracts are for the same or similar items, and contracting officers are required to compare 
their requirements with the offerings under more than one contract or are required to acquire the requirement competitively among the awardees. BPA "Multiple or Single Award IDV" value does not 
pull the "Multiple or Single Award IDV" value of the referenced FSS to the BPA. The "Multiple or Single Award IDV" value shall be required and selected by the user for all BPA bases created.

TypeOfIDC
A = INDEFINITE DELIVERY / REQUIREMENTS
B = INDEFINITE DELIVERY / INDEFINITE QUANTITY
C = INDEFINITE DELIVERY / DEFINITE QUANTITY

Identifies whether the IDC or Multi-Agency Contract is Indefinite Delivery/Requirements, Indefinite Delivery/Indefinite Quantity, or Indefinite Delivery/Definite Quantity. A requirements contract 
provides for filling all actual purchase requirements of designated Government activities for supplies or services during a specified contract period, with deliveries or performance to be scheduled 
by placing orders with the contractor. A Requirements IDC or Multi-Agency Contract is a contract for all of the agency's requirement for the supplies or services specified, and effective for the 
period stated, in the IDC or Multi-Agency Contract. After award, the contract is a mandatory source for the agency for the supplies or services specified. The quantities of supplies or services 
specified in the IDC or Multi-Agency Contract are estimates only and are not purchased by this contract. Except as this contract may otherwise provide, if the government's requirements do not result 
in orders in the quantities described as "estimated" or "maximum" in the Schedule, that fact shall not constitute the basis for an equitable price adjustment. An indefinite-quantity contract provides 
for an indefinite quantity, within stated limits, of supplies or services during a fixed period. The Government places orders for individual requirements. Quantity limits may be stated as number of 
units or as dollar values. An Indefinite Quantity is a contract for the supplies or services specified, and effective for the period stated, in the IDC or Multi-Agency Contract. The quantities of 
supplies and services specified in the IDC or Multi-Agency Contract are estimates only and are not purchased by this contract. A definite-quantity contract provides for delivery of a definite quantity 
of specific supplies or services for a fixed period, with deliveries or performance to be scheduled at designated locations upon order. A Definite Quantity IDC or Multi-Agency Contract is a 
definite-quantity, indefinite-delivery contract for the supplies or services specified, and effective for the period stated, in the IDC or Multi-Agency Contract.
*/
CREATE TABLE Dim_ContractVehicle (
	ContractVehicleKey int GENERATED ALWAYS AS IDENTITY not null,
	ParentAwardIDPIID varchar(50),	
	ParentAwardType	varchar(50),
	MultipleOrSingleAwardIDV varchar(25),	
	TypeOfIDC varchar(100),	
	OrderingPeriodEndDate date, -- Indefinite Delivery Vehicle Last Date to Order
	CONSTRAINT PK_Dim_ContractVehicle PRIMARY KEY (ContractVehicleKey)
);

-- Dim_SocioEconomicFlags (Contains recipient certifications. This dimension avoids dozen of bit columns in the fact table.)
CREATE TABLE Dim_SocioEconomicFlags (
	SocioEconomicKey	int GENERATED ALWAYS AS IDENTITY not null,
	VeteranOwnedBusiness	bit not null,
	ServiceDisabledVeteranOwnedBusiness	bit not null,
	WomanOwnedBusiness	bit not null,
	SmallDisadvantagedBusiness	bit not null,
	HUBZoneFirm	bit not null,
	MinorityOwnedBusiness	bit not null,
	BlackAmericanOwnedBusiness	bit not null,
	HispanicAmericanOwnedBusiness	bit not null,
	NativeAmericanOwnedBusiness	bit not null,
	AlaskanNativeCorporationOwnedFirm	bit not null,
	HistoricallyBlackCollege	bit not null,
	TribalCollege	bit not null,
	CONSTRAINT PK_Dim_SocioEconomicFlags PRIMARY KEY (SocioEconomicKey)
);
