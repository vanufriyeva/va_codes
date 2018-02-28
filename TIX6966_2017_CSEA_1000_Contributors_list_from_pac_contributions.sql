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

select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000'


select distinct p.person_pk, ctbn_amt , [group_pk],[aff_pk], [pay_period_dt], [pay_frequency], [transaction_nbr],
ctbn_afscme_type
into #temp2017  from 
 afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
inner join 	afscme_oltp4..Person P with (nolock )   on c.person_pk=p.person_pk
where  p.marked_for_deletion_fg=0 
 --and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and c.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
				and 
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018')  
 -----------------------------
 select * from #temp2017  where isnull(aff_pk,0)=0


 select sum( ctbn_amt )
from 
 afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
inner join 	afscme_oltp4..Person P with (nolock )   on c.person_pk=p.person_pk
where  p.marked_for_deletion_fg=0 
 --and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and c.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
				and 
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018')  


 ------------------------------------------------------
 select distinct c.person_pk, ctbn_amt , [group_pk],[aff_pk], [pay_period_dt], [pay_frequency], [transaction_nbr],
ctbn_afscme_type
into #temp2017_checks 
 from 
 afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
 
where  c.person_pk is null  
 --and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and c.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
				and 
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018')  
 and  ISNULL([transaction_nbr],'')<>''
 -------------------------
  select distinct c.person_pk, ctbn_amt , [group_pk],[aff_pk], [pay_period_dt], [pay_frequency], [transaction_nbr],
ctbn_afscme_type
into #temp2017_checks 
 from 
 afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
 
where  c.person_pk is null  
 --and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and c.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
				and 
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018')  
 and  ISNULL([transaction_nbr],'')<>''
 ----------------------
 select sum( ctbn_amt) from   #temp2017 where  isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
--947709.43
 select sum( ctbn_amt) from   #temp2017 where  isnull( ctbn_afscme_type,0)   in (82291, 82287,82331)
 --1300.00
  select sum( ctbn_amt) from    #temp2017_checks WHERE ISNULL([transaction_nbr],'')<>''
  --925242.76
------------------
--923141.58
SELECT SUM([check_amt]) FROM [dbo].[PAC_Aff_Contribution_Checks] WHERE 
(ISNULL(aff_pk,0) in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
OR ISNULL([group_pk],0) in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000'))

				AND  YEAR([pay_period_dt])=2017
						AND ISNULL([Parent_transaction_nbr],'')=''
				---------------------------------------
-----------------------------------------------------
-- 
------------------
SELECT  * FROM [dbo].[PAC_Aff_Contribution_Checks] WHERE 
(ISNULL(aff_pk,0) in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
OR ISNULL([group_pk],0) in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000'))

				AND  YEAR([pay_period_dt])=2017
				AND ISNULL([Parent_transaction_nbr],'')=''
				--------------------------------------------------

select distinct sum(ctbn_amt )

 from afscme_oltp4.dbo.PAC_Contributions c  with (nolock )  
where  c.person_pk is null  
 --and   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 and c.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
				and 
 (pay_period_dt  >= '01/01/2017' and pay_period_dt< '01/01/2018')  
 and  ISNULL([transaction_nbr],'')<>''
-------------------------------------------------------------



select distinct  person_pk, SUM(ctbn_amt) CSEA_SUM_2017
 INTO #TEMP_PERSONS
FROM #temp2017   
where   isnull( ctbn_afscme_type,0) not in (82291, 82287,82331)
 GROUP BY PERSON_PK
 --having sum(ctbn_amt)>0 ---just to exclude negative or $0


 --------------------------------
 SELECT * FROM  #TEMP_PERSONS
  SELECT PERSON_PK FROM #TEMP_PERSONS
  GROUP BY PERSON_PK HAVING COUNT(*)>1
----------------------
SELECT COUNT(DISTINCT PERSON_PK) FROM #TEMP_PERSONS
 ALTER TABLE #TEMP_PERSONS ADD CSEAMbrNo VARCHAR(50),  [ctbn_afscme_type] INT, [Method of Payment] VARCHAR(50)

 
 UPDATE T
 SET CSEAMbrNo=
ISNULL(am.mbr_no_local,'') 
  
FROM #TEMP_PERSONS T INNER JOIN
  afscme_oltp4..Aff_Members AM  
on t.person_pk =am.person_pk
WHERE AM.aff_pk in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')
   --------------------------------------
   --13855
 select count (distinct person_pk)from #TEMP_PERSONS t where t.person_pk not   in (select person_pk from aff_members where mbr_status=31001)
 --negative $$
 select a.* from #temp2017 a where a.person_pk in
( select person_pk from #TEMP_PERSONS where CSEA_SUM_2017<=0) order by person_pk, pay_period_dt
--10198257
 ---------------
 UPDATE T
 SET T.[ctbn_afscme_type]=A.[ctbn_afscme_type]
 --SELECT * 
 FROM #TEMP_PERSONS T INNER JOIN [dbo].[PAC_Contributor_Affiliation] A
 ON T.PERSON_PK=A.PERSON_PK WHERE -- ISNULL([ctbr_status],0)=82276 AND 
 T.[ctbn_afscme_type] IS NULL
 AND  A.AFF_PK in (select aff_pk from aff_organizations  
				where 	aff_localSubChapter = '1000' 
				or 	aff_councilRetiree_chap = '1000')

 SELECT * FROM #TEMP_PERSONS WHERE [ctbn_afscme_type] IS NULL
 --11337
 SELECT COUNT(DISTINCT PERSON_PK) FROM #TEMP1
 -------------------------------------------
   

  select distinct  aff_stateNat_Type from aff_organizations  
				where 	aff_localSubChapter = '1000' or 	aff_councilRetiree_chap = '1000'





 UPDATE T
 SET [Method of Payment]=isnull( C.com_cd_desc,'')
  from #TEMP_PERSONS T INNER JOIN common_codes c ON c.com_cd_pk=T.[ctbn_afscme_type]
  -------------------------------------
 
 -----------------------

  
  --(11337 rows affected)
  SELECT DISTINCT T.* , P.LAST_NM, P.FIRST_NM FROM #TEMP_PERSONS T
  INNER JOIN PERSON P ON T.PERSON_PK=P.PERSON_PK 