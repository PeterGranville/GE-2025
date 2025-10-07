
#### Setup ####

library(readxl)
library(scales)
library(plotly)
library(stringr)
library(zipcodeR)
library(geosphere)
library(tidyverse)
library(RColorBrewer)

#### End ####

###########################################
#### ACS PUMS data                     ####
#### (Do once then it's not needed)    ####
###########################################

# #### State lookup ####
# 
# stabbr <- data.frame(
#   `ST` = numeric(),
#   `STABBR` = character()
# )
# 
# stabbr <- stabbr %>% add_row(`ST`=1, `STABBR`="AL")
# stabbr <- stabbr %>% add_row(`ST`=2, `STABBR`="AK")
# stabbr <- stabbr %>% add_row(`ST`=4, `STABBR`="AZ")
# stabbr <- stabbr %>% add_row(`ST`=5, `STABBR`="AR")
# stabbr <- stabbr %>% add_row(`ST`=6, `STABBR`="CA")
# stabbr <- stabbr %>% add_row(`ST`=8, `STABBR`="CO")
# stabbr <- stabbr %>% add_row(`ST`=9, `STABBR`="CT")
# stabbr <- stabbr %>% add_row(`ST`=10, `STABBR`="DE")
# stabbr <- stabbr %>% add_row(`ST`=11, `STABBR`="DC")
# stabbr <- stabbr %>% add_row(`ST`=12, `STABBR`="FL")
# stabbr <- stabbr %>% add_row(`ST`=13, `STABBR`="GA")
# stabbr <- stabbr %>% add_row(`ST`=15, `STABBR`="HI")
# stabbr <- stabbr %>% add_row(`ST`=16, `STABBR`="ID")
# stabbr <- stabbr %>% add_row(`ST`=17, `STABBR`="IL")
# stabbr <- stabbr %>% add_row(`ST`=18, `STABBR`="IN")
# stabbr <- stabbr %>% add_row(`ST`=19, `STABBR`="IA")
# stabbr <- stabbr %>% add_row(`ST`=20, `STABBR`="KS")
# stabbr <- stabbr %>% add_row(`ST`=21, `STABBR`="KY")
# stabbr <- stabbr %>% add_row(`ST`=22, `STABBR`="LA")
# stabbr <- stabbr %>% add_row(`ST`=23, `STABBR`="ME")
# stabbr <- stabbr %>% add_row(`ST`=24, `STABBR`="MD")
# stabbr <- stabbr %>% add_row(`ST`=25, `STABBR`="MA")
# stabbr <- stabbr %>% add_row(`ST`=26, `STABBR`="MI")
# stabbr <- stabbr %>% add_row(`ST`=27, `STABBR`="MN")
# stabbr <- stabbr %>% add_row(`ST`=28, `STABBR`="MS")
# stabbr <- stabbr %>% add_row(`ST`=29, `STABBR`="MO")
# stabbr <- stabbr %>% add_row(`ST`=30, `STABBR`="MT")
# stabbr <- stabbr %>% add_row(`ST`=31, `STABBR`="NE")
# stabbr <- stabbr %>% add_row(`ST`=32, `STABBR`="NV")
# stabbr <- stabbr %>% add_row(`ST`=33, `STABBR`="NH")
# stabbr <- stabbr %>% add_row(`ST`=34, `STABBR`="NJ")
# stabbr <- stabbr %>% add_row(`ST`=35, `STABBR`="NM")
# stabbr <- stabbr %>% add_row(`ST`=36, `STABBR`="NY")
# stabbr <- stabbr %>% add_row(`ST`=37, `STABBR`="NC")
# stabbr <- stabbr %>% add_row(`ST`=38, `STABBR`="ND")
# stabbr <- stabbr %>% add_row(`ST`=39, `STABBR`="OH")
# stabbr <- stabbr %>% add_row(`ST`=40, `STABBR`="OK")
# stabbr <- stabbr %>% add_row(`ST`=41, `STABBR`="OR")
# stabbr <- stabbr %>% add_row(`ST`=42, `STABBR`="PA")
# stabbr <- stabbr %>% add_row(`ST`=44, `STABBR`="RI")
# stabbr <- stabbr %>% add_row(`ST`=45, `STABBR`="SC")
# stabbr <- stabbr %>% add_row(`ST`=46, `STABBR`="SD")
# stabbr <- stabbr %>% add_row(`ST`=47, `STABBR`="TN")
# stabbr <- stabbr %>% add_row(`ST`=48, `STABBR`="TX")
# stabbr <- stabbr %>% add_row(`ST`=49, `STABBR`="UT")
# stabbr <- stabbr %>% add_row(`ST`=50, `STABBR`="VT")
# stabbr <- stabbr %>% add_row(`ST`=51, `STABBR`="VA")
# stabbr <- stabbr %>% add_row(`ST`=53, `STABBR`="WA")
# stabbr <- stabbr %>% add_row(`ST`=54, `STABBR`="WV")
# stabbr <- stabbr %>% add_row(`ST`=55, `STABBR`="WI")
# stabbr <- stabbr %>% add_row(`ST`=56, `STABBR`="WY")
# stabbr <- stabbr %>% add_row(`ST`=72, `STABBR`="PR")
# 
# #### End ####
# 
# #### Load data ####
# 
# readPUMS <- function(filename){
#   
#   tempDF <- read.csv(
#     filename, header=TRUE
#   ) %>% select(
#     `SERIALNO`,
#     `PWGTP`,
#     `ADJINC`,
#     `ST`,
#     `AGEP`,
#     `PERNP`,
#     `ESR`,
#     `SCHL`,
#     `SCH`,
#     `FOD1P`
#   ) %>% mutate(
#     `PERNP` = `PERNP` * (`ADJINC` / 1000000)
#   ) %>% filter(
#     `AGEP` %in% (25:34),
#     `ESR` %in% c(
#       1, # Civilian employed, at work
#       2, # Civilian employed, with a job but not at work
#       4, # Armed forces, at work
#       5  # Armed forces, with a job but not at work
#     ),
#     `SCHL` %in% c(
#       16, # Regular high school diploma
#       17, # GED or alternative credential
#       21  # Bachelor's degree
#     ),
#     `SCH`==1 # Has not attended school in the last 3 months
#   )
#   
#   return(tempDF)
#   rm(tempDF)
#   
# }
# 
# pums <- rbind(
#   readPUMS("psam1519_pusa.csv"),
#   readPUMS("psam1519_pusb.csv"),
#   readPUMS("psam1519_pusc.csv"),
#   readPUMS("psam1519_pusd.csv")
# ) 
# pums <- left_join(x=pums, y=stabbr, by="ST")
# 
# pums <- pums[sample(1:nrow(pums)), ] # Shuffle order
# 
# #### End ####
# 
# #### Write function ####
# 
# findMedian <- function(data1, rowPercent, HSBS, selectedState, selectedCIP){
# 
#   tempDF <- data1
# 
#   if(HSBS=="High school diploma"){
#     tempDF <- tempDF %>% filter(
#       `SCHL` %in% c(16, 17)
#     )
#   }else{
#     if(HSBS=="Bachelor's degree"){
#       tempDF <- tempDF %>% filter(
#         `SCHL`==21
#       )
#     }else{
#       stop("Bad HSBS")
#     }
#   }
# 
#   if(selectedState != "U.S."){
#     tempDF <- tempDF %>% filter(
#       `STABBR`==selectedState
#     )
#   }
# 
#   if(selectedCIP != "All"){
#     tempDF <- tempDF %>% filter(
#       substr(`FOD1P`, 1, 2)==selectedCIP
#     )
#   }
# 
#   if(nrow(tempDF) > 0){
# 
#     tempDF <- tempDF[(1:ceiling(nrow(tempDF) * rowPercent)), ]
# 
#     medianDF <- numeric() # Establish empty vector
# 
#     for(i in (1:nrow(tempDF))){
# 
#       medianDF <- c(
#         medianDF,
#         rep(
#           tempDF$`PERNP`[i], # Earnings
#           tempDF$`PWGTP`[i]  # Weight
#         )
#       )
# 
#     }
#     rm(i)
# 
#     newMedian <- median(medianDF)
# 
#     returnDF <- data.frame(
#       `State` = selectedState,
#       `CIP` = selectedCIP,
#       `Education level` = HSBS,
#       `Population size` = sum(tempDF$PWGTP),
#       `ACS n-size` = nrow(tempDF),
#       `Coverage level` = percent(rowPercent, accuracy=0.1),
#       `Median` = newMedian,
#       check.names=FALSE
#     )
# 
#     return(returnDF)
#     rm(returnDF, newMedian)
# 
#   }else{
#     return(data.frame(
#       `State` = character(),
#       `CIP` = character(),
#       `Education level` = character(),
#       `Population size` = numeric(),
#       `ACS n-size` = numeric(),
#       `Coverage level` = numeric(),
#       `Median` = numeric(),
#       check.names=FALSE
#     ))
#   }
# 
#   rm(tempDF)
# 
# }
# 
# #### End ####
# 
# #### List all states and CIPs ####
# 
# stateList <- c(unique(pums$STABBR), "U.S.")
# cipList <- c(unique(substr(pums$FOD1P, 1, 2)), "All")
# cipList <- cipList[is.na(cipList)==FALSE]
# 
# #### End ####
# 
# #### Run all high school diploma combos ####
# 
# setRowPercent <- 1
# for(i in (1:length(stateList))){
# 
#   print(paste("Running i=", i, " out of ", length(stateList), sep=""))
# 
#   if(i == 1){
#     highschoolThresholds <- findMedian(
#       data1 = pums,
#       rowPercent = setRowPercent,
#       HSBS = "High school diploma",
#       selectedState = stateList[i],
#       selectedCIP = "All"
#     )
#   }else{
#     highschoolThresholds <- rbind(
#       highschoolThresholds,
#       findMedian(
#         data1 = pums,
#         rowPercent = setRowPercent,
#         HSBS = "High school diploma",
#         selectedState = stateList[i],
#         selectedCIP = "All"
#       )
#     )
#   }
# }
# rm(i, setRowPercent)
# 
# #### End ####
# 
# #### Run all bachelor's degree combos ####
# 
# setRowPercent <- 1
# for(i in (1:length(stateList))){
#   for(j in (1:length(cipList))){
# 
#     print(paste("Running i=", i, " out of ", length(stateList), " and j=", j, " out of ", length(cipList), sep=""))
# 
#     if((i == 1) & (j==1)){
#       bachelorThresholds <- findMedian(
#         data1 = pums,
#         rowPercent = setRowPercent,
#         HSBS = "Bachelor's degree",
#         selectedState = stateList[i],
#         selectedCIP = cipList[j]
#       )
#     }else{
#       bachelorThresholds <- rbind(
#         bachelorThresholds,
#         findMedian(
#           data1 = pums,
#           rowPercent = setRowPercent,
#           HSBS = "Bachelor's degree",
#           selectedState = stateList[i],
#           selectedCIP = cipList[j]
#         )
#       )
#     }
#   }
#   rm(j)
# }
# rm(i, setRowPercent)
# 
# #### End ####
# 
# #### Remove datasets no longer needed ####
# 
# rm(pums, stabbr)
# 
# #### End ####
# 
# #### Save files for future ####
# 
# write.csv(highschoolThresholds, "High school thresholds.csv", row.names=FALSE)
# write.csv(bachelorThresholds, "Bachelor's thresholds.csv", row.names=FALSE)
# 
# #### End ####

