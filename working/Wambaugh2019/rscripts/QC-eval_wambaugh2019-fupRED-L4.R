#==============================================================================#
## Post QC Data Check for Level-4 Estimates ##
#==============================================================================#
## R Packages ##
library(dplyr)
library(magrittr)
library(stringr)
library(here)
#==============================================================================#
## Load in the Data ##
load(here::here("data/Wambaugh2019_regen2025_fupRED_L1-3.RData"),verbose = TRUE) # load in the L1-L3 data, specifically for L2
load(here::here("data/Wambaugh2019_regen2025-fup-RED-Level4Analysis-2025-07-10.RData"),verbose = TRUE) # load in compiled L4 data
#==============================================================================#
## Items to Check:
##  1) Determine the chemicals lacking level-4 estimates.
##  2) Determine whether the chemicals lacking level-4 estimates are missing
##     required sample types.
##  3) For the chemicals with sufficient sample types, determine what other
##     factors may be causing a lack of an estimate (start with `Responses`).
#=============================================================================#
## General Investigation of Data ##
# total number of compounds in the L2 dataset that may be evaluated
length(unique(wambaugh2019.red.L2$Compound.Name))
# dimensions for the L4 Results Table - i.e. compounds with a Bayesian estimate
dim(Results)

## Evaluate the Compounds not without L4 Estimates ##
# obtain the full chem list (level-2 dataset)
full_chem_list <- unique(wambaugh2019.red.L2$Compound.Name) 
# obtain the chemicals without a level-4 estimation
chem_noL4 <- full_chem_list[which(!(full_chem_list%in%Results$Compound.Name))] 
# get the number of chemicals without a level-4 estimate
length(chem_noL4)

## Required Sample Type Check ##
# subset level-2 data to get only those without a level-4 estimate
L2_noL4 <- wambaugh2019.red.L2 %>% 
  dplyr::filter(.,Compound.Name %in% chem_noL4)

# check the sample types that are missing for each chemical lacking a level-4 estimate
table(L2_noL4[,c("Compound.Name","Sample.Type")]) %>% 
  apply(.,1,function(X)names(X)[which(X == 0)]) %>% 
  unlist() %>% as.data.frame() %>%
  table()

# obtain a dataset summarizing the unique sample types
unique_ST_DF <- wambaugh2019.red.L2 %>% 
  dplyr::group_by(.,Compound.Name) %>% 
  dplyr::reframe(.,unique_ST = unique(Sample.Type))

sample_type_check <- unique_ST_DF %>% 
  dplyr::filter(.,unique_ST != "T0") %>% # T0 is not a required sample type at this time, thus remove from sample type list
  aggregate(unique_ST ~ Compound.Name,data = .,FUN = function(x)paste(x, collapse = "|")) # collapse the existing sample types for each compound

# create a list of all possible entries for the required sample type (combinations of collapsed strings)
req.sample.type.list <- c("Plasma.Blank|PBS|Plasma","Plasma|PBS|Plasma.Blank",
                          "PBS|Plasma|Plasma.Blank","PBS|Plasma.Blank|Plasma",
                          "Plasma|Plasma.Blank|PBS","Plasma.Blank|Plasma|PBS|")

# obtain the chemicals without the required sample types for level-4 estimates
chem_wo_reqST <- sample_type_check[which(!(sample_type_check$unique_ST%in%req.sample.type.list)),"Compound.Name"]
# number of chemicals without the required sample types for level-4 estimates
length(chem_wo_reqST)

# is the number of chemicals without a level-4 estimates equal to the number of chemicals without sufficient sample types
length(chem_noL4)==length(chem_wo_reqST)
# obtain the set difference
setdiff(chem_noL4,chem_wo_reqST) # chemicals with sufficient sample types but no estimate

# obtain the samples for chemicals with sufficient samples but still lack a level-4 estimate
L2_noL4.suffsamp <- wambaugh2019.red.L2 %>% 
  dplyr::filter(.,Compound.Name %in% setdiff(chem_noL4,chem_wo_reqST))
# obtain the mean response of the compounds with sufficient samples but lacking a level-4 estimate
L2_noL4.suffsamp %>% 
  dplyr::group_by(Compound.Name,Sample.Type) %>% 
  dplyr::summarise(.,mean_resp = mean(Response,na.rm = FALSE)) # keep cases with missing data

L2_noL4.suffsamp %>% 
  dplyr::group_by(Compound.Name,Sample.Type) %>% 
  dplyr::summarise(.,mean_resp = mean(Response,na.rm = TRUE)) # remove cases with missing data
  # at least 1 sample type has only missing values

# check the chemicals with level-4 estimates that none of them have all missing data
wambaugh2019.red.L2 %>% 
  dplyr::filter(.,Compound.Name %in% setdiff(full_chem_list,chem_noL4)) %>% 
  dplyr::group_by(Compound.Name,Sample.Type) %>% 
  dplyr::summarise(.,mean_resp = mean(Response,na.rm = TRUE)) %>% 
  dplyr::filter(.,is.nan(mean_resp))

wambaugh2019.red.L2 %>% 
  dplyr::filter(.,Compound.Name %in% setdiff(full_chem_list,chem_noL4)) %>% 
  dplyr::group_by(Compound.Name,Sample.Type) %>% 
  dplyr::summarise(.,mean_resp = mean(Response,na.rm = TRUE)) %>% 
  dplyr::filter(.,is.na(mean_resp))

wambaugh2019.red.L2 %>% 
  dplyr::filter(.,Compound.Name %in% setdiff(full_chem_list,chem_noL4)) %>% 
  dplyr::group_by(Compound.Name,Sample.Type) %>% 
  dplyr::summarise(.,mean_resp = mean(Response,na.rm = TRUE)) %>% 
  print(n = nrow(.))
#==============================================================================#
## Session Information ##
Sys.time()
sessionInfo()
#==============================================================================#