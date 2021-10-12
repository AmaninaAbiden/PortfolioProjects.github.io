
SELECT * FROM PortfolioProj..Internet_activity1

-- Choosing relevant data to be extracted and then put into a temporary table 

-------------------------------------------------------------------------------------------------------------------------------------------

SELECT F1 AS [State], 'Access to information' AS Category, 'Finding information about goods/ services' AS Activity, 
F2 AS [2018], F3 AS [2019], F4 AS [2020]
INTO #FindInfo
FROM PortfolioProj..Internet_activity1
WHERE F1 IS NOT NULL AND F1 != 'Negeri                              State' AND F1 != 'Table                      : Percentage of individuals using the internet by state and type of activity, Malaysia, 2018 - 2020'
	AND F2 != '2018' AND F2 != 'Mendapatkan Maklumat Access to Information' AND F2 != 'Mendapatkan maklumat barangan/ perkhidmatan Finding information about goods/ services'
	AND F3 != '2019' AND F4 != '2020'
SELECT * FROM #FindInfo

SELECT F1 AS [State], 'Access to information' AS Category, 'Reading newspaper/ magazines online' AS Activity, 
F6 AS [2018], F7 AS [2019], F8 AS [2020]
INTO #ReadNews
FROM PortfolioProj..Internet_activity1
WHERE F1 IS NOT NULL AND F1 != 'Negeri                              State' AND F1 != 'Table                      : Percentage of individuals using the internet by state and type of activity, Malaysia, 2018 - 2020'
	AND F6 != '2018' AND F2 != 'Membaca akhbar/ majalah online Reading newspaper/ magazines online'
	AND F7 != '2019' AND F8 != '2020'
SELECT * FROM #ReadNews

SELECT F1 AS [State], 'Professional' AS Category, 'Applying for jobs' AS Activity, 
F10 AS [2018], F11 AS [2019], F12 AS [2020]
INTO #ApplyJobs
FROM PortfolioProj..Internet_activity1
WHERE F1 IS NOT NULL AND F1 != 'Negeri                              State' AND F1 != 'Table                      : Percentage of individuals using the internet by state and type of activity, Malaysia, 2018 - 2020'
	AND F10 != '2018' AND F10 != 'Profesional Professional' AND F10 != 'Memohon pekerjaan Applying for jobs'
	AND F11 != '2019' AND F12 != '2020'
SELECT * FROM #ApplyJobs

SELECT F1 AS [State], 'Professional' AS Category, 'Participating in professional networks' AS Activity, 
F14 AS [2018], F15 AS [2019], F16 AS [2020]
INTO #ProNetworks
FROM PortfolioProj..Internet_activity1
WHERE F1 IS NOT NULL AND F1 != 'Negeri                              State' AND F1 != 'Table                      : Percentage of individuals using the internet by state and type of activity, Malaysia, 2018 - 2020'
	AND F14 != '2018' AND F10 != 'Menyertai rangkaian profesional Participating in professional networks'
	AND F11 != '2019' AND F12 != '2020'
SELECT * FROM #ProNetworks

SELECT F1 AS [State], 'Professional' AS Category, 'Work from home' AS Activity, 
F18 AS [2018], F19 AS [2019], F20 AS [2020]
INTO #WorkHome
FROM PortfolioProj..Internet_activity1
WHERE F1 IS NOT NULL AND F1 != 'Negeri                              State' AND F1 != 'Table                      : Percentage of individuals using the internet by state and type of activity, Malaysia, 2018 - 2020'
	AND F18 != '2018' AND F18 != 'Bekerja dari rumah Work from home'
	AND F19 != '2019' AND F20 != '2020'
SELECT * FROM #WorkHome

----------------------------------------------------------------------------------------------------------------------------------------------

-- Combining the first two temp tables into a newly created table

----------------------------------------------------------------------------------------------------------------------------------------------

SELECT temp.* 
INTO PortfolioProj..Malaysia_internet_activity
FROM (
	SELECT * FROM #FindInfo
	UNION ALL
	SELECT * FROM #ReadNews) temp

-----------------------------------------------------------------------------------------------------------------------------------------------

-- Inserting the rest of the temp tables into the new table in database 

-----------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM PortfolioProj..Malaysia_internet_activity

INSERT INTO PortfolioProj..Malaysia_internet_activity (State, Category, Activity, [2018], [2019], [2020])
SELECT * FROM #ApplyJobs

INSERT INTO PortfolioProj..Malaysia_internet_activity (State, Category, Activity, [2018], [2019], [2020])
SELECT * FROM #ProNetworks

INSERT INTO PortfolioProj..Malaysia_internet_activity (State, Category, Activity, [2018], [2019], [2020])
SELECT * FROM #WorkHome

------------------------------------------------------------------------------------------------------------------------------------------------