/*
SELECT * FROM dbo.AnimalIntake
ORDER BY inDate
;
*/



/*BEGIN: BASIC NON NUMERICAL AGGRAGATE PIVOT (a.k.a. MIN / MAX)

	Aggregate using MAX on inDate
	Group on each of the different pet types
	Spread on each intake type
*/
SELECT * FROM
(
SELECT
	ai.petType

	/*PIVOT*/
	,ai.inDate
	/*Normally, I would use a CASE statement to eliminate spaces or reserved words in the values, but want to show you what happens when you don't*/
	,ai.intakeType
FROM
	dbo.AnimalIntake ai
) src
PIVOT
(
	MAX(inDate)
	FOR intakeType IN([confiscate],[owner sur],[stray],[return])
	/*square brackes [ ] MUST be used if your values have spaces or special characters other than underscore*/
) AS pvt
;/*END: BASIC NON NUMERICAL AGGRAGATE PIVOT (a.k.a. MIN / MAX)*/





/*BEGIN: Two Field Pivot  .... 
This will show you the lastest inDate for each breed.
If, however, you want to see the breed that was brought in for lastest inDate for each pet type, then this will not return the results you want, because of "SELECT * FROM". MAX on the pivoted field must be used in the top SELECT statement, see the next example ...
*/
SELECT * FROM
(
SELECT
	ai.petType

	/*PIVOT*/
	,ai.inDate
	,CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
		WHEN ai.intakeType = 'return' THEN 'returned' 
		ELSE ai.intakeType END AS intakeType

	/*PIVOT*/
	,ai.breed
	,'breed_' + CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
		WHEN ai.intakeType = 'return' THEN 'returned' 
		ELSE ai.intakeType END AS breedintake
FROM
	dbo.AnimalIntake ai
) src
PIVOT
(
	MAX(inDate)
	FOR intakeType IN(confiscate,owner_sur,stray,returned)
) indates
PIVOT
(
	MAX(breed)
	FOR breedintake IN(breed_confiscate,breed_owner_sur,breed_stray,breed_returned)
) breeds
;/*END: Two Field Pivot  .... EXAMPLE OF WHAT NOT TO DO*/



/*BEGIN: Two Field Pivot
	Need to include non-pivoted fields in a GROUP BY.

	To change how NULLs appear, use a COALESCE function and enter what NULLS should be replaced with

*/
SELECT
	petType
	,COALESCE(MAX(confiscate),'N/A') AS conf_date
	,COALESCE(MAX(breed_confiscate),'N/A') AS conf_breed

	,MAX(owner_sur) AS sur_date
	,MAX(breed_owner_sur) AS sur_breed

	,COALESCE(MAX(stray),'') AS stray_date
	,COALESCE(MAX(breed_stray),'') AS stray_breed

	,COALESCE(MAX(returned),'None') AS returned_date
	,COALESCE(CONVERT(VARCHAR,MAX(breed_returned)),'None') AS returned_breed
FROM
(
SELECT
	ai.petType

	/*PIVOT*/
	,CONVERT(VARCHAR,CONVERT(SQL_VARIANT,ai.inDate)) AS inDate
	,CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
		WHEN ai.intakeType = 'return' THEN 'returned' 
		ELSE ai.intakeType END AS intakeType

	/*PIVOT*/
	,ai.breed
	,'breed_' + CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
		WHEN ai.intakeType = 'return' THEN 'returned' 
		ELSE ai.intakeType END AS breedintake
FROM
	dbo.AnimalIntake ai
) src
PIVOT
(
	MAX(inDate)
	FOR intakeType IN(confiscate,owner_sur,stray,returned)
) indates
PIVOT
(
	MAX(breed)
	FOR breedintake IN(breed_confiscate,breed_owner_sur,breed_stray,breed_returned)
) breeds
GROUP BY
	petType

/*SQL_VARIANT NOTES: https://www.red-gate.com/hub/product-learning/sql-prompt/problems-caused-by-use-of-the-sql_variant-datatype
sql_variant can be a useful tool, such as when working with inconsistent or unspecified data types.

sql_variant stores the base datatype of the value it contains, so enforces all the rules of conversion between datatypes, when it is used as an intermediary.
*/
;/*END: Two Field Pivot*/






/*INVESTIGATE sqlvarient FOR CONVERTING DATA TYPES AS IT WILL KEEP THE ORIGINAL DATA TYPE LIKE DATE*/



