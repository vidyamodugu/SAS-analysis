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




/*Calculating Undergraduates enrolled for 2016 for enrollment type by student*/

proc sql;
create table SASUSER.UGEnrollmenttype2016 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(Enrolled) as UG_Enrollment2016 Label="ENR2016"
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="New First Time"
        
      
   union
   select 'Continuing:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Continuing"
      
   union
   select 'Special_non_degree_seeking:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
      
   union
   select 'Re_Admitted:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016 
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Returning from leave";
      


/*Calculating Undergraduates enrolled for 2016 for enrollment type by student*/   
proc sql;
Create table SASUSER.UGEnrollmenttype2017 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(Enrolled) as UG_Enrollment2017 Label="ENR2017"
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="New First Time"
        
      
   union
   select 'Continuing:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Continuing"
      
   union
   select 'Special_non_degree_seeking:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
      
   union
   select 'Re_Admitted:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Returning from leave";
      

      
proc sql;
  Create  table sasuser.enrollment1617 as
    select a.Enrolment, UG_Enrollment2016,UG_Enrollment2017
       from SASUSER.UGEnrollmenttype2016 as a, SASUSER.UGEnrollmenttype2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;


proc sql;
     create table sasuser.Percentage_Change_of_enrollment  as
    select *, ((UG_Enrollment2017 - UG_Enrollment2016)/100) as UGEnrollment_change
	from sasuser.enrollment1617;







/*Calculating Undergraduates full credit hours for 2016 for enrollment type by student*/
proc sql;
create table SASUSER.UGcredithours2016 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(TOT_REG_HOURS) as UGStudentCreditHours2016 "SCR2016"
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="New First Time"
        
      
   union
   select 'Continuing:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Continuing"
      
   union
   select 'Special_non_degree_seeking:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
      
   union
   select 'Re_Admitted:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          sum(TOT_REG_HOURS)
      from sasuser.Enrolled_UG2016
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Returning from leave";
      

      
proc sql;
Create table SASUSER.UGcredithours2017 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(TOT_REG_HOURS) as UGStudentCreditHours2017 "SCR2017"
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="New First Time"
        
      
   union
   select 'Continuing:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Continuing"
      
   union
   select 'Special_non_degree_seeking:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
      
   union
   select 'Re_Admitted:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'UG' and STUDENT_TYPE_DESC ="Returning from leave";
      

      
proc sql;
  Create  table sasuser.UGcredithours1617 as 
    select a.Enrolment,UGStudentCreditHours2016,UGStudentCreditHours2017
       from SASUSER.UGcredithours2016 as a, SASUSER.UGcredithours2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;


