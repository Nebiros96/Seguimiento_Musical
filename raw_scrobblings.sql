-- Se importa el csv a SQL Server con el nombre de [Brenoritvrezork]
-- Consulta para añadir los campos de fecha a la tabla leída del csv

SELECT 
	[Album],
	[Song],
	[Fecha],
	  DATEADD(HOUR, -5, Fecha) AS Fecha_GMT,
	  DATEPART(YEAR, fecha) [Year],
	  DATEPART(QUARTER, fecha) [Quarter],
	  DATEPART(MONTH, fecha) [Month],
	  DATEPART(DAY, fecha) [Day],
	  DATEPART(HOUR, fecha) [Hour],
	  FORMAT(Fecha, 'yyyy-MM') AS Year_Month,
	  FORMAT(Fecha, 'yyyy-MM-dd') AS Year_Month_Day,
	  DATENAME(WEEKDAY, Fecha) AS [WeekDay]
	INTO Scrobblings_fix
  FROM [musica_julian].[dbo].[Brenoritvrezork]; 
