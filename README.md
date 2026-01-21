# Data Processing with "invitroTKstats"

This repository contains the raw data and data processing scripts/rmarkdown files used to pipeline high-throughput toxicokinetic (HTTK) data from *in vitro* assays run for particular studies using the `invitroTKstats` R package.

## Background on "invitroTKstats" R package

The `invitroTKstats` pipeline includes standardization for data documentation, statistical analyses predicting toxicokinetics parameters characterizing absorption, distribution, metabolism, and elimination of chemicals by the body.

The assays covered by the pipeline include intrinsic clearance after hepatocyte incubation ($Cl_{int}$); two variants of plasma protein binding experiments, and CACO-2 membrane permeability. Analysis methods include frequentist point estimates and, in some cases, Bayesian methods to estimate a distributions of likely parameter values. Data for these analyses consist of ratios between peak areas of an analyte and the related internal standard compound measured with mass spectrometry. Standardized data formatting is meant to anticipate potential databases storage in future developments.

## Organization of Files

* **final_RData**: Contains a collection of R data files (extension ".RData") which are the final result from processing the raw mass-spectrometry data with the `invitroTKstats` pipeline and is the staging post before going into the `invitroTKdata` R data package.

* **working**: Contains a set of directories with raw data files from the wet-lab (internal or contracted) and scripts/rmarkdown files necessary to pipeline data to generate the final dataset related to a particular study/manuscript.

  * **CrizerPFAS**: This sub-directory contains data and R markdown files related to data pipelining for [Crizer et al. (2024)](https://doi.org/10.3390/toxics12090672).
  * **KreutzPFAS**: This sub-directory contains data and R markdown files related to data pipelining for [Kreutz et al. (2023)](https://doi.org/10.3390/toxics11050463).
  * **SmeltzPFAS**: This sub-directory contains data and R markdown files related to data pipelining for [Smeltz et al. (2023)](https://doi.org/10.1021/acs.chemrestox.3c00003).
  * **Wambaugh2019**: This sub-directory contains data and R script files related to the original data generation/pipelining done for [Wambaugh et al. (2019)](https://doi.org/10.1093/toxsci/kfz205), and some updated scripts/data output using a more recent version of `invitroTKstats` (i.e. 2025).

## Getting Started with Pipelining

Individuals that want to replicate these analyses or perform their own data processing should first install the `invitroTKstats` R package, along with any required dependencies (see [invitroTKstats GitHub](https://github.com/USEPA/invitroTKstats) for further details).

*It should be noted that the datasets generated in this repo, and their related scripts, may be generated using an earlier prototype version of the `invitroTKstats` R package.  Thus, one may need to amend the current scripts and/or install previous versions of the package.*

Once `invitroTKstats` is installed the package can be loaded into your local R session by using the following code in the R console.

```
library(invitroTKstats)
```

Check the package version installed and in use with:

```
packageVersion(invitroTKstats)
```

Final datasets (extension ".RData") should be copied to the "final_RData" directory. Upon publication of the related manuscript the dataset may be incorporated into the `invitroTKdata` R data package for use by the wider HTTK modeling and risk assessment community. See the [`invitroTKdata` GitHub](https://github.com/USEPA/invitroTKdata) repository for further details in post-publication stages.

## Contributors

Caroline Ring [ring.caroline@epa.gov] (Project Lead & Maintainer)

Barbara Wetmore [wetmore.barbara@epa.gov] (Raw Data Generation & Subject Matter Expert)

Sarah Davidson-Fritz (Software Development)

John Wambaugh (Conceptualization, Data Processing, & Subject Matter Expert)

Anna Kreutz (Raw Data Generation)

Marci Smeltz (Raw Data Generation)

David Crizer (Raw Data Generation)

### Disclaimer

The United States Environmental Protection Agency (EPA) GitHub project code is provided on an “as is” basis and the user assumes responsibility for its use. EPA has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA. The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
