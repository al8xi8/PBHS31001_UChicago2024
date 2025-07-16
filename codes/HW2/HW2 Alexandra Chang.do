* PBHS31001 Epidemiologic Methods HW2
* Date: 1/23/2024 
* By: Alexandra Chang 
*==============================================================================*

*******************************Data Exploration*********************************

*List the first 10 data to see what they look like and how they are organized.
//This is a "LONG" data file with separate record for each 3 periods.

//Long format data: only one numerator and denominator on each line.
list in 1/10

***********************************Reshape**************************************

*Arrange dataset in "WIDE" format

reshape wide sex totchol age sysbp diabp cursmoke cigpday bmi diabetes bpmeds heartrte glucose educ prevchd prevap prevmi prevstrk prevhyp time hdlc ldlc death angina hospmi mi_fchd anychd stroke cvd hyperten timeap timemi timemifc timechd timestrk timecvd timedth timehyp, i(randid) j(period)

//Wide format data: repeated observations at different times for each subject.
list in 1/10

//Long format data: only one numerator and denominator on each line.

*Arrange dataset back to "LONG" format
reshape long sex totchol age sysbp diabp cursmoke cigpday bmi diabetes bpmeds heartrte glucose educ prevchd prevap prevmi prevstrk prevhyp time hdlc ldlc death angina hospmi mi_fchd anychd stroke cvd hyperten timeap timemi timemifc timechd timestrk timecvd timedth timehyp, i(randid) j(period)

**************Categorical Variables from Continuous Variables*******************

*Modify BMI from a cont. variable into cat. variable.
//Generate BMI categories based on period 1.
recode bmi (min/18.5=0 "underweight") (18.5/25=1 "normal") (25/30=2 "overweight") (30/max=3 "obese") , gen(bmiCat)

//Tabulate to check.
tab bmiCat, missing

//Tabulate to check bmi categories by period 1 according to study question.
tab bmiCat if period==1, missing

//Cross-tabulate BMI categories and mortality.
tab bmiCat death if period==1, missing

*Repeat same steps for total cholesterol levels as we did to BMI.
 recode totchol (min/200=0 "Desirable") (200/max=1 "Undesirable") , gen(totcholCat)
 tab totcholCat if period==1, missing
 
*Create a clear table legend and footnotes to describe nature of variables.
label var death "0=No death during followup, 1=Death during followup"
tab death if period==1
label var diabetes "0=Not diabetic, 1=Diabetic"
tab diabetes if period==1
 
//Tabulate one variable stratified by another variable: what is the death outcome by BMI category?
//Restrict to tabulation of period 1 only.
bysort bmiCat: tab death if period==1

*******************************Table Contruction********************************

*Install "table1" package from the Statistical Software Components (SSC):
ssc install table1

*Create Table 1 for prospective cohort study for participants in period 1.

//Stratify by bmiCat for cohort as primary exposure.
table1 if period==1, by(bmiCat) vars(death cat\ totchol contn\ totcholCat cat\ hyperten contn\ sysbp contn\ diabp contn\ diabetes cat) format(%2.1f) missing
 
//THE END// 





