#------------------------------------------------------------------------------#
## QC Evaluation of Wambaugh 2019 Data ## 
#------------------------------------------------------------------------------#
## R Package ##
library(here)
library(dplyr)
library(magrittr)
library(readxl)
library(invitroTKstats)
#------------------------------------------------------------------------------#
## Load in the Data ##
load(here::here("data/Wambaugh2019_regen2025_fupRED_L1-3.RData"),verbose = TRUE)
#------------------------------------------------------------------------------#
## Evaluate the Data ##
# see the column names
colnames(wambaugh2019.red.L2)
# check the class of each column of the L2 dataset
sapply(wambaugh2019.red.L2,class)
# get a summary of input in each column of the L2 dataset
summary(wambaugh2019.red.L2)
# check whether any of the columns in the L2 dataset have missing values
#   (are there any with NA's which we should investigate)
sapply(wambaugh2019.red.L2,anyNA)
# subset to the columns that have at least one missing values
sapply(wambaugh2019.red.L2,anyNA) %>% .[which(.)]
#------------------------------------------------------------------------------#
## Investigate Potential Problematic Issues ##
# investigate anything that seems problematic/off
col2check <- sapply(wambaugh2019.red.L2,anyNA) %>% .[which(.)] %>% names()
sapply(wambaugh2019.red.L2[,col2check],function(x)table(is.na(x)))
# evaluate the sample types with a missing Dilution.Factor
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,is.na(Dilution.Factor)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Calibration
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,is.na(Calibration)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing ISTD.Area
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,is.na(ISTD.Area)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Area
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,is.na(Area)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Response
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,is.na(Response))
#------------------------------------------------------------------------------#
## Session Information ##
Sys.time()
sessionInfo()
#------------------------------------------------------------------------------#