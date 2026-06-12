# 06b_summary.R: script to summarize the results and generate basic figures included 
#                in the manuscript. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(ggplot2)
library(dplyr)
library(tidyr)
library(viridis)
library(ggthemes)
library(patchwork)
library(RColorBrewer)

# Simulation Study 1 Spatial Model ----------------------------------------
# Loads an object called summary_df
load("results/summary_sim_1_results.rda")

# Average values within each combination
avg_by_scenario <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width)) %>%
  ungroup()

# Figure 2 ----------------------------
fig_2_df <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(avg_bias = mean(bias), 
            low_bias = quantile(bias, 0.025), 
            high_bias = quantile(bias, 0.975),
            avg_coverage = mean(coverage), 
            low_coverage = quantile(coverage, 0.025), 
            high_coverage = quantile(coverage, 0.975),
            avg_ci_width = mean(ci_width), 
            low_ci_width = quantile(ci_width, 0.025), 
            high_ci_width = quantile(ci_width, 0.975)) %>%
  ungroup()

# Prevalence --------------------------
prev_fig_df <- fig_2_df %>%
  group_by(prevalence) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) %>% 
  mutate(prevalence = round(plogis(prevalence), 2))
prev_fig_bias <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Bias", title = "(a)")
prev_fig_coverage <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Coverage", title = "(b)")
prev_fig_ci_width <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Average Occupancy Probability", y = "95% CI Width", title = "(c)")
# Spatial decay -----------------------
decay_fig_df <- fig_2_df %>%
  group_by(sp_decay) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) 
decay_fig_bias <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Bias", title = "(d)")
decay_fig_coverage <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Coverage", title = "(e)")
decay_fig_ci_width <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Spatial Decay", y = "95% CI Width", title = "(f)")
# Number of plots
n_plot_fig_df <- fig_2_df %>%
  group_by(n_plot) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) 
n_plot_fig_bias <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Bias", title = "(g)")
n_plot_fig_coverage <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Coverage", title = "(h)")
n_plot_fig_ci_width <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of plots", y = "95% CI Width", title = "(i)")
# Design
# NOTE: hardcoded 
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("SRS", "SYS", "HT", "VT", "SA", "LA", "MP", "HP")
design_fig_df <- fig_2_df %>%
  group_by(design) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names))
