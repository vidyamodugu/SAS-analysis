proc options option=rsasuser;
run;


libname sasuser "/folders/myfolders/university";


 
Filename univ2016 "/folders/myfolders/university/Fall_census_2017.XLS.xlsx" ;
Filename univ2017 "/folders/myfolders/university/Fall_census_2017.XLS.xlsx" ;

/*Create new variable enrolled(Enrolled_IND='Y' and Enrolled_IND='Y') for 2016*/
proc sql;
   title 'Enrollment dataset with numeric variables';
   CREATE TABLE sasuser.Enrolled_UG2016 AS
   select univ2016.*,
          case 
             when ENROLLED_IND="Y" and REGISTERED_IND ='Y' then 1
             else 0
          end as Enrolled
      from sasuser.univ2016;

quit;

/*Create new variable enrolled(Enrolled_IND='Y' and Enrolled_IND='Y') for 2017*/
proc sql;
   
   title 'Enrollment dataset with numeric variables';
   CREATE TABLE sasuser.Enrolled_UG2017 AS
   select univ2017.*,
          case 
             when ENROLLED_IND="Y" and REGISTERED_IND ='Y' then 1
             else 0
          end as Enrolled
      from sasuser.univ2017;

quit;

/*creating state variable for 2016 enrollment data*/

proc sql;
Create Table  sasuser.region_UG2016 AS
select Enrolled_UG2016.*,
   case 
       when length(admit_residence)>3 then Trim(substr(admit_residence,1,length(admit_residence)-3))
       else substr(admit_residence,1,3)
       end as state
       from sasuser.Enrolled_UG2016;
       quit;
       
Proc sql;
create table sasuser.instate_outstate As
select region_UG2016.*,
   case 
       when state="TX" then "in state"
       else "out state/international"
       end as instate_outstate
       from sasuser.region_UG2016;
       quit;
 
 
 proc sql;
   CREATE TABLE sasuser.dummy_UG2016 AS
   select instate_outstate.*,
          case 
             when instate_outstate ='in state' then 1
             else 0
          end as dummy_region
      from sasuser.instate_outstate ;

/*creating state variable for 2017 enrollment data*/
proc sql;
Create Table  sasuser.region_UG2017 AS
select Enrolled_UG2017.*,
   case 
       when length(admit_residence)>3 then Trim(substr(admit_residence,1,length(admit_residence)-3))
       else substr(admit_residence,1,3)
       end as state
       from sasuser.Enrolled_UG2017;
       quit;
       


/*create region and dummy variable for 2017*/

Proc sql;
create table sasuser.instate_outstate17 As
select region_UG2017.*,
   case 
       when state="TX" then "in state"
       else "out state/international"
       end as instate_outstate
       from sasuser.region_UG2017;
       quit;
 

proc sql;
   CREATE TABLE sasuser.dummy_UG2017 AS
   select instate_outstate17.*,
          case 
             when instate_outstate ='in state' then 1
             else 0
          end as dummy_region
      from sasuser.instate_outstate17 ;

quit;

/*enrolled undergraduates in state and out state for 2016*/ 

proc sql;
create table SASUSER.UG_region_2016 as
   select 'in state:' as region, 
          sum(Enrolled) as UG_region2016 Label="REG2016"
      from sasuser.dummy_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and dummy_region=1
        
   union
   select 'out-state:',
          sum(Enrolled) 
      from sasuser.dummy_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and dummy_region=0;
      
quit;


/*enrolled undergraduates in state and out state for 2017*/ 

proc sql;
create table SASUSER.UG_region_2017 as
   select 'in state:' as region, 
          sum(Enrolled) as UG_region2017 Label="REG2017"
      from sasuser.dummy_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(Enrolled) 
      from sasuser.dummy_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and dummy_region=0;
      
quit;

/* merging 2016 and 2017 region datasets results for in state and out state*/

proc sql;
  Create  table sasuser.region1617 as
    select a.region,UG_region2016,UG_region2017
       from SASUSER.UG_region_2016 as a, SASUSER.UG_region_2017 as b
       where a.region = b.region
       order by region;

/* Calculating PERCENTAGE CHANGE ENROLLMENT by region*/
proc sql;
     create table sasuser.UGPercentage_Change_of_region  as
    select *, ((UG_region2017 - UG_region2016) /100) as UG_Enrollemnt_change
	from sasuser.region1617;



/*enrolled undergraduates credit hours in state and out state for 2016*/ 
proc sql;
create table SASUSER.UGcredithours2016 as
   select 'in state:' as region,
          sum(TOT_REG_HOURS) as UGStudentCreditHours2016 "SCR2016"
      from sasuser.dummy_UG2016
      where LEVEL = 'UG' and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(TOT_REG_HOURS) 
      from sasuser.dummy_UG2016
      where LEVEL = 'UG' and dummy_region=0;

