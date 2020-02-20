/* find the highest intakeID to know what number to start the INSERT intakeID values at:
SELECT MAX(intakeID) FROM dbo.AnimalIntake
;
*/



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
	(104, 'B606650'	,'STRAY'		,CONVERT(DATE,'1/28/2020')	,'INARA'	,'CAT'	,'2 YRS'	,'SMALL','BLACK/WHITE'	,'PERSIAN'	,'S')
,	(105, 'B648661'	,'TRANSFER'		,CONVERT(DATE,'1/24/2020')	,'KAYLEE'	,'BIRD'	,'6 MOS'	,'SMALL','LAVNDR/WHITE' ,'COCKATIEL','F')
,	(106, 'C648686'	,'CONFISCATE'	,CONVERT(DATE,'1/25/2020')	,'WASH'		,'DOG'	,'4 YRS'	,'X-LG'	,'BLUE'			,'POODLE'	,'N')
,	(107, 'D648729'	,'CONFISCATE'	,CONVERT(DATE,'1/26/2020')	,'RIVER'	,'CAT'	,'2 YRS'	,'X-SM'	,'YELLOW/BRN'	,'BENGAL'	,'S')
,	(108, 'O648814'	,'OWNER SUR'	,CONVERT(DATE,'1/30/2020')	,'JAYNE'	,'OTHER','5 YRS'	,'X-SM'	,'WHITE'		,'RAT'		,'M')
;



/*SELECT * FROM dbo.AnimalIntake;*/