design_fig_bias <- ggplot(data = design_fig_df, aes(x = design, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Bias", title = "(j)")
design_fig_coverage <- ggplot(data = design_fig_df, aes(x = design, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Coverage", title = "(k)")
design_fig_ci_width <- ggplot(data = design_fig_df, aes(x = design, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Sampling Design", y = "95% CI Width", title = "(l)")
# Number of neighbors
neighbors_fig_df <- fig_2_df %>%
  group_by(neighbors) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) 
neighbors_fig_bias <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Neighbors", y = "Bias", title = "(m)")
neighbors_fig_coverage <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Neighbors", y = "Coverage", title = "(n)")
neighbors_fig_ci_width <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of Neighbors", y = "95% CI Width", title = "(o)")

fig_2 <- (prev_fig_bias | prev_fig_coverage | prev_fig_ci_width) / 
         (decay_fig_bias | decay_fig_coverage | decay_fig_ci_width) / 
         (n_plot_fig_bias | n_plot_fig_coverage | n_plot_fig_ci_width) / 
         (design_fig_bias | design_fig_coverage | design_fig_ci_width) / 
         (neighbors_fig_bias | neighbors_fig_coverage | neighbors_fig_ci_width)
fig_2
ggsave(file = 'figures/Figure-2.png', width = 12, height = 12, units = 'in',
       bg = 'white')
# Figure 3 ----------------------------
# NOTE: hardcoded
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("Simple Random", "Systematic", "Horizontal Transects", "Vertical Transects", 
                  "Small Arrays", "Large Arrays", "Moderate Preferential", 
                  "Heavy Preferential")
fig_3a <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(bias = mean(bias)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = bias, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = 2, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Bias (Estimated - True)", color = "Design", 
         title = "(a) Bias") +
    theme(text = element_text(family="LM Roman 10"))
fig_3b <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(coverage = mean(coverage)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = coverage, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Coverage Rate", color = "Design", 
         title = "(b) Coverage") +
    theme(text = element_text(family="LM Roman 10"))
fig_3c <- avg_by_scenario %>%
  group_by(design, n_plot) %>% 
  summarize(ci_width = mean(ci_width)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = n_plot, y = ci_width, col = design)) + 
    geom_line() +
    geom_point() + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    labs(x = "Number of Plots", y = "95% CI Width", color = "Design", 
         title = "(c) 95% CI width") +
    theme(text = element_text(family="LM Roman 10"))
fig_3 <- fig_3a + fig_3b + fig_3c + plot_layout(guides = "collect")
ggsave(file = 'figures/Figure-3.png', width = 15, height = 5, units = 'in',
       bg = 'white')

# Figure S1 ---------------------------------------------------------------
# Number of neighbors by design 
fig_s1a <- avg_by_scenario %>%
  group_by(design, neighbors) %>% 
  summarize(bias = mean(bias)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = neighbors, y = bias, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = 2, col = "black") + 
    # scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
    #                    labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Neighbors", y = "Bias (Estimated - True)", color = "Design", 
         title = "(a) Bias") +
    theme(text = element_text(family="LM Roman 10"))
fig_s1b <- avg_by_scenario %>%
  group_by(design, neighbors) %>% 
  summarize(coverage = mean(coverage)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = neighbors, y = coverage, col = design)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Neighbors", y = "Coverage Rate", color = "Design", 
         title = "(b) Coverage") +
    theme(text = element_text(family="LM Roman 10"))
fig_s1c <- avg_by_scenario %>%
  group_by(design, neighbors) %>% 
  summarize(ci_width = mean(ci_width)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names)) %>%  
  ggplot(aes(x = neighbors, y = ci_width, col = design)) + 
    geom_line() +
    geom_point() + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Neighbors", y = "95% CI Width", color = "Design", 
         title = "(c) 95% CI width") +
    theme(text = element_text(family="LM Roman 10"))
fig_s1 <- fig_s1a + fig_s1b + fig_s1c + plot_layout(guides = "collect")
ggsave(file = 'figures/Figure-S1.png', width = 15, height = 5, units = 'in',
       bg = 'white')

# Comparison of spatial and nonspatial model results ----------------------
spatial_summary_df <- summary_df
# Loads an object called summary_df
load("results/nonspatial_summary_sim_1_results.rda")

spatial_summary_df$model <- "Spatial"
summary_df$model <- "Nonspatial"

full_summary_df <- rbind(spatial_summary_df, summary_df)

# Explore model results ---------------
full_summary_df %>%
  group_by(model, prevalence) %>%
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width)) %>%
  ungroup() %>%
  arrange(prevalence, model) %>%
  print(n = nrow(.))

full_summary_df %>%
  group_by(sp_decay, model) %>%
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width)) %>%
  ungroup() %>%
  arrange(sp_decay, model) %>%
  print(n = nrow(.))

# Average within scenarios
full_avg_by_scenario <- full_summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors, model) %>%
  summarize(bias = mean(bias), 
            coverage = mean(coverage), 
            ci_width = mean(ci_width)) %>%
  ungroup()

avg_df_wide <- full_avg_by_scenario %>%
  pivot_wider(names_from = model, values_from = c(bias, coverage, ci_width))
avg_df_wide <- avg_df_wide %>%
  mutate(bias_diff = bias_Nonspatial - bias_Spatial, 
         coverage_diff = coverage_Nonspatial - coverage_Spatial, 
         ci_width_diff = ci_width_Nonspatial - ci_width_Spatial)

avg_df_wide %>%
  group_by(n_plot, prevalence, design) %>%
  summarize(bias_diff = mean(bias_diff), 
            coverage_diff = mean(coverage_diff)) %>%
  ungroup() %>%
  print(n = nrow(.))

avg_df_wide %>%
  group_by(n_plot, prevalence, sp_decay) %>%
  summarize(bias_diff = mean(bias_diff), 
            coverage_diff = mean(coverage_diff)) %>%
  ungroup() %>%
  print(n = nrow(.))

