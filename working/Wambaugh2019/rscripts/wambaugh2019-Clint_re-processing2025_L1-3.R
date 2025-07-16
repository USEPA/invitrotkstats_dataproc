#------------------------------------------------------------------------------#
## Re-processing Wambaugh2019 Clint (L1-L3) ##
#------------------------------------------------------------------------------#
## NOTE: This script is meant to be run programmatically via the following
##       command in the bash command line terminal:
##          `R CMD BATCH --vanilla wambaugh2019-Clint_re-processing2025.R`
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
# assign the old version of the Wambaugh2019 Clint (L0) dataset to an new object
wambaugh2019.clint.updated <- wambaugh2019.clint
# change the time column to be numeric
wambaugh2019.clint.updated[,"Time..mins."] <- as.numeric(wambaugh2019.clint.updated[,"Time..mins."])
# add the sample type column
#   auto-assign all to "Blank", then update those with a time to "Cvst"
wambaugh2019.clint.updated <- dplyr::mutate(wambaugh2019.clint.updated,Sample.Type = "Blank")
wambaugh2019.clint.updated[!is.na(wambaugh2019.clint.updated$Time..mins.),"Sample.Type"] <- "Cvst"
#------------------------------------------------------------------------------#
## Reassign Pre-Proc Object to L0 ##
wambaugh2019.clint.L0 <- wambaugh2019.clint.updated
#------------------------------------------------------------------------------#
## Process L0 Data to L1 ##
tictoc::tic()
wambaugh2019.clint.L1 <- invitroTKstats::format_clint(
  data.in = wambaugh2019.clint.updated,
  FILENAME = "Wambaugh2019_regen2025",
  sig.figs = NULL,
  output.res = TRUE,
  OUTPUT.DIR = here::here("data"),
  sample.col="Sample.Name",
  compound.col="Preferred.Name",
  lab.compound.col="Name",
  time.col="Time..mins.",
  cal = "Wambaugh2019",
  date = "MMDD19",
  # NOTE: This is what is gathered from the "format-wambaugh2019-clint.data.R", but lists multiple 3 compounds which is not ideal.
  istd.name = "Bucetin, Propranolol, and Diclofenac",
  istd.conc = 1,
  dilution = 1,
  density = 0.5,
  biological.replicates = 1,technical.replicates = 1,
  analysis.method = "TBD",
  analysis.instrument = "TBD",
  analysis.parameters = "TBD",
  note.col = NULL,
  test.conc.col = "Conc",
  test.nominal.conc.col = "Conc",
  level0.file = "toxsci-19-0394-File012.xlsx",
  level0.sheet = "SupplementalTable3"
)
tictoc::toc()
## Process L1 to L2 ##
# check if there are any lab sample names registered as `NA`
any(is.na(wambaugh2019.clint.L1$Lab.Compound.Name))
# remove any samples with Lab.Compound.Name == `NA`
#   if there are missing Lab.Compound.Name entries these samples should be removed
#   as this is minimum required information from the wet-lab generating data
if(any(is.na(wambaugh2019.clint.L1$Lab.Compound.Name))){
  # stash samples with a missing Lab.Compound.Name
  samps_na.lab.comp.name <- dplyr::filter(wambaugh2019.clint.L1,is.na(Lab.Compound.Name))
  save(samps_na.lab.comp.name,
       file = here::here("data/Wambaugh2019_regen2025_Clint_LCNsampNA.RData"))
  # update the L1 dataset
  wambaugh2019.clint.L1 <- dplyr::filter(wambaugh2019.clint.L1,!is.na(Lab.Compound.Name))
}
# create an exclusion criteria dataframe
#   when doing the initial processing identified a compound with Blank samples and Response is Infinite
#   assume these samples should be "unverified" (i.e. held-out from the data)
EC_wambaugh2019.clint <- data.frame(
  Variables = c("Lab.Compound.Name|Sample.Type|Test.Nominal.Conc",
                "Compound.Name"),
  Values = c("BF00174486|Blank|10",
             "E-Cinnamic acid"),
  Message = c("Response Values for Blank samples are Inf",
              "Compound has insufficient data, only Blank samples exist.")
)
tictoc::tic()
wambaugh2019.clint.L2 <- invitroTKstats::sample_verification(
  data.in = wambaugh2019.clint.L1,
  exclusion.info = EC_wambaugh2019.clint,
  output.res = TRUE,
  FILENAME = "Wambaugh2019_regen2025",
  assay = "Clint",
  OUTPUT.DIR = here::here("data")
)
# manual verification since the `sample_verification` cannot handle the special
# character in the lab sample name that needs to have a verification exception 
wambaugh2019.clint.L2[which(is.na(wambaugh2019.clint.L2$Test.Nominal.Conc)),"Verified"] <-
  "Missing Nominal or Compound Concentration value."
tictoc::toc()
## Process L2 to L3 ##
tictoc::tic()
wambaugh2019.clint.L3 <- invitroTKstats::calc_clint_point(
  data.in = wambaugh2019.clint.L2,
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
  wambaugh2019.clint.L0,
  wambaugh2019.clint.L1,
  wambaugh2019.clint.L2,
  wambaugh2019.clint.L3,
  file = here::here("data/Wambaugh2019_regen2025_Clint_L1-3.RData")
)
# save supplementary files
save(
  EC_wambaugh2019.clint,
  file = here::here("data/Wambaugh2019_regen2025_Clint_supp.RData")
)
#------------------------------------------------------------------------------#
## Session Information ##
sessionInfo()
Sys.time()
#------------------------------------------------------------------------------#