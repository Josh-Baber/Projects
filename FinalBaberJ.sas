*
Programmed by: Joshua Baber ST555-001
Programmed on: 2021-11-17
Programmed to: Final Project

Modified by: Joshua Baber
Modified on: 2021-11-29
Modified to: Final Project
;

x "cd L:\st555\data\bookdata\beveragecompanycasestudy";
  libname InputDS ".";
  filename RawData ".";

x "cd L:\st555\data";
  libname InputFmt ".";

x "cd S:\ST555\Final";
  libname Final ".";

libname Counties access "L:\st555\data\bookdata\beveragecompanycasestudy\2016Data.accdb";

proc sort data = Counties."counties"n out = Final.Counties(rename = (state = stateFIPS county = countyFIPS));
  by state county;
run;

libname Counties clear;

%let DrinksAttribs =
         stateFips length = 8    label = "State FIPS" format = BEST12.
         countyFips length = 8   label = "County FIPS" format = BEST12.
         region length = $ 8       label = "Region"     format = $8.
         productname length = $ 50 label = "Beverage Name"
         type length = $ 8       label = "Beverage Type"
         flavor length = $ 30    label = "Beverage Flavor"
         productCategory length = $ 30 label = "Beverage Category"
         productSubCategory length = $ 30 label = "Beverage Sub-Category"
         size length = $ 200     label = "Beverage Volume"
         unitSize length = 8     label = "Beverage Quantity" format = BEST12.
         container length = $ 6  label = "Beverage Container"
         date length = 8         label = "Sale Date"  format = DATE9.
         unitssold length = 8    label = "Units Sold" format = COMMA7.
    ;

%let AllAttribs =
         stateName length = $ 50   label = "State Name" format = $50.
         stateFips length = 8    label = "State FIPS" format = BEST12.
         countyName length = $ 50  label = "County Name" format = $50.
         countyFips length = 8   label = "County FIPS" format = BEST12.
         region length = $ 8       label = "Region"     format = $8.
         popestimate2016 length = 8 label = "Estimated Population in 2016" format = COMMA10.
         popestimate2017 length = 8 label = "Estimated Population in 2017" format = COMMA10.
         productname length = $ 50 label = "Beverage Name"
         type length = $ 8       label = "Beverage Type"
         flavor length = $ 30    label = "Beverage Flavor"
         productCategory length = $ 30 label = "Beverage Category"
         productSubCategory length = $ 30 label = "Beverage Sub-Category"
         size length = $ 200     label = "Beverage Volume"
         unitSize length = 8     label = "Beverage Quantity" format = BEST12.
         container length = $ 6  label = "Beverage Container"
         date length = 8         label = "Sale Date"  format = DATE9.
         unitssold length = 8    label = "Units Sold" format = COMMA7.
         salesPerThousand length = 8 label = "Sales per 1,000" format = 7.4
    ;

data Final.NonColaSouth;
  infile RawData("Non-Cola--NC,SC,GA.dat") firstobs = 7;
  input stateFips 2. countyFips 3. ProductName $20. Size $10. UnitSize 3. Date MMDDYY10. UnitsSold 7.;
run;

data Final.EnergySouth;
  infile RawData("Energy--NC,SC,GA.txt") firstobs = 2 dlm = "09"x;
  input stateFips countyFips ProductName : $50. Size : $10. UnitSize Date : DATE9. UnitsSold;
run;

data Final.OtherSouth;
  infile RawData("Other--NC,SC,GA.csv") firstobs = 2 dsd;
  input stateFips countyFips ProductName : $50. Size : $10. UnitSize Date : DATE7. UnitsSold;
run;

data Final.NonColaNorth(drop = _:);
  infile RawData("Non-Cola--DC-MD-VA.dat") firstobs = 5;
  input stateFips 2. countyFips 3. ProductCode $25. _Date $10. UnitsSold 7.;
  _DateFmt = index(_Date, '/');
  if _DateFmt = 0 then do;
    Date = input(_Date, DATE9.);
  end;
  if _DateFmt = 3 then do;
    Date = input(_Date, MMDDYY10.);
  end;
