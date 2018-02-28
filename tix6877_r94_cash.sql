select * from afscme_oltp4..aff_organizations where  aff_councilRetiree_chap=94 and AFF_TYPE NOT IN ('C','L','U')
 -- aff_pk	parent_aff_fk	aff_type	aff_localSubChapter	aff_stateNat_type	aff_subUnit	aff_councilRetiree_chap
6878	14429	R		RI		94
  ------------------------------------------------------------
  alter table [dbo].[tix6848_r31_Retiree_dues] add id_va int identity(1,1)





SELECT DISTINCT AM.person_pk, mbr_status, ao.aff_councilRetiree_chap,Ao.aff_LOCalsubchapter, ao.aff_pk,
 mbr_type=(SELECT com_cd_desc FROM afscme_oltp4.dbo.COMMON_CODES WHERE COM_CD_PK=am.mbr_type) 
, P.last_nm, P.first_nm,P.middle_nm, P.suffix_nm, P.ssn, smA.addr1,smA.addr2,smA.city, smA.state, smA.zipcode, smA.zip_plus  
   , case when   AM.mbr_dues_type=42004 and AM.mbr_dues_frequency  =41004 then 'ded' when AM.mbr_dues_type=42004 and AM.mbr_dues_frequency  in (41007,41008) then 'dp'
   else '' end as dues
INTO      #r94_mbrs								-- DROP TABLE #active_mbrs
FROM afscme_oltp4.dbo.Aff_Members AM WITH (NOLOCK)			-- 3472
INNER JOIN afscme_oltp4.dbo.Person P WITH (NOLOCK)			-- 3472
	ON AM.person_pk = P.person_pk  
	  inner join(select *  from afscme_oltp4..aff_organizations where  aff_councilRetiree_chap=94 and AFF_TYPE NOT IN ('C','L','U')
)
ao on am.aff_pk=ao.aff_pk    
left outer JOIN  ( select pa.* from afscme_oltp4..Person_SMA SMA1
		       INNER JOIN  afscme_oltp4..Person_Address PA
		ON  PA.address_pk = SMA1.address_pk
		AND SMA1.current_fg = 1
) sma
ON  SMA.person_pk = P.person_pk
		  --AND ISNULL(addr_bad_fg, 0) = 0
   
left outer JOIN(SELECT * FROM afscme_oltp4.dbo.Person_Demographics  
		 WHERE   deceased_dt IS NOT NULL OR ISNULL( deceased_fg, 0) = 1
)PD
            ON  PD.person_pk=P.person_pk
     

WHERE	 PD.person_pk is null  and p.marked_for_deletion_fg=0

 --AND	mbr_status = 31001							-- Active
	--AND mbr_type IN (29001,29002)				-- Regular Retiree 
--	(47214 rows affected)	
select distinct aff_councilRetiree_chap, dues, count(*) from    #r94_mbrs	 
where mbr_status = 31001 group by aff_councilRetiree_chap,dues
order by 1,2
 --select 2167+139
 SELECT * FROM   operations.[dbo].[tix6877_R94_cashpaying_text]
 ALTER TABLE  operations.[dbo].[tix6877_R94_cashpaying_text]  ADD person_pk int
  
  select * from operations.[dbo].[tix6877_R94_cashpaying_text] where person_pk is null and address1=''

 

update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6877_R94_cashpaying_text]  t
inner join  #r94_mbrs	 	 p
on upper([last name])=upper(last_nm) 
and upper(isnull(t.[First Name] ,''))=upper(isnull(p.first_nm,''))
where
  t.person_pk is null
  and  
  left(ltrim(isnull([Address 1],'')), 5)=left(ltrim(isnull(addr1,'')), 5)
 and isnull( [Zip Code],'')=isnull(zipcode,'')

 --and isnull(replace([Phone ],'-',''),'')=isnull(replace(home_phone_number,'-',''),'')

update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on upper(last_name)=upper(last_nm) 
and upper(isnull(t.[First_Name] ,''))=upper(isnull(p.first_nm,''))
where
  t.person_pk is null
 and isnull(zip,'')=isnull(zipcode,'')
 and isnull(replace([Phone ],'-',''),'')=isnull(replace(home_phone_number,'-',''),'')

 --------------------

 update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on  upper(last_name)=upper(last_nm) 
and  left(upper(isnull(t.[First_Name] ,'')),3)=left(upper(isnull(p.first_nm,'')),3)
where
  t.person_pk is null
 and isnull(t.email,'')=isnull(p.email,'')
 and isnull(t.email,'')<>''
 ------------------------------

 update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on -- upper(last_name)=upper(last_nm) 
  left(upper(isnull(t.[First_Name] ,'')),5)=left(upper(isnull(p.first_nm,'')),5)
where
  t.person_pk is null
 and isnull(t.email,'')=isnull(p.email,'')
 and isnull(t.email,'')<>''




 update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on upper(last_name)=upper(last_nm) 
and upper(isnull(t.[First_Name] ,''))=upper(isnull(p.first_nm,''))
where
  t.person_pk is null
  and  
  left(ltrim(isnull([Address 2],'')), 5)=left(ltrim(isnull(addr1,'')), 5)
 and isnull(zip,'')=isnull(zipcode,'')

 -----------------
  update t
set t.person_pk=p.person_pk
 --select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on upper(last_name)=upper(last_nm) 
and upper(isnull(t.[First_Name] ,''))=upper(isnull(p.first_nm,''))
where
  t.person_pk is null and address1=''
  and p.person_pk not in ( )

  order by 2,1



 update t
set t.person_pk=p.person_pk
--select distinct *
from operations.[dbo].[tix6848_r31_Retiree_dues]   t
inner join  #r31_mbrs	 	 p
on left(upper(last_name),5)=left(upper(last_nm) ,5)
and left(upper(isnull(t.[First_Name] ,'')),1)=left(upper(isnull(p.first_nm,'')),1)
where
  t.person_pk is null
  and isnull(zip,'')=isnull(zipcode,'')
  -------------------------------------------

  --------------------
 use afscme_oltp4

select distinct 'update am set  AM.mbr_dues_type=42004, AM.mbr_dues_frequency=41007 , lst_mod_user_pk = 11949451, lst_mod_dt =''02/23/2018'' FROM afscme_oltp4..AFF_MEMBERS AM where am.Aff_pk=6878  and AM.mbr_type=29002  and am.person_pk='+cast(t.person_pk as varchar)
from  operations.[dbo].[tix6877_R94_cashpaying_text]    t where t.person_pk is not null--=12226160
-- is not null
 
 



  use afscme_oltp4

update am

set  AM.mbr_dues_type=42004
, AM.mbr_dues_frequency= 41004
 
, lst_mod_user_pk = 11949451, lst_mod_dt = '02/23/2018'
--SELECT *
FROM afscme_oltp4..AFF_MEMBERS AM 
WHERE Am.aff_pk=6878	 AND AM.mbr_status=31001 and AM.mbr_type=29002  
 -----------------------------------------------