# Make Figure 5 -----------------------
phi_levels <- c(0.9, 0.7, 0.5, 0.3, 0.1) 

fig_5_a <- full_avg_by_scenario %>%
  group_by(model, sp_decay, n_plot) %>% 
  summarize(bias = mean(bias)) %>% 
  mutate(esr = factor(sp_decay, levels = unique(full_avg_by_scenario$sp_decay), 
                         labels = phi_levels)) %>%  
  ggplot(aes(x = n_plot, y = bias, col = esr, shape = model, 
             linetype = model)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0, linetype = 3, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Bias (Estimated - True)", color = "Effective\nSpatial Range", 
         shape = "Model", linetype = "Model", title = "(a) Bias") +
    theme(text = element_text(family="LM Roman 10"))

fig_5_b <- full_avg_by_scenario %>%
  group_by(model, sp_decay, n_plot) %>% 
  summarize(coverage = mean(coverage)) %>% 
  mutate(esr = factor(sp_decay, levels = unique(full_avg_by_scenario$sp_decay), 
                         labels = phi_levels)) %>%  
  ggplot(aes(x = n_plot, y = coverage, col = esr, shape = model, 
             linetype = model)) + 
    geom_line() +
    geom_point() + 
    geom_hline(yintercept = 0.95, linetype = 3, col = "black") + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "Coverage Rate", color = "Effective\nSpatial Range", 
         shape = "Model", linetype = "Model", title = "(b) Coverage") +
    theme(text = element_text(family="LM Roman 10"))

fig_5_c <- full_avg_by_scenario %>%
  group_by(model, sp_decay, n_plot) %>% 
  summarize(ci_width = mean(ci_width)) %>% 
  mutate(esr = factor(sp_decay, levels = unique(full_avg_by_scenario$sp_decay), 
                         labels = phi_levels)) %>%  
  ggplot(aes(x = n_plot, y = ci_width, col = esr, shape = model, 
             linetype = model)) + 
    geom_line() +
    geom_point() + 
    scale_x_continuous(breaks = sort(unique(avg_by_scenario$n_plot)), 
                       labels = sort(unique(avg_by_scenario$n_plot))) + 
    theme_bw(base_size = 18) + 
    scale_color_colorblind() + 
    labs(x = "Number of Plots", y = "95% CI Width", color = "Effective\nSpatial Range", 
         shape = "Model", linetype = "Model", title = "(c) 95% CI Width") +
    theme(text = element_text(family="LM Roman 10"))

fig_5 <- fig_5_a + fig_5_b + fig_5_c + plot_layout(guides = "collect")
ggsave(file = 'figures/Figure-5.png', width = 15, height = 5, units = 'in',
       bg = 'white')

# Overall summary figure spatial vs. nonspatial ---------------------------
fig_4_df <- full_summary_df %>%
  group_by(model, prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(avg_bias = mean(bias), 
            low_bias = quantile(bias, 0.025), 
            high_bias = quantile(bias, 0.975),
            avg_coverage = mean(coverage), 
            low_coverage = quantile(coverage, 0.025), 
            high_coverage = quantile(coverage, 0.975),
            avg_ci_width = mean(ci_width), 
            low_ci_width = quantile(ci_width, 0.025), 
            high_ci_width = quantile(ci_width, 0.975)) %>%
  ungroup()

# Prevalence --------------------------
prev_fig_df <- fig_4_df %>%
  group_by(model, prevalence) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) %>% 
  mutate(prevalence = round(plogis(prevalence), 2))
prev_fig_bias <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_bias, 
                                                col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt",
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Bias", title = "(a)", 
       col = "Model")
prev_fig_coverage <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_coverage, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt",
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Coverage", title = "(b)", 
       col = "Model")
prev_fig_ci_width <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_ci_width, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  labs(x = "Average Occupancy Probability", y = "95% CI Width", title = "(c)", 
       col = "Model")
# Spatial decay -----------------------
decay_fig_df <- fig_4_df %>%
  group_by(sp_decay, model) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) 
