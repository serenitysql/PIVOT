/*

The data set for this example is very poor and needs to be updated with more relvant data. 
Will try to update in the near future.

*/

/*	
--	TABLE
--	Checks to see if function exists and drops it if it does 

IF OBJECT_ID(N'PivotDemo',N'U') IS NOT NULL
	DROP TABLE PivotDemo
;
*/

/*
--	TEMP TABLE

IF OBJECT_ID(N'tempdb..#PivotDemo',N'U') IS NOT NULL
	DROP TABLE #PivotDemo
;

--	Create a temp table for Pivot Data
CREATE TABLE #PivotDemo
(
	TestID INT
	,TestType VARCHAR(10)
	,TestName VARCHAR(15)
	,Category VARCHAR(15)
	,ActFlg VARCHAR(5)
	,test_sql VARCHAR(10)
	,UsrID VARCHAR(15)
	,Upd_DT DATETIME
)
;

--	LOAD DATA
INSERT INTO #PivotDemo (TestID,TestType,TestName,Category,ActFlg,test_sql,UsrID,Upd_DT)
VALUES
(215,'Type01','Test001','Category13','Y','test_sql','Chris',40822.775)
,(17,'Type02','Test001','Category03','Y','test_sql','Sam',42433.35)
,(13,'Type02','Test002','Category03','Y','test_sql','Bob',41180.4583333333)
,(216,'Type01','Test003','Category13','Y','test_sql','Chris',40822.775)
,(4,'Type02','Test003','Category03','Y','test_sql','Bob',41563.61875)
,(406,'Type01','Test004','Category16','Y','test_sql','Bob',41382.5548611111)
,(405,'Type02','Test004','Category06','Y','test_sql','Bob',41382.5548611111)
,(55,'Type02','Test005','Category10','Y','test_sql','Chris',40822.775)
,(22,'Type02','Test006','Category10','Y','test_sql','Chris',40822.775)
,(196,'Type02','Test007','Category01','N','test_sql','Frank',42487.6180555556)
,(217,'Type01','Test007','Category13','Y','test_sql','Bob',41710.5784722222)
,(425,'Type02','Test008','Category08','Y','test_sql','Bob',41712.5041666667)
,(337,'Type02','Test009','Category08','Y','test_sql','Bob',41712.49375)
,(294,'Type02','Test010','Category08','Y','test_sql','Bob',41712.4930555556)
*/
/*
,(424,'Type02','Test011','Category08','Y','test_sql','Bob',41712.5041666667)
,(391,'Type02','Test012','Category03','Y','test_sql','Bob',41254.6680555556)
,(273,'Type02','Test013','Category03','Y','test_sql','Bob',42051.5083333333)
,(238,'Type01','Test014','Category13','Y','test_sql','Sam',42398.6340277778)
,(132,'Type02','Test014','Category10','Y','test_sql','Chris',42289.5770833333)
,(437,'Type02','Test015','Category10','Y','test_sql','Chris',42289.6458333333)
,(131,'Type02','Test016','Category01','Y','test_sql','Bob',41555.5298611111)
,(412,'Type02','Test017','Category08','Y','test_sql','Bob',41745.4590277778)
,(421,'Type02','Test018','Category08','Y','test_sql','Bob',41709.625)
,(442,'Type02','Test019','Category07','Y','test_sql','Sam',42381.7)
,(63,'Type02','Test020','Category03','N','test_sql','Bob',41180.4583333333)
,(64,'Type02','Test020','Category03','N','test_sql','Bob',41180.4583333333)
,(203,'Type01','Test021','Category13','Y','test_sql','Chris',40822.775)
,(2,'Type02','Test021','Category03','Y','test_sql','Bob',41366.5673611111)
,(204,'Type01','Test022','Category13','Y','test_sql','Chris',42563.5201388889)
,(23,'Type02','Test022','Category03','Y','test_sql','Chris',40822.775)
,(207,'Type01','Test023','Category18','Y','test_sql','George',42286.5833333333)
,(107,'Type02','Test023','Category08','Y','test_sql','Sam',42398.3951388889)
,(205,'Type01','Test024','Category14','Y','test_sql','George',42286.5840277778)
,(195,'Type02','Test024','Category04','Y','test_sql','George',42286.5638888889)
,(111,'Type02','Test025','Category03','Y','test_sql','Bob',41563.6194444444)
,(280,'Type02','Test026','Category03','Y','test_sql','Bob',41563.61875)
,(7,'Type02','Test027','Category10','Y','test_sql','Bob',41596.6097222222)
,(274,'Type01','Test028','Category13','Y','test_sql','Bob',40994.4013888889)
,(279,'Type02','Test029','Category01','Y','test_sql','Bob',41129.45)
,(140,'Type02','Test030','Category10','Y','test_sql','Bob',41004.7770833333)
,(414,'Type02','Test031','Category03','Y','test_sql','Bob',41478.5097222222)
,(438,'Type02','Test032','Category04','Y','test_sql','Bob',42186.6604166667)
,(208,'Type01','Test033','Category18','Y','test_sql','Chris',40822.775)
,(193,'Type02','Test033','Category08','Y','test_sql','Bob',41114.4875)
,(396,'Type02','Test034','Category02','Y','test_sql','George',42286.5645833333)
,(433,'Type01','Test035','Category14','Y','test_sql','Bob',41974.4305555556)
,(432,'Type02','Test035','Category04','Y','test_sql','Bob',41974.4298611111)
,(16,'Type02','Test036','Category03','Y','test_sql','Bob',41180.4590277778)
,(241,'Type02','Test037','Category06','N','test_sql','Chris',40822.775)
,(230,'Type01','Test038','Category13','Y','test_sql','Chris',40822.775)
,(15,'Type02','Test038','Category10','Y','test_sql','Chris',40822.775)
,(408,'Type02','Test039','Category10','Y','test_sql','Bob',41410.5090277778)
,(60,'Type02','Test040','Category10','Y','test_sql','Chris',40822.775)
,(219,'Type01','Test041','Category13','Y','test_sql','Chris',40822.775)
,(18,'Type02','Test041','Category03','Y','test_sql','Bob',41180.4590277778)
,(198,'Type02','Test042','Category01','Y','test_sql','Bob',41914.7951388889)
,(134,'Type02','Test043','Category01','Y','test_sql','Bob',41402.4243055556)
,(209,'Type01','Test044','Category18','Y','test_sql','Chris',40822.775)
,(194,'Type02','Test044','Category08','Y','test_sql','Chris',40822.775)
,(220,'Type01','Test045','Category13','N','test_sql','George',41928.6236111111)
,(145,'Type02','Test045','Category03','N','test_sql','Bob',41914.7958333333)
,(450,'Type02','Test046','Category09','Y','test_sql','Sam',42356.4395833333)
,(451,'Type02','Test047','Category09','Y','test_sql','Sam',42356.4402777778)
,(452,'Type02','Test048','Category09','Y','test_sql','Sam',42356.4402777778)
,(439,'Type02','Test049','Category02','Y','test_sql','Chris',42425.6444444444)
,(448,'Type02','Test050','Category08','Y','test_sql','George',42347.7083333333)
,(210,'Type01','Test051','Category18','Y','test_sql','Chris',41117.4458333333)
,(112,'Type02','Test051','Category08','N','test_sql','Sam',42376.7006944444)
,(221,'Type01','Test052','Category13','Y','test_sql','Chris',40822.775)
,(192,'Type02','Test052','Category08','Y','test_sql','Chris',40822.775)
,(222,'Type01','Test053','Category13','Y','test_sql','George',42286.5840277778)
,(191,'Type02','Test053','Category08','Y','test_sql','George',42286.5645833333)
,(224,'Type01','Test054','Category13','Y','test_sql','George',42286.5840277778)
,(199,'Type02','Test054','Category08','Y','test_sql','George',42286.5652777778)
,(443,'Type02','Test055','Category08','Y','test_sql','Sam',42381.5243055556)
,(225,'Type01','Test056','Category13','Y','test_sql','Chris',40822.775)
,(413,'Type02','Test056','Category08','Y','test_sql','Bob',41473.6590277778)
,(416,'Type02','Test057','Category10','N','test_sql','Bob',42165.7111111111)
,(113,'Type02','Test058','Category10','Y','test_sql','George',42313.5423611111)
,(114,'Type02','Test059','Category03','Y','test_sql','George',42313.5430555556)
,(142,'Type02','Test060','Category06','Y','test_sql','George',42313.5430555556)
,(108,'Type02','Test061','Category10','Y','test_sql','Chris',40822.775)
,(102,'Type02','Test062','Category10','Y','test_sql','Chris',40822.775)
,(21,'Type02','Test063','Category10','Y','test_sql','Chris',40822.775)
,(211,'Type01','Test064','Category18','Y','test_sql','George',42286.5840277778)
,(56,'Type02','Test064','Category06','Y','test_sql','George',42286.5652777778)
,(141,'Type02','Test065','Category10','Y','test_sql','George',42286.5645833333)
,(212,'Type01','Test066','Category18','Y','test_sql','Bob',41274.3861111111)
,(103,'Type02','Test066','Category08','Y','test_sql','Bob',41274.3861111111)
,(53,'Type02','Test067','Category10','Y','test_sql','Chris',40822.775)
,(441,'Type02','Test068','Category10','Y','test_sql','George',42293.6208333333)
,(8,'Type02','Test069','Category10','N','test_sql','George',42296.7354166667)
,(138,'Type02','Test070','Category10','N','test_sql','George',42296.7236111111)
,(272,'Type01','Test071','Category13','Y','test_sql','Fred',40935.45)
,(401,'Type02','Test072','Category03','Y','test_sql','Bob',41361.4923611111)
,(404,'Type01','Test072','Category13','Y','test_sql','Bob',41362.3847222222)
,(276,'Type02','Test073','Category01','Y','test_sql','Bob',41374.6791666667)
,(104,'Type02','Test074','Category10','Y','test_sql','Bob',41554.5847222222)
,(129,'Type02','Test075','Category06','N','test_sql','Chris',40435.49375)
,(226,'Type01','Test076','Category13','Y','test_sql','Chris',40822.775)
,(52,'Type02','Test076','Category03','Y','test_sql','Sam',42418.6833333333)
,(214,'Type01','Test077','Category18','Y','test_sql','George',42300.4923611111)
,(105,'Type02','Test077','Category08','Y','test_sql','Sam',42424.35625)
,(430,'Type02','Test078','Category03','N','test_sql','Bob',41739.5472222222)
,(277,'Type02','Test079','Category01','Y','test_sql','Bob',41597.6576388889)
,(278,'Type01','Test079','Category11','Y','test_sql','Bob',41597.6576388889)
,(410,'Type02','Test080','Category04','Y','test_sql','Bob',41597.6569444444)
,(411,'Type01','Test080','Category14','Y','test_sql','Bob',41597.6576388889)
,(395,'Type02','Test081','Category08','Y','test_sql','Bob',41523.5986111111)
,(426,'Type02','Test082','Category04','Y','test_sql','Bob',41722.6319444444)
,(427,'Type01','Test082','Category14','Y','test_sql','Bob',41722.6326388889)
,(101,'Type02','Test083','Category03','N','test_sql','Bob',41366.4930555556)
,(110,'Type02','Test084','Category10','Y','test_sql','Chris',40822.775)
,(415,'Type02','Test085','Category01','Y','test_sql','Bob',41572.5534722222)
,(227,'Type01','Test086','Category13','Y','test_sql','Chris',40822.775)
,(26,'Type02','Test086','Category06','N','test_sql','Bob',41555.5319444444)
,(228,'Type01','Test087','Category13','Y','test_sql','Chris',40822.775)
,(19,'Type02','Test087','Category10','Y','test_sql','Chris',40822.775)
,(59,'Type02','Test088','Category10','Y','test_sql','Chris',40822.775)
,(229,'Type01','Test089','Category13','Y','test_sql','Bob',41381.5284722222)
,(51,'Type02','Test089','Category03','Y','test_sql','Bob',42046.6618055556)
,(403,'Type01','Test090','Category13','Y','test_sql','Bob',41362.3819444444)
,(402,'Type02','Test090','Category10','Y','test_sql','Bob',41362.3805555556)
,(380,'Type02','Test091','Category03','N','test_sql','George',42339.6763888889)
,(381,'Type02','Test092','Category06','Y','test_sql','Bob',41374.6770833333)
,(384,'Type01','Test092','Category16','Y','test_sql','Bob',41374.6805555556)
,(382,'Type02','Test093','Category06','Y','test_sql','Bob',41374.6770833333)
,(385,'Type01','Test093','Category16','Y','test_sql','Bob',41374.6805555556)
,(383,'Type02','Test094','Category06','Y','test_sql','Bob',41374.6770833333)
,(386,'Type01','Test094','Category16','Y','test_sql','Bob',41374.6805555556)
,(231,'Type01','Test095','Category13','Y','test_sql','Chris',40822.775)
,(6,'Type02','Test095','Category10','Y','test_sql','Chris',40822.775)
,(128,'Type02','Test096','Category08','N','test_sql','Bob',41260.6131944444)
,(232,'Type01','Test097','Category13','Y','test_sql','Chris',40822.775)
,(12,'Type02','Test097','Category03','Y','test_sql','Bob',42051.5166666667)
,(431,'Type01','Test098','Category13','N','test_sql','Bob',41740.50625)
,(429,'Type02','Test098','Category10','Y','test_sql','Bob',42039.6493055556)
,(133,'Type02','Test099','Category08','Y','test_sql','Chris',40822.775)
,(399,'Type02','Test100','Category01','Y','test_sql','Bob',41540.3972222222)
,(233,'Type01','Test101','Category13','Y','test_sql','Sam',42443.6395833333)
,(11,'Type02','Test101','Category03','Y','test_sql','Sam',42443.6395833333)
,(25,'Type02','Test102','Category03','Y','test_sql','Bob',41563.6194444444)
,(234,'Type01','Test103','Category13','Y','test_sql','Chris',40822.775)
,(3,'Type02','Test103','Category10','Y','test_sql','Bob',41631.54375)
,(235,'Type01','Test104','Category13','Y','test_sql','George',42286.5833333333)
,(10,'Type02','Test104','Category03','Y','test_sql','George',42286.5638888889)
,(236,'Type01','Test105','Category13','Y','test_sql','George',42286.5840277778)
,(5,'Type02','Test105','Category03','Y','test_sql','George',42286.5645833333)
,(237,'Type01','Test106','Category13','Y','test_sql','Chris',40822.775)
,(24,'Type02','Test106','Category03','Y','test_sql','Bob',41180.4576388889)
,(14,'Type02','Test107','Category03','Y','test_sql','Bob',41180.45625)
,(54,'Type02','Test108','Category03','Y','test_sql','Bob',41180.4569444444)
,(136,'Type02','Test109','Category07','Y','test_sql','George',42286.5645833333)
,(206,'Type01','Test109','Category16','Y','test_sql','George',42286.5840277778)
,(420,'Type02','Test110','Category01','N','test_sql','Bob',41718.5069444444)
,(428,'Type02','Test111','Category10','N','test_sql','Bob',41751.7111111111)
,(139,'Type02','Test112','Category02','Y','test_sql','Bob',41572.5486111111)
,(240,'Type01','Test113','Category11','Y','test_sql','Chris',40822.775)
,(398,'Type01','Test114','Category13','Y','test_sql','Bob',41603.3840277778)
,(409,'Type02','Test115','Category10','Y','test_sql','Bob',41570.5423611111)
;
SELECT	*
FROM	#PivotDemo
;
*/

