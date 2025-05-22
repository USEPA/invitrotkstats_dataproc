#-----------------------------------------------------------------------------#
## RData Compilation

  # The point of this R script is to generate the RData files that will be added to/updated
  # in the `invitroTKdata` R data package.

  # This script is meant to run programmatically via the command line, using the following
  #   `R CMD BATCH --vanilla data_for_invitroTKdata_Rpackage.R`
  # (In some cases one may need to overwrite the default save behavior, see
  #  the "Save the RData Files" section for further details.)

  # Suggest reading the commentary in this script prior to executing it programmatically.

  # Instructions on adding new data for export:
  #   1) Update the "Read-in Final Files & Save to R object" section with:
  #       (i)  Adding the sub-section header "### <Manuscript First Author Last Name> et al. (4-digit YEAR) ###"
  #       (ii) Add in the object read in/assignment <lastname>.<year>.<assay> (L2 data) - do for all IVTKS assays
  #   2) Update the "Save the RData Files" section with:
  #       (i)  Copy and update the code for over-writing output portion in the first part of if check
  #       (ii) Copy and update the code for typical check and file output in the second part of the if check
  #            (SUGGESTION: Have the 'save' code commented out until testing behaves as anticipated.)
  # 
  # (NOTE: Sections to be edited by users only adding data to stage for `invitroTKdata` are tagged with
  #        "#### EDIT IF ADDING DATA ####" for easy script searching.)

#-----------------------------------------------------------------------------#
## Command Line Arguments
arg_set <- (commandArgs(TRUE))
# check for any arguments passed
if(length(arg_set)==0){
  # print notification of setting defaults
  print("No arguments supplied, setting defaults.")
  # set up the default
  ow <- FALSE
}else{
  # print the argument set
  print(paste("Command line supplied arguments:",arg_set))
  # loop over and set the argument set here
  for(i in 1:length(arg_set)){
    eval(parse(text = arg_set[[i]]))
  }
  if(!is.logical(ow)){stop("ow command line argument must be TRUE or FALSE (i.e. logical); default is FALSE")}
}
#-----------------------------------------------------------------------------#
## Set-up Directories

  # Individuals users will need to set up their own 'Git_path" object to read in
  # and run this on their local machine.
  # In your local R console before running this script, do the following:
  #   (1) Create a "Git_path" object with: `Git_path <- "<path to invitrotkstats_data proc Git repo clone>"`.
  #   (2) Test "Git_path" object to see if it works by using: `list.files(Git_path)`. (Expect to see all the files at the parent directory of the Git repo clone.)
  #   (3) Save the "Git_path" object with: `save(Git_path,file = "<path to invitrotkstats_data proc Git repo clone>/final_RData/gitpath.RData")`.
  
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++##
## NOTE: Only use the getwd when running this programmatically via the
##  command line. Otherwise, if running this manually (not recommended, unless
##  trouble-shooting/updating) you may need to provide absolute paths via the
##  R console. Not recommended these are hard coded in this script.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++##

# load the Git_path object
load(file = paste(getwd(),"gitpath.RData",sep = "/"),verbose = TRUE)
# set up the final_Rdata_path object 
final_RData_path <- getwd()
# set-up the working_path object - points us to where the data actually is
working_path <- paste(Git_path,"working",sep = "/")
#-----------------------------------------------------------------------------#
## Load Previously Saved RData Files
# identify the current files in the final_RData directory
curr_final_RData <- list.files(path = final_RData_path,pattern = "\\d+.RData$")
# load the current files in the final_RData directory
for(i in curr_final_RData){
  load(file = paste(final_RData_path,i,sep = "/"),verbose = TRUE)
}
# assign the current results to a new object with ".current" suffix for later comparison
for(i in ls(pattern = "[.]clint$|[.]uc$|[.]red$")){
  assign(x = paste0(i,".current"),get(i))
}
#-----------------------------------------------------------------------------#
## Read-in Final Files & Save to R object
#### EDIT IF ADDING DATA ####
### Smeltz et al. (2023) ###
smeltz2023.red <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-fup-RED-Level2.tsv",sep = "/"),
                           sep="\t")
