/*
SELECT * FROM dbo.AnimalIntake
;

--Subtotaled Data
SELECT petType, size, COUNT(animalID) AS countPets
FROM dbo.AnimalIntake
WHERE intakeType != 'Return'
GROUP BY petType, size
ORDER BY petType
*/



/*BEGIN: Manual Pivot without windowing function

	Aggregate using SUM on a case statement
	Group on each of the different pet types and sizes
	Spread on size 
*/
SELECT
	petType
	/*To condense petTypes to one row each */
	,MAX(small) AS small
	,MAX(medium) AS medium
	,MAX(large) AS large
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
		/*Eliminate animals that were returned to get an accurate count of pet sizes*/
		ai.intakeType != 'Return'
	GROUP BY
		/*When aggregates are included in the SELECT clause, non aggregated fields must be grouped*/
		ai.petType
		,ai.size
) src
GROUP BY
	petType
ORDER BY
	petType
;/*END: Manual Pivot without windowing function*/



/*BEGIN: Manual Pivot with windowing function 

	Aggregate using SUM on a case statement
	Group on each of the different pet types and sizes
	Spread on size

Windowing Function Definition: A function that's applied to a set of rows defined by a window descriptor and returns a single value for each row from the underlying query. The purpose of the window descriptor is to define the set of rows that the function should apply to.
*/
SELECT
	petType
	,MAX(small) AS small
	,MAX(medium) AS medium
	,MAX(large) AS large
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
		ai.intakeType != 'Return'
) src
GROUP BY
	petType
;/*END: Manual Pivot with windowing function*/


/*
	As with all queries, there is more than one way to organize, format, and lay out the syntax.
	This query could be written using only the subquery and adding "DISTINCT".
	However, I wrote in a similar syntax to the Manual Pivot without Windowing Function and the Simple Pivot for equal camparison purposes.

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
;/*END: Simple Pivot*/




/*MySQL
I need to investigate more, but I don't think MySQL has a pivot operator


SELECT DISTINCT
	ai.petType
	,COUNT(IF(ai.gender IN('S','N'), ai.animalid, NULL)) AS fixed
	,COUNT(IF(ai.gender IN('F','M'), ai.animalid, NULL)) AS intact
FROM
	dbo.AnimalIntake ai
;
*/

