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
load(here::here("data/Wambaugh2019_regen2025_Clint_L1-3.RData"),verbose = TRUE)
#------------------------------------------------------------------------------#
## Evaluate the Data ##
# see the column names
colnames(wambaugh2019.clint.L2)
# check the class of each column of the L2 dataset
sapply(wambaugh2019.clint.L2,class)
# get a summary of input in each column of the L2 dataset
summary(wambaugh2019.clint.L2)
# check whether any of the columns in the L2 dataset have missing values
#   (are there any with NA's which we should investigate)
sapply(wambaugh2019.clint.L2,anyNA)
# subset to the columns that have at least one missing values
sapply(wambaugh2019.clint.L2,anyNA) %>% .[which(.)]
#------------------------------------------------------------------------------#
## Investigate Potential Problematic Issues ##
# investigate anything that seems problematic/off
col2check <- sapply(wambaugh2019.clint.L2,anyNA) %>% .[which(.)] %>% names()
sapply(wambaugh2019.clint.L2[,col2check],function(x)table(is.na(x)))
# evaluate the sample types with a missing ISTD.Area
wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,is.na(ISTD.Area)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Area
wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,is.na(Area)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Time
wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,is.na(Time)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Response
wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,is.na(Response)) %>% 
  dplyr::count(Sample.Type)
# evaluate the sample types with a missing Test.Compound.Conc
wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,is.na(Test.Compound.Conc))
# check the original raw data file to see if the Concentration is missing there as well
tmp <- readxl::read_xlsx(here::here("raw_data/toxsci-19-0394-File012.xlsx"),sheet = 1)
tmp %>% 
  dplyr::filter(.,Sample.Name == "1444917_1╡M_0_3") %>% 
  View()
# check to see if there are L3 results for this chemical
wambaugh2019.clint.L3 %>% 
  dplyr::filter(.,Compound.Name == "5-Heptyldihydro-2(3H)-furanone")
# test out whether you remove the sample with an NA test.nominal.conc if you can estimate an L3 
test <- wambaugh2019.clint.L2 %>% 
  dplyr::filter(.,Compound.Name == "5-Heptyldihydro-2(3H)-furanone") %>% 
  dplyr::filter(.,!is.na(Test.Nominal.Conc))

invitroTKstats::calc_clint_point(data.in = test,output.res = FALSE)
  # successful run so either need to 'unverify' the sample OR remove it (likely the former)
#------------------------------------------------------------------------------#
## Session Information ##
Sys.time()
sessionInfo()
#------------------------------------------------------------------------------#