smeltz2023.uc <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-PPB-UC-Level2.tsv",sep = "/"),
                          sep="\t")
smeltz2023.clint <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-Clint-Level2.tsv",sep = "/"),
                             sep="\t")

smeltz2023.red.L3 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-fup-RED-Level3.tsv",sep = "/"),
                              sep = "\t")
smeltz2023.red.L4 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-fup-RED-Level4.tsv",sep = "/"),
                              sep = "\t")
smeltz2023.uc.L3 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-PPB-UC-Level3.tsv",sep = "/"),
                             sep = "\t")
smeltz2023.uc.L4 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-PPB-UC-Level4.tsv",sep = "/"),
                             sep = "\t")
smeltz2023.clint.L3 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-Clint-Level3.tsv",sep = "/"),
                                sep = "\t")
smeltz2023.clint.L4 <- read.csv(file = paste(working_path,"SmeltzPFAS/SmeltzPFAS-Clint-Level4.tsv",sep = "/"),
                                sep = "\t")
### Kreutz et al. (2023) ###
kreutz2023.uc <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-fup-UC-Level2.tsv",sep = "/"),
                          sep="\t")
kreutz2023.clint <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-Clint-Level2.tsv",sep = "/"),
                             sep="\t")

kreutz2023.uc.L3 <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-fup-UC-Level3.tsv",sep = "/"),
                             sep = "\t")
kreutz2023.uc.L4 <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-fup-UC-Level4.tsv",sep = "/"),
                             sep = "\t")
kreutz2023.clint.L3 <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-Clint-Level3.tsv",sep = "/"),
                                sep = "\t")
kreutz2023.clint.L4 <- read.csv(file = paste(working_path,"KreutzPFAS/KreutzPFAS-Clint-Level4.tsv",sep = "/"),
                                sep = "\t")
### Crizer et al. (2024) ###
crizer2024.clint <- read.csv(file = paste(working_path,"CrizerPFAS/CrizerPFASApr2024-Clint-Level2.tsv",sep = "/"),
                             sep="\t")

crizer2024.clint.L3 <- read.csv(file = paste(working_path,"CrizerPFAS/CrizerPFASApr2024-Clint-Level3.tsv",sep = "/"),
                                sep = "\t")
crizer2024.clint.L4 <- read.csv(file = paste(working_path,"CrizerPFAS/CrizerPFASApr2024-Clint-Level4.tsv",sep = "/"),
                                sep = "\t")
#-----------------------------------------------------------------------------#
## Evaluate Current Objects (loaded) Against New Objects (generated above)
# obtain the generated rdata objects
new_rdata_obj <- ls(pattern = "[.]clint$|[.]uc$|[.]red$")
# create a placeholder vector to later store if the current and newly generated rdata objects match
#   NA indicates there is not a current RData file
test_equal_res <- rep(NA,length(new_rdata_obj))
names(test_equal_res) <- new_rdata_obj
# loop over the names of the newly generated rdata objects 
for(i in new_rdata_obj){
  cname <- paste0(i,".current")
  if(cname%in%ls()){
    test_equal_res[i] <- all.equal(get(i),get(cname))
  }
}
# print the results of the equality test
#   expect those with existing RData objects to be the same
#   otherwise may need some documentation as to why changes occurred
#   (i.e. ideal: TRUE's or NA's and zero FALSE's)
test_equal_res
#-----------------------------------------------------------------------------#
## Save the RData Files
#### EDIT IF ADDING DATA ####

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++##
## NOTE: Running this programmatically via the command line assumes that if
##  there are any differences in the current and newly generated, then these
##  need to be investigated and skipped over when saving files saving files.
##  However, this can be overcome by passing the overwrite
##  argument via using the following command in the command line terminal:
##    `R CMD BATCH --vanilla '--args ow=TRUE' data_for_invitroTKdata_Rpackage.R`
##  This should be noted when done since it currently assumes to write out all
##  files.  Thus, this should not be done lightly or regularly.
##  
##  One may also consider "archiving" current files that a new version of is
##  desired. Again, this should be noted and not done lightly or regularly.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++##

