# 01_get_data.R: script to extract the fake landscapes for Simulation Study 2
# Author: Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)
# Load utils for simulation function
source("code/00_utils.R")
# Set seed to ensure reproducibility of the same values.
set.seed(76730)

# Number of landscapes to simulate
n_sims <- 100

# Generate the data sets --------------------------------------------------
for (l in 1:n_sims) {
  dat <- data_simulation(alpha = c(-1, 0.5), sp = FALSE, x_axis = 100, y_axis = 100, 
                         species_prev = 0)
  save(dat, file = paste0("data/sim_2_data/", "simulation_", l, ".rda"))
} # Sim replicates (l)

