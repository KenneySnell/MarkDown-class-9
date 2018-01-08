#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# DUR_server.R
# Predict Old Faithful Eruption duration
library(shiny)
library(caret)

data("faithful")
set.seed(333)
inTrain <- createDataPartition(y=faithful$waiting,
                               p=0.7, list=FALSE)
trainFaith <- faithful[inTrain,]
testFaith <- faithful[-inTrain,]



shinyServer(function(input, output) {
#  mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg - 20, 0)
  eruption.lm1 <- lm(eruptions ~ waiting, data=trainFaith)
  
  
  model1 <- eruption.lm1
  eruption.lm2 <- train(eruptions ~ waiting,data=trainFaith,method="rlm")
  model2 <- eruption.lm2
  
  model1pred <- reactive({
    DURInput <- input$sliderDUR
    predict(model1, newdata = data.frame(waiting = DURInput))
  })
  
  model2pred <- reactive({
    DURInput <- input$sliderDUR
    predict(model2, newdata = 
              data.frame(waiting = DURInput))
  })
  
  output$plot1 <- renderPlot({
    DURInput <- input$sliderDUR
    
    plot(testFaith$waiting,testFaith$eruptions,ylab = "Eruption Duration (min)", xlab = "Waiting Time (min)"
         ,col = "blue", main = "Predict Old Faithful Eruption - Testing (LM)")
    lines(testFaith$waiting,pred1 <- predict(eruption.lm1,newdata = testFaith),lwd=1,col="red")
    abline(mC <- lm(eruptions ~ 1, data = testFaith))
    
    newdata <- data.frame(waiting = DURInput) #wrap the parameter 
    #Then we apply the predict function to eruption.lm along with newdata. 
    duration1a <- predict(eruption.lm1,newdata) #apply predict
    
    
    
    if(input$showModel1){
      abline(model1, col = "red", lwd = 2)
      lines(testFaith$waiting,pred1 <- predict(model1,newdata = testFaith),lwd=1,col="red")
    }
    if(input$showModel2){
      
      lines(testFaith$waiting,pred2 <- predict(model2,newdata = testFaith),lwd=1,col="black")
      
    }
    legend("bottom" , c("Model 1 Prediction - LM", "Model 2 Prediction ML (rlm)"), pch = 16, 
           col = c("red", "blue"), bty = "n", cex = 1.2)
    points(DURInput, model1pred(), col = "red", pch = 12, cex = 2)
    points(DURInput, model2pred(), col = "blue", pch = 16, cex = 2)
  })
  
  output$pred1 <- renderText({
    model1pred()
  })
  
  output$pred2 <- renderText({
    model2pred()
  })
})




