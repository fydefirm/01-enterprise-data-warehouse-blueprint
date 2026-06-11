DROP TABLE IF EXISTS Fact_Awards;

-- Fact_Awards
CREATE TABLE Fact_Awards (
	AwardFactKey	bigint GENERATED ALWAYS AS IDENTITY not null,	
	DateKey	int	not null, -- FK to Dim_Date
	RecipientKey	int not null, -- FK to Dim_Recipient
	ParentRecipientKey	int not null, -- FK to Dim_ParentRecipient
	AwardingAgencyKey	int not null, -- FK to Dim_AwardingAgency
	FundingAgencyKey	int	not null, -- FK to Dim_FundingAgency
	NAICSKey	int	not null, -- FK to Dim_NAICS
	ProductServiceCodeKey	int not null, -- FK to Dim_ProductServiceCode
	AwardTypeKey	int	not null, -- FK to Dim_AwardType
	CompetitionKey	int	not null, -- FK to Dim_Competition 
	SetAsideKey	int	not null, -- FK to Dim_SetAside
	PlaceOfPerformanceKey	int not null, -- FK to Dim_PlaceOfPerformance
	ContractVehicleKey	int	not null, -- FK to Dim_ContractVehicle
	SocioEconomicKey	int	not null, -- FK to Dim_SocioEconomicFlags
	FederalActionObligation	decimal(20,2) not null, -- Daily obligation amount
	TotalDollarsObligated	decimal(20,2) not null, -- Cumulative obligated
	TotalOutlayedAmount	decimal(20,2) not null, -- Total paid
	BaseAndExercisedOptionsValue	decimal(20,2) not null, -- Award value
	CurrentTotalValueOfAward	decimal(20,2) not null,	-- Current total
	BaseAndAllOptionsValue	decimal(20,2) not null,	-- Full potential
	PotentialTotalValueOfAward	decimal(20,2) not null, -- Maximum value
	COVIDObligatedAmount	decimal(20,2),   -- COVID funding
	IIJAObligatedAmount	decimal(20,2),	-- Infrastructure funding
	NumberOfOffersReceived	int,	-- Competition measure
	ContractTransactionKey	varchar(100) not null, -- Degenerate dimension
	ContractAwardKey	varchar(100) not null, -- Degenerate dimension
	AwardIDPIID	varchar(50)	not null, -- Degenerate dimension
	ModificationNumber	varchar(25) not null, -- Degenerate dimension
	TransactionNumber	int	not null, -- Transaction sequence
	FileName	varchar(255) not null, -- ETL audit
	InitialReportDate	timestamp	not null, --ETL audit
	LastModifiedDate	timestamp not null, -- Source audit
	CONSTRAINT PK_Fact_Awards PRIMARY KEY (AwardFactKey),
	CONSTRAINT FK_Dim_Date FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
	CONSTRAINT FK_Dim_Recipient FOREIGN KEY (RecipientKey) REFERENCES Dim_Recipient (RecipientKey),
	CONSTRAINT FK_Dim_AwardingAgency FOREIGN KEY (AwardingAgencyKey) REFERENCES Dim_AwardingAgency (AwardingAgencyKey),
	CONSTRAINT FK_Dim_FundingAgency FOREIGN KEY (FundingAgencyKey) REFERENCES Dim_FundingAgency (FundingAgencyKey),
	CONSTRAINT FK_Dim_NAICS FOREIGN KEY (NAICSKey) REFERENCES Dim_NAICS (NAICSKey),
	CONSTRAINT FK_Dim_ProductServiceCode FOREIGN KEY (ProductServiceCodeKey) REFERENCES Dim_ProductServiceCode (ProductServiceCodeKey),
	CONSTRAINT FK_Dim_AwardType FOREIGN KEY (AwardTypeKey) REFERENCES Dim_AwardType (AwardTypeKey),
	CONSTRAINT FK_Dim_Competition FOREIGN KEY (CompetitionKey) REFERENCES Dim_Competition (CompetitionKey),
	CONSTRAINT FK_Dim_SetAside FOREIGN KEY (SetAsideKey) REFERENCES Dim_SetAside (SetAsideKey),
	CONSTRAINT FK_Dim_PlaceOfPerformance FOREIGN KEY (PlaceOfPerformanceKey) REFERENCES Dim_PlaceOfPerformance (PlaceOfPerformanceKey),
	CONSTRAINT FK_Dim_ContractVehicle FOREIGN KEY (ContractVehicleKey) REFERENCES Dim_ContractVehicle (ContractVehicleKey),
	CONSTRAINT FK_Dim_SocioEconomicFlags FOREIGN KEY (SocioEconomicKey) REFERENCES Dim_SocioEconomicFlags (SocioEconomicKey)
	
);