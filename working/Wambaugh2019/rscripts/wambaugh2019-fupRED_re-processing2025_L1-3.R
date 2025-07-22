#------------------------------------------------------------------------------#
## Re-processing Wambaugh2019 fup RED (L1-L3) ##
#------------------------------------------------------------------------------#
## NOTE: This script is meant to be run programmatically via the following
##       command in the bash command line terminal:
##          `R CMD BATCH --vanilla wambaugh2019-fupRED_re-processing2025.R`
#------------------------------------------------------------------------------#
## R Packages ##
library(invitroTKstats)
library(dplyr)
library(magrittr)
library(stringr)
library(tictoc)
library(here)
## Check Package Version ##
packageVersion("invitroTKstats")
#------------------------------------------------------------------------------#
## Load in Data ##
#================================================================#
# NOTE: The 'data_dir' is the user specific path to where the    #
#       data is. Ideally, one would be working within an R       #
#       project and could utilize the "here" package for         #
#       relative file path identification.                       #
#================================================================#
# load in the currently utilized L0 data files - wambaugh2019.RData prepared by format-wambaugh2019*.R
load(here::here("raw_data/wambaugh2019.RData"),verbose = TRUE)
#------------------------------------------------------------------------------#
## pre-data proc steps ##
#================================================================#
# NOTE: This is legacy data and some of the current requirements # 
#       were not necessary in prototype versions of the          #
#       invitroTKstats R package.                                #
#================================================================#
# assign the old version of the Wambaugh2019 fup RED (L0) dataset to an new object
wambaugh2019.red.updated <- wambaugh2019.red

# remove cases where SampleName is missing (i.e. "NA")
wambaugh2019.red.updated <- dplyr::filter(wambaugh2019.red.updated,!is.na(SampleName))

# change the area, response, dilution factor, and protein columns to be numeric
wambaugh2019.red.updated[,"Area"] <- as.numeric(wambaugh2019.red.updated[,"Area"])
wambaugh2019.red.updated[,"ISTD.Area"] <- as.numeric(wambaugh2019.red.updated[,"ISTD.Area"])
wambaugh2019.red.updated[,"ISTDResponseRatio"] <- as.numeric(wambaugh2019.red.updated[,"ISTDResponseRatio"])
wambaugh2019.red.updated[,"Dilution.Factor"] <- as.numeric(wambaugh2019.red.updated[,"Dilution.Factor"])
wambaugh2019.red.updated[,"Protein"] <- as.numeric(wambaugh2019.red.updated[,"Protein"])

# add the sample type column
wambaugh2019.red.updated <- dplyr::mutate(wambaugh2019.red.updated,Sample.Type = NA) # create a Sample.Type columm - assign all to NA
wambaugh2019.red.updated[grepl(wambaugh2019.red.updated[,"SampleName"],pattern = "blank",ignore.case = TRUE),"Sample.Type"] <- "No.Plasma.Blank" # assume all lab sample names with blank are no plasma blanks
wambaugh2019.red.updated[grepl(wambaugh2019.red.updated[,"SampleName"],pattern = "plasma",ignore.case = TRUE),"Sample.Type"] <- "Plasma" # assume all lab sample names with plasma are plasma samples
wambaugh2019.red.updated[grepl(wambaugh2019.red.updated[,"SampleName"],pattern = "blank.+plasma",ignore.case = TRUE),"Sample.Type"] <- "Plasma.Blank" # assume lab sample names with blank and plasma are plasma blanks (overwrite any previously assigned to no plasma blank)
wambaugh2019.red.updated[grepl(wambaugh2019.red.updated[,"SampleName"],pattern = "Plasma_T0|T0",ignore.case = TRUE),"Sample.Type"] <- "T0" # assume lab sample names with T0 are T0 sample types
wambaugh2019.red.updated[grepl(wambaugh2019.red.updated[,"SampleName"],pattern = "PBS"),"Sample.Type"] <- "PBS" # assume lab sample names with PBS are PBS sample types

# add the "general" dilution factor information (based on previous formatting R script)
wambaugh2019.red.updated <- dplyr::mutate(wambaugh2019.red.updated,Dilution.Factor.Gen = 1) # assume for baseline all DF's are 1 unless otherwise specified below (based on `Clint-2019-Example.R`)
wambaugh2019.red.updated[which(wambaugh2019.red.updated[,"Sample.Type"]=="PBS"),"Dilution.Factor.Gen"] <- 2
wambaugh2019.red.updated[which(wambaugh2019.red.updated[,"Sample.Type"]=="Plasma"),"Dilution.Factor.Gen"] <- 5

# add an updated task order/calibration column
wambaugh2019.red.updated <- dplyr::mutate(wambaugh2019.red.updated,TO.cal = Task.Order)
# identify cases where there is a missing TO, which we will assume for the Calibration
missing_TO <- which(is.na(wambaugh2019.red.updated[,"Task.Order"]))
# extract the TO numbers for the TO.cal column
wambaugh2019.red.updated[missing_TO,"TO.cal"] <- wambaugh2019.red.updated[missing_TO,"RawDataSet"] %>%
  stringr::str_extract_all(.,pattern = "task.\\d+|Task.\\d+|task\\d+|Task\\d+") %>%
  stringr::str_remove(.,pattern ="task\\s+|Task\\s+|task|Task") %>%
  as.vector.data.frame() %>%
  as.numeric()