run;

data Final.EnergyNorth(drop = _:);
  infile RawData("Energy--DC-MD-VA.txt") firstobs = 2 dlm = "09"x;
  input stateFips countyFips ProductCode : $25. _Date : $20. UnitsSold;
  _DateFmt = index(_Date, '/');
  if _DateFmt = 0 then do;
    Date = input(_Date, DATE9.);
  end;
  if _DateFmt = 3 then do;
    Date = input(_Date, MMDDYY10.);
  end;
run;

data Final.OtherNorth;
  infile RawData("Other--DC-MD-VA.csv") firstobs = 2 dsd;
  input stateFips countyFips ProductCode : $25. Date : ANYDTDTE20. UnitsSold;
run;

options fmtsearch = (Final Inputfmt);

proc format library = Final;
  value $ NamesNC(fuzz = 0) "S-7-" = "Professor Zesty"
                          "S-8-" = "Diet Professor Zesty"
                          "S-9-" = "Citrus Splash"
                          "S-10" = "Diet Citrus Splash"
                          "S-11" = "Lemon-Lime"
                          "S-12" = "Diet Lemon-Lime"
                          "S-13" = "Orange Fizzy"
                          "S-14" = "Diet Orange Fizzy"
                          "S-15" = "Grape Fizzy"
                          "S-16" = "Diet Grape Fizzy"
  ;
  value $ NamesE(fuzz = 0)  "E-1-" = "Zip-Orange"
                          "E-2-" = "Zip-Berry"
                          "E-3-" = "Zip-Grape"
                          "E-4-" = "Diet Zip-Orange"
                          "E-5-" = "Diet Zip-Berry"
                          "E-6-" = "Diet Zip-Grape"
                          "E-7-" = "Big Zip-Berry"
                          "E-8-" = "Big Zip-Grape"
                          "E-9-" = "Diet Big Zip-Berry"
                          "E-10" = "Diet Big Zip-Grape"
                          "E-11" = "Mega Zip-Orange"
                          "E-12" = "Mega Zip-Berry"
                          "E-13" = "Diet Mega Zip-Orange"
                          "E-14" = "Diet Mega Zip-Berry"
  ;
  value $ NamesO(fuzz = 0)  "O-1-" = "Non-Soda Ades-Lemonade"
                          "O-2-" = "Non-Soda Ades-Diet Lemonade"
                          "O-3-" = "Non-Soda Ades-Orangeade"
                          "O-4-" = "Non-Soda Ades-Diet Orangeade"
                          "O-5-" = "Nutritional Water-Orange"
                          "O-6-" = "Nutritional Water-Grape"
                          "O-7-" = "Diet Nutritional Water-Orange"
                          "O-8-" = "Diet Nutritional Water-Grape"
  ;
  value $ EnergySub(fuzz = 0)  "Zip-Orange" = "Zip"
                          "Zip-Grape" = "Zip"
                          "Zip-Berry" = "Zip"
                          "Diet Zip-Orange" = "Zip"
                          "Diet Zip-Grape" = "Zip"
                          "Diet Zip-Berry" = "Zip"
                          "Big Zip-Berry" = "Big Zip"
                          "Big Zip-Grape" = "Big Zip"
                          "Diet Big Zip-Berry" = "Big Zip"
                          "Diet Big Zip-Grape" = "Big Zip"
                          "Mega Zip-Berry" = "Mega Zip"
                          "Mega Zip-Orange" = "Mega Zip"
                          "Diet Mega Zip-Berry" = "Mega Zip"
                          "Diet Mega Zip-Orange" = "Mega Zip"
   ;
   value $ OtherCat(fuzz = 0) "Non-Soda Ades-Lemonade" = "Non-Soda Ades"
                              "Non-Soda Ades-Diet Lemonade" = "Non-Soda Ades"
                              "Non-Soda Ades-Orangeade" = "Non-Soda Ades"
                              "Non-Soda Ades-Diet Orangeade" = "Non-Soda Ades"
                              "Nutritional Water-Orange" = "Nutritional Water"
                              "Nutritional Water-Grape" = "Nutritional Water"
                              "Diet Nutritional Water-Orange" = "Nutritional Water"
                              "Diet Nutritional Water-Grape" = "Nutritional Water"
   ;
   value $ sizes(fuzz = 0)    8 = "8 oz"
                              12 = "12 oz"
                              16 = "16 oz"
                              20 = "20 oz"
                              1 = "1 liter"
                              2 = "2 liter"
   ;
   value $ containers(fuzz = 0) "8 oz" = "Can"
                              "12 oz" = "Can"
                              "16 oz" = "Can"
                              "20 oz" = "Bottle"
                              "1 liter" = "Bottle"
                              "2 liter" = "Bottle"
   ;
   value $ flavors(fuzz = 0)  "Big Zip-Berry" = "Berry"
                              "Big Zip-Grape" = "Grape"
                              "Diet Big Zip-Berry" = "Berry"
                              "Diet Big Zip-Grape" = "Grape"
                              "Diet Mega Zip-Berry"= "Berry"
                              "Diet Mega Zip-Orange" = "Orange"
                              "Mega Zip-Berry" = "Berry"
                              "Mega Zip-Orange" = "Orange"
                              "Diet Zip-Berry" = "Berry"
                              "Diet Zip-Grape" = "Grape"
                              "Diet Zip-Orange" = "Orange"
                              "Zip-Berry" = "Berry"
                              "Zip-Grape" = "Grape"
                              "Zip-Orange" = "Orange"
                              "Non-Soda Ades-Diet Lemonade" = "Lemonade"
                              "Non-Soda Ades-Diet Orangeade" = "Orangeade"
                              "Non-Soda Ades-Lemonade" = "Lemonade"
                              "Non-Soda Ades-Orangeade" = "Orangeade"
                              "Diet Nutritional Water-Grape" = "Grape"
                              "Diet Nutritional Water-Orange" = "Orange"
                              "Nutritional Water-Grape" = "Grape"
                              "Nutritional Water-Orange" = "Orange"
                              "Cherry Cola" = "Cherry Cola"
                              "Cola" = "Cola"
                              "Diet Cherry Cola" = "Cherry Cola"
                              "Diet Cola" = "Cola"
                              "Diet Vanilla Cola" = "Vanilla Cola"
                              "Vanilla Cola" = "Vanilla Cola"
                              "Citrus Splash" = "Citrus Splash"
                              "Diet Citrus Splash" = "Citrus Splash"
                              "Diet Grape Fizzy" = "Grape Fizzy"
                              "Diet Lemon-Lime" = "Lemon-Lime"
                              "Diet Orange Fizzy" = "Orange Fizzy"
                              "Diet Professor Zesty" = "Professor Zesty"
                              "Grape Fizzy" = "Grape Fizzy"
                              "Lemon-Lime" = "Lemon-Lime"
                              "Orange Fizzy" = "Orange Fizzy"
                              "Professor Zesty" = "Professor Zesty"
   ;
