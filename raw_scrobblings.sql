-- Se importa el csv a SQL Server con el nombre de [Brenoritvrezork]
-- Consulta para añadir los campos de fecha a la tabla leída del csv

-- visualizamos la tabla rapidamente
 SELECT * FROM Scrobblings_fix
ORDER BY Fecha;

 -- Borramos datos sin eliminar tabla
 TRUNCATE TABLE Scrobblings_fix;

 -- Insertamos nueva data
 INSERT INTO Scrobblings_fix
 SELECT 
	[Artist],
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
	--INTO Scrobblings_fix
  FROM [musica_julian].[dbo].[Brenoritvrezork]; 
