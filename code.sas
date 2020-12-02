/*---Student ID 30867835---*/
/*Before u run this code, it is better to add a new lib name 'con'*/
/*Data collection*/
data con.ba1;
	infile'C:/Users/mktmi/OneDrive/×ÀÃæ/cons_sas/TelcoData_extract2.txt' DLM=','
	DSD MISSOVER firstobs=2;
	input Customer_ID upsell_xsell churn;
run;

PROC IMPORT OUT=con.ba2 DATAFILE="C:/Users/mktmi/OneDrive/×ÀÃæ/cons_sas/TelcoData_extract3.xlsx" dbms=xlsx replace;
  getnames=yes;
run;

data con.ba;
merge con.ba1 con.ba2 con.TelcoData_extract1;
by Customer_ID;
run;

/*Descriptive Statistic for con.ba*/
proc means data=con.ba;
run;

/*pie chart*/
proc gchart data=con.ba;
pie network_mention	service_mention	price_mention mfg_apple	mfg_samsung	mfg_htc	mfg_motorola 
mfg_lg	mfg_nokia	delinq_indicator	times_delinq upsell_xsell	churn	credit_class	sales_channel	
region	state	city	product_plan_desc	handset_age_grp	handset	lifestage	rp_pooled_ind	call_center	issue_level1	
issue_level2	call_category_1	call_category_2	resolution
/type=sum percent=arrow slice=inside ctext=black value=inside;
run;

/*bar chart*/
proc gchart data=con.ba;
hbar count_of_suspensions_6m	avg_days_susp	calls_total	calls_in_pk	calls_in_offpk	calls_out_offpk	calls_out_pk	
voice_tot_bill_mou_curr	tot_voice_chrgs_curr	tot_drpd_pr1	bill_data_usg_m03	bill_data_usg_m06	bill_data_usg_m09	
mb_data_usg_m01	mb_data_usg_m02	mb_data_usg_m03	mb_data_ndist_mo6m	mb_data_usg_roamm01	mb_data_usg_roamm02	mb_data_usg_roamm03	
data_usage_amt	tweedie_adjusted	tot_mb_data_curr	tot_mb_data_roam_curr	bill_data_usg_tot	tot_overage_chgs	
data_prem_chrgs_curr	nbr_data_cdrs	avg_data_chrgs_3m	avg_data_prem_chrgs_3m	avg_overage_chrgs_3m	nbr_contacts	
calls_TS_acct	open_tsupcomplnts	num_tsupcomplnts	unsolv_tsupcomplnt	wrk_orders	days_openwrkorders	resolved_complnts	
calls_care_acct	calls_care_3mavg_acct	calls_care_6mavg_acct	res_calls_3mavg_acct	res_calls_6mavg_acct	
last_rep_sat_score lifetime_value	avg_arpu_3m	acct_age	billing_cycle	nbr_contracts_ltd	rfm_score	Est_HH_Income	
zipcode_primary	region_lat	region_long	state_lat	state_long	city_lat	city_long	zip_lat	zip_long	cs_med_home_value	
cs_pct_home_owner	cs_ttl_pop	cs_hispanic	cs_caucsasian	cs_afr_amer	cs_other	cs_ttl_urban	cs_ttl_rural	
cs_ttl_male	cs_ttl_female	cs_ttl_hhlds	cs_ttl_mdage	
forecast_region	mb_inclplan	ever_days_over_plan	ever_times_over_plan	data_device_age	equip_age
/type=sum percent=arrow slice=inside ctext=black value=inside;
run;

/*Remove duplicate values*/
/*0 duplicate values removed*/
proc sort data = con.ba out =con.cs nodup;
    by Customer_ID;
run ;


/*Missing value query*/
data missing(drop=i);
set con.cs;
array a _numeric_;
do i=1 to dim(a);
if missing(a) then output;
end;

array b _character_;
do i=1 to dim(b);
if missing(b) then output;
end;

/*mou data set back up*/
data con.mou;
set con.cs;
if nmiss(of _numeric_) + cmiss(of _character_) > 0 then delete;
run;

/*delete mou_ 6 column*/
data con.cs1;
	set con.cs;
	drop mou_total_pct_MOM	mou_onnet_pct_MOM	mou_roam_pct_MOM	mou_onnet_6m_normal	mou_roam_6m_normal call_category_2;
