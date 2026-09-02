# 02_main.R: code to implement Simulation Study 2, which focused on answering the 
#            question: What are the consequences to fitting a spatial occupancy 
#            model when there is no spatial autocorrelation? 
# Author: Jeffrey W. Doser and Robert Howell
rm(list = ls())
library(spOccupancy)

set.seed(3291)

# Set directories, which differ depending on if we run on our machines locally or 
# if running on the HPC
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os' | machine.name == 'ROBBIESLAPTOP') {
  code_dir <- 'code/'
  results_dir <- 'results/sim_2_results/'
  data_dir <- 'data/'
} else { # Running on HPC
  if (Sys.info()["user"] == 'jwdoser') { # Jeff running it
    code_dir <- '/share/doserlab/jwdoser/DHB25/code/'
    results_dir <- '/share/doserlab/jwdoser/DHB25/results/sim_2_results/'
    data_dir <- '/share/doserlab/jwdoser/DHB25/data/'
  } else { # Robbie running it 
    code_dir <- '/share/doserlab/rmhowel3/occ_research/code/'
    results_dir <- '/share/doserlab/rmhowel3/occ_research/results/sim_2_results/'
    data_dir <- '/share/doserlab/rmhowel3/occ_research/data/'
    
  }
}

# load utils methods
source(paste0(code_dir, "00_utils.R"))

# Number of simulated data sets to work with
# NOTE: hardcoded
n_iters <- 100
n_plots <- c(100, 1024)
  
# Loop through each row of the given parameters
# Run each set of parameters a number of given times
for (i in 1:n_iters) {
  print(paste0("Currently on iteration ", i, " out of ", n_iters))
  for (l in 1:length(n_plots)) {
    # Load in the current data set
    load(paste0(data_dir, "sim_2_data/simulation_", i, ".rda"))

    # Run spatial model
    sp_output <- run_simulation(dat = dat, n.plots = n_plots[l], method = "grid", 
                                nonspatial = FALSE, waic = TRUE, n.neighbors = 7)
    non_sp_output <- run_simulation(dat = dat, n.plots = n_plots[l], method = "grid", 
                                    nonspatial = TRUE, waic = TRUE)
    
    # Save the output. 
    save(sp_output, file=paste0(results_dir, 'occupancy-sp-ests-n-plots-', n_plots[l], 
                                '-replicate-', i, '-', Sys.Date(), '.rda'))
    save(non_sp_output, file=paste0(results_dir, 'occupancy-non-sp-ests-n-plots-', n_plots[l], 
                                '-replicate-', i, '-', Sys.Date(), '.rda'))
  }  
}