# for those still missing value in TO.cal assign to "Wambaugh2019" for now
wambaugh2019.red.updated[which(is.na(wambaugh2019.red.updated[,"TO.cal"])),"TO.cal"] <- "Wambaugh2019"

# identify Compound.Names that are "NA"
missing_cmpdname <- which(wambaugh2019.red.updated[,"Preferred.Name"] == "NA" & !grepl(x = wambaugh2019.red.updated$CompoundName,pattern = "^EV"))
wambaugh2019.red.updated[missing_cmpdname,"Preferred.Name"] <- stringr::str_remove(wambaugh2019.red.updated[missing_cmpdname,"CompoundName"],pattern = "-\\d+.+")
#------------------------------------------------------------------------------#
## Reassign Pre-Proc Object to L0 ##
wambaugh2019.red.L0 <- wambaugh2019.red.updated
#------------------------------------------------------------------------------#
## Process L0 Data to L1 ##
tictoc::tic()
wambaugh2019.red.L1 <- invitroTKstats::format_fup_red(
  data.in = wambaugh2019.red.updated,
  FILENAME = "Wambaugh2019_regen2025",
  sig.figs = NULL,
  output.res = TRUE,
  OUTPUT.DIR = here::here("data"),
  sample.col="SampleName",
  compound.col="Preferred.Name",
  lab.compound.col="CompoundName",
  # cal.col = "TO.cal",
  cal = "Wambaugh2019",
  date = "MMDD19",
  # NOTE: This is what is gathered from the "format-wambaugh2019-red.data.R", but lists multiple 3 compounds which is not ideal.
  istd.name = "Bucetin and Diclofenac",
  istd.conc = 1,
  dilution.col = "Dilution.Factor.Gen",
  plasma.percent.col = "Protein",
  biological.replicates = 1,technical.replicates = 1,
  analysis.method = "TBD",
  analysis.instrument = "TBD",
  analysis.parameters = "TBD",
  note.col = NULL,
  test.nominal.conc = 5,
  test.conc = 5, # guessing on this one
  time = 120, # guessing on this one
  level0.file = "toxsci-19-0394-File011.xlsx",
  level0.sheet = "SupplementalTable2"
)
tictoc::toc()
## Process L1 to L2 ##
# check if there are any lab sample names registered as `NA`
any(is.na(wambaugh2019.red.L1$Lab.Compound.Name))
# remove any samples with Lab.Compound.Name == `NA`
#   if there are missing Lab.Compound.Name entries these samples should be removed
#   as this is minimum required information from the wet-lab generating data
if(any(is.na(wambaugh2019.red.L1$Lab.Compound.Name))){
  # stash samples with a missing Lab.Compound.Name
  samps_na.lab.comp.name <- dplyr::filter(wambaugh2019.red.L1,is.na(Lab.Compound.Name))
  save(samps_na.lab.comp.name,
       file = here::here("data/Wambaugh2019_regen2025_fupRED_LCNsampNA.RData"))
  # update the L1 dataset
  wambaugh2019.red.L1 <- dplyr::filter(wambaugh2019.red.L1,!is.na(Lab.Compound.Name))
}
# create an exclusion criteria dataframe
#   when doing the initial processing identified a compound with Blank samples and Response is Infinite
#   assume these samples should be "unverified" (i.e. held-out from the data)
exclusion_cases <- dplyr::filter(wambaugh2019.red.L1,is.nan(Response)) %>%
  .[,"Lab.Compound.Name"] %>%
  unique() %>% 
  paste("NA",.,"Plasma",0,sep = "|")

EC_wambaugh2019.red <- data.frame(
  Variables = rep("DTXSID|Lab.Compound.Name|Sample.Type|ISTD.Area",length(exclusion_cases)),
  Values = exclusion_cases,
  Message = c("ISTD.Area and Area are both 0 - Results in NaN Response.")
)

tictoc::tic()
wambaugh2019.red.L2 <- invitroTKstats::sample_verification(
  data.in = wambaugh2019.red.L1,
  output.res = TRUE,
  exclusion.info = EC_wambaugh2019.red,
  FILENAME = "Wambaugh2019_regen2025",
  assay = "fup-RED",
  OUTPUT.DIR = here::here("data")
)
tictoc::toc()
## Process L2 to L3 ##
tictoc::tic()
wambaugh2019.red.L3 <- invitroTKstats::calc_fup_red_point(
  data.in = wambaugh2019.red.L2,
  sig.figs = NULL,
  output.res = TRUE,
  FILENAME = "Wambaugh2019_regen2025",
  OUTPUT.DIR = here::here("data")
)
tictoc::toc()
#------------------------------------------------------------------------------#
## Save Data ##
# save the primary data
save(
  wambaugh2019.red.L0,
  wambaugh2019.red.L1,
  wambaugh2019.red.L2,
  wambaugh2019.red.L3,
  file = here::here("data/Wambaugh2019_regen2025_fupRED_L1-3.RData")
)
# save supplementary files
save(
  EC_wambaugh2019.red,
  file = here::here("data/Wambaugh2019_regen2025_fupRED_supp.RData")
)
#------------------------------------------------------------------------------#
## Session Information ##
sessionInfo()
Sys.time()
#------------------------------------------------------------------------------#