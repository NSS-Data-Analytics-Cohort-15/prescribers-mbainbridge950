--a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- select npi, nppes_provider_last_org_name, total_claim_count
-- from prescriber
-- LEFT JOIN prescription
-- USING (npi)
-- WHERE total_claim_count IS NOT NULL
-- ORDER BY total_claim_count DESC;

--1912011792	"COFFEY"	4538

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

-- SELECT drug.generic_name, ROUND(prescription.total_drug_cost/30,2)
-- FROM drug
-- INNER JOIN prescription ON drug.drug_name = prescription.drug_name
-- ORDER BY prescription.total_drug_cost DESC;

--"PIRFENIDONE"	94305.81

--4.  a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/

-- SELECT drug.drug_name, 
-- CASE 
-- 	WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
-- 	WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither' END AS drug_type
-- FROM drug;

--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

SELECT drug.drug_name, SUM(prescription.total_drug_cost) AS MONEY
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
FROM drug
	JOIN prescription USING (drug_name)
GROUP BY MONEY;
	