/*enrolled undergraduates credit hours in state and out state for 2017*/ 
proc sql;
create table SASUSER.UGcredithours2017 as
   select 'in state:' as region,
          sum(TOT_REG_HOURS) as UGStudentCreditHours2017 "SCR2017"
      from sasuser.dummy_UG2017
      where LEVEL = 'UG' and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(TOT_REG_HOURS) 
      from sasuser.dummy_UG2017
      where LEVEL = 'UG' and dummy_region=0;
      
/*merging instate and outstate student credithours by region for 2016 and 2017*/
 proc sql ;
  Create  table sasuser.UG_credithoursregion1617 as
    select a.region,a.UGStudentCreditHours2016,b.UGStudentCreditHours2017
       from SASUSER.UGcredithours2016 as a, SASUSER.UGcredithours2017 as b
       where a.region = b.region
       order by region;

/*Percentage change in credit hours by region for 2016 and 17 */
proc sql;
     create table sasuser.UG_Percentage_CRchange  as
    select *, ((UGStudentCreditHours2017 - UGStudentCreditHours2016) /100) as UG_Credithours_change
	from sasuser.UG_credithoursregion1617;
     
     
 


/*enrolled undergraduates FTE in state and out state for 2016*/ 

proc sql;
create table sasuser.UGFullTimeequivalents2016 as
   select 'in state:' as region,
          count(FTE) as UG_FTE2016
      from sasuser.dummy_UG2016
      where (FTE=1) and (LEVEL = 'UG') and dummy_region=1
        
      
   union
   select 'out-state:',
          count(FTE) 
      from sasuser.dummy_UG2016
      where (FTE=1) and (LEVEL = 'UG') and dummy_region=0;

/*enrolled graduates credit hours in state and out state for 2017*/

proc sql;
Create table SASUSER.UGFullTimeequivalents2017 as
   select 'in state:' as region,
           count(FTE)as UG_FTE2017
      from sasuser.dummy_UG2017
     where (FTE=1) and (LEVEL = 'UG') and dummy_region=1
      
   union
   select 'out-state:',
          count(FTE)
      from sasuser.dummy_UG2017
      where (FTE=1) and (LEVEL = 'UG') and dummy_region=0;
      
proc sql;
  Create  table sasuser.UGFullTimeEqua1617 as 
    select a.region, a.UG_FTE2016,b.UG_FTE2017
       from SASUSER.UGFullTimeequivalents2016 as a, SASUSER.UGFullTimeequivalents2017 as b
       where a.region = b.region
       order by region;


proc sql;
    Create  table sasuser.UGPercentage_change_fulltimes as 
    select *, ((UG_FTE2017 - UG_FTE2016)/100) as UG_FTE_change
	from sasuser.UGFullTimeEqua1617;











/*graduates*/


/*enrolled graduates in state and out state for 2016*/ 

proc sql;
create table SASUSER.GR_region_2016 as
   select 'in state:' as region, 
          sum(Enrolled) as GR_region2016 Label="REG2016"
      from sasuser.dummy_UG2016
      where (Enrolled = 1) and (LEVEL = 'GR') and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(Enrolled) 
      from sasuser.dummy_UG2016
      where (Enrolled = 1) and (LEVEL = 'GR') and dummy_region=0;
      
quit;


/*enrolled graduates in state and out state for 2017*/ 


proc sql;
create table SASUSER.GR_region_2017 as
   select 'in state:' as region, 
          sum(Enrolled) as GR_region2017 Label="REG2017"
      from sasuser.dummy_UG2017
      where (Enrolled = 1) and (LEVEL = 'GR') and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(Enrolled) 
      from sasuser.dummy_UG2017
      where (Enrolled = 1) and (LEVEL = 'GR') and dummy_region=0;
      
quit;

proc sql;
  Create  table sasuser.region1617 as
    select a.region,GR_region2016,GR_region2017
       from SASUSER.GR_region_2016 as a, SASUSER.GR_region_2017 as b
       where a.region = b.region
       order by region;


proc sql;
     create table sasuser.GR_Percentage_Change_region  as
    select *, ((GR_region2017 - GR_region2016) /100) as GR_Enrollment_change
	from sasuser.region1617;
	

   
   
   


/*enrolled graduates credit hours in state and out state for 2016*/ 
proc sql;
create table SASUSER.GRcredithours2016 as
   select 'in state:' as region,
          sum(TOT_REG_HOURS) as GRStudentCreditHours2016 "SCR2016"
      from sasuser.dummy_UG2016
      where LEVEL = 'GR' and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(TOT_REG_HOURS) 
      from sasuser.dummy_UG2016
      where LEVEL = 'GR' and dummy_region=0;




