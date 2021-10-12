
-- Exploring and cleaning data for the ecommerce ads analysis
-- Only needed to clean and explore some of the tables here since most tables are either faster to be cleaned on Excel or 
-- the data source is already straightforward

SELECT *
FROM PortfolioProj..Internet_activity_bystate

SELECT *
FROM PortfolioProj..Internet_activity_bystate
WHERE State = 'Malaysia' AND Category = 'e-Commerce' OR Category = 'Other Online Services'

SELECT *
FROM PortfolioProj..Internet_activity_bystate
WHERE State = 'Malaysia' AND Category = 'Other Online Services' AND Activity LIKE '%goods/services%'

-- To classify the type of transaction for sale and purchase activities and put results to new table
SELECT *,
CASE
	WHEN Category = 'e-Commerce' THEN 'Sale and purchase with online transaction'
	WHEN Activity = 'Selling goods/services' OR Activity = 'Ordering goods/services online' THEN 'Sale and purchase without online transaction'
END AS [Type]
INTO PortfolioProj..Malaysia_online_salepurchase
FROM PortfolioProj..Internet_activity_bystate
WHERE State = 'Malaysia' AND (Category = 'e-Commerce' OR Activity = 'Selling goods/services' OR Activity = 'Ordering goods/services online')

SELECT * FROM PortfolioProj..Malaysia_online_salepurchase

-- Delete blank rows in this table
SELECT *
FROM PortfolioProj..ecommerce_income_rm_million

DELETE FROM PortfolioProj..ecommerce_income_rm_million
WHERE COALESCE (Year, Quarter, Income, YoY, QoQ) IS NULL

-- Wanted to calculate the number of people for each gender population
SELECT *
FROM PortfolioProj..ecommerce_transaction_gender

--Deleting an extra blank column
ALTER TABLE PortfolioProj..ecommerce_transaction_gender
DROP COLUMN F4

-- Calculating each gender's population number based on percentage and total population number given
SELECT *, (
	CASE
		WHEN Category = 'Male population' THEN (Percentage/100 * (SELECT TOP 1 No_of_people FROM PortfolioProj..ecommerce_transaction_gender))
		WHEN Category = 'Female population' THEN (Percentage/100 * (SELECT TOP 1 No_of_people FROM PortfolioProj..ecommerce_transaction_gender))	
		ELSE No_of_people
	END) AS Population_num
FROM PortfolioProj..ecommerce_transaction_gender

-- Updating the table
UPDATE PortfolioProj..ecommerce_transaction_gender
SET No_of_people = CASE
						WHEN Category = 'Male population' THEN (Percentage/100 * (SELECT TOP 1 No_of_people FROM PortfolioProj..ecommerce_transaction_gender))
						WHEN Category = 'Female population' THEN (Percentage/100 * (SELECT TOP 1 No_of_people FROM PortfolioProj..ecommerce_transaction_gender))	
						ELSE No_of_people
					 END

-- Calulate the online transactions made by each gender based on population calculated above
SELECT Category, Percentage, (
		CASE
		WHEN Category = 'Male transaction' THEN (Percentage/100 * LAG(No_of_people, 2) OVER (ORDER BY No_of_people desc))
		WHEN Category = 'Female transaction' THEN (Percentage/100 * LAG(No_of_people,  2) OVER (ORDER BY No_of_people desc))
		ELSE No_of_people
		END) AS No_of_people
FROM PortfolioProj..ecommerce_transaction_gender

-- Putting the results in a new table
SELECT Category, Percentage, (
		CASE
		WHEN Category = 'Male transaction' THEN (Percentage/100 * LAG(No_of_people, 2) OVER (ORDER BY No_of_people desc))
		WHEN Category = 'Female transaction' THEN (Percentage/100 * LAG(No_of_people,  2) OVER (ORDER BY No_of_people desc))
		ELSE No_of_people
		END) AS No_of_people
INTO PortfolioProj..ecommerce_gender_stat
FROM PortfolioProj..ecommerce_transaction_gender

SELECT * FROM PortfolioProj..ecommerce_gender_stat



