# Guidelines for the use of spatial occupancy models to estimate species distributions 

### [Jeffrey W. Doser](https://doserlab.com/), Robert Howell, Alexa R. Busby

### In review

### Code/Data DOI:  

### Please contact the first author for questions: Jeff Doser (jwdoser@ncsu.edu) 

---------------------------------

## Abstract

1. Occupancy models are frequently used to estimate species distributions from detection-nondetection data. When applying such models across large spatial extents, it is often recommended to account for residual spatial autocorrelation (SAC) using spatial occupancy models. While such models have been increasingly adopted, there remains little practical guidance on the impacts of data characteristics on prediction accuracy of spatial occupancy models. 
2. We perform a simulation study to assess the impacts of numerous data characteristics on the accuracy and precision of spatial occupancy model estimates. We quantify the effects of sample size, sampling design, species prevalence, and the effective spatial range of SAC on the accuracy and precision of occupancy predictions. We further assess the relative performance of spatial vs. nonspatial occupancy models under varying degrees of SAC. 
3. When SAC was present, sample size and sampling design had the largest effects on spatial occupancy model performance. Estimates were positively biased when the number of sampling locations was low (50, 100), with bias effectively disappearing with 200 sampling locations. Preferential sampling resulted in positive bias in occupancy estimates, while multiple probability sampling designs had minimal bias when sample sizes were large enough. Spatial occupancy models provided no improvements over nonspatial occupancy models when SAC was absent and resulted in overly conservative credible intervals. When the effective spatial range of SAC was very small or large relative to the study area, the nonspatial model performed comparatively to the spatial model, particularly when SAC variance was low. However, when SAC varied at a range relevant to the study area size and the spatial variance was high, spatial occupancy models substantially outperformed nonspatial models, with nonspatial models having overly precise occupancy predictions. 
4. Our findings lend substantial support to the application of spatial occupancy models for estimating species distributions across a broad range of sampling designs and data characteristics, yet the utility of spatial occupancy models over nonspatial occupancy models is dependent on the magnitude of SAC and the scale of SAC relative to the study area. We present a set of practical guidelines for practitioners to consider when exploring the use of spatial occupancy models. 



## Repository Directory

### [code](./code/)

+ `00_utils.R`: contains multiple functions used for generating data and running simulations across all three simulation studies 

#### [code/01_sim_study_01](./code/01_sim_study_01)

Contains all code for Simulation Study 1. 

