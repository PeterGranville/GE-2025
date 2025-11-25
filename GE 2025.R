
#### Setup ####

library(readxl)
library(scales)
library(plotly)
library(writexl)
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

ef2022c <- read.csv(
  "ef2022c_rv.csv", header=TRUE
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
ef2022c <- left_join(
  x=ef2022c, y=efState, by="EFCSTATE"
) %>% rename(
  `Student state` = `STABBR`
)
rm(efState)

hd <- read.csv(
  "hd2022.csv", header=TRUE
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
ef2022c <- left_join(x=ef2022c, y=hd, by="UNITID")
rm(hd)

#### End #### 

#### Find whether each institution gets 50+% of its students from within its same state ####

ef2022c <- ef2022c %>% mutate(
  `Student state` = ifelse(
    `Student state` == `Institution state`, "In-state", "Out-of-state"
  )
)

inStateShares <- aggregate(
  data=ef2022c, 
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
rm(ef2022c)

#### End #### 

###########################################
#### Data on online programs           ####
###########################################

#### Loading HD data and creating OPEID6 variable ####

hd <- read.csv(
  "hd2019.csv", header=TRUE
) %>% select(
  `UNITID`, 
  `OPEID`
) %>% filter(
  `OPEID` != "-2"
) %>% rename(
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
  `OPEID6` = as.numeric(substr(`OPEID8`, 1, 6))
) %>% select(
  `UNITID`, 
  `OPEID6`
)

#### End ####  

#### Loading distance education data and merging OPEID6 variable ####

cdep <- read.csv("c2019dep_rv.csv", header=TRUE)

cdep <- left_join(x=cdep, y=hd, by="UNITID")
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
#### Alternative Options               ####
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
  `mediandebt`,
  `count_AY1617`, 
  `t4enrl2016`,
  `t4enrl2017`,
  `t4enrl2018`,
  `t4enrl2019`,
  `t4enrl2020`,
  `t4enrl2021`,
  `t4enrl2022`,
  `pell_vol_2016`,
  `pell_vol_2017`,
  `pell_vol_2018`,
  `pell_vol_2019`,
  `pell_vol_2020`,
  `pell_vol_2021`,
  `pell_vol_2022`, 
  `tot_loan_vol2016`,
  `tot_loan_vol2017`,
  `tot_loan_vol2018`,
  `tot_loan_vol2019`,
  `tot_loan_vol2020`,
  `tot_loan_vol2021`,
  `tot_loan_vol2022`
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

# If not sure, say it's not an online program: 
ge <- ge %>% mutate(`Distance status` = ifelse(
  is.na(`Distance status`), 
  "Not an online program", 
  `Distance status`
))

#### End #### 

#### Import Scorecard for LEP ####

importCSI <- read.csv(
  "Most-Recent-Cohorts-Field-of-Study_04172025.csv", header=TRUE, check.names=FALSE
) %>% select(
  `OPEID6`,             # 6-digit OPE ID for institution	
  `CIPCODE`,            # Classification of Instructional Programs (CIP) code for the field of study	
  `CREDDESC`,           # Level of credential	
  # `EARN_COUNT_WNE_4YR`, # Number of graduates working and not enrolled 4 year after completing	
  `EARN_MDN_4YR`        # Median earnings of graduates working and not enrolled 4 years after completing
) %>% mutate(
  # `EARN_COUNT_WNE_4YR` = as.numeric(`EARN_COUNT_WNE_4YR`)
  `EARN_MDN_4YR` = as.numeric(`EARN_MDN_4YR`) 
) %>% mutate(
  `EARN_MDN_4YR` = `EARN_MDN_4YR` / (1 + (0.009860818 / 2)) # Inflation: see methods doc 
) %>% filter(
  # is.na(`EARN_COUNT_WNE_4YR`)==FALSE,
  is.na(`EARN_MDN_4YR`)==FALSE
) %>% rename(
  `opeid6` = `OPEID6`, 
  `cip4` = `CIPCODE`,
  `creddesc` = `CREDDESC`, 
  `LEP earnings` = `EARN_MDN_4YR`
) %>% mutate(
  `Unique ID` = paste(
    `opeid6`, 
    `cip4`, 
    `creddesc`, 
    sep="..."
  )
) %>% filter(
  duplicated(`Unique ID`)==FALSE
) %>% select(
  -(`Unique ID`)
)

importLevels <- data.frame(
  "cred_lvl" = c(
    "UG Certificates", 
    "Associate's", 
    "Bachelor's",
    "Post-BA Certs",
    "Grad Certs", 
    "Master's", 
    "Professional",
    "Doctoral"
  ), "creddesc" = c(
    "Undergraduate Certificate or Diploma", 
    "Associate's Degree", 
    "Bachelor's Degree", 
    "Post-baccalaureate Certificate", 
    "Graduate/Professional Certificate", 
    "Master's Degree", 
    "First Professional Degree", 
    "Doctoral Degree"
  )
)

importCSI <- left_join(
  x=importCSI, 
  y=importLevels, 
  by="creddesc"
) %>% select(-(`creddesc`))
rm(importLevels)

ge <- left_join(
  x=ge, 
  y=importCSI, 
  by=c("opeid6", "cip4", "cred_lvl")
)
rm(importCSI)

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

# If a classification isn't found, say it's majority in-state 
ge <- ge %>% mutate(
  `Classification` = ifelse(
    is.na(`Classification`), 
    "Majority in-state", 
    `Classification`
  )
)

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
    is.na(`LEP earnings`),
    "No LEP data", 
    ifelse(
      `LEP earnings` >= `LEP threshold`, 
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

#### Total undergraduate certificates failing GE ####

UGcert <- ge %>% filter(`cred_lvl`=="UG Certificates")
sum(UGcert$`t4enrl2022`, na.rm=TRUE)

UGcertFailGE <- ge %>% filter(
  `passfail_2019` %in% c(
    "Fail both DTE and EP", "Fail DTE only", "Fail EP only"), 
  `cred_lvl`=="UG Certificates"
)
nrow(UGcertFailGE)

sum(UGcertFailGE$`t4enrl2022`, na.rm=TRUE) / sum(UGcert$`t4enrl2022`, na.rm=TRUE)

#### End #### 

# #### Check for LEP validity ####
# 
# ge <- ge %>% mutate(
#   `Count` = rep(1)
# )
# 
# # Preston Cooper July 2025 analysis 
# agg1 <- aggregate(
#   data=ge, 
#   cbind(`Count`, `count_AY1617`) ~ `control_peps` + `cred_lvl` + `passfailLEP` + `inLEP`, 
#   FUN=sum
# ) %>% filter(
#   `inLEP`==1
# ) %>% select(
#   -(`inLEP`)
# ) %>% filter(
#   `cred_lvl` != "Post-BA Certs"
# )
# 
# agg1A <- agg1 %>% pivot_wider(
#   id_cols=c(`control_peps`, `cred_lvl`), 
#   names_from=`passfailLEP`,
#   values_from=`Count`
# )
# agg1A[is.na(agg1A)] <- 0 
# agg1A <- agg1A %>% mutate(
#   `Share passing` = `Pass LEP` / (`Pass LEP` + `Fail LEP`)
# ) %>% mutate(
#   `control_peps` = factor(`control_peps`, levels=c(
#     "Public", 
#     "Private, Nonprofit", 
#     "Proprietary"
#   )), 
#   `cred_lvl` = factor(`cred_lvl`, levels=c(
#     "Associate's", 
#     "Bachelor's",
#     "Master's", 
#     "Doctoral",
#     "Professional"
#   ))
# )
# 
# agg1B <- agg1 %>% pivot_wider(
#   id_cols=c(`control_peps`, `cred_lvl`), 
#   names_from=`passfailLEP`,
#   values_from=`count_AY1617`
# )
# agg1B[is.na(agg1B)] <- 0 
# agg1B <- agg1B %>% mutate(
#   `Share passing` = `Pass LEP` / (`Pass LEP` + `Fail LEP`)
# )  %>% mutate(
#   `control_peps` = factor(`control_peps`, levels=c(
#     "Public", 
#     "Private, Nonprofit", 
#     "Proprietary"
#   )), 
#   `cred_lvl` = factor(`cred_lvl`, levels=c(
#     "Associate's", 
#     "Bachelor's",
#     "Master's", 
#     "Doctoral",
#     "Professional"
#   ))
# )
# 
# ggplot(
#   data=agg1A, 
#   mapping=aes(
#     x=`cred_lvl`,
#     y=`Share passing`, 
#     fill=`control_peps`
#   )
# ) + geom_bar(
#   stat="identity", 
#   position = "dodge2"
# )
# ggplot(
#   data=agg1B, 
#   mapping=aes(
#     x=`cred_lvl`,
#     y=`Share passing`, 
#     fill=`control_peps`
#   )
# ) + geom_bar(
#   stat="identity", 
#   position = "dodge2"
# )
# 
# #### End #### 

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
      is.na(`mediandebt`)==FALSE
    )
  }
  
  #### End #### 
  
  #### Define failing programs #### 
  
  failingPrograms <- gedata %>% filter(
    (`Prog ID` %in% passingPrograms$`Prog ID`)==FALSE
  )
  
  if((lepSelection=="Y") & (geSelection=="Y")){
    failingPrograms <- failingPrograms %>% filter(
      ((`passfailLEP`=="Fail LEP") & (`inLEP`==1)) | ((`passfail_2019` %in% c("Fail both DTE and EP", "Fail DTE only", "Fail EP only")) & (`inGE`==1))
    )
  }
  
  if((lepSelection=="Y") & (geSelection=="N")){
    failingPrograms <- failingPrograms %>% filter(
      ((`passfailLEP`=="Fail LEP") & (`inLEP`==1))
    )
  }
  
  if((lepSelection=="N") & (geSelection=="Y")){
    failingPrograms <- failingPrograms %>% filter(
      ((`passfail_2019` %in% c("Fail both DTE and EP", "Fail DTE only", "Fail EP only")) & (`inGE`==1))
    )
  }
  
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
    
    print(paste("Trying number ", i, " of ", nrow(failingPrograms), " failing programs in ", runName, " at ", Sys.time(), ".", sep=""))
    
    #### Create alternativePrograms, filter by online status and state #### 
    
    alternativePrograms <- passingPrograms %>% mutate(`Distance` = rep(NA))
    
    if(failingPrograms$`Distance status`[i]=="Online program"){
      
      alternativePrograms <- alternativePrograms %>% filter(
        `Distance status`=="Online program"
      )
      
    }else{
      
      alternativePrograms <- alternativePrograms %>% filter(
        `Distance status`=="Not an online program"
      )
      
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
      
    }
    
    #### End #### 
    
    #### Apply filters to alternativePrograms #### 
    
    program.level <- failingPrograms$`cred_lvl`[i]
    program.category <- failingPrograms$`Category`[i]
    program.2digCIP <- failingPrograms$`cip2`[i]
    program.4digCIP <- failingPrograms$`cip4`[i]
    
    # Apply the proper level filter to alternativePrograms
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
    
    # Apply the proper CIP code filter to alternativePrograms
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
        if((failingPrograms$`Distance status`[i]=="Online program") & (alternativePrograms$`Distance status`[j]=="Online program")){
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
      
      failingPrograms$`alt_schname`[i] <- alternativePrograms$`schname`[1]
      failingPrograms$`alt_cred_lvl`[i] <- alternativePrograms$`cred_lvl`[1]
      failingPrograms$`alt_cip4`[i] <- alternativePrograms$`cip4`[1]
      failingPrograms$`alt_zip`[i] <- alternativePrograms$`zip`[1]
      failingPrograms$`alt_opeid6`[i] <- alternativePrograms$`opeid6`[1]
      
    }else{
      failingPrograms$`Distance to nearest alternative`[i] <- NA
      failingPrograms$`alt_schname`[i] <- NA
      failingPrograms$`alt_cred_lvl`[i] <- NA
      failingPrograms$`alt_cip4`[i] <- NA
      failingPrograms$`alt_zip`[i] <- NA
      failingPrograms$`alt_opeid6`[i] <- NA
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
  return(list(failingPrograms, passingPrograms))
}

# #### Run distance function: Full data only ####
# 
# setFullEarningsData <- TRUE
# setFullDebtData <- TRUE
# ge.YYL4.FDO <- calc_dist(
#   gedata=ge,
#   lepSelection="Y",
#   geSelection="Y",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.YYL4.FDO"
# )
# ge.YNL4.FDO <- calc_dist(
#   gedata=ge,
#   lepSelection="Y",
#   geSelection="N",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.YNL4.FDO"
# )
# ge.NYL4.FDO <- calc_dist(
#   gedata=ge,
#   lepSelection="N",
#   geSelection="Y",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.NYL4.FDO"
# )
# 
# #### End ####
# 
# #### Run distance function: Not limited to full data ####
# 
# setFullEarningsData <- FALSE
# setFullDebtData <- FALSE
# ge.YYL4.NL <- calc_dist(
#   gedata=ge,
#   lepSelection="Y",
#   geSelection="Y",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.YYL4.NL"
# )
# ge.YNL4.NL <- calc_dist(
#   gedata=ge,
#   lepSelection="Y",
#   geSelection="N",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.YNL4.NL"
# )
# ge.NYL4.NL <- calc_dist(
#   gedata=ge,
#   lepSelection="N",
#   geSelection="Y",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.NYL4.NL"
# )
# 
# #### End ####
# 
# #### Run distance function: Full earnings data only ####
# 
# setFullEarningsData <- TRUE
# setFullDebtData <- FALSE
# ge.YYL4.FEDO <- calc_dist(
#   gedata=ge,
#   lepSelection="Y",
#   geSelection="Y",
#   levelSelection="Same credential level",
#   cipSelection="Same 4-digit CIP",
#   fullEarningsData=setFullEarningsData,
#   fullDebtData=setFullDebtData,
#   runName="ge.YYL4.FEDO"
# )
# ge.YNL4.FEDO <- calc_dist(
#   gedata=ge, 
#   lepSelection="Y", 
#   geSelection="N", 
#   levelSelection="Same credential level", 
#   cipSelection="Same 4-digit CIP", 
#   fullEarningsData=setFullEarningsData, 
#   fullDebtData=setFullDebtData, 
#   runName="ge.YNL4.FEDO"
# )
# ge.NYL4.FEDO <- calc_dist(
#   gedata=ge, 
#   lepSelection="N", 
#   geSelection="Y", 
#   levelSelection="Same credential level", 
#   cipSelection="Same 4-digit CIP", 
#   fullEarningsData=setFullEarningsData, 
#   fullDebtData=setFullDebtData, 
#   runName="ge.NYL4.FEDO"
# )
# 
# #### End #### 
# 
# #### Save files for future #### 
# 
# write_xlsx(ge.YYL4.FDO, "ge-YYL4-FDO.xlsx")
# write_xlsx(ge.YNL4.FDO, "ge-YNL4-FDO.xlsx")
# write_xlsx(ge.NYL4.FDO, "ge-NYL4-FDO.xlsx")
# write_xlsx(ge.YYL4.NL, "ge-YYL4-NL.xlsx")
# write_xlsx(ge.YNL4.NL, "ge-YNL4-NL.xlsx")
# write_xlsx(ge.NYL4.NL, "ge-NYL4-NL.xlsx")
# write_xlsx(ge.YYL4.FEDO, "ge-YYL4-FEDO.xlsx")
# write_xlsx(ge.YNL4.FEDO, "ge-YNL4-FEDO.xlsx")
# write_xlsx(ge.NYL4.FEDO, "ge-NYL4-FEDO.xlsx")
# 
# #### End #### 

#### Re-load files ####

ge.YYL4.FDO <- list(
  failingPrograms = read_excel(path="ge-YYL4-FDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YYL4-FDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.YNL4.FDO <- list(
  failingPrograms = read_excel(path="ge-YNL4-FDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YNL4-FDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.NYL4.FDO <- list(
  failingPrograms = read_excel(path="ge-NYL4-FDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-NYL4-FDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.YYL4.NL <- list(
  failingPrograms = read_excel(path="ge-YYL4-NL.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YYL4-NL.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.YNL4.NL <- list(
  failingPrograms = read_excel(path="ge-YNL4-NL.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YNL4-NL.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.NYL4.NL <- list(
  failingPrograms = read_excel(path="ge-NYL4-NL.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-NYL4-NL.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.YYL4.FEDO <- list(
  failingPrograms = read_excel(path="ge-YYL4-FEDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YYL4-FEDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.YNL4.FEDO <- list(
  failingPrograms = read_excel(path="ge-YNL4-FEDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-YNL4-FEDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

ge.NYL4.FEDO <- list(
  failingPrograms = read_excel(path="ge-NYL4-FEDO.xlsx", sheet="Sheet1", col_names=TRUE),
  passingPrograms = read_excel(path="ge-NYL4-FEDO.xlsx", sheet="Sheet2", col_names=TRUE)
) 

#### End #### 

analyzeSimulation <- function(
    geFull0,
    simulationData,
    simulationName,
    certsOnly
){
  
  #### Create datasets #### 
  
  geFull <- geFull0
  geFailing <- simulationData[[1]]
  gePassing <- simulationData[[2]]
  
  if(certsOnly==TRUE){
    geFull <- geFull %>% filter(`cred_lvl`=="UG Certificates")
    geFailing <- geFailing %>% filter(`cred_lvl`=="UG Certificates")
    gePassing <- gePassing %>% filter(`cred_lvl`=="UG Certificates")
  }
  
  #### End #### 
  
  #### Set "Distance to nearest alternative" to numeric ####
  
  geFailing <- geFailing %>% mutate(
    `Distance to nearest alternative` = as.numeric(`Distance to nearest alternative`)
  )

  #### End #### 
  
  #### Program totals #### 
  
  # Total failing programs (loss of T-IV aid)
  V1 <- nrow(geFailing)
  V1a <- sum(geFailing$`count_AY1617`, na.rm=TRUE)
  
  # Total passing programs (keeps T-IV aid)
  V2 <- nrow(gePassing)
  V2a <- sum(gePassing$`count_AY1617`, na.rm=TRUE)
  
  # Total programs with insufficient data (keeps T-IV aid by default or gets combined with other programs)
  V3 <- nrow(geFull) - (nrow(geFailing) + nrow(gePassing))
  V3a <- sum(geFull$`count_AY1617`, na.rm=TRUE) - (V1a + V2a)
  
  # Share of programs that are failing 
  V4 <- nrow(geFailing) / nrow(geFull)
  V4a <- V1a / sum(geFull$`count_AY1617`, na.rm=TRUE)
  
  # Share of programs that are passing
  V5 <- nrow(gePassing) / nrow(geFull)
  V5a <- V2a / sum(geFull$`count_AY1617`, na.rm=TRUE)
  
  # Share of programs with insufficient data
  V6 <- (nrow(geFull) - (nrow(geFailing) + nrow(gePassing))) / nrow(geFull)
  V6a <- V3a / sum(geFull$`count_AY1617`, na.rm=TRUE)
  
  #### End #### 
  
  #### Distance to nearest program ####
  
  # Share of programs no alternative within 30 miles
  geFailing <- geFailing %>% mutate(
    `No option within less than 30 miles` = ifelse(
      (`Distance to nearest alternative` > 30) | (is.na(`Distance to nearest alternative`)) | (is.infinite(`Distance to nearest alternative`)),
      1, 
      0
    )
  )
  V7 <- sum(geFailing$`No option within less than 30 miles`) / nrow(geFailing)
  V7a <- geFailing %>% filter(
    `No option within less than 30 miles`==1
  )
  V7a <- sum(V7a$`count_AY1617`, na.rm=TRUE)
  
  # Average distance in miles to nearest alternative program (<30 miles)
  geFailing <- geFailing %>% mutate(
    `Distance (within 30 miles)` = ifelse(
      `No option within less than 30 miles`==1, 
      NA, 
      `Distance to nearest alternative`
    )
  )
  V8 <- mean(geFailing$`Distance (within 30 miles)`, na.rm=TRUE)
  V8a <- geFailing %>% summarize(
    `Average distance` = weighted.mean(x=`Distance (within 30 miles)`, w=`count_AY1617`, na.rm=TRUE)
  )
  V8a <- V8a$`Average distance`[1]
  
  #### End #### 
  
  #### Average earnings: All Title IV students #### 
  
  # Average earnings 3 years after completion, pre-transfer: All Title IV recipients
  averageEarnings1 <- geFull %>% filter(
    is.na(`mdearnp3`)==FALSE, 
    is.na(`count_AY1617`)==FALSE
  ) %>% summarize(
    `Average earnings pre-transfer` = weighted.mean(x=`mdearnp3`, w=`count_AY1617`)
  )
  V9 <- averageEarnings1$`Average earnings pre-transfer`[1]
  
  # Simulate transfer 
  transferStudents <- geFailing %>% select(
    `alt_cip4`, 
    `alt_cred_lvl`, 
    `alt_opeid6`, 
    `count_AY1617`
  ) %>% rename(
    `cip4` = `alt_cip4`, 
    `cred_lvl` = `alt_cred_lvl`, 
    `opeid6` = `alt_opeid6`, 
    `In-transfers` = `count_AY1617`
  ) %>% filter(
    is.na(`In-transfers`)==FALSE
  )
  transferStudents <- aggregate(
    data=transferStudents, 
    `In-transfers` ~ `opeid6` + `cred_lvl` + `cip4`,
    FUN=sum
  )
  geFull <- left_join(x=geFull, y=transferStudents, by=c("opeid6", "cred_lvl", "cip4"))
  transferStudents <- transferStudents %>% mutate(
    `alt_Prog ID` = paste(
      `opeid6`, 
      `cip4`, 
      `cred_lvl`, 
      sep="..."
    )
  )
  
  # Re-calculate the new weights 
  geFull <- geFull %>% mutate(
    `count_AY1617` = ifelse(
      is.na(`count_AY1617`), 
      0, 
      `count_AY1617`
    ), 
    `In-transfers` = ifelse(
      is.na(`In-transfers`), 
      0, 
      `In-transfers`
    )
  ) %>% mutate(
    `Post-transfer student count` = ifelse(
      `Prog ID` %in% geFailing$`Prog ID`,
      0,
      `count_AY1617` + `In-transfers`
    )
  )
  
  # Average earnings 3 years after completion, post-transfer: All Title IV recipients
  averageEarnings2 <- geFull %>% filter(
    is.na(`mdearnp3`)==FALSE, 
    is.na(`Post-transfer student count`)==FALSE
  ) %>% summarize(
    `Average earnings post-transfer` = weighted.mean(x=`mdearnp3`, w=`Post-transfer student count`)
  )
  V10 <- averageEarnings2$`Average earnings post-transfer`[1]
  
  # Absolute ($) increase in earnings: All Title IV students
  V11 <- V10 - V9 
  
  # Relative (%) increase in earnings: All Title IV students
  V12 <- V11 / V9
  
  #### End #### 
  
  #### Average earnings: Title IV recipients at failing programs #### 
  
  # Average earnings 3 years after completion, pre-transfer: Title IV recipients at failing programs
  averageEarnings3 <- geFailing %>% filter(
    is.na(`mdearnp3`)==FALSE, 
    is.na(`count_AY1617`)==FALSE
  ) %>% summarize(
    `Average earnings pre-transfer (TIV Failing)` = weighted.mean(x=`mdearnp3`, w=`count_AY1617`)
  )
  V13 <- averageEarnings3$`Average earnings pre-transfer (TIV Failing)`[1]
  
  # Average earnings 3 years after completion, post-transfer: Title IV recipients at failing programs
  averageEarnings4 <- geFull %>% filter(
    `Prog ID` %in% transferStudents$`alt_Prog ID`
  ) %>% filter(
    is.na(`mdearnp3`)==FALSE, 
    is.na(`In-transfers`)==FALSE
  ) %>% summarize(
    `Average earnings post-transfer (TIV Failing)` = weighted.mean(x=`mdearnp3`, w=`In-transfers`)
  )
  V14 <- averageEarnings4$`Average earnings post-transfer (TIV Failing)`[1]
  
  # Absolute ($) increase in earnings: Title IV recipients at failing programs
  V15 <- V14 - V13 
  
  # Relative (%) increase in earnings: Title IV recipients at failing programs
  V16 <- V15 / V13 
  
  #### End #### 
  
  #### Return findings #### 
  
  returnDF <- data.frame(
    `Simulation name` = c(simulationName), 
    `Certificates only` = c(certsOnly),
    `Total failing programs (loss of T-IV aid)` = c(V1), 
    `Total students in failing programs` = c(V1a),
    `Total passing programs (keeps T-IV aid)` = c(V2),
    `Total students in passing programs` = c(V2a),
    `Total programs with insufficient data` = c(V3), 
    `Total students in programs with insufficient data` = c(V3a),
    `Share of programs that are failing` = c(V4), 
    `Share of students in programs that are failing` = c(V4a),
    `Share of programs that are passing` = c(V5), 
    `Share of students in programs that are passing` = c(V5a),
    `Share of programs with insufficient data` = c(V6), 
    `Share of students in programs with insufficient data` = c(V6a),
    `Share of programs with no program within 30 miles` = c(V7), 
    `Total students in programs with no program within 30 miles` = c(V7a), 
    `Average program's distance in miles to nearest alternative program (<30 miles)` = c(V8),
    `Average student's distance in miles to nearest alternative program (<30 miles)` = c(V8a),
    `Average earnings 3 years after completion, pre-transfer: All Title IV recipients` = c(V9), 
    `Average earnings 3 years after completion, post-transfer: All Title IV recipients` = c(V10), 
    `Absolute ($) increase in earnings: All Title IV students` = c(V11), 
    `Relative (%) increase in earnings: All Title IV students` = c(V12), 
    `Average earnings 3 years after completion, pre-transfer: Title IV recipients at failing programs` = c(V13), 
    `Average earnings 3 years after completion, post-transfer: Title IV recipients at failing programs` = c(V14), 
    `Absolute ($) increase in earnings: Title IV recipients at failing programs` = c(V15), 
    `Relative (%) increase in earnings: Title IV recipients at failing programs` = c(V16), 
    check.names=FALSE
  )
  
  return(returnDF)
  rm(
    returnDF, 
    V1,
    V1a,
    V2,
    V2a,
    V3,
    V3a,
    V4,
    V4a,
    V5,
    V5a,
    V6,
    V6a,
    V7,
    V7a,
    V8,
    V8a,
    V9,
    V10, 
    V11,
    V12,
    V13,
    V14,
    V15, 
    V16, 
    geFull,
    geFailing,
    gePassing,
    transferStudents,
    averageEarnings1,
    averageEarnings2,
    averageEarnings3,
    averageEarnings4
  )
  
  #### End #### 
  
}

#### Run results ####

resultsOverall <- rbind(
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.FDO, simulationName="ge.YYL4.FDO", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.FDO, simulationName="ge.YNL4.FDO", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.FDO, simulationName="ge.NYL4.FDO", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.NL, simulationName="ge.YYL4.NL", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.NL, simulationName="ge.YNL4.NL", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.NL, simulationName="ge.NYL4.NL", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.FEDO, simulationName="ge.YYL4.FEDO", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.FEDO, simulationName="ge.YNL4.FEDO", certsOnly=FALSE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.FEDO, simulationName="ge.NYL4.FEDO", certsOnly=FALSE)
)

resultsCerts <- rbind(
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.FDO, simulationName="ge.YYL4.FDO", certsOnly=TRUE),
  # analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.FDO, simulationName="ge.YNL4.FDO", certsOnly=TRUE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.FDO, simulationName="ge.NYL4.FDO", certsOnly=TRUE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.NL, simulationName="ge.YYL4.NL", certsOnly=TRUE),
  # analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.NL, simulationName="ge.YNL4.NL", certsOnly=TRUE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.NL, simulationName="ge.NYL4.NL", certsOnly=TRUE),
  analyzeSimulation(geFull0=ge, simulationData=ge.YYL4.FEDO, simulationName="ge.YYL4.FEDO", certsOnly=TRUE),
  # analyzeSimulation(geFull0=ge, simulationData=ge.YNL4.FEDO, simulationName="ge.YNL4.FEDO", certsOnly=TRUE),
  analyzeSimulation(geFull0=ge, simulationData=ge.NYL4.FEDO, simulationName="ge.NYL4.FEDO", certsOnly=TRUE)
)

#### End ####

#### Save results files ####

write.csv(resultsOverall, "Results overall 10-07-2025.csv", row.names=FALSE)
write.csv(resultsCerts, "Results certs-only 10-07-2025.csv", row.names=FALSE)

#### End ####

#### Yes LEP, Yes GE simulation ####

analyzeSimulation(
  geFull0=ge,
  simulationData=ge.YYL4.FEDO,
  simulationName="ge.YYL4.FEDO",
  certsOnly=TRUE
)

#### End #### 

###########################################
#### D/E versus Loan Caps              ####
###########################################

#### Format GE programs ####

ge <- ge %>% mutate(
  `Fail DTE` = ifelse(
    `passfail_2019` %in% c("Fail DTE only", "Fail both DTE and EP"), 
    "Fail DTE", 
    "Does not fail DTE"
  ), 
  `Fail GE` = ifelse(
    `passfail_2019` %in% c("Fail DTE only", "Fail both DTE and EP", "Fail EP only"), 
    "Fail GE", 
    "Does not fail GE"
  ), 
  `Fail LEP` = ifelse(
    `passfailLEP`=="Fail LEP", 
    "Fail LEP", 
    "Does not fail LEP"
  )
) %>% mutate(
  `CIP-CRED` = paste(`cip4`, `cred_lvl`, sep="...")
) %>% mutate(
  `Count` = rep(1)
)

#### End #### 

#### Programs that fail DTE but pass LEP ####

ge <- ge %>% mutate(
  `Debt-income ratio` = `mediandebt` / `mdearnp3`
)

failDTEpassLEP <- ge %>% filter(
  `Fail DTE` == "Fail DTE",
  `passfailLEP` %in% c("No LEP data", "Pass LEP"), 
  inGE==1, 
  inLEP==1
) 

median(ge$`Debt-income ratio`, na.rm=TRUE)
median(failDTEpassLEP$`Debt-income ratio`, na.rm=TRUE)

example1 <- failDTEpassLEP %>% filter(
  `opeid6`==25042, 
  `cip4`==4201, 
  `cred_lvl`=="Doctoral"
)

example2 <- failDTEpassLEP %>% filter(
  `opeid6`==2678, 
  `cip4`==4301, 
  `cred_lvl`=="Bachelor's"
)

rm(example1, example2)

nrow(failDTEpassLEP)
sum(failDTEpassLEP$t4enrl2022, na.rm=TRUE)

failDTEpassLEP <- failDTEpassLEP %>% mutate(
  `Earnings over $35,000` = ifelse(
    `mdearnp3` >= 35000, 
    "Over $35,000", 
    "Under $35,000"
  )
)
aggregate(
  data=failDTEpassLEP, 
  `t4enrl2022` ~ `Earnings over $35,000`, 
  FUN=sum
)

#### End #### 

###########################################
#### Pell Grants: programs failing LEP ####
###########################################

#### Sum Pell numbers ####

ge <- ge %>% mutate(
  `pell_vol_2016` = ifelse(is.na(`pell_vol_2016`), 0, `pell_vol_2016`),
  `pell_vol_2017` = ifelse(is.na(`pell_vol_2017`), 0, `pell_vol_2017`),
  `pell_vol_2018` = ifelse(is.na(`pell_vol_2018`), 0, `pell_vol_2018`),
  `pell_vol_2019` = ifelse(is.na(`pell_vol_2019`), 0, `pell_vol_2019`),
  `pell_vol_2020` = ifelse(is.na(`pell_vol_2020`), 0, `pell_vol_2020`),
  `pell_vol_2021` = ifelse(is.na(`pell_vol_2021`), 0, `pell_vol_2021`),
  `pell_vol_2022` = ifelse(is.na(`pell_vol_2022`), 0, `pell_vol_2022`),
  `tot_loan_vol2016` = ifelse(is.na(`tot_loan_vol2016`), 0, `tot_loan_vol2016`),
  `tot_loan_vol2017` = ifelse(is.na(`tot_loan_vol2017`), 0, `tot_loan_vol2017`),
  `tot_loan_vol2018` = ifelse(is.na(`tot_loan_vol2018`), 0, `tot_loan_vol2018`),
  `tot_loan_vol2019` = ifelse(is.na(`tot_loan_vol2019`), 0, `tot_loan_vol2019`),
  `tot_loan_vol2020` = ifelse(is.na(`tot_loan_vol2020`), 0, `tot_loan_vol2020`),
  `tot_loan_vol2021` = ifelse(is.na(`tot_loan_vol2021`), 0, `tot_loan_vol2021`),
  `tot_loan_vol2022` = ifelse(is.na(`tot_loan_vol2022`), 0, `tot_loan_vol2022`)
) %>% mutate(
  `Annual pell_vol` = (`pell_vol_2016` + `pell_vol_2017` + `pell_vol_2018` + `pell_vol_2019` + `pell_vol_2020` + `pell_vol_2021` + `pell_vol_2022`) / 7, 
  `Annual tot_loan_vol` = (`tot_loan_vol2016` + `tot_loan_vol2017` + `tot_loan_vol2018` + `tot_loan_vol2019` + `tot_loan_vol2020` + `tot_loan_vol2021` + `tot_loan_vol2022`) / 7
) %>% mutate(
  `More loans or more Pell` = ifelse(
    `Annual tot_loan_vol` > `Annual pell_vol`, 
    "More loans", 
    "More Pell"
  )
)

#### End #### 

#### Aggregate counting numbers ####

agg2 <- aggregate(
  data=ge, 
  cbind(
    `Count`, 
    `Annual pell_vol`, 
    `Annual tot_loan_vol`
  ) ~ `Fail LEP` + `Fail GE` + `inGE`, 
  FUN=sum
) %>% filter(
  `Fail GE`=="Fail GE", 
  `inGE`==1
) %>% arrange(
  desc(`Fail LEP`)
)

agg2A <- aggregate(
  data=ge, 
  cbind(
    `Count`, 
    `Annual pell_vol`, 
    `Annual tot_loan_vol`
  ) ~ `Fail GE` + `inGE`, 
  FUN=sum
) %>% filter(
  `Fail GE`=="Fail GE", 
  `inGE`==1
) %>% mutate(
  `Fail LEP` = rep("Overall (fail GE)")
)
agg2 <- rbind(
  agg2, agg2A
) %>% mutate(
  `Pell share of Title IV` = `Annual pell_vol` / (`Annual pell_vol` + `Annual tot_loan_vol`), 
) %>% mutate(
  `Annual pell_vol` = dollar(`Annual pell_vol`), 
  `Annual tot_loan_vol` = dollar(`Annual tot_loan_vol`), 
  `Pell share of Title IV` = percent(`Pell share of Title IV`)
)

write.csv(agg2, "output-2.csv", row.names=FALSE)

#### End #### 

#### Programs with more Pell than loans ####

agg3 <- aggregate(
  data=ge, 
  `Count` ~ `Fail LEP` + `Fail GE` + `More loans or more Pell`, 
  FUN=sum
) %>% filter(
  `Fail LEP`=="Fail LEP", 
  `Fail GE`=="Fail GE"
)

write.csv(agg3, "output-3.csv", row.names=FALSE)

#### End #### 

#### Programs that fail LEP ####

agg4 <- aggregate(
  data=ge, 
  `Count` ~ `Fail LEP` + `Fail GE` + `inGE`, 
  FUN=sum
) %>% filter(
  `inGE`==1, 
  `Fail LEP` == "Fail LEP"
)
  
#### End #### 

###########################################
#### Dentistry programs                ####
###########################################

#### Analyze data (Red Zone analysis) ####

csp <- read.csv(
  "Most-Recent-Cohorts-Field-of-Study_04172025.csv", 
  header=TRUE
) %>% select(
  `UNITID`, 
  `INSTNM`,
  `CONTROL`,
  `OPEID6`,
  `CIPCODE`, 
  `CIPDESC`, 
  `CREDLEV`, 
  `CREDDESC`, 
  `IPEDSCOUNT1`, 
  `IPEDSCOUNT2`,
  `DEBT_ALL_STGP_EVAL_N`,
  `DEBT_ALL_STGP_EVAL_MEAN`,
  `DEBT_ALL_STGP_EVAL_MDN`,
  `DEBT_PELL_STGP_EVAL_N`,
  `EARN_MDN_5YR`, 	
  `EARN_COUNT_WNE_5YR` 
) %>% mutate(
  `IPEDSCOUNT1` = ifelse(
    is.na(`IPEDSCOUNT1`), 0, `IPEDSCOUNT1`
  ), 
  `IPEDSCOUNT2` = ifelse(
    is.na(`IPEDSCOUNT2`), 0, `IPEDSCOUNT2`
  )
) %>% mutate(
  `IPEDSCOUNT` = `IPEDSCOUNT1` + `IPEDSCOUNT2`
) %>% filter(
  `CREDLEV` %in% (4:8)
) %>% mutate(
  `Unique code` = paste(
    `OPEID6`, 
    `CIPCODE`, 
    `CREDLEV`, 
    sep="..."
  )
) %>% arrange(
  desc(`IPEDSCOUNT`)
) %>% filter(
  duplicated(`Unique code`)==FALSE
) %>% select(
  -(`IPEDSCOUNT1`), 
  -(`IPEDSCOUNT2`)
) %>% mutate(
  `Count` = rep(1)
)

suppressWarnings({
  csp <- csp %>% mutate(
    `DEBT_ALL_STGP_EVAL_N` = as.numeric(`DEBT_ALL_STGP_EVAL_N`), 
    `DEBT_ALL_STGP_EVAL_MDN` = as.numeric(`DEBT_ALL_STGP_EVAL_MDN`), 
    `EARN_COUNT_WNE_5YR` = as.numeric(`EARN_COUNT_WNE_5YR`), 
    `EARN_MDN_5YR` = as.numeric(`EARN_MDN_5YR`)
  )
})

csp <- csp %>% filter(
  is.na(`DEBT_ALL_STGP_EVAL_N`) == FALSE, 
  `DEBT_ALL_STGP_EVAL_N` > 0
)

dentistDebt <- csp %>% filter(
  `DEBT_ALL_STGP_EVAL_N` >= 30 
) %>% filter(
  `CIPCODE`==5104, # Dentistry 
  `CREDLEV`==7 # First professional
) %>% filter(
  is.na(`DEBT_ALL_STGP_EVAL_MDN`)==FALSE
) %>% mutate(
  `Red zone status` = ifelse(
    `DEBT_ALL_STGP_EVAL_MDN` > (157987), 
    "Red zone", 
    "Not in red zone"
  )
)

agg5 <- aggregate(
  data=dentistDebt, 
  `Count` ~ `Red zone status`,
  FUN=sum
)

dentistEarnings <- csp %>% filter(
  `EARN_COUNT_WNE_5YR` >= 30 
) %>% filter(
  `CIPCODE`==5104, # Dentistry 
  `CREDLEV`==7 # First professional
) %>% filter(
  is.na(`EARN_MDN_5YR`)==FALSE
) 

weighted.mean(
  x=dentistEarnings$`EARN_MDN_5YR`, 
  w=dentistEarnings$`EARN_COUNT_WNE_5YR`
)

#### End #### 


