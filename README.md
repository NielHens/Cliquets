# Cliquets
R-code for a phase portrait relating the number of new COVID-19 hospitalisations and its growth to ICU capacity.

Publicly available data from Sciensano are used on the number of new hospitalisations, total number of hospital beds and total number of intensive care (ICU) beds, which are reported on a daily basis. 

Data are presented as the pair of new hospitalizations and growth rate of new hospitalizations. The new hospitalizations are averages of the past 14-day number of new hospitalizations. The growth rate is obtained from modeling the past 14-day number of new hospitalizations H(t) as 
log_10 (H(t)) ∼N(α+βt+γw_t,σ^2)
with w_t an indicator for weekends and holidays. The growth rate is then calculated as 
g=10^β

Colours of the phase diagram are based on the predicted ICU capacity. For an assumed number of new hospitalizations H(t_0 ) on day t_0 and and assumed (constant) growth rate g, we calculate the number of new hospitalizations in the next t days as
H(t)=H(t_0 ) g^(t-t_0 )
Based on the predicted number of new hospitalisations, we derive the total number of patients in intensive care unit (ICU), based on the proportion of hospitalised patients that need intensive care and the length of stay in ICU. The number of patients in ICU on day t is 
ICU(t)=π ∑_i H(t-i)δ(i) 
where π is the fraction of hospitalized patients going to ICU and δ(i) is the probability that a patient stays i days in ICU.

The distribution of length of stay in ICU is derived from a multicenter registry in Belgium that collects information on hospital admission related to COVID-19 infection, for the period March to August 2020 (Faes et al. 2020, Van Goethem et al 2020). Patients staying longer than 60 days in ICU are assumed to leave ICU on day 60.  The fraction π of hospitalized patients that need intensive care is, based on the survey, 0.152.  As this is a survey, and does not contain all hospitalizations, this is corrected by the fraction of daily ICU beds reported in the hospital survey versus the daily reported national ICU load (1/2.15) and the fraction of hospital beds reported in the survey and reported nationally (1/1.33). As a result, we estimate π as 0.245.

As cutpoints, we use the estimated ICU load on day t_0+14 (which resembles the covid-19 ICU load if the behavior stays the same in 2 weeks).  Cutpoints are chosen in correspondence to the hospital contingency plan in Belgium consisting of 5 different phases while focusing on covid-19 related ICU care: Phase 0: 303 ICU-beds; Phase 1A: 528 ICU-beds; Phase 1B: 987 ICU-beds; Phase 2A: 1502 ICU-beds; Phase 2B: 2019 ICU-beds. Note that within this scheme the total number of patients (covid-19 and non-covid-19) in ICU moves from 2001 (Phase 0, 1A & 1B) to 2304 (Phase 2A) and 2821 (Phase 2B) and thus non-covid-19 care gradually decreases with an increase in phases. 						
	
