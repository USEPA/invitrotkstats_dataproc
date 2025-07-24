#------------------------------------------------------------------------------#
## Split Wambaugh2019 Clint L2 for L4 Processing ##
#------------------------------------------------------------------------------#
## NOTE: This script is meant to be run programmatically via the following
##       command in the bash command line terminal:
##          `R CMD BATCH --vanilla wambaugh2019-Clint_L2-splitting-for-L4_2025.R`
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
## Local Functions ##
# Find All Factors of a Number:
#   https://coderunbox.com/example/example.r/factors-of-number
print_factors <- function(n) {
  print(paste("The factors of", n, "are:"))
  for (i in 1:n) {
    if (n %% i == 0) {
      print(i)
    }
  }
}
#------------------------------------------------------------------------------#
## Load in Data ##
# print the working directory
getwd()
# load in the split L2 data files
load(here::here("data/Wambaugh2019_regen2025_Clint_L1-3.RData"),verbose = TRUE)
#------------------------------------------------------------------------------#
## Data Prep ##
# identify the total number of unique compounds to chunk out into datasets
n.unique.chems <- length(unique(wambaugh2019.clint.L2$Compound.Name))
n.unique.chems # print the total number of unique chemicals in the dataset

# identify possible factors
print_factors(n.unique.chems)

# create a compound split match table (group of chemicals to chunk together)
#   (split data into 6 datasets, 79 unique chemicals per dataset)
compound.split.match <- data.frame(
  Compound.Name = unique(wambaugh2019.clint.L2[,"Compound.Name"]),
  GroupIndex = rep(1:6,each = 79)
  )

# split the L2 dataset
wambaugh2019.clint.L2.SPLIT <-
  # join the compound split matching table
  dplyr::full_join(wambaugh2019.clint.L2,compound.split.match,
                   by = "Compound.Name") %>%
  # group the data by the grop indices from the compound split table (above)
  dplyr::group_by(.,by = GroupIndex) %>% 
  # split the dataset by the group indices
  dplyr::group_split() %>% 
  # for each list element (subset of overall data) of the split object 
  # convert to data.frame object
  lapply(.,as.data.frame) %>% 
  # remove groupings
  lapply(.,dplyr::ungroup)
#------------------------------------------------------------------------------#
## Data Checks ##
# check that the number of unique compounds is equal across the board
#   (should be 79)
lapply(wambaugh2019.clint.L2.SPLIT,function(x){
  length(unique(x[,"Compound.Name"]))
}) %>% unlist()

# check that the number of samples per compound match the overall
#   (requires spot check)
lapply(wambaugh2019.clint.L2.SPLIT,function(x){
  dplyr::group_by(x,by = Compound.Name) %>% dplyr::group_size()
})
#------------------------------------------------------------------------------#
## Save Data ##
save(
  wambaugh2019.clint.L2.SPLIT,
  file = here::here("data/Wambaugh2019_regen2025_Clint_L2-chemsplit.RData")
)
#------------------------------------------------------------------------------#
## Session Information ##
sessionInfo()
Sys.time()
#------------------------------------------------------------------------------#