#### Load saved files ####

highschoolThresholds <- read.csv("High school thresholds.csv", header=TRUE, check.names=FALSE)
bachelorThresholds <- read.csv("Bachelor's thresholds.csv", header=TRUE, check.names=FALSE)

#### End #### 

#### Correct CIPs from ACS ####

bachelorThresholds <- bachelorThresholds %>% mutate(
  `CIP` = ifelse(
    `CIP`=="All", 
    "All",
    as.character(as.numeric(`CIP`) - 10)
  )
) %>% mutate(
  `CIP` = ifelse(
    nchar(`CIP`)==1, 
    paste("0", `CIP`, sep=""), 
    `CIP`
  )
)

#### End #### 

###########################################
#### IPEDS enrollment data             ####
###########################################

#### State look-up ####

efState <- data.frame(
  `EFCSTATE` = numeric(), 
  `STABBR` = character()
)

efState <- efState %>% add_row(`EFCSTATE`=1, `STABBR` = "AL")
efState <- efState %>% add_row(`EFCSTATE`=2, `STABBR` = "AK")
efState <- efState %>% add_row(`EFCSTATE`=4, `STABBR` = "AZ")
efState <- efState %>% add_row(`EFCSTATE`=5, `STABBR` = "AR")
efState <- efState %>% add_row(`EFCSTATE`=6, `STABBR` = "CA")
efState <- efState %>% add_row(`EFCSTATE`=8, `STABBR` = "CO")
efState <- efState %>% add_row(`EFCSTATE`=9, `STABBR` = "CT")
efState <- efState %>% add_row(`EFCSTATE`=10, `STABBR` = "DE")
efState <- efState %>% add_row(`EFCSTATE`=11, `STABBR` = "DC")
efState <- efState %>% add_row(`EFCSTATE`=12, `STABBR` = "FL")
efState <- efState %>% add_row(`EFCSTATE`=13, `STABBR` = "GA")
efState <- efState %>% add_row(`EFCSTATE`=15, `STABBR` = "HI")
efState <- efState %>% add_row(`EFCSTATE`=16, `STABBR` = "ID")
efState <- efState %>% add_row(`EFCSTATE`=17, `STABBR` = "IL")
efState <- efState %>% add_row(`EFCSTATE`=18, `STABBR` = "IN")
efState <- efState %>% add_row(`EFCSTATE`=19, `STABBR` = "IA")
efState <- efState %>% add_row(`EFCSTATE`=20, `STABBR` = "KS")
efState <- efState %>% add_row(`EFCSTATE`=21, `STABBR` = "KY")
efState <- efState %>% add_row(`EFCSTATE`=22, `STABBR` = "LA")
efState <- efState %>% add_row(`EFCSTATE`=23, `STABBR` = "ME")
efState <- efState %>% add_row(`EFCSTATE`=24, `STABBR` = "MD")
efState <- efState %>% add_row(`EFCSTATE`=25, `STABBR` = "MA")
efState <- efState %>% add_row(`EFCSTATE`=26, `STABBR` = "MI")
efState <- efState %>% add_row(`EFCSTATE`=27, `STABBR` = "MN")
efState <- efState %>% add_row(`EFCSTATE`=28, `STABBR` = "MS")
efState <- efState %>% add_row(`EFCSTATE`=29, `STABBR` = "MO")
efState <- efState %>% add_row(`EFCSTATE`=30, `STABBR` = "MT")
efState <- efState %>% add_row(`EFCSTATE`=31, `STABBR` = "NE")
efState <- efState %>% add_row(`EFCSTATE`=32, `STABBR` = "NV")
efState <- efState %>% add_row(`EFCSTATE`=33, `STABBR` = "NH")
efState <- efState %>% add_row(`EFCSTATE`=34, `STABBR` = "NJ")
efState <- efState %>% add_row(`EFCSTATE`=35, `STABBR` = "NM")
efState <- efState %>% add_row(`EFCSTATE`=36, `STABBR` = "NY")
efState <- efState %>% add_row(`EFCSTATE`=37, `STABBR` = "NC")
efState <- efState %>% add_row(`EFCSTATE`=38, `STABBR` = "ND")
efState <- efState %>% add_row(`EFCSTATE`=39, `STABBR` = "OH")
efState <- efState %>% add_row(`EFCSTATE`=40, `STABBR` = "OK")
efState <- efState %>% add_row(`EFCSTATE`=41, `STABBR` = "OR")
efState <- efState %>% add_row(`EFCSTATE`=42, `STABBR` = "PA")
efState <- efState %>% add_row(`EFCSTATE`=44, `STABBR` = "RI")
efState <- efState %>% add_row(`EFCSTATE`=45, `STABBR` = "SC")
efState <- efState %>% add_row(`EFCSTATE`=46, `STABBR` = "SD")
efState <- efState %>% add_row(`EFCSTATE`=47, `STABBR` = "TN")
efState <- efState %>% add_row(`EFCSTATE`=48, `STABBR` = "TX")
efState <- efState %>% add_row(`EFCSTATE`=49, `STABBR` = "UT")
efState <- efState %>% add_row(`EFCSTATE`=50, `STABBR` = "VT")
efState <- efState %>% add_row(`EFCSTATE`=51, `STABBR` = "VA")
efState <- efState %>% add_row(`EFCSTATE`=53, `STABBR` = "WA")
efState <- efState %>% add_row(`EFCSTATE`=54, `STABBR` = "WV")
efState <- efState %>% add_row(`EFCSTATE`=55, `STABBR` = "WI")
efState <- efState %>% add_row(`EFCSTATE`=56, `STABBR` = "WY")
efState <- efState %>% add_row(`EFCSTATE`=57, `STABBR` = "State unknown")
efState <- efState %>% add_row(`EFCSTATE`=60, `STABBR` = "AS")
efState <- efState %>% add_row(`EFCSTATE`=64, `STABBR` = "FM")
efState <- efState %>% add_row(`EFCSTATE`=66, `STABBR` = "GU")
efState <- efState %>% add_row(`EFCSTATE`=68, `STABBR` = "MH")
efState <- efState %>% add_row(`EFCSTATE`=69, `STABBR` = "MP")
efState <- efState %>% add_row(`EFCSTATE`=70, `STABBR` = "PW")
efState <- efState %>% add_row(`EFCSTATE`=72, `STABBR` = "PR")
efState <- efState %>% add_row(`EFCSTATE`=78, `STABBR` = "VI")
efState <- efState %>% add_row(`EFCSTATE`=90, `STABBR` = "Foreign countries")
efState <- efState %>% add_row(`EFCSTATE`=98, `STABBR` = "Residence not reported")

#### End #### 

#### Load data ####

ef2023c <- read.csv(
  "ef2023c.csv", header=TRUE
) %>% select(
  `UNITID`,   # Unique identification number of the institution
  `EFCSTATE`, # State of residence when student was first admitted
  `EFRES01`   # First-time degree/certificate-seeking undergraduate students
) %>% filter(
  (`EFCSTATE` %in% c(
    99, # All first-time degree/certificate seeking undergraduates, total
    58, # US total
    57, # State unknown
    89, # Outlying areas total
    98  # Residence not reported
  ))==FALSE
)
ef2023c <- left_join(
  x=ef2023c, y=efState, by="EFCSTATE"
) %>% rename(
  `Student state` = `STABBR`
)
rm(efState)

