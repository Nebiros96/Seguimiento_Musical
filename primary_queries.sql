-- Consulta de prueba para traer total de canciones escuchadas por hora y día de la semana

WITH Group_by_custom AS
	(
	SELECT *,
		DATEPART(YEAR, fecha) [Year],
		DATEPART(QUARTER, fecha) [Quarter],
		DATEPART(MONTH, fecha) [Month],
		DATEPART(DAY, fecha) [Day],
		DATEPART(HOUR, fecha) [Hour],
		FORMAT(Fecha, 'yyyy-MM') AS Year_Month,
		FORMAT(Fecha, 'yyyy-MM-dd') AS Year_Month_Day,
		DATENAME(WEEKDAY, Fecha) AS [WeekDay]
	FROM 
		Brenoritvrezork
	)
SELECT 
	[Hour], 
	[WeekDay], 
	COUNT(Artist) AS Reproducciones,
	ROUND(CAST(COUNT(Artist)AS FLOAT)/CAST(COUNT(DISTINCT(Year_Month_Day))AS DECIMAL(16,2)),2) AS rep_per_day
FROM 
	Group_by_custom 
WHERE 
	Year_Month_Day IS NOT NULL
GROUP BY 
	[WeekDay], [Hour]
ORDER BY 
	Reproducciones DESC;
  
-- Consulta para traer artistas con más apariciones en un Top N y datos adicionales 
DECLARE @TopN INT = 6;
WITH Monthly_Records AS 
	(
	SELECT 
		Year_Month, 
		Artist, 
		COUNT(Artist) AS Reps
	FROM 
		Scrobblings_fix 
	GROUP BY 
		Artist, 
		Year_Month
	),
Nested_cte AS (
SELECT 
	Year_Month, Artist, Reps, 
	ROW_NUMBER() OVER(PARTITION BY Year_Month ORDER BY Reps DESC) AS RN
FROM
	Monthly_Records
WHERE 
	Year_Month IS NOT NULL
GROUP BY 
	Year_Month, Artist, Reps
),
SubNested_cte AS (
SELECT
	Artist, 
	MIN(RN) AS Best_rank, 
	COUNT(Artist) AS Times_into_top5, 
	SUM(Reps) AS Plays_in_top5, 
	MAX(Year_Month) AS Last_Month, 
	MAX(Reps) Plays_record
FROM
	Nested_cte
WHERE 
	RN < @TopN
GROUP BY 
	Artist
	)

SELECT * FROM SubNested_cte
ORDER BY 
	Times_into_top5 DESC;