run;

data Final.AllDrinks(drop = productcode code _:);
  attrib &DrinksAttribs;
  set Final.EnergyNorth(in = inEN)
      Final.EnergySouth(in = inES)
      Final.NonColaNorth(in = inNCN)
      Final.NonColaSouth(in = inNCS)
      Final.OtherNorth(in = inON)
      Final.OtherSouth(in = inOS)
      InputDS.Coladcmdva(in = inCN)
      InputDS.Colancscga(in = inCS)
  ;
  _source = inEN * 1 + inES * 2 + inNCN * 3 + inNCS * 4 + inON * 5 + inOS * 6 + inCN * 7 + inCS * 8;
  productname = propcase(productname);
  if _source eq 1 then do;
    ProductName = put(substr(productcode, 1, 4), namese.);
    Region = "North";
    ProductCategory = "Energy";
    ProductSubCategory = put(productname, energysub.);
    Size = scan(productcode, 3, '-');
    UnitSize = scan(productcode, 1, '-', 'b');
  end;
  if _source eq 2 then do;
    Region = "South";
    ProductCategory = "Energy";
    ProductSubCategory = put(productname, energysub.);
  end;
  if _source eq 3 then do;
    ProductName = put(substr(productcode, 1, 4), namesnc.);
    Region = "North";
    ProductCategory = "Soda: Non-Cola";
    Size = scan(productcode, 3, '-');
    UnitSize = scan(productcode, 1, '-', 'b');
  end;
  if _source eq 4 then do;
    Region = "South";
    ProductCategory = "Soda: Non-Cola";
  end;
  if _source eq 5 then do;
    ProductName = put(substr(productcode, 1, 4), nameso.);
    Region = "North";
    ProductCategory = put(productname, othercat.);
    Size = scan(productcode, 3, '-');
    UnitSize = scan(productcode, 1, '-', 'b');
  end;
  if _source eq 6 then do;
    Region = "South";
    ProductCategory = put(productname, othercat.);
  end;
  if _source eq 7 then do;
    ProductName = put(substr(code, 3, 1), prodnames.);
    Region = "North";
    ProductCategory = "Soda: Cola";
    Size = scan(code, 3, '-');
    UnitSize = scan(code, 1, '-', 'b');
  end;
  if _source eq 8 then do;
    Region = "South";
    ProductCategory = "Soda: Cola";
  end;
  _diet = index(productname, "Diet");
  if _diet eq 0 then type = "Non-Diet";
    else if _diet ne 0 then type = "Diet";
  Size = put(scan(size, 1, , 'lu'), sizes.);
  Container = put(size, containers.);
  Flavor = put(productname, flavors.);
