* PBHS31001 Epidemiologic Methods HW1 
* Date: 1/15/2024 
* By: Alexandra Chang 
*==============================================================================*

*******************************Data Exploration*********************************

*List the data so you can see what they look like and how they are organized

//There are seven lines of data – one for each age group.
//There are 11 variables in each line of data.
//One age group has 5 periods and 5 denominators.

list

*********************Creating/Modifying variables(columns)**********************

*Calculate incidence rates for each time period within each age group

//Use the corresponding numerator and denominator variables.
generate Inc1 = period1/den1
generate Inc2 = period2/den2
generate Inc3 = period3/den3
generate Inc4 = period4/den4
generate Inc5 = period5/den5

//Now have 16 variables on each line of data. 
list

label variable period1 "1935-1944"

label variable period2 "1945-1954"

label variable period3 "1955-1964"

label variable period4 "1965-1974"

label variable period5 "1975-1984"

label variable Inc1 "Incidence rate 1935-1944"

label variable Inc2 "Incidence rate 1945-1954"

label variable Inc3 "Incidence rate 1955-1964"

label variable Inc4 "Incidence rate 1965-1974"

label variable Inc5 "Incidence rate 1975-1984"

***********************************Reshape**************************************

*Arrange dataset in long format

//Long format data: only one numerator and denominator on each line.
reshape long period den, i(age) j(decade)

//Each of the current lines of data would turn into five lines
//Each with FOUR variables: age group, time period, numerator, denominator.
list

*Arrage dataset in wide format

//Wide format data: repeated observations at different times for each subject.
reshape wide period den, i(age) j(decade)
list

*********************************Analyze****************************************

*Age Effect
//Analyzed by comparing (incidence rates) within different age groups at a particular point in time.

*Birth Cohort Effect Graph
//Analyzed by tracking (incidence rates) changes within a specific cohort as they age.

list age Inc1 Inc2 Inc3 Inc4 Inc5, sep (7)