hd <- read.csv(
  "hd2023.csv", header=TRUE
) %>% select(
  `UNITID`,
  `OPEID`,
  `STABBR`
) %>% rename(
  `Institution state` = `STABBR`
) %>% mutate(
  `OPEID8` = `OPEID`
) %>% mutate(
  `OPEID8` = as.character(`OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==1, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==2, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==3, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==4, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==5, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==6, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID8` = ifelse(nchar(`OPEID8`)==7, paste("0", `OPEID8`, sep=""), `OPEID8`)
) %>% mutate(
  `OPEID6` = substr(`OPEID8`, 1, 6)
)
ef2023c <- left_join(x=ef2023c, y=hd, by="UNITID")
rm(hd)

#### End #### 

#### Find whether each institution gets 50+% of its students from within its same state ####

ef2023c <- ef2023c %>% mutate(
  `Student state` = ifelse(
    `Student state` == `Institution state`, "In-state", "Out-of-state"
  )
)

inStateShares <- aggregate(
  data=ef2023c, 
  `EFRES01` ~ `OPEID6` + `Student state`, 
  FUN=sum
) %>% pivot_wider(
  id_cols=c(`OPEID6`), 
  names_from=`Student state`,
  values_from=`EFRES01`
) %>% mutate(
  `In-state` = ifelse(is.na(`In-state`), 0, `In-state`), 
  `Out-of-state` = ifelse(is.na(`Out-of-state`), 0, `Out-of-state`)
) %>% mutate(
  `Classification` = ifelse(
    `In-state` < 0.5 * (`In-state` + `Out-of-state`), 
    "Majority out-of-state", 
    "Majority in-state"
  )
) %>% select(
  -(`In-state`), -(`Out-of-state`)
)
rm(ef2023c)

#### End #### 

###########################################
#### Data on online enrollment         ####
###########################################

#### Loading HD data and creating OPEID6 variable ####

hd <- read.csv(
  "hd2019.csv", header=TRUE
) %>% select(
  `UNITID`, 
  `OPEID`
) %>% filter(
  `OPEID` != "-2"
)

hd$OPEID <- as.character(hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==1, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==2, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==3, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==4, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==5, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==6, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID <- ifelse(nchar(hd$OPEID)==7, paste("0", hd$OPEID, sep=""), hd$OPEID)
hd$OPEID6 <- as.numeric(substr(hd$OPEID, 1, 6))
hd <- hd %>% select(`UNITID`, `OPEID6`)

#### End ####  

#### Loading distance education data and merging OPEID6 variable ####

cdep <- read.csv("c2019dep_rv.csv", header=TRUE)

cdep <- right_join(x=hd, y=cdep, by="UNITID")
rm(hd)

#### End #### 

#### Organizing by 4-digit CIP code ####

cdep <- cdep %>% filter(
  substr(`CIPCODE`, 3, 7) != "     "
) # Remove 2-digit CIP entries

cdep <- cdep %>% mutate(
  `CIP4` = as.numeric(
    paste(substr(`CIPCODE`, 1, 2), substr(`CIPCODE`, 4, 5), sep="")
  )
)

#### End #### 

#### Organizing by credential level ####

cdep <- cdep %>% select(
  -(`PTOTAL`), -(`PTOTALDE`), -(`CIPCODE`), -(`UNITID`)
)

cdep <- cdep %>% pivot_longer(
  cols=c(`PASSOC`, `PASSOCDE`, 
         `PBACHL`, `PBACHLDE`, 
         `PMASTR`, `PMASTRDE`, 
         `PDOCRS`, `PDOCRSDE`, 
         `PDOCPP`, `PDOCPPDE`, 
         `PDOCOT`, `PDOCOTDE`, 
         `PCERT1`, `PCERT1DE`, 
         `PCERT2`, `PCERT2DE`, 
         `PCERT4`, `PCERT4DE`, 
         `PPBACC`, `PPBACCDE`, 
         `PPMAST`, `PPMASTDE`
  ), names_to='Variable', values_to='Programs')
joiner1 <- data.frame(
  "Variable"=c(
    "PASSOC", 
    "PASSOCDE", 
    "PBACHL", 
    "PBACHLDE", 
    "PMASTR", 
    "PMASTRDE", 
    "PDOCRS", 
    "PDOCRSDE", 
    "PDOCPP", 
    "PDOCPPDE", 
    "PDOCOT", 
    "PDOCOTDE", 
    "PCERT1", 
    "PCERT1DE", 
    "PCERT2", 
    "PCERT2DE", 
    "PCERT4", 
    "PCERT4DE", 
    "PPBACC", 
    "PPBACCDE", 
    "PPMAST", 
    "PPMASTDE"), 
  "cred_lvl"=c(
    "Associate's", 
    "Associate's", 
    "Bachelor's", 
    "Bachelor's", 
    "Master's", 
    "Master's", 
    "Doctoral", 
    "Doctoral", 
    "Professional", 
    "Professional", 
    "Professional", 
    "Professional", 
    "UG Certificates", 
    "UG Certificates", 
    "UG Certificates", 
    "UG Certificates", 
    "UG Certificates", 
    "UG Certificates", 
    "Post-BA Certs", 
    "Post-BA Certs", 
    "Grad Certs", 
    "Grad Certs"
))

joiner2 <- data.frame(
  "Variable"=c(
    "PASSOC", 
    "PASSOCDE", 
    "PBACHL", 
    "PBACHLDE", 
    "PMASTR", 
    "PMASTRDE", 
    "PDOCRS", 
    "PDOCRSDE", 
    "PDOCPP", 
    "PDOCPPDE", 
    "PDOCOT", 
    "PDOCOTDE", 
    "PCERT1", 
    "PCERT1DE", 
    "PCERT2", 
    "PCERT2DE", 
    "PCERT4", 
    "PCERT4DE", 
    "PPBACC", 
    "PPBACCDE", 
    "PPMAST", 
    "PPMASTDE"
), "distance"=rep(c("Total", "Distance"), 11))

cdep <- left_join(x=cdep, y=joiner1, by="Variable")
cdep <- left_join(x=cdep, y=joiner2, by="Variable")
rm(joiner1, joiner2)

#### End #### 

#### Aggregating by unique identifiers #### 

online.programs <- aggregate(
  data=cdep, 
  `Programs` ~ `OPEID6` + `CIP4` + `cred_lvl` + `distance`, 
  FUN=sum
)
rm(cdep)

online.programs <- online.programs %>% pivot_wider(
  names_from=`distance`, 
  values_from=`Programs`
) %>% filter(
  `Total` > 0
) %>% mutate(
  `Distance share` = `Distance` / `Total`
) %>% mutate(
  `Distance status` = ifelse(
    `Distance share` >= 0.5, 
    "Online program", 
    "Not an online program"
  )
) 

#### End #### 

#### Preparing to join with GE data ####

online.programs <- online.programs %>% select(
  `OPEID6`, 
  `CIP4`, 
  `cred_lvl`, 
  `Distance status`
) %>% rename(
  `opeid6` = `OPEID6`, 
  `cip4` = `CIP4`
)

#### End #### 

###########################################
#### Proximity of Alternative Options  ####
###########################################

#### Load in GE program data ####

ge <- read_excel(
  path="nprm-2022ppd-public-suppressed.xlsx", 
  col_names=TRUE
) %>% select(
  `schname`, 
  `inGE`, 
  `opeid6`, 
  `stabbr`, 
  `zip`,
  `control_peps`,
  `cip4`, 
  `cipdesc`, 
  `cip2`, 
  `cip2_title_2010`, 
  `cred_lvl`, 
  `passfail_2019`, 
  `mdearnp3`,
  `count_AY1617`
) %>% filter(
  (`control_peps` %in% c(
    "Foreign For-Profit", 
    "Foreign Private")
  )==FALSE, 
  (`stabbr` %in% c("AS", "FM", "GU", "MH", "MP", "PR", "PW", "VI"))==FALSE
) 
ge.level.category <- data.frame(
  "cred_lvl" = c(
    "UG Certificates", 
    "Associate's", 
    "Bachelor's",
    "Post-BA Certs",
    "Grad Certs", 
    "Master's", 
    "Professional",
    "Doctoral"
), "Category" = c(
    "Undergraduate", 
    "Undergraduate", 
    "Undergraduate", 
    "Undergraduate", 
    "Graduate", 
    "Graduate", 
    "Graduate", 
    "Graduate"
))

ge <- left_join(
  x=ge, 
  y=ge.level.category, 
  by="cred_lvl"
) %>% mutate(
  `zip` = substr(`zip`, 1, 5)
)
rm(ge.level.category)

#### End #### 

#### Import information on online programs ####

ge <- left_join(x=ge, y=online.programs, by=c("opeid6", "cip4", "cred_lvl"))

#### End #### 

#### Import data for LEP ####

inStateShares <-inStateShares %>% rename(
  `opeid6` = `OPEID6`
) %>% mutate(
  `opeid6` = as.numeric(`opeid6`)
) %>% filter(
  is.na(`opeid6`)==FALSE
)
ge <- left_join(x=ge, y=inStateShares, by="opeid6")

highschoolThresholds1 <- highschoolThresholds %>% filter(
  `State` != "U.S."
) %>% rename(
  `stabbr` = `State`,
  `Median earnings (high school, same state)` = `Median`
) %>% select(
  `stabbr`, 
  `Median earnings (high school, same state)`
)
ge <- left_join(x=ge, y=highschoolThresholds1, by="stabbr")
rm(highschoolThresholds1)

highschoolThresholds2 <- highschoolThresholds %>% filter(
  `State` == "U.S."
) 
ge <- ge %>% mutate(
  `Median earnings (high school, nationwide)` = rep(highschoolThresholds2$`Median`[1])
)
rm(highschoolThresholds2)

bachelorThresholds1 <- bachelorThresholds %>% filter(
  `State` != "U.S.", 
  `CIP` != "All"
) %>% rename(
  `stabbr` = `State`,
  `cip2` = `CIP`,
  `Median earnings (bachelor's, same state, same CIP)` = `Median`
) %>% select(
  `stabbr`,
  `cip2`,
  `Median earnings (bachelor's, same state, same CIP)`
) %>% mutate(
  `cip2` = as.numeric(`cip2`)
)
ge <- left_join(x=ge, y=bachelorThresholds1, by=c("stabbr", "cip2"))
rm(bachelorThresholds1)

bachelorThresholds2 <- bachelorThresholds %>% filter(
  `State` != "U.S.", 
  `CIP` == "All"
) %>% rename(
  `stabbr` = `State`,
  `Median earnings (bachelor's, same state, all CIPs)` = `Median`
) %>% select(
  `stabbr`,
  `Median earnings (bachelor's, same state, all CIPs)`
)
ge <- left_join(x=ge, y=bachelorThresholds2, by="stabbr")
rm(bachelorThresholds2)

bachelorThresholds3 <- bachelorThresholds %>% filter(
  `State` == "U.S.", 
  `CIP` != "All"
) %>% rename(
  `cip2` = `CIP`,
  `Median earnings (bachelor's, nationwide, same CIP)` = `Median`
) %>% select(
  `cip2`,
  `Median earnings (bachelor's, nationwide, same CIP)`
) %>% mutate(
  `cip2` = as.numeric(`cip2`)
)
ge <- left_join(x=ge, y=bachelorThresholds3, by="cip2")
rm(bachelorThresholds3)

bachelorThresholds4 <- bachelorThresholds %>% filter(
  `State` == "U.S.", 
  `CIP` == "All"
) 
ge <- ge %>% mutate(
  `Median earnings (bachelor's, nationwide, all CIPs)` = rep(bachelorThresholds4$`Median`[1])
)
rm(bachelorThresholds4)

#### End #### 

#### Assign LEP outcomes ####

ge <- ge %>% mutate(
  `inLEP` = ifelse(
    `cred_lvl` != "UG Certificates", 
    1,
    0
  ), 
  `LEP threshold` = ifelse(
    `Category`=="Undergraduate", 
    
    # Undergraduate logic
    ifelse(
      `Classification`=="Majority in-state",
      `Median earnings (high school, same state)`,
      `Median earnings (high school, nationwide)`
    ),
    
    # Graduate logic 
    ifelse(
      `Classification`=="Majority in-state",
      pmin(
        `Median earnings (bachelor's, same state, all CIPs)`, 
        `Median earnings (bachelor's, same state, same CIP)`, 
        `Median earnings (bachelor's, nationwide, same CIP)`, 
        na.rm=TRUE
      ),
      pmin(
        `Median earnings (bachelor's, nationwide, all CIPs)`, 
        `Median earnings (bachelor's, nationwide, same CIP)`, 
        na.rm=TRUE
      )
    )
  )
) %>% mutate(
  `passfailLEP` = ifelse(
    is.na(`mdearnp3`),
    "No LEP data", 
    ifelse(
      `mdearnp3` >= `LEP threshold`, 
      "Pass LEP", 
      "Fail LEP"
    )
  )
)

#### End #### 

#### Make unique IDs ####

ge <- ge %>% mutate(
  `Prog ID` = paste(
    `opeid6`, 
    `cip4`, 
    `cred_lvl`, 
    sep="..."
  )
)

#### End #### 

calc_dist <- function(gedata, lepSelection, geSelection, levelSelection, cipSelection, fullEarningsData, fullDebtData, runName){
  
  #### Create failingPrograms and passingPrograms #### 
  
  # Start with all programs passing. 
  passingPrograms <- gedata 
  
  # Apply LEP if in place 
  if(lepSelection=="Y"){
    passingPrograms <- passingPrograms %>% filter(
      (`inLEP`==0) | (`passfailLEP` %in% c("No LEP data", "Pass LEP"))
    )
  }
  
  # Apply GE if in place 
  if(geSelection=="Y"){
    passingPrograms <- passingPrograms %>% filter(
      (`inGE`==0) | (`passfail_2019` %in% c("No DTE/EP data", "Pass"))
    )
  }
  
  # Apply fullEarningsData to passing programs  
  if(fullEarningsData==TRUE){
    passingPrograms <- passingPrograms %>% filter(
      is.na(`mdearnp3`)==FALSE
    )
  }
  
  # Apply fullDebtData to passing programs  
  if(fullDebtData==TRUE){
    passingPrograms <- passingPrograms %>% filter(
      is.na(`debtservicenpp_md`)==FALSE
    )
  }
  
  # Failing programs are all those not passing 
  failingPrograms <- gedata %>% filter(
    (`Prog ID` %in% passingPrograms$`Prog ID`)==FALSE
  )
  
  failingPrograms <- failingPrograms %>% mutate(
    `Distance to nearest alternative` = rep(NA)
  )
  
  #### End #### 
  
  #### Empty variables for recording the alternative ####
  
  failingPrograms <- failingPrograms %>% mutate(
    `Distance to nearest alternative` = rep(NA), 
    `alt_schname` = rep(NA),
    `alt_cred_lvl` = rep(NA), 
    `alt_cip4` = rep(NA),
    `alt_zip` = rep(NA), 
    `alt_opeid6` = rep(NA)
  )
  
  #### End #### 
  
  for(i in (1:nrow(failingPrograms))){
    
    print("Trying number ", i, " of ", nrow(failingPrograms), " failing programs in ", runName, " at ", Sys.time(), ".", sep="")
    
    #### Create alternativePrograms, filter by state #### 
    
    alternativePrograms <- passingPrograms %>% mutate(`Distance` = rep(NA))
    
    if(failingPrograms$`stabbr`[i]=="AL"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("AL", "MS", "TN", "GA", "FL"))}
    
    if(failingPrograms$`stabbr`[i]=="AK"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("AK"))}
    
    if(failingPrograms$`stabbr`[i]=="AZ"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("AZ", "CA", "NV", "UT", "CO", "NM"))}
    
    if(failingPrograms$`stabbr`[i]=="AR"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("AR", "MO", "TN", "MS", "LA", "TX", "OK"))}
    
    if(failingPrograms$`stabbr`[i]=="CA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("CA", "AZ", "NV", "OR"))}
    
    if(failingPrograms$`stabbr`[i]=="CO"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("CO", "WY", "NE", "KS", "OK", "NM", "AZ", "UT"))}
    
    if(failingPrograms$`stabbr`[i]=="CT"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("CT", "RI", "MA", "NY", "NJ"))}
    
    if(failingPrograms$`stabbr`[i]=="DE"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("DE", "NJ", "MD", "PA"))}
    
    if(failingPrograms$`stabbr`[i]=="DC"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("DC", "MD", "VA"))}
    
    if(failingPrograms$`stabbr`[i]=="FL"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("FL", "GA", "MS", "AL"))}
    
    if(failingPrograms$`stabbr`[i]=="GA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("GA", "FL", "AL", "TN", "SC", "NC"))}
    
    if(failingPrograms$`stabbr`[i]=="HI"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("HI"))}
    
    if(failingPrograms$`stabbr`[i]=="ID"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("ID", "WA", "OR", "NV", "UT", "WY", "MT"))}
    
    if(failingPrograms$`stabbr`[i]=="IL"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("IL", "WI", "IA", "MO", "KY", "IN", "MI", "TN"))}
    
    if(failingPrograms$`stabbr`[i]=="IN"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("IN", "MI", "OH", "KY", "IL", "WI"))}
    
    if(failingPrograms$`stabbr`[i]=="IA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("IA", "SD", "NE", "MO", "KS", "IL", "WI", "MN"))}
    
    if(failingPrograms$`stabbr`[i]=="KS"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("KS", "NE", "CO", "OK", "MO", "IA"))}
    
    if(failingPrograms$`stabbr`[i]=="KY"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("KY", "IL", "IN", "OH", "WV", "VA", "TN", "MO"))}
    
    if(failingPrograms$`stabbr`[i]=="LA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("LA", "MS", "AR", "TX"))}
    
    if(failingPrograms$`stabbr`[i]=="ME"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("ME", "NH", "MA", "VT"))}
    
    if(failingPrograms$`stabbr`[i]=="MD"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MD", "DC", "VA", "WV", "PA", "DE", "NJ"))}
    
    if(failingPrograms$`stabbr`[i]=="MA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MA", "ME", "NH", "VT", "NY", "CT", "RI"))}
    
    if(failingPrograms$`stabbr`[i]=="MI"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MI", "WI", "IL", "IN", "OH"))}
    
    if(failingPrograms$`stabbr`[i]=="MN"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MN", "ND", "SD", "IA", "WI"))}
    
    if(failingPrograms$`stabbr`[i]=="MS"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MS", "AL", "TN", "FL", "AR", "LA"))}
    
    if(failingPrograms$`stabbr`[i]=="MO"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MO", "IA", "NE", "KS", "OK", "AR", "TN", "KY", "IL"))}
    
    if(failingPrograms$`stabbr`[i]=="MT"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MT", "ID", "WY", "ND", "SD"))}
    
    if(failingPrograms$`stabbr`[i]=="NE"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NE", "SD", "WY", "CO", "KS", "MO", "IA"))}
    
    if(failingPrograms$`stabbr`[i]=="NV"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NV", "ID", "OR", "CA", "AZ", "UT"))}
    
    if(failingPrograms$`stabbr`[i]=="NH"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NH", "ME", "VT", "MA"))}
    
    if(failingPrograms$`stabbr`[i]=="NJ"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NJ", "NY", "CT", "PA", "DE", "MD"))}
    
    if(failingPrograms$`stabbr`[i]=="NM"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NM", "TX", "OK", "CO", "UT", "AZ"))}
    
    if(failingPrograms$`stabbr`[i]=="NY"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NY", "CT", "MA", "VT", "PA", "NJ"))}
    
    if(failingPrograms$`stabbr`[i]=="NC"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("NC", "VA", "TN", "GA", "SC"))}
    
    if(failingPrograms$`stabbr`[i]=="ND"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("ND", "MT", "SD", "MN"))}
    
    if(failingPrograms$`stabbr`[i]=="OH"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("OH", "MI", "IN", "KY", "WV", "MD", "PA"))}
    
    if(failingPrograms$`stabbr`[i]=="OK"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("OK", "KS", "CO", "NM", "TX", "AR", "MO"))}
    
    if(failingPrograms$`stabbr`[i]=="OR"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("OR", "WA", "CA", "NV", "ID"))}
    
    if(failingPrograms$`stabbr`[i]=="PA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("PA", "NY", "NJ", "DE", "MD", "WV", "OH"))}
    
    if(failingPrograms$`stabbr`[i]=="RI"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("RI", "CT", "MA"))}
    
    if(failingPrograms$`stabbr`[i]=="SC"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("SC", "NC", "GA"))}
    
    if(failingPrograms$`stabbr`[i]=="SD"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("SD", "ND", "MT", "WY", "NE", "IA", "MN"))}
    
    if(failingPrograms$`stabbr`[i]=="TN"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("TN", "KY", "MO", "AR", "MS", "AL", "GA", "NC", "VA"))}
    
    if(failingPrograms$`stabbr`[i]=="TX"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("TX", "NM", "OK", "AR", "LA"))}
    
    if(failingPrograms$`stabbr`[i]=="UT"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("UT", "WY", "ID", "NV", "AZ", "NM", "CO"))}
    
    if(failingPrograms$`stabbr`[i]=="VT"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("VT", "ME", "NH", "NY", "CT", "MA", "RI"))}
    
    if(failingPrograms$`stabbr`[i]=="VA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("VA", "MD", "DC", "WV", "KY", "TN", "NC"))}
    
    if(failingPrograms$`stabbr`[i]=="WA"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("WA", "OR", "ID"))}
    
    if(failingPrograms$`stabbr`[i]=="WV"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("WV", "PA", "OH", "KY", "MD", "VA"))}
    
    if(failingPrograms$`stabbr`[i]=="WI"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("WI", "MN", "IA", "IL", "IN", "MI"))}
    
    if(failingPrograms$`stabbr`[i]=="WY"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("WY", "MT", "ID", "UT", "CO", "NE", "SD"))}
    
    if(failingPrograms$`stabbr`[i]=="AS"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("AS"))}
    
    if(failingPrograms$`stabbr`[i]=="GU"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("GU"))}
    
    if(failingPrograms$`stabbr`[i]=="MP"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("MP"))}
    
    if(failingPrograms$`stabbr`[i]=="PR"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("PR"))}
    
    if(failingPrograms$`stabbr`[i]=="UM"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("UM"))}
    
    if(failingPrograms$`stabbr`[i]=="VI"){alternativePrograms <- alternativePrograms %>% filter(`stabbr` %in% c("VI"))}
    
    #### End #### 
    
    #### Apply filters to alternativePrograms #### 
    
    program.level <- failingPrograms$`cred_lvl`[i]
    program.category <- failingPrograms$`Category`[i]
    program.2digCIP <- failingPrograms$`cip2`[i]
    program.4digCIP <- failingPrograms$`cip4`[i]
    
    # Apply the proper level filter to gepassdata
    if(levelSelection=="Same credential level"){
      alternativePrograms <- alternativePrograms %>% filter(
        `cred_lvl` == program.level
      )
    }
    if(levelSelection=="Same credential category"){
      alternativePrograms <- alternativePrograms %>% filter(
        `Category` == program.category
      )
    }
    
    # Apply the proper CIP code filter to gepassdata
    if(cipSelection=="Same 4-digit CIP"){
      alternativePrograms <- alternativePrograms %>% filter(
        `cip4`==program.4digCIP
      )
    }
    if(cipSelection=="Same 2-digit CIP"){
      alternativePrograms <- alternativePrograms %>% filter(
        `cip2`==program.2digCIP
      )
    }  
    
    #### End #### 
    
    #### Calculate ZIP distance #### 
    
    # Only run the next lines if there is remaining passing programs: 
    if(nrow(alternativePrograms) > 0){
      
      # Calculate distance for every other program
      for(j in (1:nrow(alternativePrograms))){
        
        # Set both programs are online, set distance to 0 
        if((failingPrograms$`Distance status`[i]) & (alternativePrograms$`Distance status`[j])){
          alternativePrograms$`Distance`[j] <- 0
          
        # Otherwise, calculate ZIP distance 
        }else{
          alternativePrograms$`Distance`[j] <- zip_distance(
            failingPrograms$`zip`[i], 
            alternativePrograms$`zip`[j], 
            units="miles"
          )$distance
        }
      }
      
      alternativePrograms <- alternativePrograms %>% filter(
        is.na(`Distance`)==FALSE, 
        is.infinite(`Distance`)==FALSE
      ) %>% arrange(
        `Distance`, 
        desc(`mdearnp3`)
      )
      
      failingPrograms$`Distance to nearest alternative`[i] <- suppressWarnings(
        min(alternativePrograms$`Distance`, na.rm=TRUE)
      )
      
      failingPrograms$`alt_schname` <- alternativePrograms$`schname`[1]
      failingPrograms$`alt_cred_lvl` <- alternativePrograms$`cred_lvl`[1]
      failingPrograms$`alt_cip4` <- alternativePrograms$`cip4`[1]
      failingPrograms$`alt_zip` <- alternativePrograms$`zip`[1]
      failingPrograms$`alt_opeid6` <- alternativePrograms$`opeid6`[1]
      
    }else{
      failingPrograms$`Distance to nearest alternative`[i] <- NA
      failingPrograms$`alt_schname` <- NA
      failingPrograms$`alt_cred_lvl` <- NA
      failingPrograms$`alt_cip4` <- NA
      failingPrograms$`alt_zip` <- NA
      failingPrograms$`alt_opeid6` <- NA
    }
    
    #### End #### 
    
    #### Remove objects #### 
    
    rm("alternativePrograms", 
       "program.level", 
       "program.category", 
       "program.2digCIP", 
       "program.4digCIP")
    
    #### End #### 

  }
  return(failingPrograms)
}

