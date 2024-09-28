-- distributing codes to each sector 

drop table if exists sba_description_codes
select *
into sba_description_codes
from 


(
	SELECT [naics_industry_description], iif( naics_industry_description like '%–%' , substring([naics_industry_description], 8 ,2) ,'')as codes,
	iif( naics_industry_description like '%–%' , ltrim(substring([naics_industry_description],
CHARINDEX('–', [naics_industry_description]), LEN([naics_industry_description]))), '') as industry_sector

  FROM [project files].[dbo].[sba_industry_standards]
  where naics_codes = ''
  ) twoo

  where
  industry_sector != '';

