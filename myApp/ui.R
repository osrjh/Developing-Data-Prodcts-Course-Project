library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Developing Data Products Course Project"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h2("Parameters"),
      h3("Variables:"),
      h6("1.  mpg	  Miles/(US) gallon"),
      #      h6("2.  cyl	  Number of cylinders"),
      h6("2.  disp  Displacement (cu.in.)"),
      h6("3.  hp	  Gross horsepower"),
      h6("4.  drat  Rear axle ratio"),
      h6("5.  wt	  Weight (1000 lbs)"),
      h6("6.  qsec  1/4 mile time"),
      #      h6("7.  vs	  Engine (0 = V-shaped, 1 = straight)"),
      #      h6("9.  am	  Transmission (0 = automatic, 1 = manual)"),
      #      h6("10. gear  Number of forward gears"),
      #      h6("11. carb  Number of carburetors"),
      selectInput("variable", "Variable:", c(#"Cylinders" = "cyl",
        "Displacement" = "disp",
        "Horse Power" = "hp", 
        "Rear Axle Ratio" = "drat",
        "Weight" = "wt",
        "Quarter Mile Time" = "qsec"),
        #"Engine Type" = "vs",
        #"Transmission" = "am",
        #"No. Forward Gears" = "gear",
        #"No. Carburetors" = "carb"),
        selected = "disp"),
      selectInput("fillvariable", "Fill:", c(#"Cylinders" = "cyl",
        "Displacement" = "disp",
        "Horse Power" = "hp", 
        "Rear Axle Ratio" = "drat",
        "Weight" = "wt",
        "Quarter Mile Time" = "qsec"),
        #"Engine Type" = "vs",
        #"Transmission" = "am",
        #"No. Forward Gears" = "gear",
        #"No. Carburetors" = "carb"),
        selected = "disp"),
      checkboxInput("show_xlab", "Show/Hide X Axis Label", value= TRUE),
      checkboxInput("show_ylab", "Show/Hide Y Axis Label", value= TRUE),
      checkboxInput("show_title", "Show/Hide Title", value = TRUE),
      #submitButton("Done"),
      uiOutput("conditional_comment"),
      uiOutput("conditional_comment2"),
      uiOutput("conditional_comment3"),
      uiOutput("conditional_comment4"),
      uiOutput("conditional_comment5"),
      h5("Slope"),
      textOutput("slopeOut"),
      h5("Intercept"),
      textOutput("intOut"),
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h1("Miles Per Gallon Simple Linear Regression Model"),
      h5("This is a basic app which will showcase a simple prediction algorithm. We will generate simple linear models using a set of factor variables and miles per gallon (MPG) in the mtcars dataset."),
      h3("Instructions"),
      h5("On the side panel you can select the variables & parameters for the modelling and data visualisation. In order to build a simple linear model, highlight a group of / all points on the plot. Move the slider along to generate predictions for different independent variable quantities."),
      em("When changing the selected variable please change it to a different variable before switching to your desired variable. e.g. if the current variable is disp and you are intending to change it to wt - change it to qsec before changing it to wt. This is to ensure that the change in variable is properly registered by the slider."),
      h3("Scatterplot"),
      plotOutput("plot1",brush = brushOpts(id="brush1")),
      h3("Predicted MPG from Simple Linear Model:"),
      textOutput("pred1"),
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      )
    )
  )
)
)