run;

proc sort data = Final.AllDrinks;
  by stateFips countyFips;
run;


data Final.AllData;
  attrib &AllAttribs;
  merge Final.AllDrinks
        Final.Counties(drop = Region);
  by stateFips countyFips;
  salesPerThousand = (2000*unitssold)/(popestimate2016 + popestimate2017);
run;

ods pdf file = "BaberFinalReport.pdf";
ods noproctitle;
ods listing close;

options nodate;

title "Activity 2.1";
title2 "Summary of Units Sold";
title3 "Single Unit Packages";
footnote j=c "Minimum and maximum Sales are within any county for any week";
proc means data = Final.Alldata sum min max nonobs nolabels;
  where (unitsize = 1) AND (flavor = "Cherry Cola" OR flavor = "Vanilla Cola"
        OR flavor = "Cola") AND (Region = "South");
  class stateFips productName size unitsize;
  var unitssold;
  attrib stateFips label = "StateFIPS"
         productName label = "productName"
         size label = "Container Size"
         unitsize label = "Containers per Unit"
   ;
run;
title;
footnote;

title1 "Activity 2.3";
title2 "Cross Tabulation of Single Unit Product Sales in Various States";
ods select freq.table1of1.crosstabfreqs
           freq.table2of1.crosstabfreqs;
proc freq data = Final.Alldata;
  where (unitsize = 1) AND (flavor = "Cherry Cola" OR flavor = "Vanilla Cola"
        OR flavor = "Cola") AND (Region = "South");
  weight unitssold;
  table productname * statefips * size / format = COMMA10. ;
run;
title;
footnote;


ods listing image_dpi = 300;
ods graphics / reset width = 6in;
title "Activity 3.1";
title2 "Single-Unit 12 oz Sales";
title3 "Regular, Non-Cola Sodas";
proc sgplot data = Final.Alldata;
  where (unitsize = 1) AND (productname = "Citrus Splash" OR productname = "Grape Fizzy"
        OR productname = "Lemon-Lime" OR productname = "Orange Fizzy" OR productname = "Professor Zesty")
        AND (Region = "South") AND (size = "12 oz");
  hbar stateName / response = unitssold group = productname
                   groupdisplay = cluster;
  styleattrs datacolors = (purple orange green red blue);
  keylegend / location = inside position = bottomright
              down = 3;
  yaxis display = (nolabel);
  xaxis label = "Total Sold";
run;
title;

