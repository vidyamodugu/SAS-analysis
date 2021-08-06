proc sql;
create table p.contribution as
select area_name,(Totaltaxes/916488050*100) as contribution
from p.tax_2015
order by contribution ;
quit;
proc sql;
create table max_population 
 (area_name char, maxpopulation num format=20.);
 quit;

proc sql;
insert into max_population
select area_name, max(distinct(census_2015)) as maxpopulation format=20.
from p.usa_population
having census_2015 = max(census_2015)

;

quit;

proc sql;
create table p.p_max 
(area_name char,year num, property_max num format=20.);

quit;

proc sql;
insert into p.p_max 
select area_name, year,(max(property_percentage)) as property_max format=20.
from p.percentage
having property_percentage = max(property_percentage)
;

quit;
