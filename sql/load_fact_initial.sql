INSERT INTO Fact_Awards (    -- Target Fact columns
    DateKey, RecipientKey, ParentRecipientKey, AwardingAgencyKey, FundingAgencyKey, 
    NAICSKey, StateKey, CountryKey, ProductServiceCodeKey, AwardTypeKey, CompetitionKey, SetAsideKey, 
    PlaceOfPerformanceKey, ContractVehicleKey, SocioEconomicKey, FederalActionObligation, 
    TotalDollarsObligated, TotalOutlayedAmount, BaseAndExercisedOptionsValue, 
    CurrentTotalValueOfAward, BaseAndAllOptionsValue, PotentialTotalValueOfAward, 
    COVIDObligatedAmount, IIJAObligatedAmount, NumberOfOffersReceived, 
    ContractTransactionKey, ContractAwardKey, AwardIDPIID, ModificationNumber, 
    TransactionNumber, FileName, InitialReportDate, LastModifiedDate
)
SELECT 
    -- 1. Dimension Surrogate Keys mapped from text lookups
    COALESCE(Dim_Date.DateKey, -1), -- 6,635,107 (took 00:02:01)
    COALESCE(Dim_Recipient.RecipientKey, -1), -- 6,635,107 (00:02:41)
    COALESCE(Dim_ParentRecipient.ParentRecipientKey, -1), -- 6,635,107 (00:02:16)
    COALESCE(Dim_AwardingAgency.AwardingAgencyKey, -1), -- 6635107 (00:02:56)
    COALESCE(Dim_FundingAgency.FundingAgencyKey, -1), -- 6635107 (00:02:26)
    COALESCE(Dim_NAICS.NAICSKey, -1), -- 6635107 (00:02:31)
	COALESCE(Dim_State.StateKey, -1), -- 6635107 (00:02:31) This is recipient state
	COALESCE(Dim_Country.CountryKey, -1), -- 6635107 (00:02:31) This is recipient Country
    COALESCE(Dim_ProductServiceCode.ProductServiceCodeKey, -1), -- 6635107 (00:02:16)
    COALESCE(Dim_AwardType.AwardTypeKey, -1), -- 6635107 (00:02:45)
    COALESCE(Dim_Competition.CompetitionKey, -1), -- 6635107 (00:03:00) rethink the last 2 columns of the join (remove from dimension table or add index exression)
    COALESCE(Dim_SetAside.SetAsideKey, -1), -- 6635107 (00:02:36)
    COALESCE(Dim_PlaceOfPerformance.PlaceOfPerformanceKey, -1), -- 6635107 (00:02:45) -- note there is an ongoing performance issue. I was getting 00:12:12 prior.
    -1, -- COALESCE(cv.ContractVehicleKey, -1), NEED FURTHER INVESTIGATION 
    -1, -- COALESCE(se.SocioEconomicKey, -1), NEED FURTHER INVESTIGATION 
        
    -- 2. Fact Measures pulled from Staging
    s.federal_action_obligation,
    s.total_dollars_obligated,
    coalesce(s.total_outlayed_amount_for_overall_award,0),
    coalesce(s.base_and_exercised_options_value,0),
    coalesce(s.current_total_value_of_award,0),
    coalesce(s.base_and_all_options_value,0),
    coalesce(s.potential_total_value_of_award,0),
    coalesce(s.obligated_amount_from_COVID_19_supplementals_for_overall_award,0),
    coalesce(s.obligated_amount_from_IIJA_supplemental_for_overall_award,0),
    coalesce(s.number_of_offers_received,0),
    
    -- 3. Degenerate/Audit Business Keys pulled from Staging
    s.contract_transaction_unique_key,
    s.contract_award_unique_key,
    s.award_id_piid,
    s.modification_number,
    coalesce(s.transaction_number,-2),
    s.file_name,
    s.initial_report_date,
    s.last_modified_date
FROM AwardData2025_Staging s

-- --- START OF DIMENSION JOINS ---
-- Joins use the best unique business text keys provided in your schema
LEFT JOIN Dim_Date 					ON s.action_date = Dim_Date.FullDate
LEFT JOIN Dim_Recipient 			ON s.recipient_uei = Dim_Recipient.RecipientUEI
LEFT JOIN Dim_ParentRecipient 		ON s.recipient_parent_uei = Dim_ParentRecipient.parentuei
LEFT JOIN Dim_AwardingAgency    	ON s.Awarding_Agency_Code = Dim_AwardingAgency.AgencyCode
										and s.Awarding_Office_Code = Dim_AwardingAgency.OfficeCode
										and s.Parent_Award_Agency_ID = Dim_AwardingAgency.ParentAgencyID
LEFT JOIN Dim_FundingAgency 	   	ON s.Funding_Agency_Code = Dim_FundingAgency.AgencyCode
										and s.Funding_Office_Code = Dim_FundingAgency.OfficeCode
										-- and s.Parent_Award_Agency_ID = Dim_FundingAgency.ParentAgencyID
LEFT JOIN Dim_NAICS 				ON s.naics_code = Dim_NAICS.NAICSCode
LEFT JOIN Dim_state 				ON s.recipient_state_code = dim_state.statecode
LEFT JOIN Dim_country				ON s.recipient_country_code = dim_country.countrycode
LEFT JOIN Dim_ProductServiceCode	ON s.product_or_service_code = Dim_ProductServiceCode.PSCCode
LEFT JOIN Dim_AwardType 		    ON s.Award_Type_Code = Dim_AwardType.AwardTypeCode
LEFT JOIN Dim_Competition 	 		ON s.extent_competed_code = Dim_Competition.extentcompetedcode
										and s.solicitation_procedures_code = Dim_Competition.solicitationprocedurescode
										and coalesce(s.other_than_full_and_open_competition_code,'') = coalesce(Dim_Competition.otherthanfullandopencompetitioncode,'')
										and coalesce(s.fair_opportunity_limited_sources_code,'') = coalesce(Dim_Competition.fairopportunitylimitedsourcescode,'')
LEFT JOIN Dim_SetAside 				ON s.type_of_set_aside_code = Dim_SetAside.TypeOfSetAsideCode
										and s.evaluated_preference_code = Dim_SetAside.EvaluatedPreferenceCode
										and s.local_area_set_aside = Dim_SetAside.LocalAreaSetAside
LEFT JOIN Dim_PlaceOfPerformance 	ON s.primary_place_of_performance_country_code = Dim_PlaceOfPerformance.countrycode
										and s.primary_place_of_performance_state_code = Dim_PlaceOfPerformance.statecode
										and s.prime_award_transaction_place_of_performance_county_fips_code = Dim_PlaceOfPerformance.countyfips
										and s.prime_award_transaction_place_of_performance_cd_current = Dim_PlaceOfPerformance.CongressionalDistrict
										and s.primary_place_of_performance_zip_4 = Dim_PlaceOfPerformance.ZipCode
-- LEFT JOIN Dim_ContractVehicle cv    ON cv.IDVID = s.idv_type NEED FURTHER RESEARCH -1 for now.
-- LEFT JOIN Dim_SocioEconomic se     ON se.SocioEconomicStatus = s.action_type NEED FURTHER RESEARCH -1 for now.