decay_fig_bias <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_bias, 
                                                  col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Bias", title = "(d)", col = "Model")
decay_fig_coverage <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_coverage, 
                                                      col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Coverage", title = "(e)", col = "Model")
decay_fig_ci_width <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_ci_width, 
                                                      col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Spatial Decay", y = "95% CI Width", title = "(f)", col = "Model")
# Number of plots
n_plot_fig_df <- fig_4_df %>%
  group_by(n_plot, model) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) 
n_plot_fig_bias <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_bias, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Bias", title = "(g)", col = "Model")
n_plot_fig_coverage <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_coverage, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Coverage", title = "(h)", col = "Model")
n_plot_fig_ci_width <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_ci_width, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of plots", y = "95% CI Width", title = "(i)", col = "Model")
# Design
# NOTE: hardcoded 
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("SRS", "SYS", "HT", "VT", "SA", "LA", "MP", "HP")
design_fig_df <- fig_4_df %>%
  group_by(design, model) %>%
  summarize(avg_bias = mean(avg_bias), 
            low_bias = mean(low_bias), 
            high_bias = mean(high_bias), 
            avg_coverage = mean(avg_coverage), 
            low_coverage = mean(low_coverage), 
            high_coverage = mean(high_coverage), 
            avg_ci_width = mean(avg_ci_width), 
            low_ci_width = mean(low_ci_width), 
            high_ci_width = mean(high_ci_width)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names))