/*	Typical PIVOT using COUNT on active flag

	Each rule should have one each of the different rule types.

	Each rule displays once with a count of active flags for each type.
*/
/*
SELECT 
	* 
FROM
	(
	SELECT
		TestName
		,TestType
		,ActFlg
	FROM
		#PivotDemo 
	) src
	PIVOT
	(
	COUNT(ActFlg)
	FOR TestType IN(Type01,Type02)
	) AS pvt1		
ORDER BY
	TestName ASC
;
*/



/*	BASIC NON AGGRAGATE PIVOT

	Which user entered the query for the specific rule type.
	
	Each rule is listed twice, once for each user with the corresponding active flag for each rule type 
*/

/*
SELECT * 
FROM
	(
	SELECT
		TestName
		,TestType
		,ActFlg
		,UsrID
	FROM
		#PivotDemo 
	) src
	PIVOT
	(
	MIN(ActFlg)
	FOR TestType IN(Type01,Type02)
	) AS pvt1		
ORDER BY
	TestName ASC
;
*/





/*	Two Field Pivot

	What if we put the user as a column.
	Would that condense each rule to one line each?
	Let's see ...
*/

/*
SELECT * 
FROM
	(
	SELECT
		TestName
		,TestType
		,'Usr_' + TestType AS UsrTestType
		,ActFlg
		,UsrID
	FROM
		#PivotDemo 
	) src
	PIVOT
	(
	MIN(ActFlg)
	FOR TestType IN(Type01,Type02)
	) AS pvt1		
	PIVOT
	(
	MIN(UsrID)
	FOR UsrTestType IN(Usr_Type01,Usr_Type02)
	) AS pvt2
ORDER BY
	TestName ASC
;
*/




