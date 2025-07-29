#-----------------------------------------------------------------------------#
## Re-Save and Compress Package Ready R Data Files ##
#-----------------------------------------------------------------------------#
## NOTES:
##  * Move the package ready data (previous generated) to alternative filename
##    (i.e. add suffix "_uncomp") to indicate these are uncompressed files.
##  * Update the .gitignore file to ignore R datafiles marked as uncompressed.
##  * Run this script with "R CMD BATCH --vanilla <filename>"
##    (generally meant to be a one time run - though may be necessary in future).
#-----------------------------------------------------------------------------#
## R Packages ##
library(stringr)
library(magrittr)
#-----------------------------------------------------------------------------#
## Data Directories ##
# load the Git_path object
load(file = paste(getwd(),"gitpath.RData",sep = "/"),verbose = TRUE)
# set up the final_Rdata_path object
final_RData_path <- paste(getwd(),"packageready_data",sep = "/")
archive_RData_path <- paste(getwd(),"archive",sep = "/")
#-----------------------------------------------------------------------------#
## Load in Data
# list the files in the 'archive' directory
archive_Rdata_files <- list.files(path = archive_RData_path)
# load in the datasets
for(i in archive_Rdata_files){
  load(file = paste(archive_RData_path,i,sep = "/"),verbose = TRUE)
}
# re-assign the files with suffix 'curr.arch' (current archive)
for(i in ls(pattern = "clint$|uc$|red$")){
  cat(paste0(i,".curr.arch"),"\n")
  assign(x = paste0(i,".curr.arch"),value = get(i))
}
# remove the original archive objects
rm(list = ls(pattern = "clint$|uc$|red$"))

# list the files in the 'final' package ready directory
final_RData_files <- list.files(path = final_RData_path,pattern = "uncomp")
# load in the datasets
for(i in final_RData_files){
  load(file = paste(final_RData_path,i,sep = "/"),verbose = TRUE)
}
#-----------------------------------------------------------------------------#
## Checks Between Current Archive and Current Final
archived_obj <- ls(pattern = "curr.arch")
for(i in archived_obj){
  cat("Check:",i,"vs",stringr::str_remove(i,".curr.arch"),"\n")
  print(all.equal(get(i),get(stringr::str_remove(i,".curr.arch"))))
}
#-----------------------------------------------------------------------------#
## Re-save Data with Further Compression
pckg_ready_data <- stringr::str_remove(final_RData_files,pattern = "_uncomp.RData") %>%
  tolower()
pckg_comp_data <- stringr::str_replace(final_RData_files,
                                       pattern = "_uncomp.RData",
                                       replacement = ".RData")
# re-save the objects with compression
for(i in pckg_ready_data){
  # print the overarching dataset to be saved
  cat(i,"\n")
  # identify the objects to save in the RData file
  save_obj <- ls(pattern = i) %>% .[!grepl(.,pattern = "curr.arch")] # ignore those with "curr.arch" (i.e. current archived items)
  print(save_obj) # print the objects that will be saved
  # identify the save name for the output file
  save_filename <- pckg_comp_data[grepl(x = pckg_comp_data,pattern = i,ignore.case = TRUE)]
  print(save_filename) # print the filename that objects will be saved to
  # check if there currently are any 'compressed' RData files
  check <- list.files(path = final_RData_path,pattern = save_filename)
  if(length(check)==0){
    # re-save objects (untagged - indicating 'compression')
    save(list = save_obj,file = paste(final_RData_path,save_filename,sep = "/"),
         compress = "xz")
  }else{
    cat("SKIP: A compressed file already exists for:",i,"\n")
  }
}
cat("END OF RESAVE","\n")
#-----------------------------------------------------------------------------#
## Session Information
Sys.time()
sessionInfo()
#-----------------------------------------------------------------------------#