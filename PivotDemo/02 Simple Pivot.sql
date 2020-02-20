

/*****************************************************************************
	SHOW SUBTOTALED DATA
*****************************************************************************/
SELECT	 petType, size, COUNT(animalID) AS countPets
FROM	 dbo.AnimalIntake
WHERE	 intakeType != 'Return'
GROUP BY petType, size
ORDER BY petType
;




/*****************************************************************************
	MANUAL PIVOT w/o WINDOWING FUNCTION
******************************************************************************
	Aggregate using SUM on a case statement
	Group on each of the different pet types and sizes
	Spread on size

	Return number of pet types by size
*/
SELECT
	size.petType

	/*To condense petTypes to one row each */
	,MAX(size.small) AS small
	,MAX(size.medium) AS medium
	,MAX(size.large) AS large
FROM
	(
	SELECT
		ai.petType
		,SUM(CASE WHEN ai.size = 'SMALL' THEN 1 ELSE 0 END) AS small
		,SUM(CASE WHEN ai.size = 'MED' THEN 1 ELSE 0 END) AS medium
		,SUM(CASE WHEN ai.size = 'LARGE' THEN 1 ELSE 0 END) AS large
	FROM
		dbo.AnimalIntake ai
	WHERE
		/*Eliminate animals that were returned to count unique animals and eliminate duplicates*/
		ai.intakeType != 'Return'
	GROUP BY
		ai.petType
		,ai.size
	) size
GROUP BY
	size.petType
ORDER BY
	size.petType
;/*END: Manual Pivot without windowing function*/



/*****************************************************************************
	MANUAL PIVOT w/ WINDOWING FUNCTION
******************************************************************************
Windowing Function Definition: A function that's applied to a set of rows defined by a window descriptor and returns a single value for each row from the underlying query. 
The purpose of the window descriptor is to define the set of rows that the function should apply to. There is no need to have GROUP BY, but you may need to use DISTINCT.

	Aggregate using SUM on a case statement
	Group on each of the different pet types and sizes
	Spread on size

	Return number of pet types by size
*/
SELECT
	size.petType
	/*To condense petTypes to one row each */
	,MAX(size.small) AS small
	,MAX(size.medium) AS medium
	,MAX(size.large) AS large
FROM
	(
	SELECT
		ai.petType
		,SUM(CASE WHEN ai.size = 'SMALL' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS small
		,SUM(CASE WHEN ai.size = 'MED' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS medium
		,SUM(CASE WHEN ai.size = 'LARGE' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS large
	FROM
		dbo.AnimalIntake ai
	WHERE
		/*Eliminate animals that were returned to count unique animals and eliminate duplicates*/
		ai.intakeType != 'Return'
	) size
GROUP BY
	size.petType
;/*END: Manual Pivot with windowing function*/



/*****************************************************************************
	MANUAL PIVOT w/ WINDOWING FUNCTION ... Alternate syntax
******************************************************************************
The above windowing query could be written using only the subquery and adding "DISTINCT".

	Return number of pet types by size

SELECT DISTINCT
	ai.petType
	,SUM(CASE WHEN ai.size = 'SMALL' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS small
	,SUM(CASE WHEN ai.size = 'MED' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS medium
	,SUM(CASE WHEN ai.size = 'LARGE' THEN 1 ELSE 0 END) OVER(PARTITION BY ai.petType) AS large
FROM
	dbo.AnimalIntake ai
WHERE
	ai.intakeType != 'Return'
*/



/*****************************************************************************
	NUMERICAL aggragate pivot (a.k.a. SUM / COUNT / AVG)
******************************************************************************
	Aggregate using COUNT on animal id
	Group on each of the different pet types
	Spread on size

	Return number of pet types by size

For very simple pivots, using an asteriks in the main query is acceptable. 
No need to write out every field that will be returned, because the fields to be returned are already limited.
*/
SELECT * FROM
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
) src
PIVOT
(
	COUNT(AnimalId)
	FOR size IN(Small, Medium, Large)
	/*even though the data in the size field for Medium is actually MED, seems like SQL Svr knows what is being referred to*/
) sizepvt
;/*END: Simple numerical aggegrate Pivot*/



/*****************************************************************************
	NON NUMERICAL aggragate pivot (a.k.a. MIN / MAX)
******************************************************************************
	Aggregate using MAX on inDate
	Group on each of the different petType
	Spread on intakeType

	Return number of pet types by size

	Since we want to see the latest date for an intake date per size, no need to eliminate animals that were returned
*/
SELECT * FROM
(
	SELECT
		ai.petType

		/*PIVOT*/
		,ai.inDate
		,ai.intakeType
	FROM
		dbo.AnimalIntake ai
) src
PIVOT
(
	MAX(inDate)
	FOR intakeType IN(confiscate,[owner surrender],stray,returned)
	/*square brackes [ ] MUST be used if the customer will not be persuaded to not use spaces or special characters other than underscore in the result output*/
) AS pvt
;/*END: BASIC NON NUMERICAL AGGRAGATE PIVOT (a.k.a. MIN / MAX)*/



/*MySQL
This has not been tested but the interwebs say this is what the syntax is for MySQL:

SELECT DISTINCT
	ai.petType
	,COUNT(IF(ai.gender IN('S','N'), ai.animalid, NULL)) AS fixed
	,COUNT(IF(ai.gender IN('F','M'), ai.animalid, NULL)) AS intact
FROM
	dbo.AnimalIntake ai
;
*/