/*	Two Field Pivot

	This is why you need to stop using astriks in your queries.
	Need to include the test name in a GROUP BY.
	
	Each rule is displayed once, showing the user and the active flag (if available).
*/
/*
SELECT
	TestName
	,MIN(Type01) AS Type01
	,MIN(Usr_Type01) AS UsrType01
	,'.' AS dot
	,MIN(Type02) AS Type02
	,MIN(Usr_Type02) AS UsrType02
FROM
	(
	SELECT
		TestName
		,TestType
		,'Usr_' + TestType AS UsrTestType
		,ActFlg
		,UsrID
	FROM
		#PivotDemo 
	) src
	PIVOT
	(
	MIN(ActFlg)
	FOR TestType IN(Type01,Type02)
	) AS pvt1		
	PIVOT
	(
	MIN(UsrID)
	FOR UsrTestType IN(Usr_Type01,Usr_Type02)
	) AS pvt2
Group By 
	TestName
ORDER BY
	TestName ASC
;
*/


/*
	Three Field Pivot
*/
SELECT
	TestName
	,MIN(Type01) AS Type01
	,MIN(Usr_Type01) AS UsrType01
	,MIN(Cat_Type01) AS CatType01
	,'.' AS dot
	,MIN(Type02) AS Type02
	,MIN(Usr_Type02) AS UsrType02
	,MIN(Cat_Type02) AS CatType02
