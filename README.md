# Enterprise Data Warehouse Blueprint

A complete enterprise-grade data warehouse architecture using USASpending.gov Award data, based on Kimball methodology.

I designed a Kimball dimensional model for USAspending contract award data at the grain of one contract transaction per day. The model includes conformed dimensions for agencies, recipients, NAICS, product/service codes, geography, and socio-economic certifications, enabling financial trend analysis, vendor concentration reporting, and public spending insights in Power BI.

## 1. BUSINESS PROCESS

### Business Process Modeled

Federal contract award transactions from USAspending.gov.

### Grain

**One row per contract award transaction per action date.**
This means each row represents a unique contract modification or transaction recorded on a specific day.

## 2. STAR SCHEMA OVERVIEW

Dim_Date

Dim_Recipient

Dim_ParentRecipient

Dim_AwardingAgency

Dim_FundingAgency

Dim_NAICS

Dim_ProductServiceCode

Dim_AwardType

Dim_Competition

Dim_PlaceOfPerformance

Dim_State

Dim_Country

Dim_ContractVehicle

Dim_SetAside

Dim_SocioEconomicFlags

Fact_Awards

## 3. SLOWLY CHANGING DIMENSIONS

| Dimension     | SCD Type          |
| ------------- | ----------------- |
| Dim_Recipient | Type 2            |
| Dim_Agency    | Type 2 (optional) |
| Dim_NAICS     | Type 1            |
| Dim_State     | Type 1            |
| Dim_Date      | Static            |

Features:

- Star Schema Design
- Slowly Changing Dimensions
- Data Marts
- Fact Tables
- Dimension Tables
- Metadata Driven ETL
- Enterprise Reporting Layer

Technology Stack

- STAR Schema on postgresql but any Relational Database would work.
- Azure Synapse
- Azure Data Factory
- Power BI
