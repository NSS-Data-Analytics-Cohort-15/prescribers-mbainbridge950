--a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- select npi, nppes_provider_last_org_name, SUM(total_claim_count)
-- from prescriber
-- LEFT JOIN prescription
-- USING (npi)
-- WHERE total_claim_count IS NOT NULL
-- ORDER BY SUM(total_claim_count) DESC;

--1912011792	"COFFEY"	4538
--Different Answer - Code does not work
--b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.

-- select npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
-- from prescriber
-- LEFT JOIN prescription
-- USING (npi)
-- WHERE total_claim_count IS NOT NULL
-- ORDER BY total_claim_count DESC;
 --"DAVID"	"COFFEY"	"Family Practice"	4538

 --2.  a. Which specialty had the most total number of claims (totaled over all drugs)?



-- SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) as total_claims 
-- FROM prescription 
-- LEFT JOIN prescriber ON prescription.npi = prescriber.npi  
-- GROUP BY prescriber.specialty_description
-- ORDER BY total_claims DESC;

--Family Practice
 

--b. Which specialty had the most total number of claims for opioids?

-- SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) as total_claims, drug.opioid_drug_flag
-- FROM prescription 
-- LEFT JOIN prescriber ON prescription.npi = prescriber.npi  
-- LEFT JOIN drug ON prescription.drug_name = drug.drug_name
-- WHERE drug.opioid_drug_flag = 'Y'
-- GROUP BY prescriber.specialty_description, drug.opioid_drug_flag
-- ORDER BY total_claims DESC;

--Nurse Practitioner

--3.  a. Which drug (generic_name) had the highest total drug cost?

-- SELECT drug.generic_name, prescription.total_drug_cost
-- FROM drug
-- INNER JOIN prescription ON drug.drug_name = prescription.drug_name
-- ORDER BY prescription.total_drug_cost DESC;

--"PIRFENIDONE"	2829174.3


--b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

-- SELECT drug.generic_name, ROUND(SUM(prescription.total_drug_cost)/SUM(prescription.total_day_supply),2) AS total_cost_per_day
-- FROM drug
-- INNER JOIN prescription ON drug.drug_name = prescription.drug_name
-- GROUP BY drug.generic_name
-- ORDER BY total_cost_per_day DESC;

--"C1 ESTERASE INHIBITOR"	3495.22

--4.  a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/

-- SELECT drug.drug_name, 
-- CASE 
-- 	WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
-- 	WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type
-- FROM drug;

--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- SELECT 
-- CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
-- 	WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type,
-- 	SUM(prescription.total_drug_cost) AS MONEY
-- FROM drug
-- 	JOIN prescription USING (drug_name)
-- GROUP BY drug_type;

--Krithika
-- SELECT 
-- 		/*CASE 
-- 			WHEN (SUM(CASE  WHEN opioid_drug_flag='Y' THEN prescription.total_drug_cost  END) > SUM(CASE  WHEN antibiotic_drug_flag='Y' THEN prescription.total_drug_cost  END)) THEN 'Most money spent on opioid' ELSE 'Most money spent on antibiotic'  END,*/
-- 	 CAST (SUM(CASE  WHEN opioid_drug_flag='Y' THEN prescription.total_drug_cost  END) AS money)AS opioid_cost,
-- 	 CAST (SUM(CASE  WHEN antibiotic_drug_flag='Y' THEN prescription.total_drug_cost  END)AS money) AS antibiotic_cost
	
-- FROM drug
--  JOIN prescription
-- 	USING (drug_name)

--Jennifer
--SELECT
--     CASE
--         WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
--         WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
--         ELSE 'neither'
--     END AS drug_type,  
--     SUM(prescription.total_drug_cost)::MONEY AS total_spent -- Postgres specific cast to the money data type
-- FROM
--     drug 
-- INNER JOIN prescription 
-- Using(drug_name)
-- WHERE drug.opioid_drug_flag = 'Y' OR drug.antibiotic_drug_flag = 'Y'
-- GROUP BY drug_type
-- ORDER BY total_spent DESC;