FROM
	(
	SELECT
		TestName
		,TestType
		,'Usr_' + TestType AS UsrTestType
		,'Cat_' + TestType AS CatTestType
		,ActFlg
		,UsrID
		,Category
	FROM
		#PivotDemo 
	) src

	PIVOT
	(
		MIN(ActFlg)
		FOR TestType IN(Type01,Type02)
	) AS pvt1		

	PIVOT
	(
		MIN(UsrID)
		FOR UsrTestType IN(Usr_Type01,Usr_Type02)
	) AS pvt2

	PIVOT
	(
		MIN(Category)
		FOR CatTestType IN(Cat_Type01,Cat_Type02)
	) AS pvt3

Group By 
	TestName
ORDER BY
	TestName ASC
;


/*
	Four Field Pivot
*/
SELECT
	TestName
	,MIN(Type01) AS Type01
	,MIN(Usr_Type01) AS UsrType01
	,MIN(Cat_Type01) AS CatType01
	,MIN(Upd_Type01) AS UpdType01
	,'.' AS dot
	,MIN(Type02) AS Type02
	,MIN(Usr_Type02) AS UsrType02
	,MIN(Cat_Type02) AS CatType02
	,MIN(Upd_Type02) AS UpdType02
FROM
	(
	SELECT
		TestName
		,TestType
		,'Usr_' + TestType AS UsrTestType
		,'Cat_' + TestType AS CatTestType
		,'Upd_' + TestType AS UpdTestType
		,ActFlg
		,UsrID
		,Category
		,Upd_DT
	FROM
		#PivotDemo 
	) src

	PIVOT
	(
		MIN(ActFlg)
		FOR TestType IN(Type01,Type02)
	) AS pvt1		

	PIVOT
	(
		MIN(UsrID)
		FOR UsrTestType IN(Usr_Type01,Usr_Type02)
	) AS pvt2

	PIVOT
	(
		MIN(Category)
		FOR CatTestType IN(Cat_Type01,Cat_Type02)
	) AS pvt3

	PIVOT
	(
		MIN(Upd_DT)
		FOR UpdTestType IN(Upd_Type01,Upd_Type02)
	) AS pvt4

Group By 
	TestName

ORDER BY
	TestName ASC
;