+ `01a_get_data.R`: calculates the simulated landscapes for Simulation Study 1.
+ `01b_get_parameters.R`: script to get a flat file of the different combination of parameter values that are used to determine the different simulation runs. Each one of the parameter combinations will be run for one of the 1000 simulated landscapes.
+ `01c_get_misspec_data.R`: calculates the simulated landscapes for the mis-specification simulations in Simulation Study 1. 
+ `02_main.R`: script to run the complete set of simulations. Inputs to the script are assumed to come from the command line for use on the HPC.
+ `02_submit.sh`: script to submit the `02_main.R` script to an HPC. 
+ `03_main_misspec.R`: script to run the complete set of simulations under a model misspecification scenario. Inputs to the script are assumed to come from the command line for use on the HPC.
+ `03_submit.sh`: scrit to submit the `03_main_misspec.R` script to an HPC. 
+ `04a_main_nonspatial.R`: runs the complete set of simulations for Simulation Study 1 with a nonspatial model. 
+ `04a_submit.sh`: script to submit the `04a_main_nonspatial.R` script to an HPC. 
+ `04b_main_nonspatial_misspec.R`: runs the complete set of simulations for Simulation Study 1 with a nonspatial model with mis-specified data. 
+ `04b_submit.sh`: script to submit the `04b_main_nonspatial_misspec.R` script to an HPC. 
+ `05a_extract_metrics.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the spatial model fits in Simulation Study 1.
+ `05a_submit.sh`: submits `05a_extract_metrics.R` to an HPC. 
+ `05b_extract_metrics_nonspatial.R`: processes the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the nonspatial model fits in Simulation Study 1. 
+ `05b_submit.sh`: submits `05b_extract_metrics_nonspatial.R` to an HPC. 
+ `05c_extract_metrics_misspec.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the spatial model fits in Simulation Study 1 with mis-specified data.
+ `05c_submit.sh`: submits `05c_extract_metrics_misspec.R` to an HPC. 
+ `05d_extract_metrics_misspec_nonspatial.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the nonspatial model fits in Simulation Study 1 with mis-specified data.
+ `05d_submit.sh`: submits `05d_extract_metrics_misspec_nonspatial.R` to an HPC. 
+ `06a_design_figure.R`: script to generate Figure 1 in the manuscript that shows the spatial design and different approaches for data collection.
+ `06b_summary.R`: script to summarize results and generate basic figures included in the manuscript. 

#### [code/02_sim_study_02](./code/02_sim_study_02)

Contains all code for Simulation Study 2

+ `01_get_data.R`: script to extract the simulated landscapes for Simulation Study 2. 
+ `02_main.R`: code to run the simulations for Simulation Study 2. 
+ `03_summary.R`: script to summarize the results for Simulation Study 2 and create the table shown in Table 1 in the manuscript. 

#### [code/03_sim_study_03](./code/03_sim_study_03)

Contains all code for Simulation Study 3

+ `01_get_data.R`: script to extract the simulated landscapes for Simulation Study 3. 
+ `02_main.R`: code to run the simulations for Simulation Study 3. 
+ `02_submit.sh`: bash script to submit the `02_main.R` to an HPC. 
+ `04_summary.R`: script to summarize results from Simulation Study 3. 

#### [code/04_shiny](./code/04_shiny)

Contains all files and scripts needed to run the Shiny app that shows all simulation results from Simulation Study 1. 

+ `create_shiny_data.R`: scripts to create objects for easy loading into Shiny. 
+ `shiny_sampling_design.rda`: R data object containing plots for sampling design information that will be included in the Shiny app. 
+ `shiny_one_parameter.rda`: R data object containing a data frame that is used to create visualizations of an individual parameter in the Shiny app. 
+ `shiny_multi_parameter.rda`: R data object containing a data frame that is used to create visualizations of the multiparameter data in the Shiny app. 
+ `app.R`: script containing code for the Shiny app. The app can be generated by downloading this repository and running `shiny::runApp()` or by clicking the `Run App` button in RStudio. 

### [data](./data/)

+ `landscape_params.csv`: a complete list of the landscape parameters that are varied across the different simulations for Simulation Study 1.  
+ `parameters.csv`: parameters of the individual detection-nondetection data sets that are collected from each of the simulated landscapes for Simulation Study 1.  
+ `sim_data/`: directory containing all the simulated data files that are run through the simulations in Simulation Study 1. 
+ `sim_2_data`: directory containing all the simulated data files that are run through the simulations in Simulation Study 2. 
+ `sim_3_data`: directory containing all the simulated data files that are run through the simulations in Simulation Study 3. 

### [figures](./figures/)

Contains all figures generated in the manuscript and supplemental information. 

### [results](./results/)

Note that the raw results files for Simulation Study 1 are not available on GitHub, but rather we provide the summarized results files. These are the files used to generate all figures and results shown in the manuscript and Shiny app.   

+ `summary_sim_1_results.rda`: results files for the spatial model fits in Simulation Study 1. 
+ `nonspatial_summary_sim_1_results.rda`: results files for the nonspatial model fits in Simulation Study 1. 
+ `misspec_summary_sim_1_results.rda`: results files for the spatial model fits in Simulation Study 1 with mis-specified data. 
+ `misspec-nonspatial_summary_sim_1_results.rda`: results files for the nonspatial model fits in Simulation Study 1 with mis-specified data. 
+ `sim_2_results/`: all results files generated from Simulation Study 2. 
+ `sim_3_results/`: all results files generated from Simulation Study 3. 