--Sunitha
-- WITH drugs AS (
-- 		SELECT
-- 			drug_name
-- 			, (CASE WHEN MAX(opioid_drug_flag) = 'Y' THEN 'opioid'
-- 					WHEN MAX(antibiotic_drug_flag) = 'Y' THEN 'antibiotic'
-- 					ELSE 'neither' END)
-- 				AS drug_type
-- 		FROM drug
-- 		GROUP BY drug_name
-- 		)
-- SELECT
-- 	SUM(CASE WHEN drug_type = 'opioid' THEN total_drug_cost END)::money AS total_spent_on_opioids
-- 	, SUM(CASE WHEN drug_type = 'antibiotic' THEN total_drug_cost END)::money AS total_spent_on_antibiotics
-- FROM prescription
-- INNER JOIN drugs USING (drug_name);
--Opioid

--5. a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.

-- SELECT DISTINCT (cbsa)
-- FROM cbsa
-- WHERE cbsaname LIKE '%TN%';

-- SELECT *
-- FROM cbsa
-- INNER JOIN fips_county
-- USING (fipscounty)
-- WHERE state = 'TN';

--10

--b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- SELECT cbsa.cbsaname, SUM(population.population)
-- FROM cbsa
-- JOIN population
-- USING (fipscounty)
-- GROUP BY cbsa.cbsaname
-- ORDER BY SUM(population.population) DESC;
--Largest - "Nashville-Davidson--Murfreesboro--Franklin, TN"	1830410

--Smallest "Morristown, TN"	116352

--c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.


-- SELECT population, fips_county.county
-- FROM population
-- LEFT JOIN cbsa
-- USING (fipscounty)
-- LEFT JOIN fips_county
-- USING (fipscounty)
-- WHERE cbsa.cbsaname IS NULL
-- ORDER BY population DESC;


-- 95523	"SEVIER"

-- SELECT cbsa.cbsaname, SUM(population.population)
-- FROM population
-- JOIN cbsa
-- USING (fipscounty)
-- GROUP BY cbsa.cbsaname
-- ORDER BY SUM(population.population) DESC;

--6.  a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- SELECT prescription.drug_name, prescription.total_claim_count
-- FROM prescription
-- WHERE total_claim_count >= 3000;

--b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

-- SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag
-- FROM prescription
-- LEFT JOIN drug
-- USING (drug_name)
-- WHERE total_claim_count >= 3000;

--c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag, prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name
-- FROM prescription
-- LEFT JOIN drug
-- USING (drug_name)
-- LEFT JOIN prescriber
-- USING (npi)
-- WHERE total_claim_count >= 3000;

--7.The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.

--a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- SELECT prescriber.specialty_description, drug.drug_name
-- FROM prescriber
-- JOIN prescription
-- USING (npi)
-- JOIN drug
-- USING (drug_name)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city = 'NASHVILLE';

--b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- SELECT prescriber.specialty_description, drug.drug_name
-- FROM prescriber
-- FULL JOIN prescription
-- USING (npi)
-- FULL JOIN drug
-- USING (drug_name)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city = 'NASHVILLE';


-- SELECT  
-- 	prescriber.npi,
-- 	prescription.drug_name,
-- 	drug.opioid_drug_flag,
-- 	prescription.total_claim_count
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (drug_name, npi)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city ILIKE 'NASHVILLE'
-- AND drug.opioid_drug_flag = 'Y';


--c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

-- SELECT  
-- 	prescriber.npi,
-- 	prescription.drug_name,
-- 	drug.opioid_drug_flag,
-- 	COALESCE (prescription.total_claim_count,0) AS total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (drug_name, npi)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city ILIKE 'NASHVILLE'
-- AND drug.opioid_drug_flag = 'Y';