title "Activity 3.3";
title2 "Average Weekly Sales, Non-Diet Energy Drinks";
title3 "For 8 oz Cans in Georgia";
proc sgplot data = Final.Alldata;
  where (stateName = "Georgia") AND (type = "Non-Diet") AND (productCategory = "Energy")
        AND (size = "8 oz");
  vbar ProductName / response = unitssold group = unitsize stat = mean
                     groupdisplay = cluster dataskin = SHEEN;
  styleattrs datacolors = (blue red green);
  keylegend / location = outside position = bottom
              down = 1;
  yaxis label = "Weekly Average Sales";
  xaxis display = (nolabel);
run;
title;

/* https://go.documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/grstatproc/n1wvtdp1zvu57un1wjyheyd61e3i.htm 
 went here to find the legendlabel option, which I had previously not known about*/
title "Activity 3.6";
title2 "Weekly Average Sales, Nutritional Water";
title3 "Single-Unit Packages";
proc sgplot data = final.alldata;
  where (Region = "South") AND (productcategory = "Nutritional Water") AND (unitsize = 1);
  hbar ProductName / response = unitssold stat = mean barwidth = 0.6
                     fill fillattrs = (color = blue) legendlabel = "Mean";
  styleattrs datacolors = (blue);
  hbar ProductName / response = unitssold stat = median fill fillattrs = (color = red)
                     transparency = 0.4 legendlabel = "Median";
  keylegend / position = topright noborder title = "Weekly Sales"
              location = inside across = 1;
  yaxis display = (nolabel); 
  xaxis label = "Georgia, North Carolina, and South Carolina";
run;
title;

ods listing close;
ods graphics off;

title "Activity 4.1";
title2 "Weekly Sales Summaries";
title3 "Cola Products, 20 oz Bottles, Individual Units";
footnote j=c "All States";
proc means data = final.alldata mean median q1 q3 nonobs maxdec = 0 nolabels;
  where (Flavor = "Cherry Cola" OR Flavor = "Vanilla Cola" OR Flavor = "Cola") AND (unitsize = 1)
        AND (size = "20 oz");
  class Region Type Flavor;
  var UnitsSold;
  attrib region label = "region"
         type label = "type"
         flavor label = "Flavor";
run;
title;
footnote;

ods listing image_dpi = 300;
ods graphics / reset width = 6in;
title "Activity 4.2";
title2 "Weekly Sales Distributions";
title3 "Cola Products, 12 Packs of 20 oz Bottles";
footnote "All States";
proc sgpanel data = Final.AllData;
  where (productCategory = "Soda: Cola") AND (size = "20 oz") AND (unitSize = 12);
  panelby region type / novarname;
  histogram unitssold / scale = proportion binstart = 125 binwidth = 250;
  rowaxis display = (nolabel) valuesformat = percent6.;
  colaxis values = (0 to 2000 by 500);
run;
title;
footnote;

ods exclude all;

proc means data = Final.Alldrinks q1 q3 nonobs;
  where (Flavor = "Cola") AND (size = "20 oz") AND (unitSize = 1);
  class region type date;
  var unitssold;
  ods output summary = final.act44;
run;

ods exclude none;

title "Activity 4.4";
title2 "Sales Inter-Quartile Ranges";
title3 "Cola: 20 oz Bottles, Individuals Units";
footnote "All States";
proc sgpanel data = Final.act44;
  panelby region type / novarname;
  highlow x = date low = unitssold_q1 high = unitssold_q3;
  colaxis interval = MONTH label = "Date";
  rowaxis values = (0 to 1250 by 250) label = "Q1-Q3";
  attrib date format = MONYY7.;
run;
title;
footnote;

ods graphics off;
ods listing close;

proc sort data = final.alldrinks;
 by productcategory productname;
run;

title "Optional Activity";
title2 "Product Information and Categorization";
proc report data = final.alldrinks;
  columns productName type ProductCategory ProductSubCategory Flavor size container;
  define productName / group order = data;
  define type / group;
  define productCategory / group order = data;
  define productSubCategory / group missing;
  define Flavor / group;
  define size / group;
  define container / group;
run;
title;

ods exclude all;

