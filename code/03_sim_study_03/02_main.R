# 02_main.R: script to run the third simulation study. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)

set.seed(77382)

# Read in given arguments (two numbers, e.g. (current row and number of replicates))
args <- commandArgs(trailingOnly = TRUE)

# Inputs from command line. 
curr_landscape = as.numeric(args[1])

# Set directories, which differ depending on if we run on our machines locally or 
# if running on the HPC
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os' | machine.name == 'ROBBIESLAPTOP') {
  code_dir <- 'code/'
  results_dir <- 'results/sim_3_results/'
  data_dir <- 'data/sim_3_data/'
} else { # Running on HPC
  if (Sys.info()["user"] == 'jwdoser') { # Jeff running it
    code_dir <- '/share/doserlab/jwdoser/DHB25/code/'
    results_dir <- '/share/doserlab/jwdoser/DHB25/results/sim_3_results/'
    data_dir <- '/share/doserlab/jwdoser/DHB25/data/sim_3_data/'
  }
}

# load utils methods and parameters csv
source(paste0(code_dir, "00_utils.R"))

replicates <- 1:100
n_iters <- length(replicates)
# Read in landscape parameters
landscape_params <- read.csv(paste0(data_dir, "landscape_params.csv"))
n_landscapes <- nrow(landscape_params)

# Loop through each row of the given parameters
# Run each set of parameters a number of given times
for (i in 1:n_iters) {
  print(paste0("Currently on iteration ", i, " out of ", n_iters))
  # Load in the current landscape
  load(paste0(data_dir, "landscape_", curr_landscape, "_simulation_", i, ".rda"))
  
  # Run spatial model
  sp_output <- run_simulation(dat = dat, n.plots = 400, method = "grid", 
                              nonspatial = FALSE, waic = TRUE, n.neighbors = 7)
  non_sp_output <- run_simulation(dat = dat, n.plots = 400, method = "grid", 
                                  nonspatial = TRUE, waic = TRUE)
  # Save the output. 
  save(sp_output, file=paste0(results_dir, 'occupancy-sp-ests-landscape', curr_landscape, 
                           '-replicate-', i, '-', Sys.Date(), '.rda'))
  save(non_sp_output, file=paste0(results_dir, 'occupancy-non-sp-ests-landscape', curr_landscape, 
                           '-replicate-', i, '-', Sys.Date(), '.rda'))
}  
