SELECT DISTINCT ID_Num = IDENTITY(int, 1, 1),
 
  cast (  am.person_pk  as varchar (30)) 
as  Affiliate_ID, cast('' as varchar(45)) as Full_Name,
            CAST( left(ltrim( REPLACE(REPLACE(REPLACE(LTRIM(isnull(P.first_nm,'')), '-', ''), '''', ''), ',', '')),25) AS [varchar](25)) AS First_Name
          , CAST((CASE WHEN middle_nm IS NULL THEN '' ELSE left(ltrim(middle_nm),25) END)  as varchar(25)) as Middle_Name
	 , CAST( left(ltrim(REPLACE(REPLACE(REPLACE(LTRIM(isnull(P.last_nm,'')), '-', ''), '''', ''), ',', '')),25)  AS [varchar](25)) AS Last_Name,
	  cast(  case when p.suffix_nm=35001 then 'Sr'
                               when p.suffix_nm=35002 then 'Jr'    
                               when p.suffix_nm=35003  then ' III' 
                              when p.suffix_nm=35004  then 'IV' 
                               when p.suffix_nm=35005 then 'II' 
                              when p.suffix_nm=35006 then 'Esq' 
                          else '' end as varchar(10)) as Name_Suffix,
	  cast(left(ltrim(isnull(PA.addr1,'')),40)  as char(40)) as Address_Line1,
      cast(left(ltrim(isnull(PA.addr2,'')),40)  as char(40)) as Address_Line2,
   cast('' as varchar(40)) as City_State_ZIP,
	  cast( (case when PA.city is null then '' else  left(ltrim(PA.city),25) end ) as varchar(25)) as City,
	CAST( LEFT( isnull(LTRIM(pa.state),''),2)  AS VARCHAR(2)) as State,
	 cast( (case when PA.zipcode is null then '' else  LEFT(LTRIM(PA.zipcode),5) end ) as char(5)) as ZIP,
	-- cast(( case when PA.zip_plus is null then '' else  PA.zip_plus end ) as char(4))as zip_plus,
 CAST(ao.aff_localSubChapter  AS VARCHAR(8)) AS Local,
	 CASE WHEN MBR_TYPE=29001 then 'A' else 'R' END as Member_Status
,CAST(REPLACE(CAST(ISNULL(convert( varchar(10),pd.dob ,101),  '') AS VARCHAR(10)),'/','') AS VARCHAR(8)) AS DOB  ,
	--'A' AS MEMBER_STATUS,
	 CAST(CASE WHEN PD.GENDER=33001 THEN 'M'
	      WHEN PD.GENDER=33002 THEN 'F'
	       ELSE ''  END AS VARCHAR(1)) AS Gender, CAST('' AS VARCHAR(20)) AS Home_Phone, CAST('' AS VARCHAR(20)) AS Cell_Phone,
		   CAST('' AS VARCHAR(40)) AS email,
	-- CAST(left([OPERATIONS].[dbo].[f_Get_Person_Phone](P.person_pk,3001,null),20)  AS VARCHAR(20)) AS Home_Phone,
	--  CAST( left([OPERATIONS].[dbo].[f_Get_Person_Phone](P.person_pk,3003, null ),20) AS VARCHAR(20)) AS Cell_Phone,

--Email=CAST(LEFT([OPERATIONS].[dbo].[f_Get_Person_Email] (P.person_pk,null  ,null),40) AS VARCHAR(40)) ,
  CAST('' AS VARCHAR(1)) AS Race,
District_or_Region=cast(isnull(aff_councilRetiree_chap  ,'') as varchar(30)) -- (   SELECT   LEFT(com_cd_desc ,30) FROM COMMON_CODES WHERE COM_CD_PK =ao.aff_afscme_region  )    
,Sector= (SELECT LEFT(com_cd_desc,30) FROM afscme_oltp4..COMMON_CODES WHERE COM_CD_PK =aes.aff_employer_sector) 
 ,cast(isnull(aff_subUnit ,'') as varchar(30)) as Sublocal
 ,cast(case when aff_type='L' THEN  left(ltrim(aff_abbreviated_nm),40) ELSE '' END  as varchar(40)) as Local_Name
, CAST('' AS VARCHAR (25)) AS Member_Class
,CAST('' AS VARCHAR (25)) AS  Craft	
, CAST(isnull( employer_name,'') AS VARCHAR(40))  AS Employer
,CAST('' AS VARCHAR (40 )) AS Work_Site

, CAST(REPLACE(CAST(convert( varchar(10),am.mbr_join_dt ,101) AS VARCHAR(10)),'/','') AS VARCHAR(8)) AS Join_Date

, CAST('' AS VARCHAR(8)) AS Renewal_Date
,CAST('' AS VARCHAR (30)) AS Affiliate_Data1
,CAST('' AS VARCHAR (30)) AS Affiliate_Data2	
,CAST('' AS VARCHAR (30)) AS Affiliate_Data3
,CAST('' AS VARCHAR (30)) AS Affiliate_Data4	
,CAST('' AS VARCHAR (30)) AS Affiliate_Data5
,CAST( '' AS VARCHAR(1))Do_Not_Call	
,CAST(CASE WHEN ISNULL(AM.no_mail_fg,0)=0 THEN '0' ELSE '1' END  AS VARCHAR(1))AS Do_Not_Mail
into    operations..cope_012420
FROM
	afscme_oltp4.dbo.Person P with (nolock)
	INNER JOIN afscme_oltp4.dbo.Aff_Members AM with (nolock)
		ON   am.person_pk = P.person_pk   
	INNER JOIN afscme_oltp4.dbo.Aff_Organizations AO with (nolock)
         ON AM.aff_pk = AO.aff_pk
left outer join afscme_oltp4.dbo.Aff_Employer_Sector  aes with (nolock)
on ao.aff_pk=aes.aff_pk
	 INNER JOIN   ( SELECT  P1.PERSON_PK,  P1.addr1, P1.addr2,P1.city, P1.state, P1.zipcode, P1.zip_plus ,P1.country
FROM  afscme_oltp4..Person_Address P1 with (nolock)   INNER JOIN afscme_oltp4..Person_SMA  SMA with (nolock)
		ON    P1.address_pk = SMA.address_pk
		WHERE SMA.current_fg = 1
  AND ISNULL(addr_bad_fg, 0) = 0 AND (P1.country IS NULL OR  P1.country =0 OR P1.country=9001) 
) PA
ON P.PERSON_PK=PA.PERSON_PK
	left outer JOIN(SELECT * FROM afscme_oltp4.dbo.Person_Demographics  with (nolock)
		WHERE   deceased_dt IS  NULL AND ISNULL( deceased_fg, 0) <> 1)PD
            ON  PD.person_pk=P.person_pk
   left outer join    afscme_oltp4.dbo.Aff_Mbr_Employers  e with (nolock) on e.person_pk=am.person_pk and e.aff_pk=am.aff_pk
    
WHERE	--PD.person_pk is null 
--aff_stateNat_type='MD' AND --aff_councilRetiree_chap='982' AND 
  p.marked_for_deletion_fg=0 and
 	AM.mbr_status = 31001 and AM.mbr_type in (29001,29002)
 ORDER BY 1
 --(1406895 rows affected)
 -----------------------------------

 select * from  operations..cope_012420 where Affiliate_ID in 
 (select Affiliate_ID--, count(*) cnt
	from  operations..cope_012420
	group by Affiliate_ID
	having count(*)>1 ) order by Affiliate_ID
--------------------
 --(1397513 row(s) affected)
--(1398841 row(s) affected)
/*

delete from #temp2 where person_pk=12884938 and zipcode='92509'
SELECT * FROM Person_address P INNER JOIN PERSON_SMA SMA
ON P.PERSON_PK=SMA.PERSON_PK
 WHERE P.Person_pk= 12884938 AND CURRENT_FG=1

*/
--(1417899 row(s) affected)
 
----------------------------------------------
  update t
set  Do_Not_Call	=case when no_phone_calls_fg=1 then '1' else '0' end
from operations..cope_012420 t left outer join  afscme_oltp4.dbo.Person_Communication_Preferences p
on t.Affiliate_ID=person_fk
------------------------------
  update t
set  Do_Not_Mail	=case when no_mail_fg =1 then '1' else '0' end
from operations..cope_012420 t inner join  afscme_oltp4.dbo.Person_Communication_Preferences p
on t.Affiliate_ID=person_fk
----------------------------------
select distinct  Do_Not_Mail	 from #temp1
select distinct Do_Not_Call	 from #temp1

----------------------------------------------------------------------
  update t
set home_Phone =ltrim(rtrim(replace(home_Phone ,'-','')))

             , cell_Phone  =ltrim(rtrim(replace( cell_Phone ,'-','')))
 
--select person_pk, home_Phone_Number,replace(home_Phone_Number,'-','')

             --, cell_Phone_Number,replace( cell_Phone_Number,'-','')
--, Work_Phone,replace (Work_Phone,'-','')
from  operations..cope_012420 t
--where isnull(home_Phone_Number,'')<>''
---------------------------
    update t
set home_Phone =ltrim(rtrim(replace(replace(replace(replace(home_Phone ,'(&cell)',''),'ext.',''),'x',''),' ','')))

             , cell_Phone =ltrim(rtrim(replace(replace(replace( replace(cell_Phone ,'(&cell)',''),'ext.',''),'x',''),' ','')))
 
--select person_pk, home_Phone_Number,replace(home_Phone_Number,'-','')
--7329281200 ext.267
--7327680887 (&cell)
             --, cell_Phone_Number,replace( cell_Phone_Number,'-','')
--, Work_Phone,replace (Work_Phone,'-','')
from  operations..cope_012420 t
--where isnull(home_Phone_Number,'')<>''
-------------------------------
   update t
set home_Phone =ltrim(rtrim(replace(replace(replace(replace(replace(replace(replace(replace(home_Phone ,'+',''),'\', ''),'''',''), 'et.',''),'Helledr',''),'q',''),'`',''),' ','')))
 
             , cell_Phone =ltrim(rtrim(replace(replace(replace( replace(cell_Phone ,'(&cell)',''),'ext.',''),'x',''),' ','')))
 --select person_pk, home_Phone_Number,replace(home_Phone_Number,'-','')
 from  operations..cope_012420 t
--------------------------------------
    update t
set home_Phone =ltrim(rtrim(replace(replace(replace(replace(replace(replace(replace(replace(home_Phone ,'+',''),'/', ''),'''',''), 'O','0'),'Helledr',''),'*',''),'=',''),' ','')))

             , cell_Phone  =ltrim(rtrim(replace(replace(replace( replace(cell_Phone ,'(&cell)',''),'ext.',''),'x',''),' ','')))
 
from  operations..cope_012420 t
---------------------------------
 

select * from #temp1 where
isnumeric(home_Phone )=0 and isnull(home_Phone ,'')<>''
-----------------------------------------------
    update t
set home_Phone =ltrim(rtrim(replace(replace(REPLACE(REPLACE(replace(home_Phone  ,'*' ,''),  '/',''),'=',''), 'X',''),' ',''))) 

             , cell_Phone   =ltrim(rtrim(replace(replace(REPLACE(REPLACE(replace ( cell_Phone ,'*' ,''),  '/',''),'=',''), 'X',''),' ',''))) 
 
 from operations..cope_012420 t
-------------------------
UPDATE T
SET T.home_Phone =''
 FROM operations..cope_012420 t WHERE isnumeric(home_Phone )=0 and isnull(home_Phone ,'')<>''
--------------------------------------
UPDATE T
SET-- T.WORK_Phone=''
   T.CELL_Phone =ltrim(rtrim(replace(replace(replace( replace( T.CELL_Phone ,'*',''),'+',''),'e',''),' ','')))

--select * 
from operations..cope_012420 T where
isnumeric( T.CELL_Phone )=0 and isnull( T.CELL_Phone ,'')<>''


UPDATE T
SET  T.CELL_Phone =--''
ltrim(rtrim(replace(replace(replace( replace( T.CELL_Phone ,'*',''),'i',''),'e',''),' ','')))--select * 
from operations..cope_012420 T where
isnumeric(CELL_Phone )=0 and isnull(CELL_Phone ,'')<>''
------------------------------------------
UPDATE T
SET  T.CELL_Phone =--''
ltrim(rtrim(replace(replace(replace( replace( T.CELL_Phone ,'?',''),'i',''),'e',''),' ','')))--select * 
from operations..cope_012420 T where
isnumeric(CELL_Phone )=0 and isnull(CELL_Phone ,'')<>''
---------------------------------
 
---------------------------
 
 
 
------------------------------------------
UPDATE T
SET  T.cell_Phone   =left(t.cell_Phone ,10)
  --WORK_Phone =ltrim(rtrim(replace(replace(replace( replace(WORK_Phone,'/',''),'t',''),'T',''),' ','')))

--select * 
from operations..cope_012420 T where
isnumeric(cell_Phone )=0 and isnull(cell_Phone  ,'')<>''

-----------------------------
UPDATE T
SET  T.cell_Phone   =''
  --WORK_Phone =ltrim(rtrim(replace(replace(replace( replace(WORK_Phone,'/',''),'t',''),'T',''),' ','')))

--select * 
from operations..cope_012420 T where
isnumeric(cell_Phone  )=0 and isnull(cell_Phone ,'')<>''

--drop table #temp2
-----------------------
select t.* into #temp2 from operations..cope_012420 t where t.id_num=(select min(t2.id_num) from operations..cope_012420 t2 where t.Affiliate_ID=t2.Affiliate_ID)

--(1402991 rows affected)
 --1387928 rows affected)
update t
set t.sector=''
from #temp2 t where sector  is   null
---------------------------------
update p
set Home_Phone =CAST(left([OPERATIONS].[dbo].[f_Get_Person_Phone](P.Affiliate_ID,3001,null),20)  AS VARCHAR(20))   
, Cell_Phone= CAST( left([OPERATIONS].[dbo].[f_Get_Person_Phone](P.Affiliate_ID,3003, null ),20) AS VARCHAR(20))  ,
 Email=CAST(LEFT([OPERATIONS].[dbo].[f_Get_Person_Email] (P.Affiliate_ID,null  ,null),40) AS VARCHAR(40)) 
from #temp2 p

--select distinct a.local, a.sublocal,a.district_or_region,
--b.local, b.district_or_region, b.local_name

update a 
set a.local_name =b.local_name 
 from
 #temp2    a
inner join ( select   * from #temp2 where local_name <>'' and sublocal='') b
on b.local=a.local and  b.district_or_region= a.district_or_region
where   a.local_name =''

-----------------------------------
alter table #temp2 
drop column id_num
(1382656 rows affected)

--(1382656 rows affected)


---(1393841 rows affected)
--(1373353 rows affected)

select * from #temp2
--(1387928 rows affected)

----(1382021 rows affected)  2020-03-23T16:11:15.3614978-04:00
--(1383021 rows affected) 08/04/2020

--(1367503 rows affected)
--(1372541 row(s) affected) --01/10/18
 --(1398841 row(s) affected)
--(1436221 row(s) affected)
--(1435749 row(s) affected)--08112015
--(1421287 row(s) affected)--11/15/16
--(1403504 row(s) affected)--7/26/17
--(1378116 row(s) affected)--10/30/17
--Member_Status	
--A	1205808
--R	197696


select Member_Status, count(*) count
from #TEMP2 
group by 
 Member_Status

A	1197805
R	190123



(1382021 rows affected)


Completion time: 2020-03-23T16:11:15.3614978-04:00

/*
 exec sp_Generate_COPE_file
A	1209376
R	224773
---------------
A	1211609
R	224140

---------------
03/15/2016
A	1195833
R	227522
--------------------------
Member_Status	
A	1212133
R	224088
--
-------------
09/09/16
Member_Status	
A	1209125
R	204725

(2 row(s) affected)
---------------
11/15/16
A	1218069
R	203218


update a
set a.Reg_Ret='Reg'

--select   count(distinct a.INTL_KEY)
from OPERATIONS..COPE_MASTER_TABLE a inner join
afscme_oltp4.dbo.Aff_Members AM
 ON   am.person_pk = a.INTL_KEY 
INNER JOIN afscme_oltp4.dbo.Aff_Organizations AO 
         ON AM.aff_pk = AO.aff_pk
where AM.mbr_type =29001 and a.INTL_GN1=AO.aff_councilRetiree_chap
 and 
a.INTL_GN2=ao.aff_localSubChapter 
-- and not exists(select * from OPERATIONS..COPE_MASTER_TABLE a1 inner join
 --afscme_oltp4.dbo.Aff_Members AM1
-- ON   am1.person_pk = a1.INTL_KEY 
-- where AM1.mbr_type =29001 and a1.INTL_KEY=a.INTL_KEY)
 --group by  AM.mbr_type

select reg_ret, count(*)
from OPERATIONS..COPE_MASTER_TABLE
group by 
reg_ret
select top 100* from OPERATIONS..[COPE_MASTER_TABLE]
Reg       	1193093
Ret       	224652
----------------
file layout
SELECT	  c.[name]
		, C.[length]
		, [Start]= 1+ ISNULL((SELECT SUM(length) FROM syscolumns WHERE [id]=858538192 and colid <  C.colid), 0)
		, [End]  = (SELECT SUM(length) FROM syscolumns WHERE [id]=858538192 and colid <= C.colid)
FROM	sysobjects T
		INNER JOIN syscolumns C
			ON C.[id]=T.[ID]
WHERE	t.[name] = 'COPE_MASTER_TABLE'
order by colid

*/
created tab delimited text file (pc, unicode)
file saved in \\mbrftp.afscme.org\aflcope\Upload_from_AFSCME\
'AFSCME_20151203.txt' =1,434,315 row(s) 
for Active Regular+Retirees
selected ONLY ONE record per person.
excluded foreign and bad addresses

here is statistics:
Member_Status	
A	1213904
R	220411