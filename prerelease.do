// Pre-Release of MosaiCH Data
// January 2018

cd H:\Dokumente_SOZ\Arbeitsmarkt\P3_Vignetten\MOSAiCH\2018\Prerelease18
use mosaich18_prerelease.dta, clear
use mosaich18_prerelease2.dta, clear
varma

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

*Haupteffekte
qui reg workwith i.v*
eststo m1
reg promote i.v*
eststo m2
qui reg friendswith i.v*
eststo m3

grstyle init
grstyle set plain, grid
grstyle set legend 6, nobox

coefplot m1, bylabel(Work With) || m2, bylabel(Promote) || m3, bylabel(Friends With) || ///
, xline(0) drop(_cons) byopts(row(1))  coeflabels(1.vmale = "Male" 1.vmarried = "Married" ///
1.vhperform = "High Performance" 1.vhorigin = "High Social Origin" ///
1.vhasp = "High Aspirations" 1.vreligion = "Religious")
graph export Haupteffekte.png, replace

esttab m* using Haupteffekte.rtf, replace

varma
fre RS33a_w2

reg workwith i.RS33a_w2
// Interaktion mit gender
qui reg workwith i.vh* i.vmar i.vrel if vmale==1
eststo m1
qui reg promote i.vh* i.vmar i.vrel if vmale==1
eststo m2
qui reg friendswith i.vh* i.vmar i.vrel if vmale==1
eststo m3

qui reg workwith i.vh* i.vmar i.vrel if vmale==0
eststo f1
qui reg promote i.vh* i.vmar i.vrel if vmale==0
eststo f2
qui reg friendswith i.vh* i.vmar i.vrel if vmale==0
eststo f3

coefplot (m1, label (Men)) (f1, label (Women)), bylabel(Work With) || ///
         (m2, label (Men)) (f2, label (Women)), bylabel(Promote) || ///
         (m3, label (Men)) (f3, label (Women)), bylabel(Friends With) || ///
         , xline(0) drop(_cons) byopts(row(1)) ///
         coeflabels(1.vmarried = "Married" ///
         1.vhperform = "High Performance" 1.vhorigin = "High Social Origin" ///
         1.vhasp = "High Aspirations" 1.vreligion = "Religious")
         graph export Interaktion.png, replace

         esttab m* f* using Interaktion.rtf, replace

fre DEMO1
gen male = DEMO1
recode male (2=0) (-2=.)
lab val male vmale
fre male

// By gender of respondent

reg workwith i.vmale##i.vmarried if male==1
eststo m1
reg promote i.vmale##i.vmarried if male==1
eststo m2
reg friendswith i.vmale##i.vmarried if male==1
eststo m3

reg workwith i.vmale##i.vmarried if male==0
eststo f1
reg promote i.vmale##i.vmarried if male==0
eststo f2
reg friendswith i.vmale##i.vmarried if male==0
eststo f3



         graph export Respondent.png, replace

         esttab m* f* using Respondent.rtf, replace
