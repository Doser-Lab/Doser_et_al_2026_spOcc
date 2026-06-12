# create_shiny_data.R: script to create objects for easy loading into R Shiny
# Author: Alexa R. Busby

rm(list = ls())
library(dplyr)
library(spOccupancy)
library(ggplot2)
library(patchwork)

#PANEL 2: SAMPLING DESIGNS (sampling_design.rda)------------------------------------------------------------------------

    # Load utility functions
    source("code/00_utils.R")
    
    set.seed(1200)
    
    # Note that this shows values for a single set of the other parameters.
    
    J.x <- 70
    J.y <- 70
    J <- J.x * J.y
    phi <- 3 / 0.7
    species_prev <- 0
    
    n.rep <- sample(3, J, replace = TRUE)  # Number of hypothetical repeat surveys at each site.
    beta <- c(species_prev, 0.2, 0.3)  # The occupancy parameters. The first is the intercept, then the effects of two simulated covariates.
    p.occ <- length(beta)  # Number of occupancy regression parameters.
    alpha <- c(0.3, 0.5)  # The detection parameters. The first is the intercept, second is a covariate.
    p.det <- length(alpha)  # Number of detection regression parameters.
    sigma.sq <- 1.5  # The spatial variance parameter
    sp <- TRUE  # Indicates that we want to simulate with a spatial model
    cov.model = 'exponential'  # Using the exponential spatial covariance function.
    
    
    # The simOcc() function generates data with the above characteristics.
    dat <- simOcc(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha,
                  sigma.sq = sigma.sq, phi = phi, sp = sp, cov.model = cov.model)
    
    plot.df <- data.frame(x = dat$coords[, 1],
                          y = dat$coords[, 2],
                          occupancy = dat$psi)
    #base plot
    base.plot <- ggplot(data = plot.df, aes(x = x, y = y, fill = occupancy)) +
      geom_raster() +
      theme_bw(base_size = 14) +
      scale_fill_gradient(low = 'white', high = 'seagreen', limits = c(0, 1)) + 
      labs(x = 'Easting', y = 'Northing', fill = 'Occupancy Probability')
    
    #random sampling
    n.plots <- 100
    plots.random <- random_sampling(n.plots = n.plots, J = J)
    random.plot.df <- plot.df[plots.random, ]
    random.plot <- base.plot + 
      geom_point(data = random.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Random sampling")
    
    #systematic sampling
    plots.sys <- grid_sampling(n.plots = n.plots, J.x = J.x, J.y = J.y)
    sys.plot.df <- plot.df[plots.sys, ]
    sys.plot <- base.plot + 
      geom_point(data = sys.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Systematic sampling") 
    
    #horizontal transects
    set.seed(8383)
    plots.hline <- line_clusters(n.plots = n.plots)
    hline.plot.df <- plot.df[plots.hline, ]
    hline.plot <- base.plot + 
      geom_point(data = hline.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Horizontal transects")
    
    #vertical transects
    set.seed(777373)
    plots.vline <- line_clusters(n.plots = n.plots, method = 'v')
    vline.plot.df <- plot.df[plots.vline, ]
    vline.plot <- base.plot + 
      geom_point(data = vline.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Vertical transects")
    
    #small arrays
    set.seed(378)
    plots.box4 <- box_clusters(n.plots = n.plots, cluster_size = 4)
    box4.plot.df <- plot.df[plots.box4, ]
    box4.plot <- base.plot + 
      geom_point(data = box4.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Small arrays")
    
    #large arrays
    set.seed(3770)
    plots.box16 <- box_clusters(n.plots = n.plots, cluster_size = 16)
    box16.plot.df <- plot.df[plots.box16, ]
    box16.plot <- base.plot + 
      geom_point(data = box16.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Large arrays")
    
    #moderate preferential sampling
    set.seed(97382)
    plots.mod.pref <- pref_sampling(n.plots = n.plots, occ_prob = dat$psi, noise_factor = 0.3)
    mod.pref.plot.df <- plot.df[plots.mod.pref, ]
    mod.pref.plot <- base.plot + 
      geom_point(data = mod.pref.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Moderate preferential sampling")
    
    #large preferential sampling
    set.seed(77373732)
    plots.heavy.pref <- pref_sampling(n.plots = n.plots, occ_prob = dat$psi, noise_factor = 0.1)
    heavy.pref.plot.df <- plot.df[plots.heavy.pref, ]
    heavy.pref.plot <- base.plot + 
      geom_point(data = heavy.pref.plot.df, aes(x = x, y = y), col = 'black', size = 1.5) + labs(title = "Large preferential sampling") 
    
    #display all
    display.all.plot <- (random.plot + sys.plot) / (hline.plot + vline.plot) / 
      (box4.plot + box16.plot) / (mod.pref.plot + heavy.pref.plot) + 
      plot_layout(guides = 'collect') & theme(legend.position = 'bottom', legend.key.width = unit(0.5, 'in'))
    
    
    #save plots to sampling_design.rda
    save(base.plot, random.plot, sys.plot, hline.plot, vline.plot, box4.plot, box16.plot, mod.pref.plot, heavy.pref.plot, 
         display.all.plot, file = "code/07_shiny/shiny_sampling_design.rda")

#PANEL 3: 1 PARAMETER VISIALIZATIONS (one_parameter.rda) ------------------------------
    load("results/summary_sim_1_results.rda")
    
    #number of neighbors - DO FIRST
    
    avg_by_scenario <- summary_df %>%
      group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
      summarize(bias = mean(bias), 
                coverage = mean(coverage), 
                ci_width = mean(ci_width)) %>%
      ungroup()
    
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
    neighbors_fig_df$model <- "Spatial"
    neighbors_fig_df <- as.data.frame(neighbors_fig_df)
    neighbors_fig_df$neighbors <- as.factor(neighbors_fig_df$neighbors)
    neighbors_fig_df <- neighbors_fig_df |> relocate(model, .after = neighbors)
    
    #species prevalence, spatial decay, number of plots, sampling design
    
    spatial_summary_df <- summary_df
    
    load("results/nonspatial_summary_sim_1_results.rda")
    
    spatial_summary_df$model <- "Spatial"
    summary_df$model <- "Nonspatial"
    
    full_summary_df <- rbind(spatial_summary_df, summary_df)
    
    fig_4_df <- full_summary_df %>% #REAL FIGURE 4 FROM PAPER AB
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
    prev_fig_df <- as.data.frame(prev_fig_df)
      
    #spatial decay
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
    decay_fig_df <- as.data.frame(decay_fig_df)
    decay_fig_df$sp_decay <- c("0.9", "0.9", "0.7", "0.7", "0.5", "0.5", "0.3", "0.3", "0.1", "0.1")
    decay_fig_df$sp_decay <- as.factor(decay_fig_df$sp_decay)
    colnames(decay_fig_df)[1] <- "sp_range" 
    
     
    #number of plots
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
        n_plot_fig_df <- as.data.frame(n_plot_fig_df)
        n_plot_fig_df$n_plot <- as.factor(n_plot_fig_df$n_plot)
      
    #sampling design
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
        design_fig_df <- as.data.frame(design_fig_df)
      
      
    #save plots to one_parameter.rda
    save(prev_fig_df, decay_fig_df, n_plot_fig_df, design_fig_df, neighbors_fig_df, file = "code/07_shiny/shiny_one_parameter.rda")

#PANEL 4 & 5: 2 & 3 PARAMETER VISIALIZATIONS (multi_parameter.rda), --------------------------------------------------------------------
    load("results/summary_sim_1_results.rda")
    
    avg_by_scenario <- summary_df %>%
      group_by(prevalence, sp_decay, n_plot, design, neighbors) %>%
      summarize(bias = mean(bias), 
                coverage = mean(coverage), 
                ci_width = mean(ci_width)) %>%
      ungroup()
    
    avg_by_scenario <- as.data.frame(avg_by_scenario)
    
    avg_by_scenario$prevalence[avg_by_scenario$prevalence == -1.734601] <- "0.15"
    
    avg_by_scenario$prevalence[avg_by_scenario$prevalence == 0] <- "0.5"
    
    avg_by_scenario$sp_decay <- as.character(avg_by_scenario$sp_decay)
    
    avg_by_scenario$sp_decay[avg_by_scenario$sp_decay == "3.33333333333333"] <- "0.9"
    
    avg_by_scenario$sp_decay[avg_by_scenario$sp_decay == "4.28571428571429"] <- "0.7"
    
    avg_by_scenario$sp_decay[avg_by_scenario$sp_decay == "6"] <- "0.5"
    
    avg_by_scenario$sp_decay[avg_by_scenario$sp_decay == "10"] <- "0.3"
    
    avg_by_scenario$sp_decay[avg_by_scenario$sp_decay == "30"] <- "0.1"
    
    colnames(avg_by_scenario)[2] <- "sp_range"
    
    design_levels <- c("random", "grid", "h_line", "v_line", "box4", "box16", 
                       "mod_pref", "heavy_pref")
    design_names <- c("SRS", "SYS", "HT", "VT", "SA", "LA", "MP", "HP")
    
    avg_by_scenario <- avg_by_scenario |> mutate(design = factor(as.character(design), levels = design_levels, 
                                              labels = design_names))
    
    avg_by_scenario$prevalence <- as.factor(avg_by_scenario$prevalence)
    
    avg_by_scenario$sp_range <- as.factor(avg_by_scenario$sp_range)
    
    avg_by_scenario$n_plot <- as.factor(avg_by_scenario$n_plot)
    
    avg_by_scenario$neighbors <- as.factor(avg_by_scenario$neighbors)
    
    avg_by_scenario$design <- as.factor(avg_by_scenario$design)

    save(avg_by_scenario, file = "code/07_shiny/shiny_multi_parameter.rda")

  
