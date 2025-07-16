#=============================================================================#
## Title: QC Level-1 Wambaugh 2019 fup-RED
#=============================================================================#
## R Packages ##
library(dplyr)
library(magrittr)
library(stringr)
library(here)
## Load in Data ##
load(here::here("data/Wambaugh2019_regen2025_fupRED_L1-3.RData"),verbose = TRUE)
#=============================================================================#
## Items to Check:
##  1) Determine if there are any columns with missing information (NA's).
##      a) Are the columns with missing information handled by the fup-RED estimation.
##      b) For the columns with missing information not handled by the fup-RED
##         estimation, determine the samples that need to be 'unverified'.
##  2) Determine if there are any chemicals that do not have sufficient sample
##     type information.
##  3) Determine if there are any responses reported as "infinite", and
##     if YES then identify them to be 'unverified'.
#=============================================================================#
## Investigate L1 Data ##
sapply(wambaugh2019.red.L1,class) # determine the class of each column
summary(wambaugh2019.red.L1) # obtain a summary of values in each column

## Missing Value Check ##
sapply(wambaugh2019.red.L1,anyNA) %>% .[which(.)] # determine the NA's
  # Dilution.Factor - If "Dilution.Factor" is missing for required samples,
  #                   then there is a problem.
  # Calibration - Currently no issue if Calibration is missing.
  # ISTD.Area - Currently no issue if ISTD.Area is missing.
  # Area - Currently no issue if Area is missing.
  # Response - Currently no issue if Response is missing.

# identify if there are any required samples with a missing 'Dilution.Factor'
dplyr::filter(wambaugh2019.red.L1,is.na(Dilution.Factor)) %>% 
  dplyr::group_by(.,DTXSID) %>% 
  dplyr::summarise(.,
                   T0.DF.Missing.Count = sum(Sample.Type == "T0"),
                   PBS.DF.Missing.Count = sum(Sample.Type == "PBS"),
                   Plasma.DF.Missing.Count = sum(Sample.Type == "Plasma")) %>% 
  dplyr::mutate(.,
                T0.DF.Missing = (T0.DF.Missing.Count != 0),
                PBS.DF.Missing = (PBS.DF.Missing.Count != 0),
                Plasma.DF.Missing = (Plasma.DF.Missing.Count != 0)) %>% 
  dplyr::filter(.,PBS.DF.Missing|Plasma.DF.Missing)
# identify the samples with a missing 'Calibration'
missing.calibration <- dplyr::filter(wambaugh2019.red.L1,is.na(Calibration)) %>% 
  dplyr::distinct(.,DTXSID)
# characterize the count of samples with missing and non-missing calibration
dplyr::filter(wambaugh2019.red.L1,DTXSID %in% missing.calibration[,1]) %>% 
  dplyr::group_by(.,DTXSID) %>% 
  dplyr::summarise(.,
                   Cal.Missing.Count = sum(is.na(Calibration)),
                   Cal.nonMissing.Count = sum(!is.na(Calibration))) %>% 
  print(n = nrow(.))
# characterize the calibrations for the chemicals with at least one missing calibration
dplyr::filter(wambaugh2019.red.L1,DTXSID %in% missing.calibration[,1]) %>% 
  dplyr::group_by(.,DTXSID) %>% 
  dplyr::distinct(.,Calibration) %>%
  dplyr::arrange(.,DTXSID) %>% 
  print(n = nrow(.))

## Sample Type Check ##
# determine the counts of the required sample types & if there are any missing
missing.sample.types <- dplyr::group_by(wambaugh2019.red.L1,DTXSID) %>%
  dplyr::select(.,c(DTXSID,Sample.Type)) %>% 
  dplyr::summarise(.,
                   Plasma.Count = sum(Sample.Type == "Plasma"),
                   PBS.Count = sum(Sample.Type == "PBS"),
                   Plasma.Blank.Count = sum(Sample.Type == "Plasma.Blank")) %>% 
  dplyr::mutate(.,
                Plasma.Missing = (Plasma.Count == 0),
                PBS.Missing = (PBS.Count == 0),
                Plasma.Blank.Missing = (Plasma.Blank.Count == 0))
# filter for chemicals that have any of the required samples missing
# missing Plasma, PBS, or Plasma.Blank
missing.sample.types %>% 
  dplyr::filter(.,Plasma.Missing|PBS.Missing|Plasma.Blank.Missing) %>% 
  print(n = nrow(.))

## Infinite Response Check ##
# identify the samples with an infinite response
dplyr::filter(wambaugh2019.red.L1,Response == "Inf")
#=============================================================================#
## Session Information ##
Sys.time()
sessionInfo()
#=============================================================================#