# 03_extract_metrics.R: script to process the results files into files that 
#                       contain information on model performance across the 
#                       different model scenarios. 
# Author: Jeffrey W. Doser and Robert Howell
rm(list = ls())

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

# Setup -------------------------------------------------------------------
# Read in landscape parameters
land_params <- read.csv(paste0(data_dir, "landscape_params.csv"))
# Simulation reps. NOTE: hardcoded
replicates <- 1:100
# Number of scenarios
n_params <- nrow(land_params)
# Number of data replicates
n_replicates <- length(replicates)
# Iterator
n_cur_row <- 1

# Unique values for all parameters that vary across simulations. 
decay_vals <- unique(land_params$decay)
variance_vals <- unique(land_params$variance)

# Model types
model_vals <- c("Nonspatial", "Spatial")
n_models <- length(model_vals)


summary_df <- expand.grid(model_vals, variance_vals, decay_vals, replicates)
colnames(summary_df) <- c("type", "variance", "decay", "replicate")
attr(summary_df, "out.attrs") <- NULL
summary_df$bias <- NA
summary_df$coverage <- NA
summary_df$ci_width <- NA
summary_df$waic <- NA

# Calculate the metrics ---------------------------------------------------
# Total number of models run 
n_total <- n_params * n_replicates * n_models

for (i in 1:n_total) {
  if (i %% 100 == 0){
    print(paste0("Currently on simulation ", i, " out of ", n_total))
  }
  curr_model <- model_vals[model_vals == summary_df$type[i]]
  if (curr_model == "Nonspatial") {
    model_val <- "non-sp"
  } else if (curr_model == "Spatial") {
    model_val <- "sp"
  }
  curr_land <- which(land_params$variance == summary_df$variance[i] & 
                     land_params$decay == summary_df$decay[i])
  tryCatch({
    load(Sys.glob(paste0('results/sim_3_results/occupancy-', model_val, 
                         "-ests-landscape", 
                         curr_land, "-replicate-", summary_df$replicate[i], '-2026*.rda')))
    if (curr_model == "Nonspatial") {
      output <- non_sp_output
    } else {
      output <- sp_output 
    }
    summary_df$bias[i] <- mean(output$psi.est - output$psi.true)
    summary_df$coverage[i] <- mean(output$psi.true <= output$psi.ci[2, ] & 
                                   output$psi.true >= output$psi.ci[1, ])
    summary_df$ci_width[i] <- mean(output$psi.ci[2, ] - output$psi.ci[1, ])
    summary_df$waic[i] <- output$waic[3]
    rm(output)
  }, error = function(e) {
    message("Error: ", e$message)
  })
}

# Save results to hard drive ----------------------------------------------
save(summary_df, file = paste0(results_dir, "summary_sim_3_results.rda"))