run;

/*Delete missing value*/
/*remain 46076 variables*/
data con.cs2;
set con.cs1;
if nmiss(of _numeric_) + cmiss(of _character_) > 0 then delete;
if days_openwrkorders = '**' then delete;
run;

/*Collinearity (Just have a look),Spearman in the following*/
proc corr data = con.cs2;
var Customer_ID upsell_xsell churn lifetime_value avg_arpu_3m acct_age billing_cycle nbr_contracts_ltd 
	rfm_score Est_HH_Income zipcode_primary region_lat region_long  state_lat state_long city_lat city_long 
	zip_lat zip_long cs_med_home_value cs_pct_home_owner cs_ttl_pop cs_hispanic cs_caucasian  cs_afr_amer 
	cs_other cs_ttl_urban  cs_ttl_rural cs_ttl_male cs_ttl_female cs_ttl_hhlds cs_ttl_mdage 
	forecast_region mb_inclplan ever_days_over_plan ever_times_over_plan data_device_age equip_age 
	mfg_apple mfg_samsung mfg_htc mfg_motorola mfg_lg mfg_nokia delinq_indicator times_delinq 
	count_of_suspensions_6m avg_days_susp calls_total calls_in_pk calls_in_offpk calls_out_offpk 
	calls_out_pk voice_tot_bill_mou_curr tot_voice_chrgs_curr tot_drpd_pr1 bill_data_usg_m03 bill_data_usg_m06 
	bill_data_usg_m09 mb_data_usg_m01 mb_data_usg_m02 mb_data_usg_m03 mb_data_ndist_mo6m mb_data_usg_roamm01 
	mb_data_usg_roamm02 mb_data_usg_roamm03 data_usage_amt tweedie_adjusted tot_mb_data_curr tot_mb_data_roam_curr 
	bill_data_usg_tot tot_overage_chgs data_prem_chrgs_curr nbr_data_cdrs avg_data_chrgs_3m avg_data_prem_chrgs_3m 
	avg_overage_chrgs_3m nbr_contacts calls_TS_acct open_tsupcomplnts num_tsupcomplnts unsolv_tsupcomplnt 
	wrk_orders days_openwrkorders resolved_complnts calls_care_acct calls_care_3mavg_acct 
	calls_care_6mavg_acct res_calls_3mavg_acct res_calls_6mavg_acct last_rep_sat_score network_mention service_mention price_mention;
run;


/*PCA*/
proc princomp data=con.cs2 out=con.prin prefix=z standard;
var Customer_ID upsell_xsell churn lifetime_value avg_arpu_3m acct_age billing_cycle nbr_contracts_ltd 
	rfm_score Est_HH_Income zipcode_primary region_lat region_long  state_lat state_long city_lat city_long 
	zip_lat zip_long cs_med_home_value cs_pct_home_owner cs_ttl_pop cs_hispanic cs_caucasian  cs_afr_amer 
	cs_other cs_ttl_urban  cs_ttl_rural cs_ttl_male cs_ttl_female cs_ttl_hhlds cs_ttl_mdage 
	forecast_region mb_inclplan ever_days_over_plan ever_times_over_plan data_device_age equip_age 
	mfg_apple mfg_samsung mfg_htc mfg_motorola mfg_lg mfg_nokia delinq_indicator times_delinq 
	count_of_suspensions_6m avg_days_susp calls_total calls_in_pk calls_in_offpk calls_out_offpk 
	calls_out_pk voice_tot_bill_mou_curr tot_voice_chrgs_curr tot_drpd_pr1 bill_data_usg_m03 bill_data_usg_m06 
	bill_data_usg_m09 mb_data_usg_m01 mb_data_usg_m02 mb_data_usg_m03 mb_data_ndist_mo6m mb_data_usg_roamm01 
	mb_data_usg_roamm02 mb_data_usg_roamm03 data_usage_amt tweedie_adjusted tot_mb_data_curr tot_mb_data_roam_curr 
	bill_data_usg_tot tot_overage_chgs data_prem_chrgs_curr nbr_data_cdrs avg_data_chrgs_3m avg_data_prem_chrgs_3m 
	avg_overage_chrgs_3m nbr_contacts calls_TS_acct open_tsupcomplnts num_tsupcomplnts unsolv_tsupcomplnt 
	wrk_orders days_openwrkorders resolved_complnts calls_care_acct calls_care_3mavg_acct 
	calls_care_6mavg_acct res_calls_3mavg_acct res_calls_6mavg_acct last_rep_sat_score network_mention service_mention price_mention;