proc sql;
    create table sasuser.UGPercentage_Change_credit_hours as
    select *, ((UGStudentCreditHours2017 - UGStudentCreditHours2016/100) as UGcredithours_change
	from sasuser.UGcredithours1617;
   
   


/*full time equivalents*/
   
proc sql;
create table sasuser.UGFullTimeequivalents2016 as
   select 'First_Time_Graduate:' as Enrolment,
          count(FTE) as UG_FTE2016
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="New First Time"
        
      
   union
   select 'Continuing:',
          count(FTE) 
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Continuing"
   union
   select 'Special_non_degree_seeking:',
          count(FTE) 
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
   union
   select 'Re_Admitted:',
          count(FTE)  
      from sasuser.Enrolled_UG2016
     where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          count(FTE)  
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          count(FTE) 
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Returning from leave";

      
proc sql;
Create table SASUSER.UGFullTimeequivalents2017 as
   select 'First_Time_Graduate:' as Enrolment,
           count(FTE)as UG_FTE2017
      from sasuser.Enrolled_UG2017
     where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="New First Time"
      
   union
   select 'Continuing:',
          count(FTE)
      from sasuser.Enrolled_UG2017
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Continuing"
      
   union
   select 'Special_non_degree_seeking:',
          count(FTE)
      from sasuser.Enrolled_UG2017
     where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Special (non-degree seeking)"
      
   union
   select 'Re_Admitted:',
          count(FTE)
      from sasuser.Enrolled_UG2017
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Re-Admitted"
      
   union
   select 'Transfer:',
          count(FTE)
      from sasuser.Enrolled_UG2017
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Transfer"
      
      
   union
   select 'Returningfromleave:',
          count(FTE)
      from sasuser.Enrolled_UG2017
      where (FTE=1) and (LEVEL = 'UG') and STUDENT_TYPE_DESC ="Returning from leave";
      

  /*merging the results for creating percentage change variable*/    
proc sql;
  Create  table sasuser.UGFullTimeEqua1617 as 
    select a.Enrolment, UG_FTE2016,UG_FTE2017
       from SASUSER.UGFullTimeequivalents2016 as a, SASUSER.UGFullTimeequivalents2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;

/*creation of percentage change variable for 3016 and 2017*/
proc sql;
    Create  table UGPercentage_change_fulltimes as 
    select *, ((UG_FTE2017 - UG_FTE2016)/100) as UG_FTE_change
	from sasuser.UGFullTimeEqua1617;
   











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


/*Calculating Undergraduates enrolled for 2016 for enrollment type by student*/

proc sql;
create table SASUSER.GR_enrollment_type2016 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(Enrolled) as GR_Enrollment2016 Label="ENR2016"
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="First Time Graduate"
        
      
   union
   select 'Continuing:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2016
      where (Enrolled = 1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="Continuing";
      quit;
      
  
/*Calculating Undergraduates enrolled for 2016 for enrollment type by student*/
  proc sql;
create table SASUSER.GR_enrollment_type2017 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(Enrolled) as GR_Enrollment2017 Label="ENR2017"
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="First Time Graduate"
        
      
   union
   select 'Continuing:',
          sum(Enrolled) 
      from sasuser.Enrolled_UG2017
      where (Enrolled = 1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="Continuing";
      quit;  
      
      
proc sql;
  Create  table sasuser.GRenrollment1617 as
    select a.Enrolment, GR_Enrollment2016,GR_Enrollment2017
       from SASUSER.GR_Enrollment_type2016 as a, SASUSER.GR_Enrollment_type2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;


/*percentage change in enrollments*/
proc sql;
     create table sasuser.GR_PercentageChange_Enrollment  as
    select *, ((GR_Enrollment2017 - GR_Enrollment2016)/100) as GR_Enrollment_change
	from sasuser.GRenrollment1617;



/*Calculating Undergraduates full credit hours for 2016 for enrollment type by student*/
proc sql;
create table SASUSER.GR_Credithours2016 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(TOT_REG_HOURS) as GR_StudentCreditHours2016 "SCR2016"
      from sasuser.Enrolled_UG2016
      where LEVEL = 'GR' and STUDENT_TYPE_DESC ="First Time Graduate"
        
      
   union
   select 'Continuing:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2016
      where LEVEL = 'GR' and STUDENT_TYPE_DESC ="Continuing";
      

proc sql;
Create table SASUSER.GR_Credithours2017 as
   select 'First_Time_Graduate:' as Enrolment,
          sum(TOT_REG_HOURS) as GR_StudentCreditHours2017 "SCR2017"
      from sasuser.Enrolled_UG2017
      where LEVEL = 'GR' and STUDENT_TYPE_DESC ="First Time Graduate"
        
      
   union
   select 'Continuing:',
          sum(TOT_REG_HOURS) 
      from sasuser.Enrolled_UG2017
      where LEVEL = 'GR' and STUDENT_TYPE_DESC ="Continuing";



proc sql;
  Create  table sasuser.GRcredithours1617 as 
    select a.Enrolment,GR_StudentCreditHours2016,GR_StudentCreditHours2017
       from SASUSER.GR_credithours2016 as a, SASUSER.GR_credithours2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;


proc sql;
    create table sasuser.GR_PercentageChange_credit_hours as
    select *, ((GR_StudentCreditHours2017 - GR_StudentCreditHours2016)/100) as GR_credithours_change
	from sasuser.GRcredithours1617;



/*full time equivalents*/
   
proc sql;
create table sasuser.GR_FullTimeequivalents2016 as
   select 'First_Time_Graduate:' as Enrolment,
          count(FTE) as GR_FTE2016
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="First Time Graduate"
        
      
   union
   select 'Continuing:',
          count(FTE) 
      from sasuser.Enrolled_UG2016
      where (FTE=1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="Continuing";



proc sql;
Create table SASUSER.GR_FullTimeequivalents2017 as
   select 'First_Time_Graduate:' as Enrolment,
           count(FTE)as GR_FTE2017
      from sasuser.Enrolled_UG2017
     where (FTE=1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="First Time Graduate"
      
   union
   select 'Continuing:',
          count(FTE)
      from sasuser.Enrolled_UG2017
      where (FTE=1) and (LEVEL = 'GR') and STUDENT_TYPE_DESC ="Continuing";


proc sql;
  Create  table sasuser.GR_FullTimeEqua1617 as 
    select a.Enrolment, GR_FTE2016,GR_FTE2017
       from SASUSER.GR_FullTimeequivalents2016 as a, SASUSER.GR_FullTimeequivalents2017 as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;


proc sql;
    Create  table GR_Percentage_change_fulltimes as 
    select *, ((GR_FTE2017 - GR_FTE2016)/100) as GR_FTE_change
	from sasuser.GR_FullTimeEqua1617;
   
  
  
  
  /*Creating table by merging results of undergradutae enrollment by student type*/
proc sql;
    Create  table sasuser.Enrollment_By_Studenttype as 
    select a.Enrolment,a.UG_Enrollment2016,a.UG_Enrollment2017,a.UGEnrollment_change,
           b.UGStudentCreditHours2016,b.UGStudentCreditHours2017,b.UGcredithours_change
       from sasuser.Percentage_Change_of_enrollment as a,sasuser.UGPercentage_Change_credit_hours as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;
       
       
proc sql;
    Create  table sasuser.UGEnrollment_By_Studenttype as 
    select a.Enrolment,a.UG_Enrollment2016,a.UG_Enrollment2017,a.UGEnrollment_change,
           a.UGStudentCreditHours2016,a.UGStudentCreditHours2017,a.UGcredithours_change,
           b.UG_FTE2016,UG_FTE2017,UG_FTE_change
       from sasuser.Enrollment_By_Studenttype as a,UGPercentage_change_fulltimes as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;

  
  

 /*Creating table by merging results of gradutae enrollment by student type*/


proc sql;

    Create  table sasuser.GR_Enrollment_Studenttype as 
    select a.Enrolment,a.GR_Enrollment2016,a.GR_Enrollment2017,a.GR_Enrollment_change,
           b.GR_StudentCreditHours2016,b.GR_StudentCreditHours2017,b.GR_credithours_change
       from sasuser.GR_PercentageChange_Enrollment as a,sasuser.GR_PercentageChange_credit_hours as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;
       
       
proc sql;
    Create  table sasuser.GR_Enrollment_Studenttype as 
    select a.Enrolment,a.GR_Enrollment2016,a.GR_Enrollment2017,a.GR_Enrollment_change,
           a.GR_StudentCreditHours2016,a.GR_StudentCreditHours2017,a.GR_credithours_change,
           b.GR_FTE2016,GR_FTE2017,GR_FTE_change
       from  sasuser.GR_Enrollment_Studenttype as a,GR_Percentage_change_fulltimes as b
       where a.Enrolment = b.Enrolment
       order by Enrolment;








   