design_fig_bias <- ggplot(data = design_fig_df, aes(x = design, y = avg_bias, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Bias", title = "(j)", col = "Model")
design_fig_coverage <- ggplot(data = design_fig_df, aes(x = design, y = avg_coverage, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Coverage", title = "(k)", col = "Model")
design_fig_ci_width <- ggplot(data = design_fig_df, aes(x = design, y = avg_ci_width, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Sampling Design", y = "95% CI Width", title = "(l)", col = "Model")

fig_4 <- (prev_fig_bias | prev_fig_coverage | prev_fig_ci_width) / 
  (decay_fig_bias | decay_fig_coverage | decay_fig_ci_width) / 
  (n_plot_fig_bias | n_plot_fig_coverage | n_plot_fig_ci_width) / 
  (design_fig_bias | design_fig_coverage | design_fig_ci_width) + 
  plot_layout(guides = "collect")
fig_4
ggsave(file = 'figures/Figure-4.png', width = 14, height = 12, units = 'in',
       bg = 'white')

# Simulation Study 2 Spatial Model ----------------------------------------
# Loads an object called summary_df
load("results/misspec_summary_sim_2_results.rda")

# Average values within each combination
avg_by_scenario <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(bias = mean(bias, na.rm = TRUE), 
            coverage = mean(coverage, na.rm = TRUE), 
            ci_width = mean(ci_width, na.rm = TRUE)) %>%
  ungroup()

# Figure S2 ----------------------------
fig_S2_df <- summary_df %>%
  group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(avg_bias = mean(bias, na.rm = TRUE), 
            low_bias = quantile(bias, 0.025, na.rm = TRUE), 
            high_bias = quantile(bias, 0.975, na.rm = TRUE),
            avg_coverage = mean(coverage, na.rm = TRUE), 
            low_coverage = quantile(coverage, 0.025, na.rm = TRUE), 
            high_coverage = quantile(coverage, 0.975, na.rm = TRUE),
            avg_ci_width = mean(ci_width, na.rm = TRUE), 
            low_ci_width = quantile(ci_width, 0.025, na.rm = TRUE), 
            high_ci_width = quantile(ci_width, 0.975, na.rm = TRUE)) %>%
  ungroup()

# Prevalence --------------------------
prev_fig_df <- fig_S2_df %>%
  group_by(prevalence) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm =  TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) %>% 
  mutate(prevalence = round(plogis(prevalence), 2))
prev_fig_bias <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Bias", title = "(a)")
prev_fig_coverage <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Coverage", title = "(b)")
prev_fig_ci_width <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Average Occupancy Probability", y = "95% CI Width", title = "(c)")
# Spatial decay -----------------------
decay_fig_df <- fig_S2_df %>%
  group_by(sp_decay) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) 
decay_fig_bias <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Bias", title = "(d)")
decay_fig_coverage <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Coverage", title = "(e)")
decay_fig_ci_width <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Spatial Decay", y = "95% CI Width", title = "(f)")
# Number of plots
n_plot_fig_df <- fig_S2_df %>%
  group_by(n_plot) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) 
n_plot_fig_bias <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Bias", title = "(g)")
n_plot_fig_coverage <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Coverage", title = "(h)")
n_plot_fig_ci_width <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of plots", y = "95% CI Width", title = "(i)")
# Design
# NOTE: hardcoded 
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("SRS", "SYS", "HT", "VT", "SA", "LA", "MP", "HP")
design_fig_df <- fig_S2_df %>%
  group_by(design) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names))
design_fig_bias <- ggplot(data = design_fig_df, aes(x = design, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Bias", title = "(j)")
design_fig_coverage <- ggplot(data = design_fig_df, aes(x = design, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Coverage", title = "(k)")
design_fig_ci_width <- ggplot(data = design_fig_df, aes(x = design, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Sampling Design", y = "95% CI Width", title = "(l)")
# Number of neighbors
neighbors_fig_df <- fig_S2_df %>%
  group_by(neighbors) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) 
neighbors_fig_bias <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_bias)) + 
  geom_point() + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Neighbors", y = "Bias", title = "(m)")
neighbors_fig_coverage <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_coverage)) + 
  geom_point() + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Neighbors", y = "Coverage", title = "(n)")
neighbors_fig_ci_width <- ggplot(data = neighbors_fig_df, aes(x = neighbors, y = avg_ci_width)) + 
  geom_point() + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt") + 
  theme_bw(base_size = 14) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of Neighbors", y = "95% CI Width", title = "(o)")

fig_S2 <- (prev_fig_bias | prev_fig_coverage | prev_fig_ci_width) / 
  (decay_fig_bias | decay_fig_coverage | decay_fig_ci_width) / 
  (n_plot_fig_bias | n_plot_fig_coverage | n_plot_fig_ci_width) / 
  (design_fig_bias | design_fig_coverage | design_fig_ci_width) / 
  (neighbors_fig_bias | neighbors_fig_coverage | neighbors_fig_ci_width)
fig_S2
ggsave(file = 'figures/Figure-S2.png', width = 12, height = 12, units = 'in',
       bg = 'white')

# Compare spatial vs. nonspatial model ------------------------------------
spatial_summary_df <- summary_df
# Loads an object called summary_df
load("results/misspec-nonspatial_summary_sim_1_results.rda")

spatial_summary_df$model <- "Spatial"
summary_df$model <- "Nonspatial"

full_summary_df <- rbind(spatial_summary_df, summary_df)

fig_4_df <- full_summary_df %>%
  group_by(model, prevalence, sp_decay, n_plot, design, neighbors) %>%
  summarize(avg_bias = mean(bias, na.rm = TRUE), 
            low_bias = quantile(bias, 0.025, na.rm = TRUE), 
            high_bias = quantile(bias, 0.975, na.rm = TRUE),
            avg_coverage = mean(coverage, na.rm = TRUE), 
            low_coverage = quantile(coverage, 0.025, na.rm = TRUE), 
            high_coverage = quantile(coverage, 0.975, na.rm = TRUE),
            avg_ci_width = mean(ci_width, na.rm = TRUE), 
            low_ci_width = quantile(ci_width, 0.025, na.rm = TRUE), 
            high_ci_width = quantile(ci_width, 0.975, na.rm = TRUE)) %>%
  ungroup()

# Prevalence --------------------------
prev_fig_df <- fig_4_df %>%
  group_by(model, prevalence) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) %>% 
  mutate(prevalence = round(plogis(prevalence), 2))
prev_fig_bias <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_bias, 
                                                col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt",
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Bias", title = "(a)", 
       col = "Model")
