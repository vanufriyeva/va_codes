/*
Please create a list of everyone who contributes to PEOPLE in 2017 who are a part of CSEA 1000.
Include:
AFSCME ID (Person PK)
CSEA ID
Last Name
First Name
Method of Payment--afscme_contributions type
Total Amount in 2017

1.  Make sure the column headers are exactly as I have stated above.
2.  Do not include ANY other information

select distinct [ctbn_afscme_type] from [dbo].[PAC_Contributor_Affiliation]
select * from common_codes where com_cd_pk in (82291, 82287,82331)
Raffles, Pass Hat, etc
Sales
Fundraiser

select * from common_codes where com_cd_pk in (82285,82286,82287)
AFSCMEType
This is a critical request
*/

select distinct p.person_pk, sum(ctbn_amt) sum_12m  
into #temp2017  from 
 afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
inner join 	afscme_oltp4..Person P with (nolock )   on c.person_pk=p.person_pk
where  p.marked_for_deletion_fg=0 
 and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018') group by p.person_pk

 --------------------------------

 SELECT 	DISTINCT  ID_Num = IDENTITY(int, 1, 1),  AO.aff_stateNat_Type AS AFF_State
		
	 , cast(AO.aff_councilRetiree_Chap as int) AS Council
   , AO.aff_type As Type
	,  cast(AO.aff_localSubChapter as int)AS [local],
             ao.aff_subUnit, AM.AFF_PK,  
   t.person_pk, p.last_nm, p.first_nm, 

sum_12m as [Total Amount in 2017] 
,mbrtype=(select isnull( C.com_cd_desc,'') from common_codes c where c.com_cd_pk=am.mbr_type)
, case when am.mbr_status=31001 then 'Active Members'
 when  am.mbr_status=31002 then 'Inactive Members'
 when  am.mbr_status=31003 then 'Temp Members' ELSE '' END AS MBR_STATUS,
ISNULL(am.mbr_no_local,'') as CSEAMbrNo
 into    #temp1
FROM
  afscme_oltp4..Aff_Members AM inner join
 
  afscme_oltp4..Aff_Organizations AO 
         ON AM.aff_pk = AO.aff_pk
	inner join  #temp2017 t
on t.person_pk =am.person_pk
inner join person p on p.person_pk=t.person_pk
  where  AO.aff_localSubChapter='1000'  and AO.aff_stateNat_Type='NY'
  AND ISNULL(sum_12m,0)>0 
   ORDER BY 1,2,3  
----------------------
 ALTER TABLE #TEMP1 ADD  [ctbn_afscme_type] INT, [Method of Payment] VARCHAR(50)

 
 SELECT 	DISTINCT  ID_Num = IDENTITY(int, 1, 1),  AO.aff_stateNat_Type AS AFF_State
		
	 , cast(AO.aff_councilRetiree_Chap as int) AS Council
   , AO.aff_type As Type
	,  cast(AO.aff_localSubChapter as int)AS [local],
             ao.aff_subUnit, AM.AFF_PK,  
   t.person_pk, p.last_nm, p.first_nm, 

sum_12m as [Total Amount in 2017] 
,mbrtype=(select isnull( C.com_cd_desc,'') from common_codes c where c.com_cd_pk=am.mbr_type)
, case when am.mbr_status=31001 then 'Active Members'
 when  am.mbr_status=31002 then 'Inactive Members'
 when  am.mbr_status=31003 then 'Temp Members' ELSE '' END AS MBR_STATUS,
ISNULL(am.mbr_no_local,'') as CSEAMbrNo
 into    #temp2
FROM
  afscme_oltp4..Aff_Members AM inner join
 
  afscme_oltp4..Aff_Organizations AO 
         ON AM.aff_pk = AO.aff_pk
	inner join  #temp2017 t
on t.person_pk =am.person_pk
inner join person p on p.person_pk=t.person_pk
  where  AO.aff_councilRetiree_Chap='1000'  and AO.aff_stateNat_Type='NY'
  AND ISNULL(sum_12m,0)>0 
   ORDER BY 1,2,3  
   --------------------------------------
    ALTER TABLE #TEMP2 ADD  [ctbn_afscme_type] INT, [Method of Payment] VARCHAR(50)


 ---------------
 UPDATE T
 SET T.[ctbn_afscme_type]=A.[ctbn_afscme_type]
 --SELECT * 
 FROM #TEMP1 T INNER JOIN [dbo].[PAC_Contributor_Affiliation] A
 ON T.PERSON_PK=A.PERSON_PK WHERE --ISNULL([ctbr_status],0)=82276
 T.[ctbn_afscme_type] IS NULL
 AND T.AFF_PK=A.AFF_PK

 SELECT * FROM #TEMP1 WHERE [ctbn_afscme_type] IS NULL
 --11337
 SELECT COUNT(DISTINCT PERSON_PK) FROM #TEMP1
 -------------------------------------------
  UPDATE T
 SET T.[ctbn_afscme_type]=A.[ctbn_afscme_type]
 --SELECT * 
 FROM #TEMP2 T INNER JOIN [dbo].[PAC_Contributor_Affiliation] A
 ON T.PERSON_PK=A.PERSON_PK WHERE --ISNULL([ctbr_status],0)=82276
