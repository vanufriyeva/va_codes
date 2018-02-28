963	3528	A

SELECT DISTINCT aff_localSubChapter, aff_subUnit INTO #TEMP1 FROM Aff_Organizations
 WHERE aff_councilRetiree_chap=963 AND aff_stateNat_type='NJ'
 AND   aff_status NOT IN (select com_cd_pk from dbo.common_codes WITH(NOLOCK) where com_cd_type_key = 'AffiliateStatus' and com_cd_desc IN ('Merged', 'Deactivated', 'Decertified'))
 AND aff_localSubChapter <>''


SELECT DISTINCT [localsubchapter],[sublocalnumber]
INTO #TEMP3
FROM OPERATIONS.[dbo].[TIX6968_UW_NJ963_ENT_TRAN_20180223] A
WHERE[sublocalnumber]<>'' AND  NOT EXISTS (SELECT T.* FROM #TEMP1 T
WHERE A.[localsubchapter]=T.aff_localSubChapter AND A.[sublocalnumber]=T.aff_subUnit)
---------------------------------

SELECT DISTINCT [localsubchapter] 
 FROM OPERATIONS.[dbo].[TIX6968_UW_NJ963_ENT_TRAN_20180223] A
WHERE[sublocalnumber]<>'' AND [localsubchapter]  NOT IN (SELECT T.aff_localSubChapter FROM #TEMP1 T
 )

------------------------
SELECT DISTINCT * FROM #TEMP3 T INNER JOIN #TEMP1 ON [localsubchapter]=aff_localSubChapter