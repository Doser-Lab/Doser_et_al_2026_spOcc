# 04_summary.R: script to summarize results from Simulation Study 3 
rm(list = ls())
library(ggplot2)
library(dplyr)
library(tidyr)

# Load data with basic EDA ------------------------------------------------
load("results/sim_3_results/summary_sim_3_results.rda")

# Average values within each combination
avg_by_scenario <- summary_df |> 
  group_by(type, variance, decay) |>
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width), 
            waic = mean(waic)) |>
  ungroup() 


avg_by_scenario |> mutate(decay = 3 / decay) |> print(n = Inf)


summary_df |> 
  group_by(type, variance) |> 
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width), 
            waic = mean(waic)) |> 
  ungroup()

summary_df |> 
  group_by(type, decay) |> 
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width), 
            waic = mean(waic)) |> 
  ungroup()


# Create summary figure ---------------------------------------------------
n_var <- n_distinct(avg_by_scenario$variance)
n_models <- n_distinct(avg_by_scenario$type)
plot_df <- avg_by_scenario |> 
  mutate(esr = factor(case_when(decay == 3 / 100 ~ 10000, 
                                decay == 3 / 20 ~ 20, 
                                decay == 3 / 2 ~ 2, 
                                decay > 3 / 0.7 - 1e-06 & decay < 3 / 0.7 + 1e-06 ~ 0.7,
                                decay == 3 / 0.005 ~ 0.005)),
         sigma_sq = factor(variance))

wide_plot_df <- plot_df |> 
  select(type, variance, decay, waic, esr, sigma_sq) |> 
  pivot_wider(names_from = type, values_from = waic) |> 
  mutate(waic_percent_diff = (Nonspatial - Spatial) / Nonspatial * 100, 
         waic_diff = Nonspatial - Spatial)


ggplot(data = wide_plot_df, aes(x = sigma_sq, y = esr, fill = waic_diff)) +
  geom_tile(color = 'black') +
  scale_fill_gradient2(midpoint = 0, high = '#2166AC', mid = 'white', low = '#B2182B') +
  theme_bw() +
  theme(panel.grid = element_blank(),
        text = element_text(family = 'LM Roman 10')) +
  labs(x = 'Spatial Variance', y = 'Effective Spatial Range', 
       fill = expression(paste(Delta, " WAIC"))) + 
  scale_x_discrete(expand = c(0, 0)) + 
  scale_y_discrete(expand = c(0, 0))
ggsave(file = 'figures/Figure-6.png', width = 5, height = 4, units = 'in',
       bg = 'white')

