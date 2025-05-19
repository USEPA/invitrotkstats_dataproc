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
    
    