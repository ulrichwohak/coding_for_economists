* Import data
use "data/derived/tender_data_analysis.dta", clear

* Keep only tenders with a single winning country
keep if strlen(win_country_code) == 2

* Create variable that shows whether winning country is the same as issuing country
// gen same_country = 0
// replace same_country = 1 if iso_country_code == win_country_code

gen same_country = (iso_country_code == win_country_code)

* Tabulate frequency
tabulate same_country // Strong home bias.

* Does the value of the tender differ if home firm wins?
* In levels
reg award_value_euro same_country

* In logs
reg ln_award_value_euro same_country, coeflegend
di exp(_b[same_country])-1

* Merge country info
merge m:1 iso_country_code using "data/derived/country_codes.dta", keepusing(untermenglishshort) keep(1 3)
assert _merge == 1 if iso_country_code == "UK" // it seems UK is coded differently in country_codes.dta

* Now we also want to look at multi-country tenders
use "data/derived/tender_data_analysis.dta", clear

drop if missing(win_country_code)

* We wanna check whether the issuing country is contained in the the winning countries
gen same_country = strpos(win_country_code, iso_country_code) // yields starting index of win_country_code
replace same_country = 1 if same_country > 1

* Do the same things but differently
gen same_country2 = 0

split win_country_code, parse("---") generate(country_)

forvalues i = 1 / `r(k_new)' {
	
	replace same_country2 = 1 if iso_country_code == country_`i' // This is robust.
	drop country_`i'
}

