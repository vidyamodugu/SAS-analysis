proc sql;
 select Area_name, Income_percentage
  from p.percentage_taxheads
 Where Income_percentage>60
 order by Income_percentage;
 quit;
 