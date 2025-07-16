* PBHS31001 Epidemiologic Methods HW4
* Date: 2/6/2024 
* By: Alexandra Chang 
*==============================================================================*

**************Categorical Variables from Continuous Variables*******************

*
*Modify "bmi" from a cont. variable into cat. variable.
//Generate BMI categories based on period 1.
recode bmi (min/18.5=0 "underweight") (18.5/25=1 "normal") (25/30=2 "overweight") (30/max=3 "obese") , gen(bmiCat)

//Tabulate to check.
tab bmiCat, missing

*
*Repeat same steps for "death".
//Examine distribution of each variable along with missing variables.
sum death
tab death, missing

//Cross-tabulate "bmiCat" and "death".
tab bmiCat death, missing

*******************************Table Contruction********************************

*Install "table1" package from the Statistical Software Components (SSC):
ssc install table1

*Create Table 1 for prospective cohort study for participants.

//Stratify by bmiCat for cohort as primary exposure.
table1, by(bmiCat) vars(death cat) format(%2.1f) missing

**************************1. Analyzing Cohort Study*****************************

*
*Create a table for prospective cohort study for participants for cum. incidence.
//Assuming equal or complete follow-up time for each subject.
//Using normal weight(unexposed) as reference.

csi 1358 1358 3674 3674
//Result of RR = 1: No difference in risk between the exposed and unexposed groups.

*Manually input data for underweight(exposed) vs normal weight(unexposed).
csi 68 1358 99 3674

*Repeat same steps for overweight(exposed) vs normal weight(unexposed).
csi 1511 1358 3305 3674

*Repeat same steps for obese(exposed) vs normal weight(unexposed).
csi 558 1358 1002 3674

*Double check p-values using "normal" as reference group.
//Specify "normal" as reference group by adding "b1" in regression command.
regress death ib1.bmiCat

*******************************Survival Analysis********************************

*
*Create a table for prospective cohort study for participants for incidence rate.
//Using normal weight(unexposed) as reference.

//Assuming 'death' is the death indicator, 'bmiCat' is the categorical variable, and 'timedth' is the survival time variable.

*Define Survival-Time Data.
stset timedth, failure(death)

*Calculate Person-Time.
//Use stsum to calculate person-time
//Summarize survival times stratified by 'bmiCat' to obtain incidence rate.
stsum, by(bmiCat)
//Determine person-time for each category by using "ir" command.
ir death bmiCat timedth if bmiCat==0
ir death bmiCat timedth if bmiCat==1
ir death bmiCat timedth if bmiCat==2
ir death bmiCat timedth if bmiCat==3

*Manually input data for underweight(exposed) vs normal weight(unexposed).
iri 68 1358 1258925 4.00e+07 
 
*Repeat same steps for overweight(exposed) vs normal weight(unexposed).
iri 1511 1358 3.78e+07 4.00e+07 

*Repeat same steps for obese(exposed) vs normal weight(unexposed).
iri 558 1358 1.20e+07 4.00e+07

**********************2. Stratified Analysis for Confounding********************

*Recategorize bmi to exclude underweight and overweight.
recode bmi (18.5/25=0 "normal") (30/max=1 "obese") , gen(bmiCatt)

*Possible 3 Confounders: age, sex, cursmoke
//Recategorize age: 
recode age (min/39=0 "30's") (39/49=1 "40's") (49/59=2 "50's") (59/max=3 "60 plus") , gen(ageCat)

*Individual stratified analysis for each 3 variables.
//ageCat:
cs death bmiCatt if bmiCatt==0 | bmiCatt==1, by(ageCat)
//sex:
cs death bmiCatt if bmiCatt==0 | bmiCatt==1, by(sex)
//cursmoke:
cs death bmiCatt if bmiCatt==0 | bmiCatt==1, by(cursmoke)

*Combined stratified analysis for all 3 variables.
cs death bmiCatt if bmiCatt==0 | bmiCatt==1, by(ageCat sex cursmoke)

//THE END//