prev_fig_coverage <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_coverage, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt",
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Average Occupancy Probability", y = "Coverage", title = "(b)", 
       col = "Model")
prev_fig_ci_width <- ggplot(data = prev_fig_df, aes(x = factor(prevalence), y = avg_ci_width, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  scale_color_brewer(palette = "Set1") + 
  labs(x = "Average Occupancy Probability", y = "95% CI Width", title = "(c)", 
       col = "Model")
# Spatial decay -----------------------
decay_fig_df <- fig_4_df %>%
  group_by(sp_decay, model) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) 
decay_fig_bias <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_bias, 
                                                  col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Bias", title = "(d)", col = "Model")
decay_fig_coverage <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_coverage, 
                                                      col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Spatial Decay", y = "Coverage", title = "(e)", col = "Model")
decay_fig_ci_width <- ggplot(data = decay_fig_df, aes(x = sp_decay, y = avg_ci_width, 
                                                      col = model)) + 
  geom_point(position = position_dodge(width = 1)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Spatial Decay", y = "95% CI Width", title = "(f)", col = "Model")
# Number of plots
n_plot_fig_df <- fig_4_df %>%
  group_by(n_plot, model) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) 
n_plot_fig_bias <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_bias, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Bias", title = "(g)", col = "Model")
n_plot_fig_coverage <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_coverage, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Number of Plots", y = "Coverage", title = "(h)", col = "Model")
n_plot_fig_ci_width <- ggplot(data = n_plot_fig_df, aes(x = n_plot, y = avg_ci_width, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 20)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 20)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Number of plots", y = "95% CI Width", title = "(i)", col = "Model")
# Design
# NOTE: hardcoded 
design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                   "mod_pref", "heavy_pref")
design_names <- c("SRS", "SYS", "HT", "VT", "SA", "LA", "MP", "HP")
design_fig_df <- fig_4_df %>%
  group_by(design, model) %>%
  summarize(avg_bias = mean(avg_bias, na.rm = TRUE), 
            low_bias = mean(low_bias, na.rm = TRUE), 
            high_bias = mean(high_bias, na.rm = TRUE), 
            avg_coverage = mean(avg_coverage, na.rm = TRUE), 
            low_coverage = mean(low_coverage, na.rm = TRUE), 
            high_coverage = mean(high_coverage, na.rm = TRUE), 
            avg_ci_width = mean(avg_ci_width, na.rm = TRUE), 
            low_ci_width = mean(low_ci_width, na.rm = TRUE), 
            high_ci_width = mean(high_ci_width, na.rm = TRUE)) %>% 
  mutate(design = factor(as.character(design), levels = design_levels, 
                         labels = design_names))
design_fig_bias <- ggplot(data = design_fig_df, aes(x = design, y = avg_bias, 
                                                    col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Bias", title = "(j)", col = "Model")
design_fig_coverage <- ggplot(data = design_fig_df, aes(x = design, y = avg_coverage, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(family="LM Roman 10"), 
        panel.grid = element_blank()) + 
  geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
  labs(x = "Sampling Design", y = "Coverage", title = "(k)", col = "Model")
design_fig_ci_width <- ggplot(data = design_fig_df, aes(x = design, y = avg_ci_width, 
                                                        col = model)) + 
  geom_point(position = position_dodge(width = 0.3)) + 
  geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", 
               position = position_dodge(width = 0.3)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw(base_size = 16) + 
  theme(text = element_text(ggfamily="LM Roman 10"), 
        panel.grid = element_blank()) + 
  labs(x = "Sampling Design", y = "95% CI Width", title = "(l)", col = "Model")

fig_s3 <- (prev_fig_bias | prev_fig_coverage | prev_fig_ci_width) / 
  (decay_fig_bias | decay_fig_coverage | decay_fig_ci_width) / 
  (n_plot_fig_bias | n_plot_fig_coverage | n_plot_fig_ci_width) / 
  (design_fig_bias | design_fig_coverage | design_fig_ci_width) + 
  plot_layout(guides = "collect")
fig_s3
ggsave(file = 'figures/Figure-4.png', width = 14, height = 12, units = 'in',
       bg = 'white')
