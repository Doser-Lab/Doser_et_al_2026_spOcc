# Shiny app for "Guidelines for the use of spatial occupancy models to estimate species distributions"
# Author: Alexa R. Busby

#load packages -----------------------------------------------------------------

library(shiny)
library(bslib)
#library(spOccupancy)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(tidyr)
#library(patchwork)

#run startup functions (permanent - not changeable by app user)
load("shiny_sampling_design.rda")
load("shiny_one_parameter.rda")
load("shiny_multi_parameter.rda")

#UI ----------------------------------------------------------------------------

ui <- page_navbar(
  
  navbar_options = navbar_options(bg = "#c1d7e4"),
  
  #navset_card_tab( #can change to tab or underline if desired
    
    #PANEL 1: GENERAL INFO. ----------------------------------------------------
    nav_panel( 
      title = "Read Me!", 
        navset_card_underline(
             nav_panel("Introduction",
               tags$span("Guidelines for the use of spatial occupancy models to estimate species distributions", style = "font-size: 26px"),
               tags$span("Jeffrey W. Doser", tags$sup(1), ", Robert Howell, Alexa R. Busby", style = "font-size: 18px"),
               tags$span(tags$sup(1), "Corresponding author; jwdoser@ncsu.edu; ORCID ID: 0000-0002-8950-9895", style = "font-size:12px"),
               tags$span("In review", style = "font-size: 16px; font-style: italic"),
               tags$span("Our Study:", style = "font-size: 16px; font-weight: bold"),
               tags$span("Occupancy models are frequently used to estimate species distributions from detection-nondetection data. 
                          When applying such models across large spatial extents, it is often recommended to account for residual 
                          spatial autocorrelation (SAC) using spatial occupancy models. While such models have been increasingly 
                          adopted, there remains little practical guidance on the impacts of survey design and SAC characteristics 
                          on prediction accuracy of spatial occupancy models. We perform a simulation study to assess the 
                          impacts of survey design and species characteristics on the accuracy and precision of spatial occupancy 
                          model estimates. We quantify the effects of sample size, sampling design, species prevalence, and the 
                          effective spatial range of SAC on the accuracy and precision of occupancy predictions. We further 
                          assess the relative performance of spatial vs. nonspatial occupancy models under varying degrees of SAC.", style = "font-size: 14px"), 
               tags$span("Key Results:", style = "font-size: 16px; font-weight: bold"),
               tags$span("When SAC was present, sample size and sampling design had the largest effects on spatial occupancy 
                          model performance. Estimates were positively biased when the number of sampling locations was low (50, 100), 
                          with bias effectively disappearing with 200 sampling locations. Preferential sampling resulted in 
                          positive bias in occupancy estimates, while multiple probability sampling designs had minimal bias when sample 
                          sizes were large enough. Spatial occupancy models provided no improvements over nonspatial occupancy models when 
                          SAC was absent and resulted in overly conservative credible intervals. When the effective spatial range of SAC was 
                          very small or large relative to the study area, the nonspatial model performed comparatively to the spatial model, 
                          particularly when SAC variance was low. However, when SAC varied at a range relevant to the study area size and the 
                          spatial variance was high, spatial occupancy models substantially outperformed nonspatial models, with nonspatial 
                          models having overly precise occupancy predictions. Our findings lend substantial support to the application of 
                          spatial occupancy models for estimating species distributions across a broad range of survey designs, yet the 
                          utility of spatial occupancy models over nonspatial occupancy models is dependent on the magnitude of SAC and the 
                          scale of SAC relative to the study area. We present a set of practical guidelines for practitioners to consider 
                          when exploring the use of spatial occupancy models.", style = "font-size: 14px"),
               tags$span("Resources", style = "font-size: 16px; font-weight: bold"),
               tags$span("The code used to generate these results and other helpful resources can be found at the paper's",
                         tags$a(href = "https://github.com/Doser-Lab/Doser_et_al_2026_spOcc/tree/main", "GitHub repository."), style = "font-size: 14px"),
               tags$span(
                 tags$img(src = "https://doserlab.com/files/spoccupancy-web/logo.png", height = "150px", width = "130px"),
                 tags$img(src = "https://github.com/Doser-Lab/resources/blob/main/SEFS_Logo_TransparentBG.png?raw=true", height = "230px", width="400px")
               )
             ), #end of nav_panel1
             
             nav_panel("App Instructions",
               tags$span("This R Shiny application allows users to explore the results of Simulation Study 1 from Doser et al. In review. All results in Simulation Study 2 and 3 are presented in the manuscript.",
                         style = "font-size: 18px"),
               
               tags$span("Page: Sampling Designs", style = "font-size: 16px; font-weight: bold"),
               
               tags$span("This page allows users to explore visualizations of the eight sampling designs evaluated in our simulation study. 
                         Sampling designs are shown over an example of a single simulated species distribution. The example simulated
                         species distribution is the simulated occupancy of a single species across a 70 x 70 unit grid landscape. This
                         grid landscape is comprised of 4,900 locations, which each represent potential locations for performing a detection-nondetection
                         survey. The occupancy probability at each location is shown by color intensity. On the left side of the page, users can use the
                         radio button to select the sampling design they wish to display over the simulated distribution. The final radio button allows
                         users to display all eight sampling designs simulatenously as a 2x4 grid. The black points that appear after selection correspond
                         to sampling locations across the landscape.", style = "font-size: 14px"),
               
               tags$span("Page: Visualize Performance of a Single Variable", style = "font-size: 16px; font-weight: bold"),
               
               tags$span("This page allows users to explore the effects of a single variable on spatial and nonspatial model performance by generating a point plot of average performance metric estimates and their uncertainty. On the left side of the page, you can make selections
                         to specify the point plot you wish to display. First, select one of the five variables from our study from the dropdown menu (for variable descriptions 
                         see 'terminology' tab). This will serve as the x axis of the point plot. Next, check the boxes of the three performance metric(s) from our study you wish to display (for performance metric descriptions see 'terminology'
                         tab). Mutliple performance metrics can be displayed simultaneously. Finally, check the boxes of the model type(s) you wish to display (for model type descriptions
                         see 'terminology' tab). Both model types can be displayed simultaneously. The point plot(s) displayed after selections are completed show estimates which are averaged over all simulation
                         scenarios for the selected variable. The vertical lines surrounding each point show the upper and lower limits of the 95% credible interval. Above the point plot, click 'Table' to display the numerical
                         estimates shown in the plot.", style = "font-size: 14px"),
              
               tags$span("Page: Visualize Performance of Two Variables", style = "font-size: 16px; font-weight: bold"),
               
               tags$span("This page allows users to explore the interactive effects of two variables on model performance by generating a scatterplot of the relationship between a variable and a performance metric, where lines are colored according to a second variable. On the left side of the page, you can make selections
                         to specify the scatterplot you wish to display. First, select one of the five variables from our study to display as the x axis of the plot (for
                         variable descriptions see 'terminology' tab). Next, select one of the three performance metrics to display as the y axis of the plot (for performance metric
                         descriptions see 'terminology' tab). Next, select a second of the five variables from our study to display as the colors of the scatterplot lines. 
                         Based on the second variable selected, check boxes will appear to allow you to select which levels of that variable to include in the plot (for variable level
                         descriptions see 'terminology' tab). Above the scatterplot, click 'Table' to display the numerical estimates shown in the plot.", style = "font-size: 14px"),
               
               tags$span("Page: Visualize Performance of Three Variables", style = "font-size: 16px; font-weight: bold"),
               
               tags$span("This page allows users to explore the interactive effects of three variables on model performance by generating a matrix of the scatterplots from above, where each panel in the matrix corresponds to a third variable. On the left side of the page, 
                         you can make selections to specify the matrix you wish to display. First, select one of the five variables from our study to display as the x axis of the plot (for
                         variable descriptions see 'terminology' tab). Next, select one of the three performance metrics to display as the y axis of the plot (for performance metric
                         descriptions see 'terminology' tab). Next, select a second of the five variables from our study to display as the colors of the scatterplot lines. 
                         Based on the second variable selected, check boxes will appear to allow you to select which levels of that variable to include in the plot (for variable level
                         descriptions see 'terminology' tab). Finally, select a third of the five variables from our study to use to specify the panels of the matrix (for variable descriptions
                         see 'terminology' tab). Above the matrix, click 'Table' to display the numerical estimates shown in the plot.", style = "font-size: 14px")
             ), #end of nav_panel2
             
             nav_panel("Terminology",
                       
               tags$span("Variables Evaluated", style = "font-size: 22px; font-weight: bold"),
               
               tags$span("Survey design characterisitcs", style = "font-size: 18px"),
               
               tags$span(
                   tags$ol(
                     tags$li("Number of plots - number of spatial locations at which data were collected", style = "font-size:16px; margin-bottom: 8px"), #1
                     tags$ul(
                       tags$li("50 locations", style = "margin-bottom: 8px"),
                       tags$li("100 locations", style = "margin-bottom: 8px"),
                       tags$li("200 locations", style = "margin-bottom: 8px"),
                       tags$li("400 locations", style = "margin-bottom: 8px"),
                       tags$li("600 locations", style = "margin-bottom: 8px"),
                     style = "list-style-type: disc"),
                     tags$li("Sampling design - placement of sampling locations", style = "font-size:16px; margin-bottom: 8px"), #2
                     tags$ul(
                       tags$li("Simple random sampling (SRS)", style = "margin-bottom: 8px"),
                       tags$li("Systematic sampling (SYS)", style = "margin-bottom: 8px"),
                       tags$li("Cluster sampling via horizontal transects (HT)", style = "margin-bottom: 8px"),
                       tags$li("Cluster sampling via vertical transects (VT)", style = "margin-bottom: 8px"),
                       tags$li("Cluster sampling via small (4 site) square arrays (SA)", style = "margin-bottom: 8px"),
                       tags$li("Cluster sampling via large (16 site) square arrays (LA)", style = "margin-bottom: 8px"),
                       tags$li("Moderate preferential sampling (MP)", style = "margin-bottom: 8px"),
                       tags$li("Heavy preferential sampling (HP)", style = "margin-bottom: 8px"),
                     style = "list-style-type: disc")
                   ), style = "font-size: 14px"), #end of survey design list
               
                   tags$span("Species characteristics", style = "font-size: 18px"),
                   
                   tags$span(
                     tags$ol(start = "3",
                     tags$li("Average species prevalence - whether the species was rare or common", style = "font-size:16px; margin-bottom: 8px"), #3
                     tags$ul(
                       tags$li("Rare - average occupancy probability of 0.15", style = "margin-bottom: 8px"),
                       tags$li("Common - average occupancy probability of 0.5", style = "margin-bottom: 8px"),
                     style = "list-style-type: disc"),
                     tags$li("Effective range of spatial autocorrelation - gradient of fine-scale (high values of phi) to large-scale (low values of phi) spatial autocorrelation", style = "font-size:16px; margin-bottom:8px"), #4
                     tags$ul(
                       tags$li("phi = 3/0.1", style = "margin-bottom: 8px"),
                       tags$li("phi = 3/0.3", style = "margin-bottom: 8px"),
                       tags$li("phi = 3/0.5", style = "margin-bottom: 8px"),
                       tags$li("phi = 3/0.7", style = "margin-bottom: 8px"),
                       tags$li("phi = 3/0.9", style = "margin-bottom: 8px"),
                     style = "list-style-type: disc")
                   ), style = "font-size: 14px"), #end of species characteristics list
               
                   tags$span("Spatial occupancy model specifications", style = "font-size: 18px"),
                   
                   tags$span(
                     tags$ol(start = "5",
                     tags$li("Number of neighbors in the Nearest Neighbor Gaussian Process (NNGP)", style = "font-size: 16px; margin-bottom: 8px"), #5
                     tags$ul(
                       tags$li("5 neighbors", style = "margin-bottom: 8px"),
                       tags$li("10 neighbors", style = "margin-bottom: 8px"),
                       tags$li("15 neighbors", style = "margin-bottom: 8px"),
                       tags$li("20 neighbors", style = "margin-bottom: 8px"),
                       tags$li("25 neighbors", style = "margin-bottom: 8px"),
                     style = "list-style-type: disc")
                   ), style = "font-size: 14px"), #end of spaital occupancy model list
               
               tags$span("Performance Metrics Calculated", style = "font-size: 22px; font-weight: bold"),
               
               tags$span(
                 tags$ol(
                   tags$li("Occupancy probability average bias - estimated value minus true simulated value", style = "margin-bottom: 8px"),
                   tags$li("Coverage rates of 95% credible intervals - the percentage of the true occupancy probabilities contained within the 95% credible interval", style = "margin-bottom: 8px"),
                   tags$li("Width of 95% credible intervals - a measure of uncertainty in subsequent model predictions", style = "margin-bottom: 8px")
                 ),
               style = "font-size: 16px"),#end of performance metrics list
               
               tags$span("Model Types", style = "font-size: 22px; font-weight:bold"),
               
               tags$span("We assessed model performance of both a spatial model (i.e., includes a NNGP spatial random effect) and a nonspatial model (i.e., a regular
                          occupancy model without a spatial random effect). This app shows results only for the 'correctly specified' scenario. Results for the mis-specified 
                          scenario described in the manuscript are anlaogous.", style = "font-size: 16px")
             ) #end of nave_panel3    
        ) #end of navset_card_underline
    ), #end of panel 1
  
    #PANEL 2: SAMPLING DESIGNS -------------------------------------------------
    nav_panel(
      title = "Sampling Designs",
      
      #create 2 columns (selection, visualization)
      layout_columns(
        #column for selection
        card(
          card_body(
            card_header(tags$span("Explore the spatial arrangement of sampling designs included in this study", style = "font-size: 18px")),
            
            radioButtons(
               inputId = "sampling_design.2",
               label = "Select a sampling design below:",
               choices = c(
                 "None",
                 "Simple random sampling",
                 "Systematic sampling",
                 "Horizontal transects",
                 "Vertical transects", 
                 "Small arrays" ,
                 "Large arrays",
                 "Moderate preferential sampling",
                 "Heavy preferential sampling",
                 "Display all"
               ) #end choices
            ), #end radio buttons widget
          tags$span("Sampling designs are shown over an example of a single simulated species distribution (i.e., the simulated occupancy of a species across a 70 x 70 unit grid landscape). 
                   Each pixel represents a potential locations for performing a detection-nondetection survey. Occupancy probability at each location is shown by color intensity. Black points correspond to survey locations.", 
                    style = "font-size: 14px; margin-top: 30px")
          ) #end of selection column card body
        ), #end of selection column
        
        #column for visualization
        card(
          plotOutput("landscape", width = "75%")
        ), #end of visualization column
        
        col_widths = c(4,8)
        
      ) #end of columns
    ), #end of panel 2
  
    #PANEL 3: SINGLE VARIABLE VISUALIZATIONS ---------------------------------------
    nav_panel(
      title = "Visualize Performance of a Single Variable",
      #create 4 columns (selection, bias, coverage, ci width)
      layout_columns(
        #left column: card for selections
        card(
          card_header(tags$span("Explore the effects of a single variable on spatial and nonspatial model performance using point plots", style="font-size:18px")),
          
          card_body(height="770px",
            selectInput(
              inputId = "characteristic.3",
              label = "Select a variable to view its influence on model performance",
              choices = list(
                " ",
                "Species prevalence",
                "Effective spatial range",
                "Number of plots",
                "Sampling design",
                "Number of neighbors (spatial model only)"
              ) #end of selection choices
            ), #end of selection widget
            checkboxGroupInput(
              inputId = "performance_metric.3",
              label = "Check the performance metric(s) you wish to display",
              choices = c(
                "Bias" = 1,
                "Coverage" = 2,
                "CI width" = 3
              ) #end of checkbox group choices 1
            ), #end of checkbox group widget 1
            
            
            checkboxGroupInput(
              inputId = "model_type.3",
              label = "Check the model type(s) you wish to display",
              choices = c(
                "Spatial",
                "Nonspatial"
              ), #end of checkbox group choices 2
            ),#end of checkbox group widget 2
            
            tags$span("Spatial model estimates shown in blue", style = "font-size: 14px;color: #377EB8"),
            
            tags$span("Nonspatial model estimates shown in red", style = "font-size: 14px;color: #e41a1c"),
            
            tags$span("Points show performance metric estimates averaged over all simulation scenarios for the selected variable.
                      Vertical lines surrounding points show upper and lower limits of the 95% credible interval.", style = "font-size: 14px; margin-top: 20px")
            
          )#end of selection column card body
          
        ), #end of selection column
        
        #middle 3 columns
        div(style = "display: flex, align-items: flex-start; height: 100%; margin-top: 135px",
        layout_columns(
        height = "500px",
        fill= FALSE,
        #column for bias
        navset_card_underline(
          title = "Bias",
          nav_panel("Plot", plotOutput("bias")),
          nav_panel("Table", tableOutput("bias.table"))
        ), #end of bias column
        
        #column for coverage
        navset_card_underline(
          title = "Coverage",
          nav_panel("Plot", plotOutput("coverage")),
          nav_panel("Table", tableOutput("coverage.table"))
        ), #end of coverage column
        
        #column for ci width
        navset_card_underline(
          title = "CI width",
          nav_panel("Plot", plotOutput("ci_width")),
          nav_panel("Table", tableOutput("ci_width.table"))
        ) #end of ci width column
        )#end of second layout_columns
        ), #end of div
        
        col_widths = c(3, 9)
      )#end of layout_columns
    ), #end of panel 3
  
    #PANEL 4: MULTI VARIABLE VISUALIZATIONS ---------------------------------------
    nav_panel(
      title = "Visualize Performance of Two Variables",
      layout_columns(
        #column for selection
        card(
          card_header(tags$span("Explore the effects of a two variables on spatial model performance using a scatterplot", style="font-size:18px")),
          selectInput(
            inputId = "characteristic.4",
            label = "Select the variable you wish to display as the x axis of the plot",
            choices = list(
              " ",
              "Species prevalence",
              "Effective spatial range",
              "Number of plots",
              "Number of neighbors",
              "Sampling design"
            ) #end of selectInput: characteristic choices
          ), #end of selectInput: characteristic widget
          
          selectInput(
            inputId = "performance_metric.4",
            label = "Select the performance metric you wish to display, this will become the y axis of the plot",
            choices = list(
              " ",
              "Bias",
              "Coverage",
              "CI width"
            ) #end of selectInput: performance metric choices
          ), #end of selectInput: performance metric widget
          
          selectInput(
            inputId = "grouping.4",
            label = "Select the variable you wish to use to group points by color, choosing the same variable as the x axis will result in error",
            choices = list(
              " ",
              "Species prevalence",
              "Effective spatial range",
              "Number of plots",
              "Number of neighbors",
              "Sampling design"
            ) #end of selectInput: grouping variable choices
          ), #end of selectInput: grouping variable widget
          
          uiOutput("levels.4"),
          
          tags$span("Points show performance metric estimates averaged over all simulation scenarios for the selected variables.", style = "font-size: 14px; margin-top: 20px")
          
        ), #end of selection column
        
        #column for visualization
        navset_card_underline(
          nav_panel("Plot", plotOutput("plot.4")),
          nav_panel("Table", tableOutput("table.4"))
        ), #end of visualization column
        
        col_widths = c(4, 8)
        
      ) #end of columns
    ), #end of panel
  
  #PANEL 5: FACET PLOTS
  nav_panel(
    title = "Visualize Performance of Three Variables",
    layout_columns(
      #column for selection
      card(
        card_header(tags$span("Explore the effects of a three variables on spatial model performance using a matrix of scatterplots", style="font-size:18px")),
        selectInput(
          inputId = "characteristic.5",
          label = "Select the variable you wish to display as the x axis of the plots",
          choices = list(
            " ",
            "Species prevalence",
            "Effective spatial range",
            "Number of plots",
            "Number of neighbors",
            "Sampling design"
          ) #end of selectInput: characteristic choices
        ), #end of selectInput: characteristic widget
        
        selectInput(
          inputId = "performance_metric.5",
          label = "Select the performance metric you wish to display, this will become the y axis of the plots",
          choices = list(
            " ",
            "Bias",
            "Coverage",
            "CI width"
          ) #end of selectInput: performance metric choices
        ), #end of selectInput: performance metric widget
        
        selectInput(
          inputId = "grouping.5",
          label = "Select the variable you wish to use to group points by color, choosing the same variable as the x axis will result in error",
          choices = list(
            " ",
            "Species prevalence",
            "Effective spatial range",
            "Number of plots",
            "Number of neighbors",
            "Sampling design"
          ) #end of selectInput: grouping variable choices
        ), #end of selectInput: grouping variable widget
        
        uiOutput("levels.5"),
        
        selectInput(
          inputId = "facet.5",
          label = "Select the variable you wish to use to divide plots in the matrix, choosing the same variable as the x axis or color grouping will result in error",
          choices = list(
            " ",
            "Species prevalence",
            "Effective spatial range",
            "Number of plots",
            "Number of neighbors",
            "Sampling design"
          )
        ), #end of selectInput: facet plot grouping widget
        
        tags$span("Points show performance metric estimates averaged over all simulation scenarios for the selected variables.", style = "font-size: 14px; margin-top: 20px") 
        
      ), #end of selection column
      
      #column for visualization
      navset_card_underline(
        nav_panel("Plot", plotOutput("plot.5")),
        nav_panel("Table", tableOutput("table.5"))
      ), #end of visualization column
      
      col_widths = c(3, 9)
    ) #end of columns
  ) #end of panel 5
    
  ) #end of page_navbar

#SERVER ------------------------------------------------------------------------

server <- function(input, output){
  #PANEL 2, output: plot of sampling design responsive to radio button selection
  output$landscape <- renderPlot({
    switch(input$sampling_design.2,
                   "None" = base.plot,
                   "Simple random sampling" = random.plot,
                   "Systematic sampling" = sys.plot,
                   "Horizontal transects" = hline.plot,
                   "Vertical transects" = vline.plot, 
                   "Small arrays" = box4.plot,
                   "Large arrays" = box16.plot,
                   "Moderate preferential sampling" = mod.pref.plot,
                   "Heavy preferential sampling" = heavy.pref.plot,
                   "Display all" = display.all.plot)
  })#end of output$landscape
  
  #PANEL 3, output: plot of bias responsive to selectInput and checkbox group selections
  output$bias <- renderPlot({
    
    req(1 %in% input$performance_metric.3) #only render bias plot if bias (1) is checked
    
    data.3 <- switch(input$characteristic.3,
           " " = NULL,
           "Species prevalence" = prev_fig_df,
           "Effective spatial range" = decay_fig_df,
           "Number of plots" = n_plot_fig_df,
           "Sampling design" = design_fig_df,
           "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3.2 <- data.3[data.3$model %in% input$model_type.3, ]
    
    x.3 <- switch(input$characteristic.3,
                  " " = NULL,
                  "Species prevalence" = factor(data.3.2$prevalence),
                  "Effective spatial range" = data.3.2$sp_range,
                  "Number of plots" = data.3.2$n_plot,
                  "Sampling design" = factor(data.3.2$design),
                  "Number of neighbors (spatial model only)" = data.3.2$neighbors)
    xlabel.3 <- switch(input$characteristic.3,
                    " " = NULL,
                    "Species prevalence" = "Average occupancy probability",
                    "Effective spatial range" = "Effective spatial range",
                    "Number of plots" = "Number of Plots",
                    "Sampling design" = "Sampling Design",
                    "Number of neighbors (spatial model only)" = "Number of Neighbors")
    
    ggplot(data = data.3.2, aes(x = x.3, y = avg_bias, col = model)) + 
      geom_point(position = position_dodge(width = 0.3)) + 
      geom_segment(aes(y = low_bias, yend = high_bias), lineend = "butt", position = position_dodge(width = 0.3)) +
      theme_bw(base_size = 14) +
      theme(legend.position = "none") +
      scale_color_manual(values=c("Spatial" = "#377EB8","Nonspatial" = "#E41A1C" )) + 
      geom_hline(yintercept = 0, linetype = 2, col = "black") + 
      labs(x = xlabel.3, y = "Bias")
     
  }) #end of output$bias
  
  output$bias.table <- renderTable({
    
    data.3 <- switch(input$characteristic.3,
                     " " = NULL,
                     "Species prevalence" = prev_fig_df,
                     "Effective spatial range" = decay_fig_df,
                     "Number of plots" = n_plot_fig_df,
                     "Sampling design" = design_fig_df,
                     "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3T <- data.3[data.3$model %in% input$model_type.3, c(1:5)]
    
    data.3T
    })#end of output$bias.table
  
  #PANEL 3, output: plot of coverage responsive to selectInput and checkbox group selections
  output$coverage <- renderPlot({
    
    req(2 %in% input$performance_metric.3) #only render coverage plot if coverage (2) is checked
    
    data.3 <- switch(input$characteristic.3,
                     " " = NULL,
                     "Species prevalence" = prev_fig_df,
                     "Effective spatial range" = decay_fig_df,
                     "Number of plots" = n_plot_fig_df,
                     "Sampling design" = design_fig_df,
                     "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3.2 <- data.3[data.3$model %in% input$model_type.3, ]
    
    x.3 <- switch(input$characteristic.3,
                  " " = NULL,
                  "Species prevalence" = factor(data.3.2$prevalence),
                  "Effective spatial range" = data.3.2$sp_range,
                  "Number of plots" = data.3.2$n_plot,
                  "Sampling design" = factor(data.3.2$design),
                  "Number of neighbors (spatial model only)" = data.3.2$neighbors)
    xlabel.3 <- switch(input$characteristic.3,
                       " " = NULL,
                       "Species prevalence" = "Average occupancy probability",
                       "Effective spatial range" = "Effective spatial range",
                       "Number of plots" = "Number of Plots",
                       "Sampling design" = "Sampling Design",
                       "Number of neighbors (spatial model only)" = "Number of Neighbors")
    
    ggplot(data = data.3.2, aes(x = x.3, y = avg_coverage, col = model)) + 
      geom_point(position = position_dodge(width = 0.3)) + 
      geom_segment(aes(y = low_coverage, yend = high_coverage), lineend = "butt", position = position_dodge(width = 0.3)) +   
      scale_color_manual(values=c("Spatial" = "#377EB8","Nonspatial" = "#E41A1C" )) + 
      theme_bw(base_size = 14) +
      theme(legend.position = "none") +
      geom_hline(yintercept = 0.95, linetype = 2, col = "black") + 
      labs(x = xlabel.3, y = "Coverage", 
           col = "Model")
  }) #end of output$coverage
  
  output$coverage.table <- renderTable({
    
    data.3 <- switch(input$characteristic.3,
                     " " = NULL,
                     "Species prevalence" = prev_fig_df,
                     "Effective spatial range" = decay_fig_df,
                     "Number of plots" = n_plot_fig_df,
                     "Sampling design" = design_fig_df,
                     "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3T <- data.3[data.3$model %in% input$model_type.3, c(1,2,6,7,8)]
    
    data.3T
  })#end of output$coverage.table
  
  #PANEL 3, output: plot of ci width responsive to selectInput and checkbox group selections
  output$ci_width <- renderPlot({
    
    req(3 %in% input$performance_metric.3) #only render ci width plot if ci width (3) is checked
    
    data.3 <- switch(input$characteristic.3,
                     " " = NULL,
                     "Species prevalence" = prev_fig_df,
                     "Effective spatial range" = decay_fig_df,
                     "Number of plots" = n_plot_fig_df,
                     "Sampling design" = design_fig_df,
                     "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3.2 <- data.3[data.3$model %in% input$model_type.3, ]
    
    x.3 <- switch(input$characteristic.3,
                  " " = NULL,
                  "Species prevalence" = factor(data.3.2$prevalence),
                  "Effective spatial range" = data.3.2$sp_range,
                  "Number of plots" = data.3.2$n_plot,
                  "Sampling design" = factor(data.3.2$design),
                  "Number of neighbors (spatial model only)" = data.3.2$neighbors)
    xlabel.3 <- switch(input$characteristic.3,
                       " " = NULL,
                       "Species prevalence" = "Average occupancy probability",
                       "Effective spatial range" = "Effective spatial range",
                       "Number of plots" = "Number of Plots",
                       "Sampling design" = "Sampling Design",
                       "Number of neighbors (spatial model only)" = "Number of Neighbors")
    
    ggplot(data = data.3.2, aes(x = x.3, y = avg_ci_width, col = model)) + 
      geom_point(position = position_dodge(width=0.3)) + 
      geom_segment(aes(y = low_ci_width, yend = high_ci_width), lineend = "butt", position = position_dodge(width=0.3)) +  
      scale_color_manual(values=c("Spatial" = "#377EB8","Nonspatial" = "#E41A1C" )) + 
      theme_bw(base_size = 14) +
      theme(legend.position = "none") +
      labs(x = xlabel.3, y = "95% CI Width", 
           col = "Model")
  }) #end of output$ci_width
  
  output$ci_width.table <- renderTable({
    
    data.3 <- switch(input$characteristic.3,
                     " " = NULL,
                     "Species prevalence" = prev_fig_df,
                     "Effective spatial range" = decay_fig_df,
                     "Number of plots" = n_plot_fig_df,
                     "Sampling design" = design_fig_df,
                     "Number of neighbors (spatial model only)" = neighbors_fig_df)
    
    data.3T <- data.3[data.3$model %in% input$model_type.3, c(1,2,9,10,11)]
    
    data.3T
  })#end of output$ci_width.table
  
  #PANEL 4, output: dynamic UI checkboxes
  output$levels.4 <- renderUI({
    
    if (input$grouping.4 == " ")
      return()
    
    switch(input$grouping.4,
      
      "Species prevalence" = checkboxGroupInput(
        inputId = "group.options.4", 
        "Select the levels of the color grouping variable you wish to display",
        choices = c(
          "rare (0.15)" = "0.15",
          "common (0.5)" = "0.5"
        )
      ), #end of prevalence checkbox
     
      "Effective spatial range" = checkboxGroupInput(
        inputId = "group.options.4", 
        "Select the levels of the color grouping variable you wish to display",
        choices = c(
          "phi = 3/0.1" = "0.1",
          "phi = 3/0.3" = "0.3",
          "phi = 3/0.5" = "0.5", 
          "phi = 3/0.7" = "0.7",
          "phi = 3/0.9" = "0.9"
        )
      ), #end of spatial decay checkbox 
      
      "Number of plots" = checkboxGroupInput(
        inputId = "group.options.4", 
        "Select the levels of the color grouping variable you wish to display",
        choices = c(
          "50" = "50", 
          "100" = "100",
          "200" = "200",
          "600" = "600"
        )
      ), #end of number of plots checkbox
      
      "Number of neighbors" = checkboxGroupInput(
        inputId = "group.options.4", 
        "Select the levels of the color grouping variable you wish to display",
        choices = c(
          "5" = "5",
          "10" = "10",
          "15" = "15",
          "25" = "25"
        )
      ), #end of neighbors checkbox
      
      "Sampling design" = checkboxGroupInput(
        inputId = "group.options.4", 
        "Select the levels of the color grouping variable you wish to display",
        choices = c(
          "simple random sampling" = "SRS",
          "systematic sampling" = "SYS",
          "horizontal transects" = "HT",
          "vertical transects" = "VT",
          "small arrays" = "SA",
          "large arrays" = "LA",
          "moderate preferential sampling" = "MP",
          "heavy preferential sampling" = "HP"
        )
      ), #end of design checkbox
      
    )#end of dynamic ui switch
    
  }) #end of output$levels.4
  
  #PANEL 4, output: plot and table responsive to selectInput (characteristic), selectInput (performance metric), and checkbox group selections
  output$plot.4 <- renderPlot({
      
      req(!(" " %in% input$characteristic.4)) #require that the user select one of the actual characteristic options to render a plot
      req(!(" " %in% input$performance_metric.4)) #require that the user select one of the actual performance metric options to render a plot
      req(!(" " %in% input$grouping.4)) #require that the user select one of the actual grouping options to render a plot
    
      group.4 <- switch(input$grouping.4,
                        " " = NULL,
                        "Species prevalence" = "prevalence",
                        "Effective spatial range" = "sp_range",
                        "Number of plots" = "n_plot",
                        "Number of neighbors" = "neighbors",
                        "Sampling design" = "design")
      
      xaxis.4 <- switch(input$characteristic.4,
                        " " = NULL,
                        "Species prevalence" = "prevalence",
                        "Effective spatial range" = "sp_range",
                        "Number of plots" = "n_plot",
                        "Number of neighbors" = "neighbors",
                        "Sampling design" = "design")
      
      data.4 <- avg_by_scenario %>%
        group_by(.data[[group.4]], .data[[xaxis.4]]) %>% 
        summarize(bias = mean(bias), coverage = mean(coverage), ci_width = mean(ci_width))
      
      subset.4 <- switch(input$grouping.4,
                         " " = NULL,
                         "Species prevalence" = data.4$prevalence,
                         "Effective spatial range" = data.4$sp_range,
                         "Number of plots" = data.4$n_plot,
                         "Number of neighbors" = data.4$neighbors,
                         "Sampling design" = data.4$design)
      
      data.4 <- data.4[subset.4 %in% input$group.options.4, ]
    
      x.4 <- switch(input$characteristic.4,
                      " " = NULL,
                      "Species prevalence" = data.4$prevalence,
                      "Effective spatial range" = data.4$sp_range,
                      "Number of plots" = data.4$n_plot,
                      "Number of neighbors" = data.4$neighbors,
                      "Sampling design" = data.4$design)
      
      y.4 <- switch(input$performance_metric.4,
                      " " = NULL,
                      "Bias" = data.4$bias,
                      "Coverage" = data.4$coverage,
                      "CI width" = data.4$ci_width)
      
      color.4 <- switch(input$grouping.4,
                        " " = NULL,
                        "Species prevalence" = data.4$prevalence,
                        "Effective spatial range" = data.4$sp_range,
                        "Number of plots" = data.4$n_plot,
                        "Number of neighbors" = data.4$neighbors,
                        "Sampling design" = data.4$design)
      
      xlabel.4 <- switch(input$characteristic.4,
                       " " = NULL,
                       "Species prevalence" = "Average occupancy probability",
                       "Effective spatial range" = "Effective spatial range",
                       "Number of plots" = "Number of plots",
                       "Number of neighbors" = "Number of neighbors",
                       "Sampling design" = "Sampling design")
      
      ylabel.4 <- switch(input$performance_metric.4,
                       " " = NULL,
                       "Bias" = "Bias",
                       "Coverage" = "Coverage",
                       "CI width" = "CI width")
     
       colorlabel.4 <- switch(input$grouping.4,
                        " " = NULL,
                        "Species prevalence" = "Prevalence",
                        "Effective spatial range" = "Spatial Range",
                        "Number of plots" = "# Plots",
                        "Number of neighbors" = "# Neighbors",
                        "Sampling design" = "Design")
      
      yintercept.4 <- switch(input$performance_metric.4,
                       " " = 0,
                       "Bias" = 0,
                       "Coverage" = 0.95,
                       "CI width" = 0)
      
      alpha.4 <- switch(input$performance_metric.4,
                            " " = 0,
                            "Bias" = 1,
                            "Coverage" = 1,
                            "CI width" = 0)
    
      ggplot(data.4, aes(x = x.4, y = y.4, col = color.4, group = color.4)) + 
        geom_line() +
        geom_point() + 
        geom_hline(yintercept = yintercept.4, linetype = 2, col = "black", alpha = 1) + 
        theme_bw(base_size = 18) + 
        scale_color_colorblind() + 
        labs(x = xlabel.4, y = ylabel.4, color = colorlabel.4)
      
    
  }) #end of output$plot.4
  
  output$table.4 <- renderTable({
    group.4 <- switch(input$grouping.4,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    xaxis.4 <- switch(input$characteristic.4,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    data.4 <- avg_by_scenario %>%
      group_by(.data[[group.4]], .data[[xaxis.4]]) %>% 
      summarize(bias = mean(bias), coverage = mean(coverage), ci_width = mean(ci_width))
    
    subset.4T <- switch(input$performance_metric.4,
                       " " = 1,
                       "Bias" = c(1:3),
                       "Coverage" = c(1,2,4),
                       "CI width" = c(1,2,5))
    
    data.4T <- data.4[ , subset.4T]
    
    data.4T
    
  }) #end of output$table.4
  
  #PANEL 5, output: dynamic UI checkboxes
  output$levels.5 <- renderUI({
    
    if (input$grouping.5 == " ")
      return()
    
    switch(input$grouping.5,
           
           "Species prevalence" = checkboxGroupInput(
             inputId = "group.options.5", 
             "Select the levels of the color grouping variable you wish to display, you must select at least one level to display the matrix",
             choices = c(
               "rare (0.15)" = "0.15",
               "common (0.5)" = "0.5"
             )
           ), #end of prevalence checkbox
           
           "Effective spatial range" = checkboxGroupInput(
             inputId = "group.options.5", 
             "Select the levels of the color grouping variable you wish to display, you must select at least one level to display the matrix",
             choices = c(
               "phi = 3/0.1" = "0.1",
               "phi = 3/0.3" = "0.3",
               "phi = 3/0.5" = "0.5", 
               "phi = 3/0.7" = "0.7",
               "phi = 3/0.9" = "0.9"
             )
           ), #end of spatial decay checkbox 
           
           "Number of plots" = checkboxGroupInput(
             inputId = "group.options.5", 
             "Select the levels of the color grouping variable you wish to display, you must select at least one level to display the matrix",
             choices = c(
               "50" = "50", 
               "100" = "100",
               "200" = "200",
               "600" = "600"
             )
           ), #end of number of plots checkbox
           
           "Number of neighbors" = checkboxGroupInput(
             inputId = "group.options.5", 
             "Select the levels of the color grouping variable you wish to display, you must select at least one level to display the matrix",
             choices = c(
               "5" = "5",
               "10" = "10",
               "15" = "15",
               "25" = "25"
             )
           ), #end of neighbors checkbox
           
           "Sampling design" = checkboxGroupInput(
             inputId = "group.options.5", 
             "Select the levels of the color grouping variable you wish to display, you must select at least one level to display the matrix",
             choices = c(
               "simple random sampling" = "SRS",
               "systematic sampling" = "SYS",
               "horizontal transects" = "HT",
               "vertical transects" = "VT",
               "small arrays" = "SA",
               "large arrays" = "LA",
               "moderate preferential sampling" = "MP",
               "heavy preferential sampling" = "HP"
             )
           ), #end of design checkbox
           
    )#end of dynamic ui switch
  }) #end of output$levels.5
  
  #PANEL 5, output: plot and table responsive to selectInput (characteristic), selectInput (performance metric), checkbox group selections, and selectInput (facet plot grouping)
  output$plot.5 <- renderPlot({
    
    req(!(" " %in% input$characteristic.5)) #require that the user select one of the actual characteristic options to render a plot
    req(!(" " %in% input$performance_metric.5)) #require that the user select one of the actual performance metric options to render a plot
    req(!(" " %in% input$grouping.5)) #require that the user select one of the actual grouping options to render a plot
    req(!(" " %in% input$facet.5)) #require that the user select one of the actual grouping options to render a plot
    
    group.5 <- switch(input$grouping.5,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    xaxis.5 <- switch(input$characteristic.5,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    facetgroup.5 <- switch(input$facet.5,
                           " " = NULL,
                           "Species prevalence" = "prevalence",
                           "Effective spatial range" = "sp_range",
                           "Number of plots" = "n_plot",
                           "Number of neighbors" = "neighbors",
                           "Sampling design" = "design")
    
    data.5 <- avg_by_scenario %>%
      group_by(.data[[group.5]], .data[[xaxis.5]], .data[[facetgroup.5]]) %>% 
      summarize(bias = mean(bias), coverage = mean(coverage), ci_width = mean(ci_width))
    
    subset.5 <- switch(input$grouping.5,
                       " " = NULL,
                       "Species prevalence" = data.5$prevalence,
                       "Effective spatial range" = data.5$sp_range,
                       "Number of plots" = data.5$n_plot,
                       "Number of neighbors" = data.5$neighbors,
                       "Sampling design" = data.5$design)
    
    data.5 <- data.5[subset.5 %in% input$group.options.5, ]
    
    x.5 <- switch(input$characteristic.5,
                  " " = NULL,
                  "Species prevalence" = data.5$prevalence,
                  "Effective spatial range" = data.5$sp_range,
                  "Number of plots" = data.5$n_plot,
                  "Number of neighbors" = data.5$neighbors,
                  "Sampling design" = data.5$design)
    
    y.5 <- switch(input$performance_metric.5,
                  " " = NULL,
                  "Bias" = data.5$bias,
                  "Coverage" = data.5$coverage,
                  "CI width" = data.5$ci_width)
    
    color.5 <- switch(input$grouping.5,
                      " " = NULL,
                      "Species prevalence" = data.5$prevalence,
                      "Effective spatial range" = data.5$sp_range,
                      "Number of plots" = data.5$n_plot,
                      "Number of neighbors" = data.5$neighbors,
                      "Sampling design" = data.5$design)
    
    xlabel.5 <- switch(input$characteristic.5,
                       " " = NULL,
                       "Species prevalence" = "Average occupancy probability",
                       "Effective spatial range" = "Effective spatial range",
                       "Number of plots" = "Number of plots",
                       "Number of neighbors" = "Number of neighbors",
                       "Sampling design" = "Sampling design")
    
    ylabel.5 <- switch(input$performance_metric.5,
                       " " = NULL,
                       "Bias" = "Bias",
                       "Coverage" = "Coverage",
                       "CI width" = "CI width")
    
    colorlabel.5 <- switch(input$grouping.5,
                           " " = NULL,
                           "Species prevalence" = "Prevalence",
                           "Effective spatial range" = "Spatial range",
                           "Number of plots" = "# Plots",
                           "Number of neighbors" = "# Neighbors",
                           "Sampling design" = "Design")
    
    yintercept.5 <- switch(input$performance_metric.5,
                           " " = 0,
                           "Bias" = 0,
                           "Coverage" = 0.95,
                           "CI width" = 0)
    
    alpha.5 <- switch(input$performance_metric.5,
                      " " = 0,
                      "Bias" = 1,
                      "Coverage" = 1,
                      "CI width" = 0)
    
    base.plot.5 <- ggplot(data.5, aes(x = x.5, y = y.5, col = color.5, group = color.5)) + 
      geom_line() +
      geom_point() + 
      geom_hline(yintercept = yintercept.5, linetype = 2, col = "black", alpha = alpha.5) + 
      theme_bw(base_size = 14) + 
      scale_color_colorblind() + 
      labs(x = xlabel.5, y = ylabel.5, color = colorlabel.5)
  
    vars.5 <- switch(input$facet.5,
                     " " = NULL,
                     "Species prevalence" = data.5$prevalence,
                     "Effective spatial range" = data.5$sp_range,
                     "Number of plots" = data.5$n_plot,
                     "Number of neighbors" = data.5$neighbors,
                     "Sampling design" = data.5$design)
    
    base.plot.5 + facet_grid(vars(.data[[facetgroup.5]])) 
    
    
  }) #end of output$plot.5
  
  output$table.5 <- renderTable({
    group.5 <- switch(input$grouping.5,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    xaxis.5 <- switch(input$characteristic.5,
                      " " = NULL,
                      "Species prevalence" = "prevalence",
                      "Effective spatial range" = "sp_range",
                      "Number of plots" = "n_plot",
                      "Number of neighbors" = "neighbors",
                      "Sampling design" = "design")
    
    facetgroup.5 <- switch(input$facet.5,
                           " " = NULL,
                           "Species prevalence" = "prevalence",
                           "Effective spatial range" = "sp_range",
                           "Number of plots" = "n_plot",
                           "Number of neighbors" = "neighbors",
                           "Sampling design" = "design"
    )
    
    data.5 <- avg_by_scenario %>%
      group_by(.data[[group.5]], .data[[xaxis.5]], .data[[facetgroup.5]]) %>% 
      summarize(bias = mean(bias), coverage = mean(coverage), ci_width = mean(ci_width))
    
    subset.5T <- switch(input$performance_metric.5,
                        " " = 1,
                        "Bias" = c(1:4),
                        "Coverage" = c(1,2,3,5),
                        "CI width" = c(1,2,3,6))
    
    data.5T <- data.5[ , subset.5T]
    
    data.5T
    
  }) #end of output$table.5
  
  } #end of server


#run the app -------------------------------------------------------------------
shinyApp(ui = ui, server = server)
