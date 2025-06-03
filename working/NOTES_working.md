# Working Directory Notes

  This sub-directory contains raw data, R data processing scripts, and other scripts/data files used during IVTKS (in vitro high-throughput toxicokinetic assay) data processing. This document is meant to document important notes or comments useful for provenance regarding the files in this directory, e.g. organization, file renaming, etc. 

## Notes

  * 05/14/2025: Pulled updates post-PR merge to include the Crizer et al. (2024) new data and data processing files - PR was done in BitBucket.
  
  * 05/15/2025:
    * Deleted files no longer necessary for this repo (part of the splitting process), including:
      * tarball files for invitroTKstats R package
      * invitroTKstats R package sub-directories/R project
      * draft preliminary HTTK data SOP
    * Moved the free-floating kreutz2020, smeltz2020, and Crizer Clint 2024 data (in the parent directory level) to a "final_RData" directory (created with the intention of putting all the final data here - staging for the invitroTKdata R data package)
    * Updated the gitignore file and README doc
    
  * 05/19/2025:
    * Created a NOTES markdown file in the working directory to help track major updates across time with the organization, inclusion of new data, new projects, data processing, etc.
    
    * Move files that were in final_RData to a temporary directory and into the working directory.
    * Rename the R script for compiling data to go into the invitroTKdata R package, and update it to provide more code commentary along with more generalized code for other analysts/users to reproduce/update what is currently here.
    
  * 05/21/2025:
    * Organize files to clarify what needs to stay and what can be cleaned-up from the repo.
    
  * 05/22/2025:
    * Create a draft script, temporary directory, and output 're-processing' the data for Wambaugh2019 with the updated version of the package.
    * Update the "data for package" R script.
    
  * 06/03/2025:
    * Removed free-floating files in temporary directories since they are not relevant/no longer necessary for the general repo.
    * Moved R markdowns, HTML's, and data files that were in the invitroTKstats vignette directory as supplementary files into manuscript relevant sub-directories.
    * Updated the git ignore file to allow necessary files to remain available in Git tracking and ignore others no longer needed and/or not necessary to track.
    