run;

/*Normality test*/
proc univariate data = con.prin normal plot;
	var z1-z8;
run;

/*standardization*/
proc standard data=con.cs2 out=con.std mean=0 std=1;
var Customer_ID upsell_xsell churn lifetime_value avg_arpu_3m acct_age billing_cycle nbr_contracts_ltd 
	rfm_score Est_HH_Income zipcode_primary region_lat region_long  state_lat state_long city_lat city_long 
	zip_lat zip_long cs_med_home_value cs_pct_home_owner cs_ttl_pop cs_hispanic cs_caucasian  cs_afr_amer 
	cs_other cs_ttl_urban  cs_ttl_rural cs_ttl_male cs_ttl_female cs_ttl_hhlds cs_ttl_mdage 
	forecast_region mb_inclplan ever_days_over_plan ever_times_over_plan data_device_age equip_age 
	mfg_apple mfg_samsung mfg_htc mfg_motorola mfg_lg mfg_nokia delinq_indicator times_delinq 
	count_of_suspensions_6m avg_days_susp calls_total calls_in_pk calls_in_offpk calls_out_offpk 
	calls_out_pk voice_tot_bill_mou_curr tot_voice_chrgs_curr tot_drpd_pr1 bill_data_usg_m03 bill_data_usg_m06 
	bill_data_usg_m09 mb_data_usg_m01 mb_data_usg_m02 mb_data_usg_m03 mb_data_ndist_mo6m mb_data_usg_roamm01 
	mb_data_usg_roamm02 mb_data_usg_roamm03 data_usage_amt tweedie_adjusted tot_mb_data_curr tot_mb_data_roam_curr 
	bill_data_usg_tot tot_overage_chgs data_prem_chrgs_curr nbr_data_cdrs avg_data_chrgs_3m avg_data_prem_chrgs_3m 
	avg_overage_chrgs_3m nbr_contacts calls_TS_acct open_tsupcomplnts num_tsupcomplnts unsolv_tsupcomplnt 
	wrk_orders days_openwrkorders resolved_complnts calls_care_acct calls_care_3mavg_acct 
	calls_care_6mavg_acct res_calls_3mavg_acct res_calls_6mavg_acct last_rep_sat_score network_mention service_mention price_mention;
run;


/*PCA*/
proc princomp data=con.std out=con.stdprin prefix=z standard;
var Customer_ID upsell_xsell churn lifetime_value avg_arpu_3m acct_age billing_cycle nbr_contracts_ltd 
	rfm_score Est_HH_Income zipcode_primary region_lat region_long  state_lat state_long city_lat city_long 
	zip_lat zip_long cs_med_home_value cs_pct_home_owner cs_ttl_pop cs_hispanic cs_caucasian  cs_afr_amer 
	cs_other cs_ttl_urban  cs_ttl_rural cs_ttl_male cs_ttl_female cs_ttl_hhlds cs_ttl_mdage 
	forecast_region mb_inclplan ever_days_over_plan ever_times_over_plan data_device_age equip_age 
	mfg_apple mfg_samsung mfg_htc mfg_motorola mfg_lg mfg_nokia delinq_indicator times_delinq 
	count_of_suspensions_6m avg_days_susp calls_total calls_in_pk calls_in_offpk calls_out_offpk 
	calls_out_pk voice_tot_bill_mou_curr tot_voice_chrgs_curr tot_drpd_pr1 bill_data_usg_m03 bill_data_usg_m06 
	bill_data_usg_m09 mb_data_usg_m01 mb_data_usg_m02 mb_data_usg_m03 mb_data_ndist_mo6m mb_data_usg_roamm01 
	mb_data_usg_roamm02 mb_data_usg_roamm03 data_usage_amt tweedie_adjusted tot_mb_data_curr tot_mb_data_roam_curr 
	bill_data_usg_tot tot_overage_chgs data_prem_chrgs_curr nbr_data_cdrs avg_data_chrgs_3m avg_data_prem_chrgs_3m 
	avg_overage_chrgs_3m nbr_contacts calls_TS_acct open_tsupcomplnts num_tsupcomplnts unsolv_tsupcomplnt 
	wrk_orders days_openwrkorders resolved_complnts calls_care_acct calls_care_3mavg_acct 
	calls_care_6mavg_acct res_calls_3mavg_acct res_calls_6mavg_acct last_rep_sat_score network_mention service_mention price_mention;
