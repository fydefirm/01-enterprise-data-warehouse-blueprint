-- create raw table to hold population data from: https://www.census.gov/data/tables/time-series/demo/popest/2020s-state-total.html
-- file name: Annual Estimates of the Resident Population for the United States, Regions, States, District of Columbia, and Puerto Rico: April 1, 2020 to July 1, 2025

CREATE TABLE statepopulation (State text, pop2020 text, pop2021 text,pop2022 text,pop2023 text,pop2024 text,pop2025 text);

-- load raw table
COPY statepopulation
FROM 'C:\Users\Hillview Group\OneDrive - Hillview Group Inc\Hillview Group\playground\postgresql\USASpending\state-population-2025.csv'
WITH(FORMAT csv, HEADER);

select *
from statepopulation;

-- expand statefips table schema to accomodate new population figures as numbers.
alter table statefips add column pop2020 int,
					  add column pop2021 int,
					  add column pop2022 int, 
					  add column pop2023 int,
					  add column pop2024 int,
					  add column pop2025 int;

select *
from statefips;

-- script to view before and after state of loading statefips
select sp.state,
	   sp.pop2020::int as pop2020,
	   sp.pop2021::int as pop2021,
	   sp.pop2022::int as pop2022,
	   sp.pop2023::int as pop2023,
	   sp.pop2024::int as pop2024,
	   sp.pop2025::int as pop2025,
	   sf.*
from statepopulation sp
left join statefips sf on UPPER(sp.state) = sf.statename

-- sync statefips using census file
MERGE INTO statefips as t
USING (
		select sp.state,
			   sp.pop2020::int as pop2020,
			   sp.pop2021::int as pop2021,
			   sp.pop2022::int as pop2022,
			   sp.pop2023::int as pop2023,
			   sp.pop2024::int as pop2024,
			   sp.pop2025::int as pop2025
		from statepopulation sp
	  ) as s
ON t.statename = UPPER(s.state)
WHEN MATCHED THEN 
	UPDATE SET  pop2020 = s.pop2020,
				pop2021 = s.pop2021,
				pop2022 = s.pop2022,
				pop2023 = s.pop2023,
				pop2024 = s.pop2024,
				pop2025 = s.pop2025
WHEN NOT MATCHED THEN
	INSERT(fipscode, statename, pop2020, pop2021, pop2022, pop2023, pop2024, pop2025)
	VALUES ('72', UPPER(s.state), s.pop2020, s.pop2021, s.pop2022, s.pop2023, s.pop2024, s.pop2025);