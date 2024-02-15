* Load data
import delimited using "data/raw/european_commission/ted-sample.csv", clear

* Only keep relevant variables
keep iso_country_code win_country_code award_value_euro

* Summarize award_value_euro
summarize award_value_euro, detail
// display "Number of observations: `r(N)'"
// display "Mean: `r(mean)'"

* Drop outliers
// drop if award_value_euro > `r(p95)'

* Plot the distribution of award_value_euro
hist award_value_euro // Large outliers

* Create a logged variable
gen ln_award_value_euro = ln(award_value_euro)

hist ln_award_value_euro // Looks much better.

* Let's generate an indicator: 1 (above median), 0 otherwise
generate above_mean = (award_value_euro > `r(p50)')

save "data/derived/tender_data_analysis.dta", replace

* Import country codes and save as .dta
import delimited using "data/raw/country_codes/country_codes.csv", clear

* Variable to match is iso31661alpha3
rename iso31661alpha2 iso_country_code

save "data/derived/country_codes.dta", replace

* Little excursion: Looping in Stata

****************************
* Recall Python loop syntax:
* for i in range(10):
*	print(i)
****************************
* forvalues loop
forvalues i = 0/9 {
	display `i'
}

* foreach (1)
foreach vegetable in paprika aubergine carrot {
	di "`vegetable'"
}

* foreach (2)
foreach var of varlist iso_country_code win_country_code {
	count if strlen(`var') > 2
}







