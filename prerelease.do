// Pre-Release of MosaiCH Data
// January 2018

cd H:\Dokumente_SOZ\Arbeitsmarkt\P3_Vignetten\MOSAiCH\2018\Prerelease18
use mosaich18_prerelease.dta, clear

fre RS33a_w2 RS33b_w2 RS33c_w2 RS33d_w2 RS33e_w2 RS33f_w2
gen vmale = RS33a_w2
gen vhperform = RS33b_w2
gen vhorigin = RS33c_w2
gen vmarried = RS33d_w2
gen vhasp = RS33e_w2
gen vreligion = RS33f_w2

recode vmale (2=0)
recode vmarried (2=0)
recode vhperform (2=1) (1=0)
recode vhorigin (2=1) (1=0)
recode vhasp (2=1) (1=0)
recode vreli (2=1) (1=0)

lab def vmale 0 "female" 1 "male"
lab val vmale vmale
lab def vmarried 0 "single" 1 "married"
lab val vmarried vmarried
lab def hilo 0 "low" 1 "high"
lab val vh* hilo
lab def vreli 0 "not religious" 1 "religious"
lab val vreligion vreli

gen workwith = RS34_w2
gen promote = RS35_w2
gen friendswith = RS36_w2

mvdecode workwith promote friendswith, mv(-6 -2 -1 12)

save mosaich18_prerelease2.dta, replace
fre v*
fre workwith promote friendswith
fre RS34_w2 RS35_w2 RS36_w2

//Analysen

use mosaich18_prerelease2.dta, clear

qui reg workwith i.vmale
qui margins vmale, post
eststo m1
qui reg promote i.vmale
qui margins vmale, post
eststo m2
qui reg friendswith i.vmale
qui margins vmale, post
eststo m3

coefplot m1 m2 m3, xline(0) aseq

reg workwith i.vmale##i.vmarried
reg promote i.vmale##i.vmarried
reg friendswith i.vmale##i.vmarried

reg workwith i.vmale##i.vhperform
reg promote i.vmale##i.vhperform
reg friendswith i.vmale##i.vhperform

reg workwith i.vhorigin
reg promote i.vhorigin
reg friendswith i.vhorigin

reg workwith i.vmale##i.vhorigin
reg promote i.vmale##i.vhorigin
reg friendswith i.vmale##i.vhorigin

reg workwith i.vmale##i.vhasp
reg promote i.vmale##i.vhasp
reg friendswith i.vmale##i.vhasp