#### Run distance function: Full data only ####

setFullEarningsData <- TRUE 
setFullDebtData <- TRUE 
ge.YYL4.FDO <- calc_dist(
  gedata=ge, 
  lepSelection="Y", 
  geSelection="Y", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.YYL4.FDO"
)
ge.YNL4.FDO <- calc_dist(
  gedata=ge, 
  lepSelection="Y", 
  geSelection="N", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.YNL4.FDO"
)
ge.NYL4.FDO <- calc_dist(
  gedata=ge, 
  lepSelection="N", 
  geSelection="Y", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.NYL4.FDO"
)

#### End #### 

#### Run distance function: Not limited to full data #### 

setFullEarningsData <- FALSE 
setFullDebtData <- FALSE 
ge.YYL4.NL <- calc_dist(
  gedata=ge, 
  lepSelection="Y", 
  geSelection="Y", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.YYL4.NL"
)
ge.YNL4.NL <- calc_dist(
  gedata=ge, 
  lepSelection="Y", 
  geSelection="N", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.YNL4.NL"
)
ge.NYL4.NL <- calc_dist(
  gedata=ge, 
  lepSelection="N", 
  geSelection="Y", 
  levelSelection="Same credential level", 
  cipSelection="Same 4-digit CIP", 
  fullEarningsData=setFullEarningsData, 
  fullDebtData=setFullDebtData, 
  runName="ge.NYL4.NL"
)

