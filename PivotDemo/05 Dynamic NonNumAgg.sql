
DECLARE @spreadPvt1 NVARCHAR(MAX) = N'';
SELECT @spreadPvt1 += N', ' + QUOTENAME(breed)
  FROM (SELECT DISTINCT ai.breed
		FROM dbo.AnimalIntake ai
		) col
;


DECLARE @sql NVARCHAR(MAX) = N'
SELECT size, ' + STUFF(@spreadPvt1, 1, 2, '') + '
FROM
(
SELECT
	ai.size

	/*PIVOT*/
	,CONVERT(VARCHAR,CONVERT(SQL_VARIANT,ai.inDate)) AS inDate
	,ai.breed
FROM
	dbo.AnimalIntake ai
) src
PIVOT
(
	MAX(inDate)
	FOR breed IN('+ STUFF(REPLACE(@spreadPvt1, ', [', ',['), 1, 1, '') + ')
) intake
;'
;
EXEC sp_executesql @sql;