# currently assumptions for writing out files:
#   * if we are overwriting we want to do all files - though may update script in future to only overwrite a subset
#   * the write out process could likely be streamlined via a utility function rather than copy/pasting code, but for now keeping it simple

if(ow){
  # print notification that the files will be overwritten
  cat("Overwrite is set to TRUE via command line, write out all files.\n")
  ## Smeltz et al. 2023 ##
  cat("UPDATE WRITE OUT: Smeltz et al. 2023\n")
  save(smeltz2023.red,smeltz2023.uc,smeltz2023.clint,
       smeltz2023.red.L3,smeltz2023.uc.L3,smeltz2023.clint.L3,
       smeltz2023.red.L4,smeltz2023.uc.L4,smeltz2023.clint.L4,
       file="Smeltz2023.RData",
       version=2)
  ## Kreutz et al. 2023 ##
  cat("UPDATE WRITE OUT: Kreutz et al. 2023\n")
  save(kreutz2023.uc,kreutz2023.clint,
       kreutz2023.uc.L3,kreutz2023.clint.L3,
       kreutz2023.uc.L4,kreutz2023.uc.L4,
       file="Kreutz2023.RData",
       version=2)
  ## Crizer et al. 2024 ##
  save(crizer2024.clint,
       crizer2024.clint.L3,
       crizer2024.clint.L4,
       file="Crizer2024.RData",
       version=2)
}else{
  # print notification that files will NOT be overwritten
  cat("Overwrite is set to FALSE (default), only write out files with NA.\n")
  ## Smeltz et al. 2023 ##
  if(all(is.na(test_equal_res[grepl(names(test_equal_res),pattern = "^smeltz2023")]))){
    cat("NEW WRITE OUT: Smeltz et al. 2023\n")
    save(smeltz2023.red,smeltz2023.uc,smeltz2023.clint,
         smeltz2023.red.L3,smeltz2023.uc.L3,smeltz2023.clint.L3,
         smeltz2023.red.L4,smeltz2023.uc.L4,smeltz2023.clint.L4,
         file="Smeltz2023.RData",
         version=2)
  }else if(any((test_equal_res[grepl(names(test_equal_res),pattern = "^smeltz2023")])!=TRUE)){
    cat("SKIP (at least one FALSE): Smeltz et al. 2023 - file already exists and identifying differences\n")
  }else{
    cat("SKIP: Smeltz et al. 2023 - file already exists and all equal\n")
  }
  ## Kreutz et al. 2023 ##
  if(all(is.na(test_equal_res[grepl(names(test_equal_res),pattern = "^kreutz2023")]))){
    cat("NEW WRITE OUT: Kreutz et al. 2023\n")
    save(kreutz2023.uc,kreutz2023.clint,
         kreutz2023.uc.L3,kreutz2023.clint.L3,
         kreutz2023.uc.L4,kreutz2023.uc.L4,
         file="Kreutz2023.RData",
         version=2)
  }else if(any((test_equal_res[grepl(names(test_equal_res),pattern = "^smeltz2023")])!=TRUE)){
    cat("SKIP (at least one FALSE): Kreutz et al. 2023 - file already exists and identifying differences\n")
  }else{
      cat("SKIP: Kreutz et al. 2023 - file already exists and all equal\n")
  }
  ## Crizer et al. 2024 ##
  if(all(is.na(test_equal_res[grepl(names(test_equal_res),pattern = "^crizer2024")]))){
    cat("NEW WRITE OUT: Crizer et al. 2024\n")
    save(crizer2024.clint,
         crizer2024.clint.L3,
         crizer2024.clint.L4,
         file="Crizer2024.RData",
         version=2)
  }else if(any((test_equal_res[grepl(names(test_equal_res),pattern = "^crizer2024")])!=TRUE)){
    cat("SKIP (at least one FALSE): Crizer et al. 2024 - file already exists and identifying differences\n")
  }else{
    cat("SKIP: Crizer et al. 2024 - file already exists and all equal\n")
  }
}

#-----------------------------------------------------------------------------#
## Session Information
Sys.time()
sessionInfo()
#-----------------------------------------------------------------------------#