proc report data = Final.Alldata out = Final.Act55;
  where (stateName = "North Carolina" OR stateName = "South Carolina") AND (size = "12 oz")
        AND (unitsize = 1) AND (Flavor = "Cola") AND (Date = "05AUG2016"d OR Date = "12AUG2016"d
        OR Date = "19AUG2016"d OR Date = "26AUG2016"d);
  columns stateName type date unitssold dummy UnitsSoldNC UnitsSoldSC;
  define stateName / group;
  define type / group;
  define date / group;
  define unitssold / analysis sum noprint;
  define dummy / computed noprint;
  define unitssoldNC / computed;
  define unitssoldSC / computed;
  compute dummy;
    if lowcase(_break_) eq 'stateName' then do;
    c = 0;
    end;
    else if _break_ eq '' then do;
    c+1;
    end;
  endcomp;
  compute unitssoldNC;
    if c = 1 then unitssoldNC = unitssold.sum;
    if c = 2 then unitssoldNC = unitssold.sum;
    if c = 3 then unitssoldNC = unitssold.sum;
    if c = 4 then unitssoldNC = unitssold.sum;
    if c = 5 then unitssoldNC = unitssold.sum;
    if c = 6 then unitssoldNC = unitssold.sum;
    if c = 7 then unitssoldNC = unitssold.sum;
    if c = 8 then unitssoldNC = unitssold.sum;
  endcomp;
  compute unitssoldSC;
    if c = 9 then unitssoldSC = unitssold.sum;
    if c = 10 then unitssoldSC = unitssold.sum;
    if c = 11 then unitssoldSC = unitssold.sum;
    if c = 12 then unitssoldSC = unitssold.sum;
    if c = 13 then unitssoldSC = unitssold.sum;
    if c = 14 then unitssoldSC = unitssold.sum;
    if c = 15 then unitssoldSC = unitssold.sum;
    if c = 16 then unitssoldSC = unitssold.sum;
  endcomp;
run;

ods exclude none;

ods listing image_dpi = 300;
ods graphics / reset width = 6in;
title "Activity 5.5";
title2 "North and South Carolina Sales in August";
title3 "12 oz, Single-Unit, Cola Flavor";
proc sgpanel data = final.act55;
  format date MMDDYY8.;
  panelby type / columns = 1 novarname;
  hbar date / response = unitssoldNC fill legendlabel = "North Carolina"
              fillattrs = (color = blue) barwidth = 0.6;
  hbar date / response = unitssoldSC fill legendlabel = "South Carolina"
              fillattrs = (color = red transparency = 0.4);
  rowaxis     display = (nolabel);
  colaxis     label = "Sales" valuesformat = COMMA9. type = linear;
run;
title;

ods listing close;
ods graphics off;

/* https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/proc/p16uti3vzgml7gn1nt3ov7cqxf9i.htm
   went here to find the suppress option for the break statement */
title "Activity 6.2";
title2 "Quarterly Sales Summaries for 12oz Single-Unit Products";
title3 "Maryland Only";
proc report data = final.alldata;
  where (stateName = "Maryland") AND (size = "12 oz") AND (Unitsize = 1);
  columns type productname date unitssold=salesmed unitssold=salestotal unitssold=salesmin unitssold=salesmax;
  format date qtrr.;
  define type / group 'Product Type';
  define productname / group 'Name';
  define date / group 'Quarter' order = internal;
  define salesmed / analysis median 'Median Weekly Sales';
  define salestotal / analysis sum 'Total Sales';
  define salesmin / analysis min 'Lowest Weekly Sales';
  define salesmax / analysis max 'Highest Weekly Sales';
  break after productname / suppress summarize;
run;
title;

/*

data Final.Sodas(drop =);
  attrib Number length = 8 label = "Product Number"
         ProductName length = $20 label = "Product Name"
         Size length = $8  label = "Individual Container Size"
         Quantity length = 8  label = "Retail Unit Size" format = BEST12.
         code   length = $14  label = "Product Code";
  infile RawData("Sodas.csv") dsd firstobs = 6;
  input Number ProductName $ @;
  do i = 1 to 6;
    input size $ @;
  output;
  end;
run; 

proc report data = final.sodas;
  columns number productname size quantity code;
  define number / group 'Product Number';
  define productname / group 'Product Name';
  define size / group 'Individual Container Size';
  define quantity / group 'Retail Unit Size';
  define code / group 'Product Code';
run; */