run;

/*Normality test*/
/*The result is still not following the normal distribution*/
proc univariate data = con.stdprin normal plot;
	var z1-z8;
run;

/*Convert character variables to numeric variables*/
data con.cs3(drop=i);                                                                                                                       
set con.cs2;

	array sample{7} credit_class sales_channel region	handset_age_grp handset	lifestage rp_pooled_ind; 
	do i=1 to 7;

		     if sample{i}= 'risky'       then sample{i}=1;                                                                                                     
		else if sample{i}= 'other'       then sample{i}=2;
		else if sample{i}= 'near prime'  then sample{i}=3;
		else if sample{i}= 'prime' 	     then sample{i}=4;                                                                                                     
		else if sample{i}= 'smax prime'  then sample{i}=5;

			 if sample{i}= 'Direct' 				  then sample{i}=1;                                                                                                     
		else if sample{i}= 'Private Label GM'         then sample{i}=2;
		else if sample{i}= 'Indirect'   			  then sample{i}=3;
		else if sample{i}= 'Branded 3rd Party Retail' then sample{i}=4;                                                                                                     
		else if sample{i}= 'Retail'  				  then sample{i}=5;
		else if sample{i}= 'National Sales' 		  then sample{i}=6;

			 if sample{i}= 'Great Lakes'   then sample{i}=1;                                                                                                     
		else if sample{i}= 'Greater Texas' then sample{i}=2;
		else if sample{i}= 'Mid Atlantic'  then sample{i}=3;
		else if sample{i}= 'Midwest' 	   then sample{i}=4;                                                                                                     
		else if sample{i}= 'Mtn West'      then sample{i}=5;
		else if sample{i}= 'New England'   then sample{i}=6;
		else if sample{i}= 'Pacific'       then sample{i}=7;
		else if sample{i}= 'South'         then sample{i}=8;
		else if sample{i}= 'Southwest'     then sample{i}=9;

			 if sample{i}= '< 24 Months' then sample{i}=1;                                                                                                     
		else if sample{i}= '24-48 Month' then sample{i}=2;
		else if sample{i}= '> 48 Months' then sample{i}=3;

		     if sample{i}= 'Apple'         then sample{i}=1;                                                                                                     
		else if sample{i}= 'HTC'   	       then sample{i}=2;
		else if sample{i}= 'LG' 		   then sample{i}=3;
		else if sample{i}= 'Motorola' 	   then sample{i}=4;                                                                                                     
		else if sample{i}= 'Nokia'         then sample{i}=5;
		else if sample{i}= 'Samsung'       then sample{i}=6;
		else if sample{i}= 'Unknown'       then sample{i}=7;

		     if sample{i}= 'EARLY TENURED' then sample{i}=1;                                                                                                     
		else if sample{i}= 'EXPIRY'        then sample{i}=2;
		else if sample{i}= 'OFF-CONTRACT'  then sample{i}=3;
		else if sample{i}= 'ON-CONTRACT'   then sample{i}=4;                                                                                                     
		else if sample{i}= 'PRE-EXPIRY'    then sample{i}=5;

			 if sample{i}= 'N'       then sample{i}=0;                                                                                                     
		else if sample{i}= 'Y'       then sample{i}=1;
	
	end; 
run;

/*Numeric Outliers*/
PROC UNIVARIATE DATA=con.cs3 plot;
VAR _NUMERIC_;
RUN;

/*Outliers*/
data con.cs4;
set con.cs3;
if mb_data_usg_m03 = -509 then delete;
if mb_data_usg_roamm02 = 18727 then delete;
if mb_data_usg_m03 = 40784 then delete;
run;

/*Deduplication*/
data con.cs5;
	set con.cs4;
	drop mfg_samsung mfg_nokia mfg_motorola mfg_lg mfg_htc mfg_apple;
run;

/*Pearson coefficient matrix*/
proc corr spearman nosimple data=con.cs5;
	var _NUMERIC_;
