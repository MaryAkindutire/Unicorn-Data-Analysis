SELECT * FROM dbo.Unicorns$

DROP TABLE #Unicorns
CREATE TABLE #Unicorns (
Company VARCHAR (100),
Valuation MONEY,
Date_Joined DATE,
Country VARCHAR (50),
City VARCHAR (50),
Industry VARCHAR (150),
Investors VARCHAR (255)
)
INSERT INTO #Unicorns
(Company, Valuation, Date_Joined, Country, City, Industry, Investors)
SELECT [Company]
      ,[Valuation ($B)]
      ,[Date Joined]
      ,[Country]
      ,[City]
      ,[Industry]
      ,[Select Investors] 
FROM dbo.Unicorns$ --Created a temporary table and selected key columns from the original table

--Lets explore and answer some questions using SQL
--How many Unicorns are there globally
 SELECT COUNT(Company) AS no_of_companies
 FROM #Unicorns
 
 --Total Valuation of all Unicorns
  SELECT SUM(Valuation) AS Total_Valuation_Figure
 FROM #Unicorns

 --Countries with the amount of unicorns
 SELECT TOP 10 Country,  COUNT(Company) AS no_of_companies,
 COUNT(Company) * 100.0 / (SELECT COUNT(Company) FROM #Unicorns) AS percentage_of_total
 FROM #Unicorns
 GROUP BY Country
 ORDER BY no_of_companies DESC

 --Cities with their total amount of Unicorns
 SELECT TOP 10 Country, City, COUNT(Company) AS no_of_companies, 
 COUNT(Company) * 100.0 /
 (SELECT COUNT(Company) FROM #Unicorns) AS percentage_of_total
 FROM #Unicorns
 GROUP BY Country, City
 ORDER BY no_of_companies DESC

 --How long also each company joined the group of unicorns
 SELECT Company, Valuation, Date_Joined, DATEDIFF(year, Date_Joined, '2022-10-10') as no_of_years
 FROM #Unicorns
 ORDER BY no_of_years DESC, valuation DESC
 
 --Unicorn By Industry
 SELECT Industry, COUNT(Company) AS no_of_companies,
 COUNT(Company) * 100.0 / (SELECT COUNT(Company) FROM #Unicorns) AS percentage_of_total
 FROM #Unicorns
 GROUP BY Industry
 ORDER BY no_of_companies DESC

 -- Unicorns By valuation
 SELECT Company, Valuation,
 Valuation * 100.0 / (SELECT SUM(Valuation) AS Total_Valuation_Figure FROM #Unicorns) AS percentage_of_total
 FROM #Unicorns
 ORDER BY Valuation DESC

 --Top Investant Company that has invested in the highest company
 WITH Unicorn_Investors AS (
SELECT Company, LTRIM (value) AS Investors_
 FROM #Unicorns
 CROSS APPLY string_split (Investors, ',')
 )
SELECT Investors_, SUM (COUNT(Company)) Over (PARTITION BY Investors_) AS no_of_companies
FROM Unicorn_Investors
WHERE Investors_ <> ' '
GROUP BY Investors_
ORDER BY no_of_companies DESC

 --Top Industry that has the highest number of investors. 
 WITH Unicorn_Investors AS (
SELECT Company, Industry, LTRIM (value) AS Investors_
 FROM #Unicorns
 CROSS APPLY string_split (Investors, ',')
 )
SELECT Industry, COUNT(Industry) AS no_of_investors 
FROM Unicorn_Investors
WHERE Investors_ <> ' '
GROUP BY Industry
ORDER BY no_of_investors DESC

-- Breakdown of the Investors investment in each Industry by the companies
WITH Unicorn_Investors AS (
SELECT Company, Industry, LTRIM (value) AS Investors_
 FROM #Unicorns
 CROSS APPLY string_split (Investors, ',')
 )
SELECT Industry, Investors_, COUNT(Industry) AS no_of_companies_invested_in -- 
FROM Unicorn_Investors
WHERE Investors_ <> ' '
GROUP BY Industry, Investors_
ORDER BY no_of_companies_invested_in DESC


