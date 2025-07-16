* PBHS31001 Epidemiologic Methods HW3
* Date: 1/30/2024 
* By: Alexandra Chang 
*==============================================================================*

*******************************Data Exploration*********************************

*Analyze the effects of maternal age, race and education on risk of preterm birth: gestational age <37 weeks.

*Effect Variables using:
//maternal age (dmage)
//maternal education (dmeduc)
//maternal race (mrace)

*Outcome Variable using:
//gestational age (dgestat)

*Examine distribution of each variable along with missing variables.
summarize dmage
tab dmage, missing

summarize dmeduc
tab dmeduc, missing
// dmeduc = 99, not stated: count as missing when re-organizing into categorial.

summarize mrace
tab mrace, missing

summarize dgestat
tab dgestat, missing

//no missing observations, 40,274 observations total for each variable.

**************Categorical Variables from Continuous Variables*******************

*
*Modify "maternal age" from a cont. variable into cat. variable.

recode dmage (min/15=0 "< 15 yrs old") (15/25=1 "15-25 yrs old") (25/35=2 "25-35 yrs old") (35/45=3 "35-45 yrs old") (45/max=4 "45-55 yrs old") , gen(dmageCat)

rename dmageCat Maternal_Age

//Tabulate to check. (There are no missing values.)
tab Maternal_Age

*
*Repeat same steps for maternal education.

//First, specify dmeduc = 99 as missing.
gen miss_dmeduc = dmeduc >=99
tab miss_dmeduc
//Table shows that there are 39,694 data and 580 missing data.

//Showing there are 580 missing education data.
//When we categorize, need to specifiy these as missing.
gen dmeducCat =.
replace dmeducCat=1 if dmeduc<=00
replace dmeducCat=2 if dmeduc>=1 & dmeduc<=8 
replace dmeducCat=3 if dmeduc>=9 & dmeduc<=12 
replace dmeducCat=4 if dmeduc>=13 & dmeduc<=17 
replace dmeducCat=5 if dmeduc>=99 & dmeduc!=.

*Create a clear table legend and footnotes to describe nature of variables.

rename dmeducCat Maternal_Education
label var Maternal_Education "1=No education, 2=Elementary, 3=Highschool, 4=College, 5=Not stated"

//Tabulate to check.
tab Maternal_Education

*
*Repeat same steps for maternal race.

//Race needs 14 categories.
recode mrace (1=0 "White") (2=1 "Black")  (3=2 "American Indian") (4=3 "Chinese") (5=4 "Japanese") (6=5 "Hawaiian") (7=6 "Filipino") (18=7 "Asian Indian") (28=8 "Korean") (38=9 "Samoan") (48=10 "Vietnamese") (58=11 "Guamanian") (68=12 "Other Asian/Pacific Islander") (78=13 "Combined Asian/Pacific Islander"), gen(mraceCat)

rename mraceCat Maternal_Race

//Tabulate to check.
tab Maternal_Race

*
*Repeat same steps for effect variable: gestational age, but specifiy missing values.

//First, specify dmeduc = 99 as missing.
gen miss_dgestat = dgestat >=99

rename miss_dgestat Gestational_Age
label var Gestational_Age "0=Complete gestation, 1=Missing gestation"


tab Gestational_Age
//Table shows that there are 39,861 data and 413 missing data.

//Showing there are 413 missing education data.
//When we categorize, need to specifiy these as missing.

******************************Hypothesis Testing********************************

*Chi-square tests: compares frequency distributions of categorical variables.

tab Maternal_Age Gestational_Age, chi
tab Maternal_Education Gestational_Age, chi
tab Maternal_Race Gestational_Age, chi

//Stata a P-value of 0.000 is actually <0.0005.
//So we report P<0.001 with statistical significance across all 3 variables to gestational age.

*******************************Table Contruction********************************

*Install "table1" package from the Statistical Software Components (SSC):
ssc install table1

*Create Table 1 that compares those with and without missing gestational age in terms of the other 3 variables.

*Create a clear table legend and footnotes to describe nature of variables.
label var Maternal_Race Maternal_Race
label var Maternal_Age Maternal_Age
label var Maternal_Education Maternal_Education
label var Maternal_Education "Maternal_Age: 1=No education, 2=Elementary, 3=Highschool, 4=College, 5=Not stated"

//Stratify by Gestational_Age as primary exposure.
table1, by(Gestational_Age) vars(Maternal_Age cat\ Maternal_Education cat\ Maternal_Race cat) format(%2.1f) missing

//THE END// 