run;

/*Remove multicollinearity, judge by Pearson coefficient > 0.8*/
data con.cs6;
	set con.cs5;
	drop region_long state_long city_long zip_long forecast_region cs_ttl_hhlds
		 cs_ttl_rural cs_ttl_female res_calls_3mavg_acct data_usage_amt mb_data_usg_roamm01
		 mb_data_usg_roamm02 mb_data_usg_roamm03 calls_in_pk calls_in_offpk calls_out_pk
		 voice_tot_bill_mou_curr res_calls_6mavg_acct;
run;

data con.cs7;
	set con.cs6;
		credit_class_n = credit_class*1;
		sales_channel_n = sales_channel*1;
		region_n = region *1;
		handset_age_grp_n =handset_age_grp*1;
		handset_n	= handset*1;
		lifestage_n = lifestage*1;
		rp_pooled_ind_n = rp_pooled_ind*1;
		credit_class_n = credit_class*1;
	drop credit_class sales_channel region handset_age_grp handset lifestage rp_pooled_ind;
run;


/*Individual Part*/
proc sort data = con.cs7;
by Churn;
run; 

/*Sampling for solving data imbalance*/
PROC SURVEYSELECT DATA = con.cs7 out = con.samp1 method = srs sampsize = 2000 seed = 123;
     STRATA Churn;
RUN;

/*Out of order*/
data con.samp2;
	set con.samp1;
	rand = uniform(12);
run;
proc sort data = con.samp2;
by rand;
run; 
data con.samp3;
	set con.samp2;
	drop rand Customer_ID upsell_xsell call_center issue_level1 issue_level2 call_category resolution
		 state city product_plan_desc call_category_1 SelectionProb SamplingWeight product_plan_desc;
run;

data con.samp4;
	set con.samp3;
	drop count_of_suspensions_6m calls_care_acct price_mention
		 tot_drpd_pr1 nbr_contacts last_rep_sat_score;
run;

/*Inspection data type*/
proc contents data=con.samp4 out=a;
run;



/*Change the variable name to make it easy to code*/
data con.samp5;
  set con.samp4;
  array x{69} churn  lifetime_value  avg_arpu_3m  acct_age  billing_cycle  nbr_contracts_ltd  rfm_score  Est_HH_Income  zipcode_primary  region_lat  state_lat  city_lat  zip_lat 
 			  cs_med_home_value  cs_pct_home_owner  cs_ttl_pop  cs_hispanic  cs_caucasian  cs_afr_amer  cs_other  cs_ttl_urban  cs_ttl_male  cs_ttl_mdage  mb_inclplan 
 			  ever_days_over_plan  ever_times_over_plan  data_device_age  equip_age  delinq_indicator  times_delinq    avg_days_susp  calls_total  
			  calls_out_offpk  tot_voice_chrgs_curr bill_data_usg_m03  bill_data_usg_m06  bill_data_usg_m09  mb_data_usg_m01  mb_data_usg_m02  
			  mb_data_usg_m03  mb_data_ndist_mo6m  tweedie_adjusted  tot_mb_data_curr  tot_mb_data_roam_curr  bill_data_usg_tot  tot_overage_chgs  data_prem_chrgs_curr  
			  nbr_data_cdrs  avg_data_chrgs_3m  avg_data_prem_chrgs_3m  avg_overage_chrgs_3m  calls_TS_acct  open_tsupcomplnts  num_tsupcomplnts  
			  unsolv_tsupcomplnt  wrk_orders  days_openwrkorders  resolved_complnts calls_care_3mavg_acct  calls_care_6mavg_acct 
			  network_mention  service_mention  credit_class_n  sales_channel_n  region_n  handset_age_grp_n  handset_n  lifestage_n  rp_pooled_ind_n
			  ;
  array v{69} v1-v69;
  do i=1 to 69;
   v{i}=x{i};
     end;
  keep v:;
run;

data con.samp6;
	set con.samp5;
	Y=v1;
	drop v1;
run;


/*Using 10-fold cross-validation method to calculate the prediction accuracy on the test set*/
%let k=10;                           
%let rate=%sysevalf((&k-1)/&k);       
 
/*Generate 10 examples of cross-validation, save in cv*/
proc surveyselect data=con.samp6 
              out=cv            
		      seed=158
			  samprate=&rate    
			  outall            
			  reps=10;         
