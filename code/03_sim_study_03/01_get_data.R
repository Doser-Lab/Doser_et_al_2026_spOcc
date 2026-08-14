# 01_get_data.R: script to extract the fake landscapes for Simulation Study 3
# Author: Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)
# Load utils for simulation function
source("code/00_utils.R")
# Set seed to ensure reproducibility of the same values.
set.seed(7002893)

# Number of landscapes to simulate
n_sims <- 100

# Spatial decay
spatial_decay <- c(3/0.005, 3/0.7, 3/2, 3/20, 3/100)
# Spatial variance
spatial_variance <- c(0.1, 0.5, 1, 2, 5)
parameter_comb <- expand.grid(variance = spatial_variance, decay = spatial_decay)
write.csv(parameter_comb, "data/sim_3_data/landscape_params.csv", row.names = FALSE)


# Generate the data sets --------------------------------------------------
for (i in 1:nrow(parameter_comb)) {
  print(paste0("Currently on landscape ", i, " out of ", nrow(parameter_comb)))
  for (l in 1:n_sims) {
    if (l %% 10 == 0) print(paste0("Currently on sim ", l, " out of ", n_sims))
    dat <- data_simulation(sigma_sq = parameter_comb$variance[i],
                           spatial_decay = parameter_comb$decay[i])
    save(dat, file = paste0("data/sim_3_data/landscape_", i, "_simulation_", l,
                            ".rda"))
  } # Sim replicates (l)
} # parameter list (i)
