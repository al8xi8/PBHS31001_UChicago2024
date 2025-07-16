* PBHS31001 Epidemiologic Methods HW6
* Date: 2/20/2024 
* By: Alexandra Chang 
*==============================================================================*

***************************Variable Construction********************************

*****Outcome Variable

//Step 1. Examine distribution of each observation along with missing variables.
tab dgestat, missing
//Step 2. Dichotomous variable describing yes/no of preterm using 37 weeks as cut-off.
gen  dgestatCat=1 if dgestat<37 & dgestat~=.
replace  dgestatCat=0 if dgestat>=37 & dgestat~=.
replace  dgestatCat=. if dgestat==99
label variable dgestatCat "Preterm Birth"
label define yesno 0 no 1 yes
label values dgestatCat yesno
drop if dgestatCat==.
//Step 3. Tabulate to check the new variable, "dgestatCat".
tab  dgestatCat

*****Predictor Variables

*Step 1. Race
//From natality data description: White (1); Black or African American (2); Asian/Pacific Islander (4, 5, 6, 7, 18, 28, 38, 48, 58, 68, 78); American Indian/Alaska Native (3).
tab mrace
recode mrace (1=1 "White") (2=2 "Black")  (4 5 6 7 18 28 38 48 58 68 78=3 "Asian/Pacific Islander") (3=4 "Am. Indian/Alaska Native"), gen(mraceCat) 
label variable mraceCat "Maternal Racial Category"
tab mraceCat 
//Dichotomous variable describing White/Black only.
gen mraceCatt=1 if mraceCat==2
replace mraceCatt=0 if mraceCat==1
recode mraceCatt (0 = 0 "White") (1 = 1 "Black"), gen(mraceCat1)
label variable mraceCat1 "White vs Black"
tab mraceCat1

//Dichotomous variable describing Hispanic/Non-Hispanic only.
tab ormoth
recode ormoth (0=0 "NonHispanic") (1 2 3 4 5 = 1 "Hispanic"), gen(ormothCat)
drop if ormothCat == 9 
label variable ormothCat "Maternal Ethinicy"
tab ormothCat

*Step 2. Age, from "dmage"
//keep age as continuous variable.
tab dmage
//Recode age as categorical variable.
*<20; 20-24 (reference category); 25-29; 30-34; 35+ (advanced maternal age).
recode dmage (min/19=1 "<20") (20/24=2 "20-24") (25/29=3 "25-29") (30/34=4 "30-34") (35/max=5 "35+"), gen(dmageCat) 
label var dmageCat "Maternal Age Category"
tab dmageCat
//Additional age categorical variable as 3 categories.
recode dmage (min/19=1 "<20") (20/34=2 "20-34") (35/max=5 "35+"), gen(dmageCat3) 
label var dmageCat3 "Maternal Age: 3 Categories"
tab dmageCat3

*Step 3. Education, from "dmeduc"
tab dmeduc
recode dmeduc (min/11=1 "<12 yrs") (12=2 "12 yrs") (13/15=3 "13-15 yrs") (16/17=4 "16+ yrs") (99=5 "missing"), gen(dmeducCat) 
drop if dmeducCat==5
label variable dmeducCat "Maternal Education Category"
tab dmeducCat
//Education as 3 categories.

*Step 4. Tobacco Use, from "tobacco"
tab tobacco
drop if tobacco==9
recode tobacco (1=1 "yes") (2=2 "no"), gen(tobaccoCat)
tab tobaccoCat

*Step 5. Alcohol Use, from "alcohol"
tab alcohol
drop if alcohol==9
recode alcohol (1=1 "yes") (2=2 "no"), gen(alcoholCat)
tab alcoholCat

***************************Variable Analysis************************************

*****Race/Ethinicy on Preterm Birth, controlling for Age and Education.
*Exploratory analysis to choose the best Age variable.
tabodds dgestatCat dmageCat, graph
//Continuous
logistic dgestatCat dmage, nolog
est store dmage
//Ordinal
logistic dgestatCat dmageCat, nolog
est store dmageCat
//Categorical, using ""20-24" as reference category.
logistic dgestatCat ib2.dmageCat, nolog
est store idmageCat
//Estimate stats of AIC and BIC to compare.
estimate stats dmage dmageCat idmageCat

*Repeat same steps for Education from "dmeduc".
tabodds dgestatCat dmeducCat, graph
//Continuous
logistic dgestatCat dmeduc, nolog
est store dmeduc
//Ordinal
logistic dgestatCat dmeducCat, nolog
est store dmeducCat
//Categorical
logistic dgestatCat i.dmeducCat, nolog
est store idmeducCat
//Estimate stats of AIC and BIC to compare.
estimate stats dmeduc dmeducCat idmeducCat

*Logistic Regression of age, race, ethinicity, education on preterm birth.
logistic dgestatCat ib2.dmageCat mraceCat ormothCat dmeducCat, nolog

*****Interaction between Age and Race on Preterm Birth.
//Controlling for education and Hispanic ethnicity
logistic dgestatCat ib2.dmageCat3##i.mraceCat1 dmeducCat ormothCat, nolog

*****Effect of Alcohol use on odds of Preterm Birth.
//Bivariate analysis, yielding a crude estimate but run using logistic regression.
logistic dgestatCat i.alcoholCat, nolog
//Checking alcohol being confounded by maternal age/race/ethinicity/education.
logistic dgestatCat i.alcoholCat ib2.dmageCat i.mraceCat ormothCat dmeducCat , nolog
//Checking alcohol being effect modified by advanced/teenage maternal age or race (black/white only)
logistic dgestatCat i.alcoholCat##ib2.dmageCat3, nolog
logistic dgestatCat i.alcoholCat##i.mraceCat1, nolog

//THE END///