/*enrolled graduates credit hours in state and out state for 2017*/
proc sql;
create table SASUSER.GRcredithours2017 as
   select 'in state:' as region,
          sum(TOT_REG_HOURS) as GRStudentCreditHours2017 "SCR2017"
      from sasuser.dummy_UG2017
      where LEVEL = 'GR' and dummy_region=1
        
      
   union
   select 'out-state:',
          sum(TOT_REG_HOURS) 
      from sasuser.dummy_UG2017
      where LEVEL = 'GR' and dummy_region=0;
      

 proc sql;
  Create  table sasuser.GR_credithoursregion1617 as
    select a.region,a.GRStudentCreditHours2016,b.GRStudentCreditHours2017
       from SASUSER.GRcredithours2016 as a, SASUSER.GRcredithours2017 as b
       where a.region = b.region
       order by region;


proc sql;
     create table sasuser.GR_Percentagecredithours_region  as
    select *, ((GRStudentCreditHours2017 - GRStudentCreditHours2016) /100) as GR_credithours_change
	from sasuser.GR_credithoursregion1617;




	
/*enrolled undergraduates FTE in state and out state for 2016 by enrollment status*/ 

proc sql;
create table sasuser.GRFullTimeequivalents2016 as
   select 'in state:' as region,
          count(FTE) as GR_FTE2016
      from sasuser.dummy_UG2016
      where (FTE=1) and (LEVEL = "GR") and dummy_region=1
        
      
   union
   select 'out-state:',
          count(FTE) 
      from sasuser.dummy_UG2016
      where (FTE=1) and (LEVEL = 'GR') and dummy_region=0;
   
/*enrolled graduates credit hours in state and out state for 2017 by enrollment status*/

proc sql;
Create table SASUSER.GRFullTimeequivalents2017 as
   select 'in state:' as region,
           count(FTE)as GR_FTE2017
      from sasuser.dummy_UG2017
     where (FTE=1) and (LEVEL = 'GR') and dummy_region=1
      
   union
   select 'out-state:',
          count(FTE)
      from sasuser.dummy_UG2017
      where (FTE=1) and (LEVEL = 'GR') and dummy_region=0;
      
proc sql;
  Create  table sasuser.GRFullTimeEqua1617 as 
    select a.region, a.GR_FTE2016,b.GR_FTE2017
       from SASUSER.GRFullTimeequivalents2016 as a, SASUSER.GRFullTimeequivalents2017 as b
       where a.region = b.region
       order by region;


proc sql;
    Create  table GRPercentage_change_fulltimes as 
    select *, ((GR_FTE2017 - GR_FTE2016)/100) as GR_FTE_change
	from sasuser.GRFullTimeEqua1617;
	
	
    



/*Creating table by merging the above results for undergraduates*/

proc sql;
    Create  table sasuser.Enrollment_by_Residency as 
    select a.region,a.UG_region2016,a.UG_region2017,a.UG_Enrollemnt_change,
           b.UGStudentCreditHours2016,b.UGStudentCreditHours2017,b.UG_Credithours_change
       from sasuser.UGPercentage_Change_of_region as a,sasuser.UG_Percentage_CRchange as b
       where a.region = b.region
       order by region;
       
       
proc sql;
    Create  table sasuser.UGEnrollment_By_Residency as 
    select a.region,a.UG_region2016,a.UG_region2017,a.UG_Enrollemnt_change,
           a.UGStudentCreditHours2016,a.UGStudentCreditHours2017,a.UG_Credithours_change,
           b.UG_FTE2016,b.UG_FTE2017,b.UG_FTE_change
       from sasuser.Enrollment_by_Residency as a,sasuser.UGPercentage_change_fulltimes as b
       where a.region = b.region
       order by region;	
	
   
 /*Creating table by merging the above results for undergraduates*/

proc sql;
    Create  table sasuser.Enrollment_By_Residency as 
    select a.region,a.GR_region2016,a.GR_region2017,a.GR_Enrollment_change,
           b.GRStudentCreditHours2016,b.GRStudentCreditHours2017,b.GR_credithours_change
       from sasuser.GR_Percentage_Change_region as a,sasuser.GR_Percentagecredithours_region as b
       where a.Region = b.Region
       order by Region;
 quit;      
       
proc sql;
    Create  table sasuser.GREnrollment_By_Residency as 
    select a.region,a.GR_region2016,a.GR_region2017,a.GR_Enrollment_change,
           a.GRStudentCreditHours2016,a.GRStudentCreditHours2017,a.GR_credithours_change,
           b.GR_FTE2016,b.GR_FTE2017,b.GR_FTE_change
       from  sasuser.Enrollment_By_Residency as a,sasuser.GRPercentage_change_fulltimes  as b
       where a.region = b.region
       order by region;
      