#### End #### 

# Make calculations (this will take a long time to run)
ge.fail.A <- calc_dist(ge.pass, ge.fail, "Same credential level", "Same 4-digit CIP")
ge.fail.B <- calc_dist(ge.pass, ge.fail, "Same credential level", "Same 2-digit CIP")
ge.fail.D <- calc_dist(ge.pass, ge.fail, "Same credential category", "Same 4-digit CIP")

# Add in the determinations on online programs 
ge.fail.A <- left_join(x=ge.fail.A, y=online.programs, by=c("opeid6", "cip4", "cred_lvl"))
ge.fail.B <- left_join(x=ge.fail.B, y=online.programs, by=c("opeid6", "cip4", "cred_lvl")) 
ge.fail.D <- left_join(x=ge.fail.D, y=online.programs, by=c("opeid6", "cip4", "cred_lvl")) 
ge.fail.A$`Distance to nearest alternative`[ge.fail.A$`Online alternative A`=="Online with an online alternative"] <- 0
ge.fail.B$`Distance to nearest alternative`[ge.fail.B$`Online alternative B`=="Online with an online alternative"] <- 0
ge.fail.D$`Distance to nearest alternative`[ge.fail.D$`Online alternative D`=="Online with an online alternative"] <- 0

# Count the number of students with no alternative within 30 miles 
ge.fail.A$`Students with no nearby options` <- ifelse(ge.fail.A$`Distance to nearest alternative` > 30, ge.fail.A$`count_AY1617`, 0)
ge.fail.B$`Students with no nearby options` <- ifelse(ge.fail.B$`Distance to nearest alternative` > 30, ge.fail.B$`count_AY1617`, 0)
ge.fail.D$`Students with no nearby options` <- ifelse(ge.fail.D$`Distance to nearest alternative` > 30, ge.fail.D$`count_AY1617`, 0)

# Set programs with no alternative within 30 miles to NA
ge.fail.A$`Distance to nearest alternative`[ge.fail.A$`Distance to nearest alternative` > 30] <- NA
ge.fail.B$`Distance to nearest alternative`[ge.fail.B$`Distance to nearest alternative` > 30] <- NA
ge.fail.D$`Distance to nearest alternative`[ge.fail.D$`Distance to nearest alternative` > 30] <- NA

# Average distance, excluding students with no option in 30 miles 
weighted.mean(ge.fail.A$`Distance to nearest alternative`, w = ge.fail.A$`count_AY1617`, na.rm=TRUE)
weighted.mean(ge.fail.B$`Distance to nearest alternative`, w = ge.fail.B$`count_AY1617`, na.rm=TRUE)
weighted.mean(ge.fail.D$`Distance to nearest alternative`, w = ge.fail.D$`count_AY1617`, na.rm=TRUE)

# Share with no option within 30 miles 
sum(ge.fail.A$`Students with no nearby options`, na.rm=TRUE) / sum(ge.fail.A$`count_AY1617`, na.rm=TRUE)
sum(ge.fail.B$`Students with no nearby options`, na.rm=TRUE) / sum(ge.fail.B$`count_AY1617`, na.rm=TRUE)
sum(ge.fail.D$`Students with no nearby options`, na.rm=TRUE) / sum(ge.fail.D$`count_AY1617`, na.rm=TRUE)

#### End #### 

#### ZIP distance function: Record nearest program #### 

