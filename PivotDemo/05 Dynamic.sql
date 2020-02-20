/*Get to know your data: List of breeds*/
SELECT DISTINCT ai.breed
FROM dbo.AnimalIntake ai
WHERE ai.intakeType != 'Return'
;



/*****************************************************************************
	DYNAMIC PIVOT
******************************************************************************

	Returns the MAX inDate for each breed

Dynamic Pivot Query: "SQL to create dynamic PIVOT queries in SQL Server" by Aaron Bertrand
https://www.mssqltips.com/sqlservertip/2783/script-to-create-dynamic-pivot-queries-in-sql-server/
*/

/*declare variable for column spread and initialize to Unicode (NVARCHAR)*/
DECLARE @spreadPvt1 NVARCHAR(MAX) = N'';

/* Set up the variable to hold a list of unknown values for the column spread
 
   QUOTENAME: Returns a Unicode string with the delimiters added to make the input string a valid SQL Server delimited identifier.
   SYNTAX: QUOTENAME('character_string' [, 'quote_character'])
*/
SELECT @spreadPvt1 += N', ' + QUOTENAME(breed)
  FROM (SELECT DISTINCT ai.breed
		FROM dbo.AnimalIntake ai
		) col
;

/*declare and set pivot query*/
DECLARE @sqlBreed NVARCHAR(MAX) = N'
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
) intake;'
;
EXEC sp_executesql @sqlBreed;



/*****************************************************************************
	INSERT NEW VALUES
******************************************************************************
--find the highest intakeID to know what number to start the INSERT intakeID values at:

SELECT MAX(intakeID) FROM dbo.AnimalIntake
;

INSERT INTO dbo.AnimalIntake
(	intakeID
	,animalID
	,intakeType
	,inDate
	,petName
	,petType
	,age
	,size
	,color
	,breed
	,gender
)
VALUES
	(104, 'B606650'	,'STRAY'		,CONVERT(DATE,'1/28/2020')	,'INARA'	,'CAT'	,'2 YRS'	,'X-SM','BLACK/WHITE'	,'PERSIAN'	,'S')
,	(105, 'B648661'	,'TRANSFER'		,CONVERT(DATE,'1/24/2020')	,'KAYLEE'	,'BIRD'	,'6 MOS'	,'X-SM','LAVNDR/WHITE' ,'COCKATIEL','F')
,	(106, 'C648686'	,'CONFISCATE'	,CONVERT(DATE,'1/25/2020')	,'WASH'		,'DOG'	,'4 YRS'	,'X-LG'	,'BLUE'			,'POODLE'	,'N')
,	(107, 'D648729'	,'CONFISCATE'	,CONVERT(DATE,'1/26/2020')	,'RIVER'	,'CAT'	,'2 YRS'	,'X-SM'	,'YELLOW/BRN'	,'BENGAL'	,'S')
,	(108, 'O648814'	,'OWNER SUR'	,CONVERT(DATE,'1/30/2020')	,'JAYNE'	,'OTHER','5 YRS'	,'TINY'	,'WHITE'		,'RAT'		,'M')
;
*/
/*SELECT * FROM dbo.AnimalIntake;*/



/*****************************************************************************
	DYNAMIC PIVOT THAT SHOWS NEW SIZE VALUES
*****************************************************************************/


/*declare variable for column spread and initialize to Unicode (NVARCHAR)*/
DECLARE @columns NVARCHAR(MAX) = N'';

/* Set up the variable to hold a list of unknown values for the column spread
 
   QUOTENAME: Returns a Unicode string with the delimiters added to make the input string a valid SQL Server delimited identifier.
   SYNTAX: QUOTENAME('character_string' [, 'quote_character'])
*/
SELECT @columns += N', ' + QUOTENAME(size)
FROM (SELECT DISTINCT CASE WHEN ai.size = 'MED' THEN 'MEDIUM' ELSE ai.size END AS size /*spreading*/
	  FROM dbo.AnimalIntake ai
	 ) col
;

/*declare and and initialize to Unicode (NVARCHAR) dynamic sql, then set dynamic pivot query

The STUFF function inserts a string into another string. 
It deletes a specified length of characters in the first string at the start position and then inserts the second string into the first string at the start position. 
SYNTAX: STUFF(character_expression, start, length, replaceWith_expression)
*/

DECLARE @sqlSize NVARCHAR(MAX) = N'
SELECT	petType /*grouping field*/
		, ' + STUFF(@columns, 1, 2, '') + '
FROM
(
SELECT
	ai.petType /*grouping*/

	/*PIVOT*/
	,ai.AnimalId
	,CASE WHEN ai.size = ''MED'' THEN ''medium'' ELSE ai.size END AS size
FROM
  dbo.AnimalIntake ai
WHERE
	ai.intakeType != ''Return''
) src
PIVOT
(
  COUNT(animalId)
  FOR size IN('+ STUFF(REPLACE(@columns, ', [', ',['), 1, 1, '') + ')
) pvt
;';

EXEC sp_executesql @sqlSize;
