-- inspecting data set for anomalities --
select *
from .. sba_public_data ;

-- summary of approved ppp loans

select  YEAR(DateApproved),
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data;

--- Seprating and comparing the amount of loans approve across all years 2020-2021

select YEAR(DateApproved),
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2020

group by YEAR(DateApproved)


union 

select YEAR(DateApproved),
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2021

group by YEAR(DateApproved)
;

--- originating lenders in 2020 vs 2021 

select COUNT( distinct OriginatingLender ) OriginatingLender,
		YEAR(DateApproved),
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2023

group by YEAR(DateApproved)

union 
select COUNT( distinct OriginatingLender ) OriginatingLender,
		YEAR(DateApproved),
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2021

group by YEAR(DateApproved)

-- top 50 orignating lenders by total loan count, avg loan size, total loan approved for 2020 and 2021 

select  top 15
		OriginatingLender,
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2020 -- 2020

group by OriginatingLender
order by 3 desc;

--## VS
select  top 15
		OriginatingLender,
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data

where YEAR(DateApproved) = 2021 -- 2021

group by OriginatingLender
order by 3 desc;





---Top 20 industry the recieved ppp loans in 2020 and 2021

with cte as 
(

select  top 20
		c.industry_sector,
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data p
inner join sba_description_codes c
on left( p.NAICSCode, 2)= c.codes

where YEAR(DateApproved) = 2021 -- 2021

group by c.industry_sector
--order by 3 desc
)
select industry_sector, approved_no, approved_amount,avg_loan_size, approved_amount/SUM(approved_amount) over() * 100 as percentage_of_total
from cte
group by industry_sector,approved_no,approved_amount,avg_loan_size
order by 5 desc;

-- ## VS


with cte1 as
(

select  top 20
		c.industry_sector,
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data p
inner join sba_description_codes c
on left( p.NAICSCode, 2)= c.codes

where YEAR(DateApproved) = 2020 -- 2020

group by c.industry_sector
--order by 3 desc;
)

select industry_sector, approved_no, approved_amount,avg_loan_size, cast(approved_amount/SUM(approved_amount) over() * 100 as  float (2)) percentage_of_total
from cte1
group by industry_sector,approved_no,approved_amount,avg_loan_size
order by 5 desc;


-- How Much Of Total Loan Approved Have been Fully Forgiven

select
		
		COUNT(LoanNumber) approved_no,
		sum(CurrentApprovalAmount) current_approved_amount,
		AVG(CurrentApprovalAmount) Current_avg_loan_size,
		sum(ForgivenessAmount) amount_forgiven,
		sum(ForgivenessAmount)/sum(CurrentApprovalAmount) * 100 percentage_forgiven
from .. sba_public_data 

where year(DateApproved) = 2020

-- 521779394924.949
-- 506493913588.793  
-- 97% of the approved loans in 2020 were fully forgiven 
-- ## VS

select
		
		COUNT(LoanNumber) approved_no,
		sum(CurrentApprovalAmount) current_approved_amount,
		AVG(CurrentApprovalAmount) Current_avg_loan_size,
		sum(ForgivenessAmount) amount_forgiven,
		sum(ForgivenessAmount)/sum(CurrentApprovalAmount) * 100 percentage_forgiven
from .. sba_public_data 

where year(DateApproved) = 2021

-- 270824357397.812
-- 255952433179.67
--94% of the approved loans in 2021 were fully forgiven 

--Year and month with the highest PPP loans Approved


select
		YEAR(DateApproved) year_approved,
		MONTH(DateApproved) month_approved,
		COUNT(LoanNumber) approved_no,
		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size
from .. sba_public_data p

group by
		YEAR(DateApproved),
		MONTH(DateApproved)
order by 4 desc

-- april of 2020 and january of 2021 were teh periods with the most approved loans within the data frame
--

