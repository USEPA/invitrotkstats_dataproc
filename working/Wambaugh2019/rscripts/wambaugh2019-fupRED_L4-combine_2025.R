#------------------------------------------------------------------------------#
## Combining the L4 Wambaugh2019 fup RED Data ##
#-----------------------------------------------------------------------------#
## NOTE: This script is meant to be run programmatically via the following
##  command in the bash command line terminal:
##  `R CMD BATCH --vanilla wambaugh2019-fupRED_L4-combine_2025.R wambaugh2019-fupRED_L4-combine_2025_MMDDYYYY.Rout`
##    (where SPLIT-X should correspond to the chemical chunk being evaluated, e.g. SPLIT-3)
##    (where MMDDYYYY corresponds to the 2-digit month, 2-digit day, and 4-digit year)
#-----------------------------------------------------------------------------#
## R Packages ##
library(dplyr)
library(magrittr)
library(stringr)
#------------------------------------------------------------------------------#
## Load in Data ##
# identify the L4 chemsplit files to read in
chemsplit_files <- list.files(here::here("data"),pattern = "RED.+Level4Analysis")
# load in the chemsplit files
tmp_Results <- data.frame()
for(i in chemsplit_files){
  load(file = here::here("data",i),verbose = TRUE)
  tmp_Results <- rbind.data.frame(tmp_Results,Results)
}
# check the number of rows in the combined Results dataset
nrow(tmp_Results)
#------------------------------------------------------------------------------#
## Save Data ##
# set up the file name for saving results
save_filename <- sub(x = chemsplit_files[1],pattern = "_\\d",replacement = "")
# reassign the combined results to 'Results'
assign(x = "Results",value = tmp_Results)

# save the combined results
save(
  list = c("Results"),
  file = here::here("data",save_filename)
)
#------------------------------------------------------------------------------#
## Session Information ##
sessionInfo()
Sys.time()
#------------------------------------------------------------------------------#