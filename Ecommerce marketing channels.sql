
SELECT *
FROM PortfolioProj..Dvc_used_forinterternet_bystate

SELECT *
FROM PortfolioProj..ecommerce_income_bycustomer

SELECT *
FROM PortfolioProj..ecommerce_income_rm_million

DELETE FROM PortfolioProj..ecommerce_income_rm_million
WHERE COALESCE (Year, Quarter, Income, YoY, QoQ) IS NULL

SELECT *
FROM PortfolioProj..Household_ICT_serv_equip_access

EXEC sp_rename 'Household_ICT_serv_equip_access.Fixed-line telephone', 'Fixed_line_telephone', 'COLUMN'

SELECT *
FROM PortfolioProj..Household_internet_access

SELECT *
FROM PortfolioProj..Household_phone_access

ALTER TABLE PortfolioProj..Household_phone_access
DROP COLUMN F7, F8

SELECT *
FROM PortfolioProj..Internet_activity_byagegroup

SELECT Age_group, Category, Activity, Percentage AS 'Has_access', (100 - Percentage) AS No_access
INTO #temptable
FROM Internet_activity_byagegroup
WHERE Category = 'Total'

SELECT (AVG([No_access]))
FROM #temptable

DROP TABLE #temptable
DROP TABLE #temporary

SELECT * FROM #temptable
SELECT * FROM #temporary

SELECT [Has_access] 
INTO #temporary
FROM #temptable
UNION 
SELECT No_access FROM #temptable

/*EXEC sp_rename '#temporary.[Has_access]', 'Percentage', 'COLUMN'*/

ALTER TABLE #temptable
DROP COLUMN [Has_access], No_access

SELECT * FROM #temptable JOIN * FROM #temporary


ALTER TABLE #temptable
(SELECT [Has_access] FROM #temptable UNION SELECT No_access FROM #temptable) AS Percentage
FROM #temptable

SELECT Age_group, Category, Activity, Access_status
CASE
		WHEN Percentage < 50 THEN No_access
		ELSE 'Has_access'
END AS Access_status
FROM #temptable
WHERE Category = 'Total'

SELECT Category, (AVG(Percentage)) AS Average_individuals_percent
FROM Internet_activity_byagegroup
WHERE Age_group = 'Total'
GROUP BY Category

SELECT *
FROM PortfolioProj..Internet_activity_bygender

SELECT *
FROM PortfolioProj..Internet_activity_bystate
SELECT *
FROM PortfolioProj..Internet_activity_bystate
WHERE State = 'Malaysia' AND Category = 'e-Commerce' AND Category = 'Other Online Services'*/

SELECT *
FROM PortfolioProj..Mobilephone_use_own_bystate

SELECT *
FROM PortfolioProj..Salespurchase_platform_byphase

/*CREATE TABLE Household_connectivity_access
AS (SELECT * FROM Household_internet_access)
AND (SELECT Paid_TV_channel, Fixed_line_telephone FROM Household_ICT_serv_equip_access)

SELECT Customers.CustomerName, Orders.OrderID
INTO CustomersOrderBackup2017
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID

*/

SELECT HIA.*, ICT.Paid_TV_channel, ICT.Fixed_line_telephone 
	INTO Household_connectivity_access
	FROM Household_internet_access HIA RIGHT JOIN Household_ICT_serv_equip_access ICT
	ON (HIA.State = ICT.State
		AND HIA.Area = ICT.Area
		AND HIA.Year = ICT.Year)

SELECT * FROM Household_connectivity_access
ORDER BY Year desc, Area

SELECT * FROM temptable2
ORDER BY Year desc, Area

CREATE TABLE temptable 
	(SELECT HIA.*, ICT.Paid_TV_channel, ICT.Fixed_line_telephone
		FROM Household_internet_access HIA RIGHT JOIN Household_ICT_serv_equip_access ICT
                ON HIA.State = ICT.State,
				HIA.Area = ICT.Area,
				HIA.Year = ICT.Year)

