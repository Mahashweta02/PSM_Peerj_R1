***Total women in NFHS-5= 724115
***Dropping women who are 25-49 to whom the MH questions were not asked. dropped= 482,935
***Remaining young women 15-25= 241,180
***Deleting observations whom STI symptoms questions were not asked and those who never heard of STIs
drop if v750==.
*(205,063 observations deleted)
 drop if v750==0
*(4,175 observations deleted)
***Dropped 209,238. Remaining 31,942
***Dropping women who didn't  response to symptoms questions or responded don't know
drop if v763b==.
(29 observations deleted)
 drop if v763b==8
(21 observations deleted)
. drop if v763c==8
(9 observations deleted)
*total dropped 59, remaining= 31,883

*treatment
gen hygiene=.
replace hygiene=1 if s260b==1| s260c==1| s260d==1| s260e==1
replace hygiene=0 if s260a==1| s260f==1| s260x==1
recode hygiene (0 .=0 "unhygienic") (1=1 "hygienic"), gen (hygiene1)

*in case we need unhygienic materials use, I made a separate variable for unhygienic materials 
gen unhygiene=.
replace unhygiene=0 if s260b==1| s260c==1| s260d==1| s260e==1
replace unhygiene=1 if s260a==1| s260f==1| s260x==1
recode unhygiene (0 .=0 "hygienic") (1=1 "only unhygienic"), gen (unhygiene1)


*Outcome
gen rti=.
replace rti=1 if v763b==1|v763c==1
recode rti (.=0 "no rti") (1=1 "any symptoms of rti"), g (rti1)



*current age
*continuous
v012
*categorical 
v013

*age at menarche
s259
*dropping don't know values
drop if s259==98
*94 obs deleted
*categorical age menarche for prevalence
recode s259 (7/12=1 "=<12") (13/15=2 "13-15") (16/24=3 "=<16"), gen(age_menarche)
drop if age_menarche==.
*(89 observations deleted)


*social group
recode s116 (1=1 "SC") (2=2 "ST") (3=3 "OBC") (4=4 "Other") (. 8=0 "missing and dont know") , gen (social_grp)
label variable social_grp "social groups"
recode social_grp (3 4=0 "non SC/ST") (1 2=1 "SC/ST"), gen (SC_ST)
drop if social_grp==0
*1592 obs deleted

*Religion
recode v130 (1=1 "Hindu") (2=2 "muslim") (3=3 "christian") (4/96=4 "others"), gen(religion)
recode religion (2 3 4=0 "non-hindu") (1=1 "hindu"), gen (hindu)

*wealth factor score 
v191
*wealth quintile
v190

*education in years
v133
*years of schooling categorical
recode v133 (0=0 "no education") (1/5=1 "1-5 years") (6/10=2 "6-10 years") (11/20=3 "11 years and above"), gen (schooling)

*mass media exposure
gen mass_media=v157+v158+v159
label variable mass_media "addition of newspaper, radio, TV"  
recode mass_media (0=0 "No_exposure to mass media") (1/9=1 "at least exposed to any one kind of mass media"), gen (mass_media_exposure)

*place of residence
v025

*did you take bath during menstruation
s264
drop if s264==.
(2,125 observations deleted)


*discussed MH with CHW
s365s

*condom use (female and male condom)
gen condom=.
replace condom=1 if s321f==1| s321g==1
tab condom
replace condom=0 if condom==.
tab condom

*Region of residence
recode v024 (1 2 3 8 6 4 7 37 5=1 "north") (9 23 22 =2 "central") (10 20 19 21 =3 "east") (24 27 30 25 =4 "west") (32 29 28 33 35 34 36 31 =5 "southern") (11 12 18 17 14 15 13 16 =6 "north-east"), gen (zones_india)
label variable zones_india "Zones of India"
tab zones_india, gen (region)

*working status
v714

*******FINAL SAMPLE SIZE 27,983 ****

******Matching variables 
//v012   respondent's current age
//s259   age at first monthly period
//v133   education in single years
//SC_ST  RECODE of social_grp (social groups)
//hindu  RECODE of religion (RECODE of v130 (religion))
//v191   wealth index factor score combined (5 decimals)
//mass_media_exposure RECODE of mass_media (addition of newspaper, radio, TV)
//s365s  services/matters talked about in last 3 months: menstrual hygiene
//v025   type of place of residence
//s264   do you take a bath during your menstrual period ?
//condom condom used by male female
//s720    do you drink alcohol
//v714 respondent currently working
//region2   zones_india==central
//region3   zones_india==east
//region4   zones_india==west
//region5   zones_india==southern
//region6   zones_india==north-east

global xlist v012 s259 v133 SC_ST hindu v191 mass_media_exposure s365s v714 s264 condom s720 v025 region2 region3 region4 region5 region6
psmatch2 hygiene1 $xlist, outcome(rti1) neighbor(1) cal(0.2) common quietly ate
pstest $xlist, both gr
psgraph


tab1 v013 age_menarche schooling social_grp religion v190 mass_media_exposure s365s v714 s264 condom s720 v025 zones_india [aw=wt]
