# Survey design considerations for spatial occupancy models 

### Author list

### In review

### Code/Data DOI: 

### Please contact the first author for questions: 

---------------------------------

## Abstract

1. Occupancy models are frequently used to estimate species distributions while accounting for false absences in detection-nondetection data. When applying such models across large spatial extents, it is often recommended to account for residual spatial autocorrelation within the occupancy model structure using spatial occupancy models. While such models are seeing increasing adoption by ecologists and practitioners, there remains little practical guidance on the impacts of survey design on the accuracy and reliability of predictions from spatial occupancy models. 
2. We perform an extensive simulation study to assess the impacts of survey design and species characteristics on the accuracy and precision of spatial occupancy model estimates. Our simulations focus on a spatial occupancy model implemented in the `spOccupancy` R package using Nearest Neighbor Gaussian Processes (NNGP). We explicitly quantify the effects of sample size, sampling design, species prevalence, the number of neighbors used in the NNGP, and the effective spatial range of spatial autocorrelation on the accuracy and precision of occupancy predictions. 
3. We found that sample size and sampling design had the most prominent effects on spatial occupancy model performance with all other tested characteristics having relatively little or no effect. Estimates were positively biased when the number of sampling locations was low (50, 100), with bias effectively disappearing with 200 sampling locations. Preferential sampling resulted in positive bias in occupancy estimates, while all other sampling designs (i.e., simple random sampling, systematic sampling, and four types of cluster sampling) had minimal bias when sample sizes were large enough, suggesting practitioners can adopt a probability sampling design most suited to their logistical needs without sacrificing any statistical efficiency. In comparison to estimates from a nonspatial occupancy model, spatial occupancy models always had less than or equal bias and substantially more optimal 95\% credible interval coverage rates, suggesting that spatial occupancy models should be used if residual spatial autocorrelation is present, even when the number of sampling locations is low. 
4. Our findings lend strong support to the application of spatial occupancy models for estimating species distributions across a broad range of survey design characteristics. Users can further explore our simulation study results across a variety of scenarios using an R Shiny web application (*url to be provided upon acceptance*). 

## Repository Directory

### [code](./code/)

+ `00_utils.R`: contains multiple functions used for generating data and running simulations. 
+ `01a_get_data.R`: calculates the simulated landscapes for Simulation Study 1.
+ `01b_get_parameters.R`: script to get a flat file of the different combination of parameter values that are used to determine the different simulation runs. Each one of the parameter combinations will be run for one of the 1000 simulated landscapes.
+ `01c_get_misspec_data.R`: calculates the simulated landscapes for Simulation Study 2. 
+ `02_main.R`: script to run the complete set of simulations. Inputs to the script are assumed to come from the command line for use on the HPC.
+ `02_submit.sh`: script to submit the `02_main.R` script to an HPC. 
+ `03_main_misspec.R`: script to run the complete set of simulations under a model misspecification scenario. Inputs to the script are assumed to come from the command line for use on the HPC.
+ `03_submit.sh`: scrit to submit the `03_main_misspec.R` script to an HPC. 
+ `04a_main_nonspatial.R`: runs the complete set of simulations for Simulation Study 1 with a nonspatial model. 
+ `04a_submit.sh`: script to submit the `04a_main_nonspatial.R` script to an HPC. 
+ `04b_main_nonspatial_misspec.R`: runs the complete set of simulations for Simulation Study 2 with a nonspatial model. 
+ `04b_submit.sh`: script to submit the `04b_main_nonspatial_misspec.R` script to an HPC. 
+ `05a_extract_metrics.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the spatial model fits in Simulation Study 1.
+ `05a_submit.sh`: submits `05a_extract_metrics.R` to an HPC. 
+ `05b_extract_metrics_nonspatial.R`: processes the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the nonspatial model fits in Simulation Study 1. 
+ `05b_submit.sh`: submits `05b_extract_metrics_nonspatial.R` to an HPC. 
+ `05c_extract_metrics_misspec.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the spatial model fits in Simulation Study 2.
+ `05c_submit.sh`: submits `05c_extract_metrics_misspec.R` to an HPC. 
+ `05d_extract_metrics_misspec_nonspatial.R`: script to process the massive amount of results files into the specific metrics that will be used to calculate bias, coverage rates, and credible interval widths for the nonspatial model fits in Simulation Study 2.
+ `05d_submit.sh`: submits `05d_extract_metrics_misspec_nonspatial.R` to an HPC. 
+ `06a_design_figure.R`: script to generate Figure 1 in the manuscript that shows the spatial design and different approaches for data collection.
+ `06b_summary.R`: script to summarize results and generate basic figures included in the manuscript. 
+ `07_shiny/`: directory containing all files and scripts needed to run the Shiny app. 
     + `create_shiny_data.R`: scripts to create objects for easy loading into Shiny. 
     + `shiny_sampling_design.rda`: R data object containing plots for sampling design information that will be included in the Shiny app. 
     + `shiny_one_parameter.rda`: R data object containing a data frame that is used to create visualizations of an individual parameter in the Shiny app. 
     + `shiny_multi_parameter.rda`: R data object containing a data frame that is used to create visualizations of the multiparameter data in the Shiny app. 
     + `app.R`: script containing code for the Shiny app. The app can be generated by downloading this repository and running `shiny::runApp()` or by clicking the `Run App` button in RStudio. 

### [data](./data/)

+ `landscape_params.csv`: a complete list of the landscape parameters that are varied across the different simulations. 
+ `parameters.csv`: parameters of the individual detection-nondetection data sets that are collected from each of the simulated landscapes. 
+ `sim_data/`: directory containing all the simulated data files that are run through the simulations. 

### [figures](./figures/)

Contains all figures generated in the manuscript and supplemental information. 

### [results](./results/)

Note that the raw results files are not available on GitHub, but rather we provide the summarized results files. These are the files used to generate all figures and results shown in the manuscript and Shiny app.   

+ `summary_sim_1_results.rda`: results files for the spatial model fits in Simulation Study 1. 
+ `nonspatial_summary_sim_1_results.rda`: results files for the nonspatial model fits in Simulation Study 1. 
+ `misspec_summary_sim_2_results.rda`: results files for the spatial model fits in Simulation Study 2. 
+ `misspec-nonspatial_summary_sim_2_results.rda`: results files for the nonspatial model fits in Simulation Study 2. 