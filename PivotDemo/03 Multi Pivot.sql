


/*****************************************************************************
	TWO FIELD PIVOT ... bad use for SELECT * FROM
******************************************************************************
	Return the lastest inDate for each breed, but it is not pretty

If you want to see the breed that was the most recent inDate for each pet type, then this will not return the results you want.
MAX on the pivoted field must be used in the top SELECT statement.
*/
SELECT * FROM
(
SELECT
	ai.petType

	/*PIVOT*/
	,ai.inDate
	,ai.intakeType

	/*PIVOT*/
	,ai.breed
	,'breed_' + ai.intakeType AS breedintake
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



/*****************************************************************************
	TWO FIELD PIVOT ... bad use for SELECT * FROM
******************************************************************************

	Returns the MAX inDate for each breed, but it is not pretty

Suggestion: convert date fields (especially) using SQL_VARIANT datatype.
	SQL_VARIANT datatype stores the base datatype of the value it contains.
	It enforces all the rules of conversion between datatypes, when it is used as an intermediary.
	SQL_VARIANT NOTES: https://www.red-gate.com/hub/product-learning/sql-prompt/problems-caused-by-use-of-the-sql_variant-datatype
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
	,ai.intakeType

	/*PIVOT*/
	,ai.breed
	,'breed_' + ai.intakeType AS breedintake
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
;/*END: Two Field Pivot*/



/*****************************************************************************
	TWO FIELD PIVOT ... better
******************************************************************************

	Returns the MAX inDate for each breed, but it is not pretty

Use CTE to create two pivot queries to combine size with intake type, then finalize output in the main query.

Common Table Expression (CTE):
	Specifies a temporary named result set. This is derived from a simple query and defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE or MERGE statement.
	ANY CTE can be converted to a subquery in the FROM clause, but depending on how complicated your entire query is, this can be easier to read and understand.
*/
WITH pvtExample AS
(
	SELECT
		petType
		,small
		,medium
		,large
		,'' AS confiscate
		,'' AS owner_sur
		,'' AS stray
		,'' AS returned
	FROM
	(
	SELECT DISTINCT
		ai.petType

		/*PIVOT*/
		,ai.AnimalId
		,ai.size
	FROM
		dbo.AnimalIntake ai
	WHERE
		ai.intakeType != 'Return'
	) sizesrc
	PIVOT
	(
		COUNT(AnimalId)
		FOR size IN(small, medium, large)
	) sizepvt

	UNION 

	SELECT
		petType
		,'' AS small
		,'' AS medium
		,'' AS large
		,confiscate
		,owner_sur
		,stray
		,returned
	FROM
	(
	SELECT DISTINCT
		ai.petType

		/*PIVOT*/
		,ai.AnimalId
		,ai.intakeType
	FROM
		dbo.AnimalIntake ai
	WHERE
		ai.intakeType != 'Return'
	) intakesrc
	PIVOT
	(
		COUNT(AnimalId)
		FOR intakeType IN(confiscate, owner_sur, stray, returned)
	) intakepvt
)

/*MAIN QUERY*/
SELECT
	petType
	,MAX(small) AS small
	,MAX(medium) AS medium
	,MAX(large) AS large
	,MAX(confiscate) AS confiscate
	,MAX(owner_sur) AS owner_sur
	,MAX(stray) AS stray
	,MAX(returned) AS returned
FROM
	pvtExample
GROUP BY
	petType