title "Activity 7.4";
title2 "Quarterly Sales Summaries for 12oz Single-Unit Products";
title3 "Maryland Only";
proc report data = final.alldata
  style(header) = [backgroundcolor = CXBFB2B5 color = CX3230B2]
  style(summary) = [backgroundcolor = black color = white];
  where (stateName = "Maryland") AND (size = "12 oz") AND (Unitsize = 1);
  columns type productname date unitssold=salesmed unitssold=salestotal unitssold=salesmin unitssold=salesmax;
  format date qtrr.;
  define type / group 'Product Type';
  define productname / group 'Name';
  define date / group 'Quarter' order = internal;
  define salesmed / analysis median 'Median Weekly Sales';
  define salestotal / analysis sum 'Total Sales';
  define salesmin / analysis min 'Lowest Weekly Sales';
  define salesmax / analysis max 'Highest Weekly Sales';
  break after productname / suppress summarize;
  compute date;
    if lowcase(_break_) eq 'productname' then do;
    c = 0;
    end;
    else if _break_ eq '' then do;
    c+1;
    end;
       if mod(c,5) eq 1 then
       call define (_row_, 'style', 'style = [backgroundcolor = white]');
       else if mod(c,5) eq 2 then
       call define (_row_, 'style', 'style = [backgroundcolor = CXBFBFBF]');
       else if mod(c,5) eq 3 then
       call define (_row_, 'style', 'style = [backgroundcolor = CX8C8C8C]');
       else if mod(c,5) eq 4 then
       call define (_row_, 'style', 'style = [backgroundcolor = CX595959]');
       else if mod(c,5) eq 0 then
       call define (_row_, 'style', 'style = [backgroundcolor = black color = white]');
  endcomp;
run;
title;


title "Activity 7.5";
title2 "Quarterly Per-Capita Sales Summaries";
title3 "12oz Single-Unit Lemonade";
title4 "Maryland Only";
footnote "Flagged Rows: Sales Less Than 7.5 per 1000 for Diet; Less Than 30 per 1000 for Non-Diet";
proc report data = final.alldata
  style(header) = [backgroundcolor = CXBFBFBF color = CX5A58A6];
  where (stateName = "Maryland") AND (Flavor = "Lemonade") AND (size = "12 oz")
        AND (unitsize = 1);
  columns countyName type date unitssold salesPerThousand popestimate2016 dummy;
  format date qtrr. unitssold COMMA12. salesPerThousand 5.1;
  define countyName / group 'County';
  define popestimate2016 / analysis mean noprint;
  define type / group 'Product Type';
  define date / group 'Quarter' order = internal;
  define unitssold / analysis sum 'Total Sales';
  define salesPerThousand / analysis sum 'Sales per 1000';
  define dummy / computed noprint;
  compute dummy;
    if lowcase(_break_) eq 'countyName' then do;
    c = 0;
    end;
    else if _break_ eq '' then do;
    c+1;
    end;
    if mod(c,8) eq 1 AND salesPerThousand.sum lt 7.5 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 2 AND salesPerThousand.sum lt 7.5 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 3 AND salesPerThousand.sum lt 7.5 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 4 AND salesPerThousand.sum lt 7.5 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 5 AND salesPerThousand.sum lt 30 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 6 AND salesPerThousand.sum lt 30 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 7 AND salesPerThousand.sum lt 30 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
    if mod(c,8) eq 0 AND salesPerThousand.sum lt 30 then do;
        call define(_row_, 'style', 'style = [backgroundcolor = grey]');
        call define('_c5_', 'style', 'style = [color = red]');
    end;
  endcomp;
  break after countyName / suppress summarize style = [backgroundcolor = CXBBBFAC];
  compute after countyName / style = [backgroundcolor = black color = white];
    line '2016 Population: ' popestimate2016.mean comma9.;
  endcomp;
run;

ods pdf close;
ods listing close;

quit;
