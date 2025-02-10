//Rohan Avuthu



cd "/Users/rohanavuthu/Desktop/econ120rohanavuthu"

use Uganda_baseline,clear

//Part 1 
// Question 1
	gen savings_account = sa1
	replace savings_account=0 if savings_account==2
	tab sa1 savings_account
	
	
	gen female_head=0 if bi13==2
	replace female_head=1 if bi13==1 | bi13==3 | bi13==4

	gen female_literacy=fh4
	replace female_literacy=0 if female_literacy==2

	gen male_literacy=mh4
	replace male_literacy=0 if male_literacy==2

	reg savings_account female_literacy
	reg savings_account female_head
	reg savings_account male_literacy
// Question 2
	gen borrowed = 0
	replace borrowed = 1 if cr21 == 1 | cr22 == 1 | cr23 == 1
	tab borrowed
	reg borrowed female_literacy
	reg borrowed female_head
	reg borrowed male_literacy

// Question 3
gen cashround_part = mr0
	replace cashround_part=1 if cashround_part>=1 & !missing(cashround_part)
	tab mr0 cashround_part, m
	
gen female = (bi7 == 2)
reg cashround_part female hh1 hh2 hh3 hh4 hh6 hh7 hh8 hh10 
// only regressing the variables with pvalue less than 0.05 (statistically significant)
reg cashround_part female hh4 hh8

// Question 4
replace cr5c=0 if cr5c==2
	reg cr5c female_literacy male_literacy
	
// Question 5
regress cr5c hh4 hh5 hh6 hh8 hh10



// PART 2
// Question 1
use Uganda_baseline, clear				// baseline
	merge 1:1 hhid using Uganda_treatment_assignment // treat assign
	tab _m
	
	keep if _m==3
	drop _m
	
	merge 1:1 hhid using Uganda_bankinfo 	// bank data
	tab _m
	gen in_bankdata=1 if _m==2 | _m==3
	replace in_bankdata=0 if _m==1
	drop _m
	
	merge 1:1 hhid using Uganda_followup 	// follow up
	tab _m
	gen in_followup=1 if _m==2 | _m==3
	replace in_followup=0 if _m==1

	*we should now drop the ineligible households;
	drop if ineligible_hh==1

// Question 2

	
	gen attrited = 1 - in_followup
	tab attrited

	tab attrited treatment
	
// regression 
regress attrited treatment

// Question 3
replace sa_acct = 0 if sa_acct == 2
replace sa_acct = 1 if sa_acct == 1
tab sa_acct
regress sa_acct treatment

// Question 4
tab sa_reasons, sort
	
	tab sa_reasons if treatment==1 , sort
	tab sa_reasons if treatment==0 , sort
	
gen sa_r6 = 1 if sa_reasons == 6
	replace sa_r6 = 0 if sa_reasons != 6
	replace sa_r6 =. if sa_reasons == .
	
	reg sa_r6 treatment

	
// Question 5
replace num_transactions_real=0 if tookup_account==0 & treatment==1
	sum num_transactions_real , de
	tab num_transactions_real, m
	
// Question 6
gen active_users = 1 if num_transactions_real >= 2 & num_transactions_real !=.
replace active_users = 0 if num_transactions_real <= 1 & num_transactions_real !=.
	replace active_users = 0 if tookup_account == 0
	tab active_users if treatment == 1
	
// Question 7 
// rerun the generation of female_literacy, male_literacy, and cashround_part
regress tookup_account female_literacy male_literacy cashround_part hh1 hh2 hh3 hh4 hh6 hh7 hh8 hh10 














