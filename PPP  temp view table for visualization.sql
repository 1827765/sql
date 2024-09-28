create view ppp_main as 

select
		c.industry_sector,
		YEAR(DateApproved) year_approved,
		MONTH(DateApproved) month_approved,
		OriginatingLender,
		BorrowerState,
		Race,
		Gender,
		Ethnicity,
		COUNT(LoanNumber) No_of_approved,

		sum(CurrentApprovalAmount) current_approved_amount,
		AVG(CurrentApprovalAmount) Current_avg_loan_size,
		sum(ForgivenessAmount) amount_forgiven,

		sum(InitialApprovalAmount) approved_amount,
		AVG(InitialApprovalAmount) avg_loan_size



from .. sba_public_data p
inner join sba_description_codes c
on left( p.NAICSCode, 2)= c.codes



group by c.industry_sector,
		YEAR(DateApproved),
		MONTH(DateApproved),
		OriginatingLender,
		BorrowerState,
		Race,
		Gender,
		Ethnicity