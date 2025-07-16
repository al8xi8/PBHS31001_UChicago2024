* PBHS31001 Epidemiologic Methods HW5
* Date: 2/13/2024 
* By: Alexandra Chang 
*==============================================================================*

*******************************Data Exploration*********************************

*Inclusion Criteria:
//Subjects must have baseline data on cigarette smoking status.
//Subjects must be free of stroke at baseline.
tab cursmoke if period == 1, missing

*Exclusion Criteria: 
//Subjects with a history of stroke at baseline.
//Subjects missing data on smoking status or stroke history.
tab stroke if period == 1, missing

************************Data Set Cleaning and Preparation***********************

*Subjects that are eligible to participate: 
tab cursmoke stroke if period == 1, missing

*Setting Approprite Parameters for Eligible Participants.
//Check for timestrk=0
//Prevents error syntax for Poisson exposure variable.
list if timestrk <= 0
//Remove the zeros for exposure of timestrk.
drop if timestrk <= 0

************************Simple Poisson Regression*******************************

*Simple Poisson Regression
poisson stroke cursmoke, exposure(timestrk)nolog

//Calculate incidence rate ratio by adding "irr".
poisson stroke cursmoke, exposure(timestrk) irr

//Double Check with the "ir" command.
ir stroke cursmoke timestrk

****************************Analyzing Covariates********************************

*Covariate 1: diabetes
poisson stroke cursmoke i.diabetes, exposure(timestrk) nolog
poisson stroke cursmoke i.diabetes, exposure(timestrk) irr nolog

*Covariate 2: age
//Re-categorize age into a cat. variable.
recode age (min/39=0 "30's") (39/49=1 "40's") (49/59=2 "50's") (59/max=3 "60 plus") , gen(ageCat)
poisson stroke cursmoke i.ageCat, exposure(timestrk) nolog
poisson stroke cursmoke i.ageCat, exposure(timestrk) irr nolog

*Covariate 3: sex
poisson stroke cursmoke i.sex, exposure(timestrk) nolog
poisson stroke cursmoke i.sex, exposure(timestrk) irr nolog

************************Multivariable Poisson Regression************************

//Fitting full model
poisson stroke cursmoke i.diabetes i.ageCat i.sex, exposure(timestrk) nolog
poisson stroke cursmoke i.diabetes i.ageCat i.sex, exposure(timestrk) irr nolog

//Backward Selection, removing terms with p ≥ 0.05
stepwise, pr(.05) lockterm1: poisson stroke cursmoke i.diabetes i.ageCat i.sex

***********************Number of Cigarettes Per Day*****************************

//Re-categorize cigs per pack into smoking behavior.
gen smkbhv=.
replace smkbhv=1 if cigpday>=1 & cigpday<=2 
replace smkbhv=2 if cigpday>=3 & cigpday<=5 
replace smkbhv=3 if cigpday>5 & cigpday!=.

//Tabulate to check.
tab stroke smkbhv

//Simple Poisson Regression
poisson stroke i.smkbhv, exposure(timestrk)nolog

//Calculate incidence rate ratio by adding "irr".
poisson stroke i.smkbhv, exposure(timestrk) irr

***************************Individual to Grouped Data***************************

*Make sure all variables are grouped into categories.
poisson stroke cursmoke i.diabetes i.ageCat i.sex, exposure(timestrk) nolog
poisson stroke cursmoke i.diabetes i.ageCat i.sex, exposure(timestrk) irr nolog






