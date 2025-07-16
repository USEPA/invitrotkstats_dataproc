#------------------------------------------------------------------------------#
## Re-processing Wambaugh2019 Clint (L4) ##
#-----------------------------------------------------------------------------#
## NOTE: This script is meant to be run programmatically via the following
##  command in the bash command line terminal:
##  `R CMD BATCH --vanilla '--args chem.group=<integer>' wambaugh2019-Clint_SPLIT_re-processing2025_L4.R wambaugh2019-Clint_SPLIT-X_re-processing2025_L4_MMDDYYYY.Rout`
##    (where SPLIT-X should correspond to the chemical chunk being evaluated, e.g. SPLIT-3)
##    (where MMDDYYYY corresponds to the 2-digit month, 2-digit day, and 4-digit year)
#-----------------------------------------------------------------------------#
## Command Line Arguments
arg_set <- (commandArgs(TRUE))
# check for any arguments passed
if(length(arg_set)==0){
  # stop if no defaults are set
  stop("No arguments supplied, and no defaults available. Please provide a positive integer for the `chem.group` argument.")
}else{
  # print the argument set
  print(paste("Command line supplied arguments:",arg_set))
  # loop over and set the argument set here
  for(i in 1:length(arg_set)){
    eval(parse(text = arg_set[[i]]))
  }
  if(!is.numeric(chem.group)){stop("`chem.group` command line argument must be numeric; no default available")}
  if(chem.group<=0){stop("`chem.group` command line argument must be positive numeric integer; no default available")}
}
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
# print the working directory
getwd()
# load in the split L2 data files
load(file = here::here("data/Wambaugh2019_regen2025_Clint_L2-chemsplit.RData"),verbose = TRUE)
#------------------------------------------------------------------------------#
# check the provided chem.group is valid for the chemical split data subset list
if(chem.group > length(wambaugh2019.clint.L2.SPLIT)){
  stop("The `chem.group` arguement provided is larger than the number of available chemical grouping subsets.")
}
# set up a filename for the particular chemical group split
chemsplit_FILENAME <- paste0("Wambaugh2019_regen2025_",chem.group)
chemsplit_FILENAME
# show the dimensions of the subset undergoing L4 processing
dim(wambaugh2019.clint.L2.SPLIT[[chem.group]])
# show the number of chemicals to be evaluated with this chemical split
length(unique(wambaugh2019.clint.L2.SPLIT[[chem.group]]$Compound.Name))
## Process L2 to L4 ##
tictoc::tic()
jags_path <- runjags::findJAGS()
tmp.wambaugh2019.clint.L4 <- invitroTKstats::calc_clint(
  data.in = wambaugh2019.clint.L2.SPLIT[[chem.group]],
  FILENAME = chemsplit_FILENAME,
  TEMP.DIR = here::here("data/L4_interim"),
  JAGS.PATH = jags_path,
  OUTPUT.DIR = here::here("data")
)
tictoc::toc()
#------------------------------------------------------------------------------#
## Save Data ##
# set up the object and file names for saving results
save_objectname <- paste0("wambaugh2019.clint.L4",".chemsplit.",chem.group)
save_filename   <- paste0("Wambaugh2019_regen2025_Clint_L4","-chemsplit-",chem.group,".RData")
# assign the temporary object to a chem split specific object name
assign(x = save_objectname,tmp.wambaugh2019.clint.L4)

# print save file path
here::here("data",save_filename)
# save the primary data
save(
  list = c(save_objectname),
  file = here::here("data",save_filename)
)
#------------------------------------------------------------------------------#
## Session Information ##
sessionInfo()
Sys.time()
#------------------------------------------------------------------------------#