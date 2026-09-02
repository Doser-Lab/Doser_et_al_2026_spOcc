# 03_summary.R: script to summarize the results of Simulation Study 2. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(dplyr)
library(ggplot2)

# Process raw simulation results ------------------------------------------
# Number of replicates (NOTE: hardcoded)
replicates <- 1:100
n_replicates <- length(replicates)
# Only thing that varies is the number of plots
plots_vals <- c(100, 1024)
n_plots <- length(plots_vals)
# Model types
model_vals <- c("Nonspatial", "Spatial")
n_models <- length(model_vals)


# Calculate the metrics ---------------------------------------------------
# Total number of models run
n_total <- n_plots * n_replicates * n_models
summary_df <- expand.grid(model_vals, plots_vals, replicates)
colnames(summary_df) <- c("type", "n_plot", "replicate")
attr(summary_df, "out.attrs") <- NULL
summary_df$bias <- NA
summary_df$coverage <- NA
summary_df$ci_width <- NA
summary_df$waic <- NA

for (i in 1:n_total) {
  curr_model <- model_vals[model_vals == summary_df$type[i]]
  if (curr_model == "Nonspatial") {
    model_val <- "non-sp"
  } else if (curr_model == "Spatial") {
    model_val <- "sp"
  }
  curr_n_plot <- plots_vals[plots_vals == summary_df$n_plot[i]]
  tryCatch({
    load(Sys.glob(paste0('results/sim_2_results/occupancy-', model_val, "-ests-n-plots-", 
                         curr_n_plot, "-replicate-", summary_df$replicate[i], '-2026*.rda')))
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

# Basic summaries ---------------------------------------------------------
# Average bias, coverage, CI width, and WAIC
ests_out <- summary_df |> 
  group_by(type, n_plot) |> 
  summarize(avg_bias = mean(bias), 
            avg_coverage = mean(coverage), 
            avg_ci_width = mean(ci_width), 
            avg_waic = mean(waic)) |> 
  ungroup() |> 
  arrange(n_plot)

ests_out
