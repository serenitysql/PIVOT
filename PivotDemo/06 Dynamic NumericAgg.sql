/*BEGIN: Simple Pivot
	Aggregate using COUNT on animal id
	Group on each of the different pet types
	Spread on size 
*/
SELECT * FROM
/*For very simple pivots, using an asteriks in the main query is acceptable. No need to write out every field that will be returned.*/
(
SELECT DISTINCT
	ai.petType

	/*PIVOT*/
	,ai.AnimalId
	,CASE WHEN ai.size = 'MED' THEN 'medium' ELSE ai.size END AS size
FROM
	dbo.AnimalIntake ai
WHERE
	ai.intakeType != 'Return'
) src
PIVOT
(
	COUNT(AnimalId)
	FOR size IN(small, medium, large)
) sizepvt
/*END: Simple Pivot*/
;






/*
SQL to create dynamic PIVOT queries in SQL Server by Aaron Bertrand
https://www.mssqltips.com/sqlservertip/2783/script-to-create-dynamic-pivot-queries-in-sql-server/
*/

/** declare variable for column spread
*** and initialize to Unicode (NVARCHAR) 
**/
DECLARE @columns NVARCHAR(MAX) = N'';


/** Set up the variable to hold a list of unknown values for the column spread
*** 
*** QUOTENAME: Returns a Unicode string with the delimiters added to make the input string a valid SQL Server delimited identifier.
*** QUOTENAME('character_string' [, 'quote_character'])
*** Subquery: pulls the value for the column spread
**/
SELECT @columns += N', ' + QUOTENAME(size)
FROM (SELECT DISTINCT ai.size /*spreading*/
	  FROM dbo.AnimalIntake ai
	 ) col
;



/** declare variable for for dynamic sql
*** and initialize to Unicode (NVARCHAR) dynamic sql
*** The STUFF function inserts a string into another string. It deletes a specified length of characters in the first string at the start position and then inserts the second string into the first string at the start position.
*** STUFF(character_expression, start, length, replaceWith_expression)
**/

DECLARE @sql NVARCHAR(MAX) = N'
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

EXEC sp_executesql @sql;


/*
Next Steps: Read the following tips and other resources:

	Crosstab queries using PIVOT in SQL Server 2005
	Cross tab queries with SQL Server 2000
	Using PIVOT and UNPIVOT on MSDN

Last Updated: 2012-10-16
*/