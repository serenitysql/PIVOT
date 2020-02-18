/*
SELECT * FROM dbo.AnimalIntake
ORDER BY inDate
;
*/
WITH pvtExample AS
/*
Common Table Expression (CTE):
Specifies a temporary named result set. This is derived from a simple query and defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE or MERGE statement. \
Ths can cause slightly more overhead, but can make a query easier to read vs using subqueries.
*/
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
		,CASE WHEN ai.size = 'MED' THEN 'medium' ELSE ai.size END AS size
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
/*
	/*PIVOT*/
	,ai.inDate

	/*PIVOT*/
	,ai.breed
	,'breed_' + CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
		WHEN ai.intakeType = 'return' THEN 'returned' 
		ELSE ai.intakeType END AS breedintake
*/
		/*PIVOT*/
		,ai.AnimalId
		,CASE WHEN ai.intakeType = 'owner sur' THEN 'owner_sur' 
			WHEN ai.intakeType = 'return' THEN 'returned' 
			ELSE ai.intakeType END AS intakeType
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
