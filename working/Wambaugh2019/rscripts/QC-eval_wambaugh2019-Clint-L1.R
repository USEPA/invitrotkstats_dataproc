#=============================================================================#
## Title: QC Level-1 Wambaugh 2019 Clint
#=============================================================================#
## R Packages ##
library(dplyr)
library(magrittr)
library(stringr)
library(here)
## Load in Data ##
load(here::here("data/Wambaugh2019_regen2025_Clint_L1-3.RData"),verbose = TRUE)
#=============================================================================#
## Items to Check:
##  1) Determine if there are any columns with missing information (NA's).
##      a) Are the columns with missing information handled by the Clint estimation.
##      b) For the columns with missing information not handled by the Clint
##         estimation, determine the samples that need to be 'unverified'.
##  2) Determine if there are any chemicals that do not have sufficient sample
##     type information.
##  3) Determine if there are any responses reported as "infinite", and
##     if YES then identify them to be 'unverified'.
#=============================================================================#
## Investigate L1 Data ##
sapply(wambaugh2019.clint.L1,class) # determine the class of each column
summary(wambaugh2019.clint.L1) # obtain a summary of values in each column

## Missing Value Check ##
sapply(wambaugh2019.clint.L1,anyNA) %>% .[which(.)] # determine the NA's
  # ISTD.Area - Currently no issue if ISTD.Area is missing.
  # Area - Currently no issue if Area is missing.
  # Time - If "Time" is missing for a non-"Blank" sample, then there is a problem.
  # Test.Compound.Conc - Currently no issue if Test.Compound.Conc is missing.
  # Test.Nominal.Conc - Issues if any Test.Nominal.Conc values are missing.
  # Response - Currently no issue if Response is missing.

# identify the non-Blank samples with a missing 'Time'
dplyr::filter(wambaugh2019.clint.L1,is.na(Time)) %>% 
  dplyr::filter(.,Sample.Type != "Blank")

# identify the samples with a missing 'Test.Nominal.Conc'
dplyr::filter(wambaugh2019.clint.L1,is.na(Test.Nominal.Conc))

## Sample Type Check ##
# determine the counts of the required sample types & if there are any missing
missing.sample.types <- dplyr::group_by(wambaugh2019.clint.L1,DTXSID) %>%
  dplyr::select(.,c(DTXSID,Sample.Type)) %>% 
  dplyr::summarise(.,
                   Blank.Count = sum(Sample.Type == "Blank"),
                   Cvst.Count = sum(Sample.Type == "Cvst")) %>% 
  dplyr::mutate(.,
                Blank.Missing = (Blank.Count == 0),
                Cvst.Missing = (Cvst.Count == 0))
# filter for chemicals that have any of the required samples missing
missing.sample.types %>% 
  dplyr::filter(.,Blank.Missing|Cvst.Missing)

## Infinite Response Check ##
# identify the samples with an infinite response
dplyr::filter(wambaugh2019.clint.L1,Response == "Inf")
# determine the chemicals with an infinite response
dplyr::filter(wambaugh2019.clint.L1,Response == "Inf") %>% 
  dplyr::summarise(.,unique(DTXSID))
# check to make sure there is sufficient samples to obtain an estimate after 
#   flagging the infinite responses
dplyr::filter(wambaugh2019.clint.L1,DTXSID == "DTXSID4020870") %>% 
  dplyr::group_by(.,DTXSID) %>% 
  dplyr::filter(.,Response!="Inf") %>% 
  dplyr::select(.,c(DTXSID,Sample.Type,Response)) %>% 
  dplyr::summarise(.,
                   Blank.Sample.Count = sum(Sample.Type == "Blank"),
                   Cvst.Sample.Count = sum(Sample.Type == "Cvst"))
#=============================================================================#
## Session Information ##
Sys.time()
sessionInfo()
#=============================================================================#