run;

 
data cv;
  set cv;
   if selected then new_y=Y;
  run;
 
/*Logistic regression main program-10% off cross-validation*/
ods output parameterestimates=paramest   
           association=assoc;            
proc logistic data=cv des;           
		model new_y = v2-v69 / SELECTION=STEPWISE SLE=0.1 SLS=0.1;
    by replicate;                         
	output out=out1(where=(new_y=.))    
           p=y_hat;
run;
ods output close;
 
data out1;  
	set out1;
	if y_hat>0.5 then pred=_LEVEL_ ;
	else pred=0;                     
run;
 
/*Summarize the results of cross-validation*/
data out2;
	set out1;
	if Y=pred then d=1;  
	else d=0;
run;
 
proc summary data=out2;
 	var d;
	by replicate;
	output out=out3 sum(d)=d1;   
run;
 
data out3;
	set out3;
	acc=d1/_freq_;   
	keep replicate acc;
run;
 
/*Include cross-validated C statistics in the results*/
data assoc;
	set assoc;
	where label2="c";
	keep replicate cvalue2;
run;
 
/*Combine the statistical results of cross-validation*/
data cvresult;
merge assoc(in=ina) out3(in=inb);
keep replicate cvalue2 acc;
run;
 
proc print data=cvresult;
title'Cross-validation group number, c statistics, prediction accuracy';
run;
 
title 'Cross-validation optimal model selection: group number, prediction accuracy';
ods output SQL_Results=cvparam;      
proc sql ;
	select replicate,acc from cvresult having acc=max(acc);
quit;
ods output close;
 
 
 
/***************** Model with cross-validated optimal result set  *************************************/

proc sql ;
	create table train as
    select * from cv where replicate in (select replicate from cvparam)
    having selected=1;
    create table test as
    select * from cv where replicate in (select replicate from cvparam)
    having selected=0;
run;
 
TITLE '--------Logistic Regression------------';
 
/* Logistic regression main program-build a logistic model from the training set*/
proc logistic data=train  DES                    
                    covout outest=Nout_step  
					outmodel=model            
                    simple;                           
		MODEL Y=v2-v69                             
                      / SELECTION=STEPWISE             
                        SLE=0.1 SLS=0.1              
                        details                      
                        lackfit                      
                        RSQ                          
						STB                          
                        CL                           
                        itprint                      
                        corrb                        
                        covb                         
                        ctable                       
                        influence                    
						IPLOTS ;                     
 score data=train outroc=train_roc;            
 score data=test 
       out=test_pred 
       outroc=test_roc;                      
OUTPUT out=train_pred                        
            P=PHAT  lower=LCL upper=UCL              
            RESCHI=RESCHI  RESDEV=RESDEV             
            DIFCHISQ=DIFCHISQ  DIFDEV=DIFDEV         
                                                     
           / ALPHA=0.1;                             
run;     
quit;
 


data train_pred;  
	set train_pred;
	if PHAT>0.5 then pred=_LEVEL_ ;     
	else pred=0;                    
run;
 
/* Output confusion matrix-training set*/
ods output CrossTabFreqs=ct_train;  
ods trace on;
proc freq data=train_pred;
	tables Y*pred;
run;
ods trace off;
ods output close;
 
proc sql;
	create table acc1 as
	select sum(percent) from ct_train where (Y=pred and Y ^=.);
proc print data=acc1;
title 'Prediction accuracy on the training set';
run;
 
 
/* Output indicators such as confusion matrix and accuracy-test set*/
ods output CrossTabFreqs=ct_test; 
proc freq data=test_pred;
	tables F_Y*I_Y ;
run;
ods output close;
 
proc sql;
	create table acc2 as
	select sum(percent) from ct_test where (F_Y=I_Y and F_Y ^='');
proc print data=acc2;
title 'Prediction accuracy on test set';
run;

/*Clustering*/
proc gchart data=con.samp3;
hbar avg_overage_chrgs_3m
/type=sum ;
run;

data con.km;
	set con.samp3;
	keep avg_overage_chrgs_3m;
run;

proc fastcluster data=con.km maxc=3 maxiter=10 list output=con.c11;
var avg_overage_chrgs_3m;
run;
 