calc_dist_and_record <- function(gepassdata, gefaildata, levelSelection, cipSelection){
  
  gefaildata$`Distance to nearest alternative` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_schname` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_cred_lvl` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_cip4` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_zip` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_opeid6` <- rep(NA, nrow(gefaildata))
  
  for(i in (1:nrow(gefaildata))){
    
    print(i)
    
    gealternatives <- gepassdata
    
    if(gefaildata$`stabbr`[i]=="AL"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("AL", "MS", "TN", "GA", "FL"))}
    
    if(gefaildata$`stabbr`[i]=="AK"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("AK"))}
    
    if(gefaildata$`stabbr`[i]=="AZ"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("AZ", "CA", "NV", "UT", "CO", "NM"))}
    
    if(gefaildata$`stabbr`[i]=="AR"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("AR", "MO", "TN", "MS", "LA", "TX", "OK"))}
    
    if(gefaildata$`stabbr`[i]=="CA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("CA", "AZ", "NV", "OR"))}
    
    if(gefaildata$`stabbr`[i]=="CO"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("CO", "WY", "NE", "KS", "OK", "NM", "AZ", "UT"))}
    
    if(gefaildata$`stabbr`[i]=="CT"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("CT", "RI", "MA", "NY", "NJ"))}
    
    if(gefaildata$`stabbr`[i]=="DE"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("DE", "NJ", "MD", "PA"))}
    
    if(gefaildata$`stabbr`[i]=="DC"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("DC", "MD", "VA"))}
    
    if(gefaildata$`stabbr`[i]=="FL"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("FL", "GA", "MS", "AL"))}
    
    if(gefaildata$`stabbr`[i]=="GA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("GA", "FL", "AL", "TN", "SC", "NC"))}
    
    if(gefaildata$`stabbr`[i]=="HI"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("HI"))}
    
    if(gefaildata$`stabbr`[i]=="ID"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("ID", "WA", "OR", "NV", "UT", "WY", "MT"))}
    
    if(gefaildata$`stabbr`[i]=="IL"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("IL", "WI", "IA", "MO", "KY", "IN", "MI", "TN"))}
    
    if(gefaildata$`stabbr`[i]=="IN"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("IN", "MI", "OH", "KY", "IL", "WI"))}
    
    if(gefaildata$`stabbr`[i]=="IA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("IA", "SD", "NE", "MO", "KS", "IL", "WI", "MN"))}
    
    if(gefaildata$`stabbr`[i]=="KS"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("KS", "NE", "CO", "OK", "MO", "IA"))}
    
    if(gefaildata$`stabbr`[i]=="KY"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("KY", "IL", "IN", "OH", "WV", "VA", "TN", "MO"))}
    
    if(gefaildata$`stabbr`[i]=="LA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("LA", "MS", "AR", "TX"))}
    
    if(gefaildata$`stabbr`[i]=="ME"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("ME", "NH", "MA", "VT"))}
    
    if(gefaildata$`stabbr`[i]=="MD"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MD", "DC", "VA", "WV", "PA", "DE", "NJ"))}
    
    if(gefaildata$`stabbr`[i]=="MA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MA", "ME", "NH", "VT", "NY", "CT", "RI"))}
    
    if(gefaildata$`stabbr`[i]=="MI"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MI", "WI", "IL", "IN", "OH"))}
    
    if(gefaildata$`stabbr`[i]=="MN"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MN", "ND", "SD", "IA", "WI"))}
    
    if(gefaildata$`stabbr`[i]=="MS"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MS", "AL", "TN", "FL", "AR", "LA"))}
    
    if(gefaildata$`stabbr`[i]=="MO"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MO", "IA", "NE", "KS", "OK", "AR", "TN", "KY", "IL"))}
    
    if(gefaildata$`stabbr`[i]=="MT"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MT", "ID", "WY", "ND", "SD"))}
    
    if(gefaildata$`stabbr`[i]=="NE"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NE", "SD", "WY", "CO", "KS", "MO", "IA"))}
    
    if(gefaildata$`stabbr`[i]=="NV"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NV", "ID", "OR", "CA", "AZ", "UT"))}
    
    if(gefaildata$`stabbr`[i]=="NH"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NH", "ME", "VT", "MA"))}
    
    if(gefaildata$`stabbr`[i]=="NJ"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NJ", "NY", "CT", "PA", "DE", "MD"))}
    
    if(gefaildata$`stabbr`[i]=="NM"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NM", "TX", "OK", "CO", "UT", "AZ"))}
    
    if(gefaildata$`stabbr`[i]=="NY"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NY", "CT", "MA", "VT", "PA", "NJ"))}
    
    if(gefaildata$`stabbr`[i]=="NC"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("NC", "VA", "TN", "GA", "SC"))}
    
    if(gefaildata$`stabbr`[i]=="ND"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("ND", "MT", "SD", "MN"))}
    
    if(gefaildata$`stabbr`[i]=="OH"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("OH", "MI", "IN", "KY", "WV", "MD", "PA"))}
    
    if(gefaildata$`stabbr`[i]=="OK"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("OK", "KS", "CO", "NM", "TX", "AR", "MO"))}
    
    if(gefaildata$`stabbr`[i]=="OR"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("OR", "WA", "CA", "NV", "ID"))}
    
    if(gefaildata$`stabbr`[i]=="PA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("PA", "NY", "NJ", "DE", "MD", "WV", "OH"))}
    
    if(gefaildata$`stabbr`[i]=="RI"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("RI", "CT", "MA"))}
    
    if(gefaildata$`stabbr`[i]=="SC"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("SC", "NC", "GA"))}
    
    if(gefaildata$`stabbr`[i]=="SD"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("SD", "ND", "MT", "WY", "NE", "IA", "MN"))}
    
    if(gefaildata$`stabbr`[i]=="TN"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("TN", "KY", "MO", "AR", "MS", "AL", "GA", "NC", "VA"))}
    
    if(gefaildata$`stabbr`[i]=="TX"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("TX", "NM", "OK", "AR", "LA"))}
    
    if(gefaildata$`stabbr`[i]=="UT"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("UT", "WY", "ID", "NV", "AZ", "NM", "CO"))}
    
    if(gefaildata$`stabbr`[i]=="VT"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("VT", "ME", "NH", "NY", "CT", "MA", "RI"))}
    
    if(gefaildata$`stabbr`[i]=="VA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("VA", "MD", "DC", "WV", "KY", "TN", "NC"))}
    
    if(gefaildata$`stabbr`[i]=="WA"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("WA", "OR", "ID"))}
    
    if(gefaildata$`stabbr`[i]=="WV"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("WV", "PA", "OH", "KY", "MD", "VA"))}
    
    if(gefaildata$`stabbr`[i]=="WI"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("WI", "MN", "IA", "IL", "IN", "MI"))}
    
    if(gefaildata$`stabbr`[i]=="WY"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("WY", "MT", "ID", "UT", "CO", "NE", "SD"))}
    
    if(gefaildata$`stabbr`[i]=="AS"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("AS"))}
    
    if(gefaildata$`stabbr`[i]=="GU"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("GU"))}
    
    if(gefaildata$`stabbr`[i]=="MP"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("MP"))}
    
    if(gefaildata$`stabbr`[i]=="PR"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("PR"))}
    
    if(gefaildata$`stabbr`[i]=="UM"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("UM"))}
    
    if(gefaildata$`stabbr`[i]=="VI"){gealternatives <- gealternatives %>% filter(`stabbr` %in% c("VI"))}
    
    gealternatives$`Distance` <- rep(NA, nrow(gealternatives))
    program.level <- gefaildata$`cred_lvl`[i]
    program.category <- gefaildata$`Category`[i]
    program.2digCIP <- gefaildata$`cip2`[i]
    program.4digCIP <- gefaildata$`cip4`[i]
    
    # Apply the proper level filter to gepassdata
    if(levelSelection=="Same credential level"){gealternatives <- gealternatives %>% filter(`cred_lvl` == program.level)}
    if(levelSelection=="Same credential category"){gealternatives <- gealternatives %>% filter(`Category` == program.category)}
    
    # Apply the proper CIP code filter to gepassdata
    if(cipSelection=="Same 4-digit CIP"){gealternatives <- gealternatives %>% filter(`cip4`==program.4digCIP)}
    if(cipSelection=="Same 2-digit CIP"){gealternatives <- gealternatives %>% filter(`cip2`==program.2digCIP)}  
    
    # Only run the next lines if there is remaining passing programs: 
    if(nrow(gealternatives) > 0){
      
      # Calculate distance for every other program
      for(j in (1:nrow(gealternatives))){
        gealternatives$`Distance`[j] <- zip_distance(gefaildata$`zip`[i], gealternatives$`zip`[j], units="miles")$distance
      }
      
      gealternatives <- gealternatives %>% filter(is.na(`Distance`)==FALSE)
      gefaildata$`Distance to nearest alternative`[i] <- suppressWarnings(min(gealternatives$`Distance`, na.rm=TRUE))
      gealternatives <- gealternatives %>% filter(is.infinite(`Distance`)==FALSE) 
      gealternatives <- gealternatives %>% arrange(`Distance`, desc(`mdearnp3`))
      
      gefaildata$`alt_schname`[i] <- gealternatives$`schname`[1]
      gefaildata$`alt_cred_lvl`[i] <- gealternatives$`cred_lvl`[1]
      gefaildata$`alt_cip4`[i] <- gealternatives$`cip4`[1]
      gefaildata$`alt_zip`[i] <- gealternatives$`zip`[1]
      gefaildata$`alt_opeid6`[i] <- gealternatives$`opeid6`[1]
      
    }else{
      gefaildata$`Distance to nearest alternative`[i] <- NA
      gefaildata$`alt_schname`[i] <- NA
      gefaildata$`alt_cred_lvl`[i] <- NA
      gefaildata$`alt_cip4`[i] <- NA
      gefaildata$`alt_zip`[i] <- NA
      gefaildata$`alt_opeid6`[i] <- NA
    }
    
    print(gefaildata$`Distance to nearest alternative`[i])
    print(gefaildata$`alt_schname`[i])
    
    rm("gealternatives", 
       "program.level", 
       "program.category", 
       "program.2digCIP", 
       "program.4digCIP")
  }
  return(gefaildata)
}

ge.fail.A_record <- calc_dist_and_record(ge.pass, ge.fail, "Same credential level", "Same 4-digit CIP")
write.csv(ge.fail.A_record, "ge.fail.A_record.csv", row.names=FALSE)

#### End #### 

###########################################
#### Proximity of Alternative Options  ####
#### Full Earnings and Debt Data Only  ####
###########################################

#### Load in GE program data ####

ge <- fread("nprm-2022ppd-public-suppressed.csv", header=TRUE, select=c(
  "schname", 
  "inGE", 
  "opeid6", 
  "stabbr", 
  "zip",
  "control_peps",
  "cip4", 
  "cipdesc", 
  "cip2", 
  "cip2_title_2010", 
  "cred_lvl", 
  "passfail_2019", 
  "mdearnp3",
  "debtservicenpp_md",
  "count_AY1617"
))
ge <- ge %>% filter((`control_peps` %in% c("Foreign For-Profit", "Foreign Private"))==FALSE)

ge.level.category <- data.table("cred_lvl" = c(
  "UG Certificates", 
  "Associate's", 
  "Bachelor's",
  "Post-BA Certs",
  "Grad Certs", 
  "Master's", 
  "Professional",
  "Doctoral"
), "Category" = c(
  "Undergraduate", 
  "Undergraduate", 
  "Undergraduate", 
  "Undergraduate", 
  "Graduate", 
  "Graduate", 
  "Graduate", 
  "Graduate"
))

ge <- left_join(x=ge, y=ge.level.category, by="cred_lvl")
ge$zip <- substr(ge$zip, 1, 5)

ge.fail <- ge %>% filter(`passfail_2019` %in% c("Fail both DTE and EP", "Fail DTE only", "Fail EP only")) %>% filter(inGE==1)
ge.pass <- ge %>% filter(`passfail_2019` %in% c("Pass", "No DTE/EP data")) %>% filter(is.na(`mdearnp3`)==FALSE) %>% filter(is.na(`debtservicenpp_md`)==FALSE)

#### End #### 

#### ZIP distance function: Record nearest program #### 

calc_dist_and_record <- function(gepassdata, gefaildata, levelSelection, cipSelection){
  
  gefaildata$`Distance to nearest alternative` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_schname` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_cred_lvl` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_cip4` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_zip` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_opeid6` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_mdearnp3` <- rep(NA, nrow(gefaildata))
  gefaildata$`alt_debtservicenpp_md` <- rep(NA, nrow(gefaildata))
  
  for(i in (1:nrow(gefaildata))){
    
    print(i)
    
    gealternatives <- gepassdata
    gealternatives$`Distance` <- rep(NA, nrow(gealternatives))
    program.level <- gefaildata$`cred_lvl`[i]
    program.category <- gefaildata$`Category`[i]
    program.2digCIP <- gefaildata$`cip2`[i]
    program.4digCIP <- gefaildata$`cip4`[i]
    
    # Apply the proper level filter to gepassdata
    if(levelSelection=="Same credential level"){gealternatives <- gealternatives %>% filter(`cred_lvl` == program.level)}
    if(levelSelection=="Same credential category"){gealternatives <- gealternatives %>% filter(`Category` == program.category)}
    
    # Apply the proper CIP code filter to gepassdata
    if(cipSelection=="Same 4-digit CIP"){gealternatives <- gealternatives %>% filter(`cip4`==program.4digCIP)}
    if(cipSelection=="Same 2-digit CIP"){gealternatives <- gealternatives %>% filter(`cip2`==program.2digCIP)}  
    
    # Only run the next lines if there is remaining passing programs: 
    if(nrow(gealternatives) > 0){
      
      # Calculate distance for every other program
      for(j in (1:nrow(gealternatives))){
        gealternatives$`Distance`[j] <- zip_distance(gefaildata$`zip`[i], gealternatives$`zip`[j], units="miles")$distance
      }
      
      gealternatives <- gealternatives %>% filter(is.na(`Distance`)==FALSE)
      gefaildata$`Distance to nearest alternative`[i] <- suppressWarnings(min(gealternatives$`Distance`, na.rm=TRUE))
      gealternatives <- gealternatives %>% filter(is.infinite(`Distance`)==FALSE) 
      gealternatives <- gealternatives %>% arrange(`Distance`, desc(`mdearnp3`))
      
      gefaildata$`alt_schname`[i] <- gealternatives$`schname`[1]
      gefaildata$`alt_cred_lvl`[i] <- gealternatives$`cred_lvl`[1]
      gefaildata$`alt_cip4`[i] <- gealternatives$`cip4`[1]
      gefaildata$`alt_zip`[i] <- gealternatives$`zip`[1]
      gefaildata$`alt_opeid6`[i] <- gealternatives$`opeid6`[1]
      gefaildata$`alt_mdearnp3`[i] <- gealternatives$`mdearnp3`[1]
      gefaildata$`alt_debtservicenpp_md`[i] <- gealternatives$`debtservicenpp_md`[1]
      
    }else{
      gefaildata$`Distance to nearest alternative`[i] <- NA
      gefaildata$`alt_schname`[i] <- NA
      gefaildata$`alt_cred_lvl`[i] <- NA
      gefaildata$`alt_cip4`[i] <- NA
      gefaildata$`alt_zip`[i] <- NA
      gefaildata$`alt_opeid6`[i] <- NA
    }
    
    print(gefaildata$`Distance to nearest alternative`[i])
    print(gefaildata$`alt_schname`[i])
    
    rm("gealternatives", 
       "program.level", 
       "program.category", 
       "program.2digCIP", 
       "program.4digCIP")
  }
  return(gefaildata)
}

ge.fail.fulldata_record <- calc_dist_and_record(ge.pass, ge.fail, "Same credential level", "Same 4-digit CIP")
write.csv(ge.fail.fulldata_record, "ge.fail.fulldata_record.csv", row.names=FALSE)

#### End #### 

#### Running weighted means ####

ge.fail.fulldata_record <- read.csv("ge.fail.fulldata_record.csv", header=TRUE)

ge.fail.fulldata_record_earnings <- ge.fail.fulldata_record %>% filter(is.na(`alt_mdearnp3`)==FALSE) %>% filter(is.na(`mdearnp3`)==FALSE) %>% filter(is.na(`count_AY1617`)==FALSE)

`Average earnings in state (pre-transfer)` <- weighted.mean(ge.fail.fulldata_record_earnings$`mdearnp3`, w = ge.fail.fulldata_record_earnings$`count_AY1617`, na.rm=TRUE)
`Average earnings in state (post-transfer)` <- weighted.mean(ge.fail.fulldata_record_earnings$`alt_mdearnp3`, w = ge.fail.fulldata_record_earnings$`count_AY1617`, na.rm=TRUE)

ge.fail.fulldata_record_debt <- ge.fail.fulldata_record %>% filter(is.na(`alt_debtservicenpp_md`)==FALSE) %>% filter(is.na(`debtservicenpp_md`)==FALSE) %>% filter(is.na(`count_AY1617`)==FALSE)

`Average annual debt servicing in state (pre-transfer)` <- weighted.mean(ge.fail.fulldata_record_debt$`debtservicenpp_md`, w = ge.fail.fulldata_record_debt$`count_AY1617`, na.rm=TRUE)
`Average annual debt servicing in state (post-transfer)` <- weighted.mean(ge.fail.fulldata_record_debt$`alt_debtservicenpp_md`, w = ge.fail.fulldata_record_debt$`count_AY1617`, na.rm=TRUE)

`Aggregate discretionary D/E rate (pre-transfer)` <- `Average annual debt servicing in state (pre-transfer)` / (`Average earnings in state (pre-transfer)` - 18735)
`Aggregate discretionary D/E rate (post-transfer)` <- `Average annual debt servicing in state (post-transfer)` / (`Average earnings in state (post-transfer)` - 18735)

`Aggregate annual D/E rate (pre-transfer)` <- `Average annual debt servicing in state (pre-transfer)` / `Average earnings in state (pre-transfer)`
`Aggregate annual D/E rate (post-transfer)` <- `Average annual debt servicing in state (post-transfer)` / `Average earnings in state (post-transfer)`

#### End #### 

###########################################
#### Improvements to earnings from GE  ####
###########################################

#### Load GE data ####

ge <- read_excel(
  path="nprm-2022ppd-public-suppressed.xlsx", 
  col_names=TRUE
) %>% filter(
  (`control_peps` %in% c(
    "Foreign For-Profit", 
    "Foreign Private"
  ))==FALSE
) %>% select(
  `schname`, 
  `inGE`, 
  `opeid6`, 
  `cip4`,
  `cred_lvl`, 
  `control_peps`, 
  `st_fips`, 
  `earn_count_ne_3yr`, 
  `mdearnp3`, 
  `debtservicenpp_md`,
  `meandebt`,
  `mdincearn_lf`, 
  `EP_lf_2019`,
  `passfail_2019`, 
  `count_AY1617`
)

#### End #### 

#### Merge in info for simulation #### 

ge.fail.A_record <- read.csv(
  "ge.fail.A_record.csv", 
  header=TRUE
)

# Remove programs where there was no alternative 
ge.fail.A_record <- ge.fail.A_record %>% filter(
  is.na(`alt_opeid6`)==FALSE
)

# Create a unique identifier for each program: 
ge.fail.A_record <- ge.fail.A_record %>% mutate(
  `Prog_ID` = paste(`alt_opeid6`, `alt_cip4`, `alt_cred_lvl`, sep="-")
)

# Keep in only the essentials 
ge.transfers <- ge.fail.A_record %>% select(
  `Prog_ID`, 
  `count_AY1617`
) %>% rename(
  `TransferStudents` = `count_AY1617`
)
ge.transfers <- aggregate(
  data=ge.transfers, 
  `TransferStudents` ~ `Prog_ID`, 
  FUN=sum
)

#### End #### 

#### Filter for programs with sufficient data for evaluation ####

ge <- ge %>% filter(
  `passfail_2019` != "No DTE/EP data",
  is.na(`count_AY1617`)==FALSE
)

#### End #### 

#### Run function for states #### 

states <- unique(ge$st_fips)[1:51]

for(i in (1:length(states))){
  if(i==1){
    statesData <- data.frame(
      `State` = states,
      `X1` = rep(NA, length(states)), 
      `X2` = rep(NA, length(states)), 
      `X3` = rep(NA, length(states)), 
      `X4` = rep(NA, length(states))
    )
    names(statesData) <- c("State", 
                           "Average earnings in state (all programs)", 
                           "Average earnings in state (passing programs)", 
                           "Average annual debt servicing in state (all programs)", 
                           "Average annual debt servicing in state (passing programs)")
  }
  
  ge.all <- ge %>% filter(`st_fips`==states[i])
  ge.passing <- ge.all %>% filter(`passfail_2019`=="Pass")
  
  # Here, we load in the data on transfers: 
  ge.passing <- ge.passing %>% mutate(`Prog_ID` = paste(`opeid6`, `cip4`, `cred_lvl`, sep="-"))
  ge.passing <- left_join(x=ge.passing, y=ge.transfers, by="Prog_ID")
  ge.passing$`TransferStudents`[is.na(ge.passing$`TransferStudents`)] <- 0
  ge.passing <- ge.passing %>% mutate(`count_AY1617` = `count_AY1617` + `TransferStudents`)
  
  statesData$`Average earnings in state (all programs)`[i] <- weighted.mean(ge.all$`mdearnp3`, w = ge.all$`count_AY1617`)
  statesData$`Average earnings in state (passing programs)`[i] <- weighted.mean(ge.passing$`mdearnp3`, w = ge.passing$`count_AY1617`)
  
  # At this stage, we filter out programs without debt data. 
  ge.all <- ge.all %>% filter(is.na(`debtservicenpp_md`)==FALSE)
  ge.passing <- ge.passing %>% filter(is.na(`debtservicenpp_md`)==FALSE)
  
  statesData$`Average annual debt servicing in state (all programs)`[i] <- weighted.mean(ge.all$`debtservicenpp_md`, w = ge.all$`count_AY1617`)
  statesData$`Average annual debt servicing in state (passing programs)`[i] <- weighted.mean(ge.passing$`debtservicenpp_md`, w = ge.passing$`count_AY1617`)
}

# Adding in the nationwide numbers
ge.all <- ge
ge.passing <- ge.all %>% filter(`passfail_2019`=="Pass")
ge.passing <- ge.passing %>% mutate(`Prog_ID` = paste(`opeid6`, `cip4`, `cred_lvl`, sep="-"))
ge.passing <- left_join(x=ge.passing, y=ge.transfers, by="Prog_ID")
ge.passing$`TransferStudents`[is.na(ge.passing$`TransferStudents`)] <- 0
ge.passing <- ge.passing %>% mutate(`count_AY1617` = `count_AY1617` + `TransferStudents`)
statesData <- statesData %>% add_row(
  `State` = "U.S. Overall", 
  `Average earnings in state (all programs)` = weighted.mean(ge.all$`mdearnp3`, w = ge.all$`count_AY1617`, na.rm=TRUE),
  `Average earnings in state (passing programs)` = weighted.mean(ge.passing$`mdearnp3`, w = ge.passing$`count_AY1617`, na.rm=TRUE), 
  `Average annual debt servicing in state (all programs)` = weighted.mean(ge.all$`debtservicenpp_md`, w = ge.all$`count_AY1617`, na.rm=TRUE), 
  `Average annual debt servicing in state (passing programs)` = weighted.mean(ge.passing$`debtservicenpp_md`, w = ge.passing$`count_AY1617`, na.rm=TRUE)
)

# Calculating annual D/E rate 
statesData <- statesData %>% mutate(`Aggregate annual D/E rate (all programs)` = `Average annual debt servicing in state (all programs)` / `Average earnings in state (all programs)`)
statesData <- statesData %>% mutate(`Aggregate annual D/E rate (passing programs)` = `Average annual debt servicing in state (passing programs)` / `Average earnings in state (passing programs)`)

statesData <- statesData %>% mutate(`Aggregate discretionary D/E rate (all programs)` = `Average annual debt servicing in state (all programs)` / (`Average earnings in state (all programs)` - 18735))
statesData <- statesData %>% mutate(`Aggregate discretionary D/E rate (passing programs)` = `Average annual debt servicing in state (passing programs)` / (`Average earnings in state (passing programs)` - 18735))

#### End #### 

#### Earnings gain chart ####

plot1 <- statesData %>% select(`State`, `Average earnings in state (all programs)`, `Average earnings in state (passing programs)`)

plot1 <- plot1 %>% filter(`State` != "District of Columbia")

plot1A <- plot1 %>% pivot_longer(cols=c(`Average earnings in state (all programs)`, `Average earnings in state (passing programs)`), names_to="Program category", values_to="Average earnings in state")
plot1A$`Program category`[plot1A$`Program category`=="Average earnings in state (all programs)"] <- "Pre-GE status quo"
plot1A$`Program category`[plot1A$`Program category`=="Average earnings in state (passing programs)"] <- "Post-GE simulation"

ggplot(data=plot1A, mapping=aes(y=reorder(`State`, `Average earnings in state`, max), x=`Average earnings in state`, color=`Program category`, group=`State`)) + geom_point(aes(size=`Program category`)) + geom_line() + scale_x_continuous(labels=scales::dollar_format(accuracy=1)) + labs(y="State", x="Annual earnings among program graduates") + scale_color_manual(values=c("firebrick3", "gray23"), name="") + scale_size_manual(values=c(2.5, 1), name="")

#### End #### 

#### Earnings gain chart: Plotly ####
names(plot1) <- c("State", "Pre-GE", "Post-GE")

plot1$`State` <- factor(plot1$`State`, levels=plot1$`State`[order(plot1$`Post-GE`)])

plot1$`Pre-GE Text` <- paste(plot1$`State`, " Pre-GE: ", dollar(plot1$`Pre-GE`, accuracy=1), sep="")
plot1$`Post-GE Text` <- paste(plot1$`State`, " Post-GE: ", dollar(plot1$`Post-GE`, accuracy=1), sep="")

earnings.fig <- plot_ly(plot1, color = I("gray80"), width=900, height=900)
earnings.fig <- earnings.fig %>% add_segments(x = ~`Pre-GE`, xend = ~`Post-GE`, y = ~`State`, yend = ~`State`, showlegend = FALSE, hoverinfo = 'skip')
earnings.fig <- earnings.fig %>% add_markers(x = ~`Pre-GE`, y = ~`State`, name = "Pre-GE", color = I("gray23"), text = ~`Pre-GE Text`, hoverinfo = "text")
earnings.fig <- earnings.fig %>% add_markers(x = ~`Post-GE`, y = ~`State`, name = "Post-GE", color = I("firebrick3"), text = ~`Post-GE Text`, hoverinfo = "text")
earnings.fig <- earnings.fig %>% layout(
  title = "Enacting the GE rules increases program completers’ typical annual earnings <br> in every state, and by more than $5,000 in several states.",
  xaxis = list(title = "Annual earnings among program graduates", tickformat='$,d'),
  yaxis = list(title = ""),
  margin = list(l = 65), 
  hovermode = "y unified"
)
earnings.fig
api_create(earnings.fig, filename = "earnings-09232023")

#### End #### 

#### D/E Annual Ratio Chart ####

# Option 1: Discretionary D/E rate 
# plot2 <- statesData %>% select(`State`, `Aggregate discretionary D/E rate (all programs)`, `Aggregate discretionary D/E rate (passing programs)`)
# plot2 <- plot2 %>% pivot_longer(cols=c(`Aggregate discretionary D/E rate (all programs)`, `Aggregate discretionary D/E rate (passing programs)`), names_to="Program category", values_to="Aggregate discretionary D/E rate")
# plot2$`Program category`[plot2$`Program category`=="Aggregate discretionary D/E rate (all programs)"] <- "Pre-GE status quo"
# plot2$`Program category`[plot2$`Program category`=="Aggregate discretionary D/E rate (passing programs)"] <- "Post-GE simulation"
# ggplot(data=plot2, mapping=aes(y=reorder(`State`, `Aggregate discretionary D/E rate`, min), x=`Aggregate discretionary D/E rate`, color=`Program category`, group=`State`)) + geom_point(aes(size=`Program category`)) + geom_line() + scale_x_continuous(labels=scales::percent_format(accuracy=1)) + labs(y="State", x="Discretionary D/E rate among program graduates") + scale_color_manual(values=c("dodgerblue", "gray23"), name="") + scale_size_manual(values=c(2.5, 1), name="")

# Option 2: Annual D/E rate
plot2 <- statesData %>% select(`State`, `Aggregate annual D/E rate (all programs)`, `Aggregate annual D/E rate (passing programs)`)

plot2A <- plot2 %>% pivot_longer(cols=c(`Aggregate annual D/E rate (all programs)`, `Aggregate annual D/E rate (passing programs)`), names_to="Program category", values_to="Aggregate annual D/E rate")
plot2A$`Program category`[plot2A$`Program category`=="Aggregate annual D/E rate (all programs)"] <- "Pre-GE status quo"
plot2A$`Program category`[plot2A$`Program category`=="Aggregate annual D/E rate (passing programs)"] <- "Post-GE simulation"
ggplot(data=plot2A, mapping=aes(y=reorder(`State`, `Aggregate annual D/E rate`, min), x=`Aggregate annual D/E rate`, color=`Program category`, group=`State`)) + geom_point(aes(size=`Program category`)) + geom_line() + scale_x_continuous(labels=scales::percent_format(accuracy=1)) + labs(y="State", x="Annual D/E rate among program graduates") + scale_color_manual(values=c("dodgerblue", "gray23"), name="") + scale_size_manual(values=c(2.5, 1), name="")

# Option 3: Dollar amounts of debt payment
# plot2 <- statesData %>% select(`State`, `Average annual debt servicing in state (all programs)`, `Average annual debt servicing in state (passing programs)`) %>% filter(State != "District of Columbia")
# plot2 <- plot2 %>% pivot_longer(cols=c(`Average annual debt servicing in state (all programs)`, `Average annual debt servicing in state (passing programs)`), names_to="Program category", values_to="Average annual debt servicing in state")
# plot2$`Program category`[plot2$`Program category`=="Average annual debt servicing in state (all programs)"] <- "Pre-GE status quo"
# plot2$`Program category`[plot2$`Program category`=="Average annual debt servicing in state (passing programs)"] <- "Post-GE simulation"
# ggplot(data=plot2, mapping=aes(y=reorder(`State`, `Average annual debt servicing in state`, min), x=`Average annual debt servicing in state`, color=`Program category`, group=`State`)) + geom_point(aes(size=`Program category`)) + geom_line() + scale_x_continuous(labels=scales::dollar_format(accuracy=1)) + labs(y="State", x="Annual loan among program graduates") + scale_color_manual(values=c("dodgerblue", "gray23"), name="") + scale_size_manual(values=c(2.5, 1), name="") 


#### End #### 

#### D/E Annual Ratio chart: Plotly ####
names(plot2) <- c("State", "Pre-GE", "Post-GE")

plot2$`State` <- factor(plot2$`State`, levels=plot2$`State`[order(plot2$`Post-GE`)])

plot2$`Pre-GE Text` <- paste(plot2$`State`, " Pre-GE: ", percent(plot2$`Pre-GE`, accuracy=0.01), sep="")
plot2$`Post-GE Text` <- paste(plot2$`State`, " Post-GE: ", percent(plot2$`Post-GE`, accuracy=0.01), sep="")

debt.fig <- plot_ly(plot2, color = I("gray80"), width=900, height=900)
debt.fig <- debt.fig %>% add_segments(x = ~`Pre-GE`, xend = ~`Post-GE`, y = ~`State`, yend = ~`State`, showlegend = FALSE, hoverinfo = 'skip')
debt.fig <- debt.fig %>% add_markers(x = ~`Pre-GE`, y = ~`State`, name = "Pre-GE", color = I("gray23"), text = ~`Pre-GE Text`, hoverinfo = "text")
debt.fig <- debt.fig %>% add_markers(x = ~`Post-GE`, y = ~`State`, name = "Post-GE", color = I("dodgerblue"), text = ~`Post-GE Text`, hoverinfo = "text")
debt.fig <- debt.fig %>% layout(
  title = "Removing the worst-performing programs from the student loan program <br> makes monthly debt payments more manageable <br> by lowering total debt and improving earnings.",
  xaxis = list(title = "Annual D/E rate among program graduates", tickformat='1%'),
  yaxis = list(title = ""),
  margin = list(l = 65), 
  hovermode = "y unified"
)
debt.fig
api_create(debt.fig, filename = "debt-09232023")

#### End #### 


