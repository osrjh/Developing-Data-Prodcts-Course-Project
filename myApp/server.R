library(shiny)
library(ggplot2)
library(dplyr)
library(datasets)

# Define server logic required to draw a boxplot
shinyServer(function(input, output) {
  
  output$plot1 <- renderPlot({
    
    # prepare mtcars dataset
    mtcars %>%
      mutate(am = ifelse(am == 0, "automatic",
                         ifelse(am == 1, "manual", am)),
             vs = ifelse(am == 0, "v-shaped",
                         ifelse(am == 1, "straight", vs)),
             am = factor(am),
             vs = factor(vs),
             gear = factor(gear),
             carb = factor(carb),
             cyl = factor(cyl)) -> data_c
    
    xlab <- ifelse(input$show_xlab, paste0(input$variable), "")
    ylab <- ifelse(input$show_ylab, "Miles per US Gallon", "")
    main <- ifelse(input$show_title, paste0("Fuel Consumption by Transmission type", input$variable), "") 
    
    # draw the boxplot with the specified parameters
    if(input$variable %in% c("cyl", "vs","am", "gear", "carb")) {
      if(input$fillvariable %in% c("cyl", "vs","am", "gear", "carb")) {
        data_c %>%
          ggplot(aes_string(x = input$variable, y = "mpg")) +
          geom_point(aes_string(col = input$fillvariable), size = 3) +
          labs(x = xlab,
               y = ylab,
               title = main) +
          theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
          scale_color_manual(values = c("#1D8CAB", "#E13A3E","#F5CB39", "#FF9900","#25D366","#833AB4"))}
      else {data_c %>%
          ggplot(aes_string(x = input$variable, y = "mpg")) +
          geom_point(aes_string(col = input$fillvariable), size = 3) +
          labs(x = xlab,
               y = ylab,
               title = main) +
          theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
          scale_colour_gradient(low = "#1D8CAB", high = "#E13A3E")}}
    
    else {
      
      model <- reactive({
        brushed_data <- brushedPoints(data_c, input$brush1,
                                      xvar = paste0(input$variable), yvar = "mpg")
        if(nrow(brushed_data) < 2) {
          return(NULL)
        }
        
        brushed_data %>%
          select(mpg, input$variable) -> brushed_data
        
        lm(mpg ~ ., data = brushed_data)
      })
      
      output$slopeOut <- renderText({
        if(is.null(model())){
          "No Model Found"
        } else {
          model()[[1]][2]
        }
      })
      output$intOut <- renderText({
        if(is.null(model())){
          "No Model Found"
        }
        else {
          model()[[1]][1]
        }
      })
      
      output$pred1 <- reactive({
        sum(model()[[1]][2] * input$slider, model()[[1]][])
      })
      
      if(input$fillvariable %in% c("cyl", "vs","am", "gear", "carb")) {
        
        data_c %>%
          ggplot(aes_string(x = input$variable, y = "mpg")) +
          geom_point(aes_string(col = input$fillvariable), size = 3) +
          labs(x = xlab,
               y = ylab,
               title = main) +
          theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
          scale_color_manual(values = c("#1D8CAB", "#E13A3E","#F5CB39", "#FF9900","#25D366","#833AB4")) +
          if(!is.null(model())){geom_abline(intercept = model()[[1]][1], slope = model()[[1]][2], col = "#833AB4", lwd = 0.8)} 
      }
      
      else{data_c %>%
          ggplot(aes_string(x = input$variable, y = "mpg")) +
          geom_point(aes_string(col = input$fillvariable), size = 3) +
          labs(x = xlab,
               y = ylab,
               title = main) +
          theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
          scale_colour_gradient(low = "#1D8CAB", high = "#E13A3E") + 
          geom_point(aes(x=input$slider,y=sum(input$slider*model()[[1]][2],model()[[1]][1])), colour="833AB4", size = 4) +
          if(!is.null(model())){geom_abline(intercept = model()[[1]][1], slope = model()[[1]][2], col = "#833AB4", lwd = 0.8)} 
      }
    }
  })
  
  output$conditional_comment <- renderUI({
    req(input$variable == "disp")
    sliderInput("slider", "What is the engine displacement of the car?", 
                70, 480, value = 70)
  })
  
  output$conditional_comment2 <- renderUI({
    req(input$variable == "hp")
    sliderInput("slider", "What is the horse power of the car?",
                50, 335, value = 50)
  })
  
  output$conditional_comment3 <- renderUI({
    req(input$variable == "drat")
    sliderInput("slider", "What is the rear axle ratio of the car?",
                2.5, 5, value = 2.5)
  })
  
  output$conditional_comment4 <- renderUI({
    req(input$variable == "wt")
    sliderInput("slider", "What is the weight of the car?",
                1.5, 5.5, value = 1.5)
  })
    
  output$conditional_comment5 <- renderUI({
    req(input$variable == "qsec")
    sliderInput("slider", "What is the 1/4 mile time of the car??",
                14.5, 23, value = 14.5)
  })
  
})