-T.[ctbn_afscme_type] IS NULL
 --AND T.AFF_PK=A.AFF_PK
 SELECT * FROM PAC_CONTRIBUTIONS WHERE PERSON_PK=10063524 ORDER BY pay_period_dt DESC

   UPDATE T
 SET T.[ctbn_afscme_type]=A.[ctbn_afscme_type]
 --SELECT * 
 FROM #TEMP2 T INNER JOIN [dbo].[PAC_ContributIONS] A
 ON T.PERSON_PK=A.PERSON_PK WHERE --ISNULL([ctbr_status],0)=82276
-T.[ctbn_afscme_type] IS NULL

 SELECT * FROM #TEMP2 WHERE [ctbn_afscme_type] IS NULL
 --11337
 SELECT COUNT(DISTINCT PERSON_PK) FROM #TEMP1
 --3658
  SELECT COUNT(DISTINCT PERSON_PK) FROM #TEMP2





 UPDATE T
 SET [Method of Payment]=isnull( C.com_cd_desc,'')
  from #TEMP1  T INNER JOIN common_codes c ON c.com_cd_pk=T.[ctbn_afscme_type]
  -------------------------------------
 DELETE T
  --SELECT T.* 
  FROM #TEMP1 T 
WHERE T.PERSON_PK IN
 ( SELECT PERSON_PK FROM #TEMP1 GROUP BY PERSON_PK
  HAVING COUNT(*)>1)
 AND  MBR_STATUS= 'Inactive Members' AND
  EXISTS (SELECT A.* FROM #TEMP1 A WHERE A.PERSON_PK=T.PERSON_PK
  AND MBR_STATUS<> 'Inactive Members')
 -----------------------

 UPDATE T
 SET [Method of Payment]=isnull( C.com_cd_desc,'')
  from #TEMP2 T INNER JOIN common_codes c ON c.com_cd_pk=T.[ctbn_afscme_type]


  DELETE T
  --SELECT T.* 
  FROM #TEMP2 T 
WHERE T.PERSON_PK IN
 ( SELECT PERSON_PK FROM #TEMP2 GROUP BY PERSON_PK
  HAVING COUNT(*)>1)
 AND  MBR_STATUS= 'Inactive Members' AND
  EXISTS (SELECT A.* FROM #temp2 A WHERE A.PERSON_PK=T.PERSON_PK
  AND MBR_STATUS<> 'Inactive Members')


 SELECT T.* 
  FROM #TEMP2 T 
WHERE T.PERSON_PK IN
 ( SELECT PERSON_PK FROM #TEMP2 GROUP BY PERSON_PK
  HAVING COUNT(*)>1)
  ORDER BY T.PERSON_PK
  ------------------------------
  --(11337 rows affected)
  SELECT distinct ID_Num  , AFF_State, Council,     Type, local, aff_subUnit, AFF_PK  ,person_pk ,
    last_nm  ,first_nm   , [Total Amount in 2017]  ,mbrtype ,
  MBR_STATUS, CSEAMbrNo , [Method of Payment]
  into #temp_l100
  FROM #TEMP1 T
  WHERE T.ID_Num  =(SELECT MIN(T1.ID_Num ) FROM #TEMP1 T1 WHERE t.person_pk=t1.person_pk)
  ------------------------------
  --3658
  SELECT distinct ID_Num  , AFF_State, Council,     Type, local, aff_subUnit, AFF_PK  ,person_pk ,
    last_nm  ,first_nm   , [Total Amount in 2017]  ,mbrtype ,
  MBR_STATUS, CSEAMbrNo , [Method of Payment]
  into #temp_r1000
  FROM #TEMP2 T
  WHERE T.ID_Num  =(SELECT MIN(T1.ID_Num ) FROM #TEMP2 T1 WHERE t.person_pk=t1.person_pk)
  ------------------------
  select * 
  --delete a 
  from  #temp_l100 a inner join #temp_r1000 b
  on a.person_pk=b.person_pk where b.MBR_STATUS='Inactive Members'

  --------------------------------------
  select AFF_State, Council,     Type, local, aff_subUnit, AFF_PK  ,person_pk ,
    last_nm  ,first_nm   , [Total Amount in 2017]  ,mbrtype ,
  MBR_STATUS, CSEAMbrNo , [Method of Payment]
  from #temp_l100
  union
select AFF_State, Council,     Type, local, aff_subUnit, AFF_PK  ,person_pk ,
    last_nm  ,first_nm   , [Total Amount in 2017]  ,mbrtype ,
  MBR_STATUS, CSEAMbrNo , [Method of Payment]
  from #temp_r1000 