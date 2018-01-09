Old Faithlful Prediction Application
========================================================
author: 
date: 
autosize: true
Description

This Shiny Application predicts the duration (minutes) of the next eruption of Old Faithful.
Use the slider to enter the waiting time (minutes) between eruptions.  The applicaiton uses linear regression and machine learning to predict the duration of next eruption.

Inputs:
- Duration time since the last eruption
- Display Method 1 - Uses Linear Regression
- Display Method 2 - Uses the caret(train) Machine Learning method rlm (robust linear model)

Outputs
- Graph showing the fitted line for both methods and the predicted point on the line.
- pred1: Prediction (minutes) for the next eruption using method 1.
- pred2: Prediction (minutes) for the next eruption using method 2.

Data Description (faithful)
Waiting time between eruptions and the duration of the eruption for the Old Faithful geyser in Yellowstone National Park, Wyoming, USA.


A data frame with 272 observations on 2 variables.
[,1]	 eruptions	 numeric	 Eruption time in mins
[,2]	 waiting	 numeric	 Waiting time to next eruption (in mins)

========================================================


```r
library(caret)
library(klaR)
data("faithful")
inTrain <- createDataPartition(y=faithful$waiting,
                               p=0.7, list=FALSE)
trainFaith <- faithful[inTrain,]
testFaith <- faithful[-inTrain,]
summary(testFaith)
```

```
   eruptions        waiting     
 Min.   :1.667   Min.   :45.00  
 1st Qu.:2.096   1st Qu.:58.00  
 Median :3.833   Median :76.00  
 Mean   :3.411   Mean   :70.88  
 3rd Qu.:4.463   3rd Qu.:82.00  
 Max.   :5.033   Max.   :91.00  
```




```r
# Training (LM)
eruption.lm1 <- lm(eruptions ~ waiting, data=trainFaith)
plot(trainFaith$waiting,trainFaith$eruptions,ylab = "Eruption Duration (min)", xlab = "Waiting Time (min)"
     ,col = "blue", main = "Predict Old Faithful Duration - Training (LM)")
abline( eruption.lm1, col = "black",lwd=1)
abline(mC <- lm(eruptions ~ 1, data = trainFaith))
```

<img src="Old_Failful_Predict-figure/linear_reg_Training-1.png" title="plot of chunk linear_reg_Training" alt="plot of chunk linear_reg_Training" width="1000px" height="1000px" />

========================================================


```r
# Testing (LM)
plot(testFaith$waiting,testFaith$eruptions,ylab = "Eruption Duration (min)", xlab = "Waiting Time (min)"
     ,col = "blue", main = "Predict Old Faithful Eruption - Testing (LM)")
lines(testFaith$waiting,pred1 <- predict(eruption.lm1,newdata = testFaith),lwd=1,col="red")
abline(mC <- lm(eruptions ~ 1, data = testFaith))
waiting <- 80
newdata <- data.frame(waiting = 80) #wrap the parameter 
coeffs <- coefficients(eruption.lm1)
duration1 <- coeffs[1] + coeffs[2]*waiting
points(waiting,duration1, col = "green", pch = 16, cex = 2)
```

<img src="Old_Failful_Predict-figure/linear_reg_Test-1.png" title="plot of chunk linear_reg_Test" alt="plot of chunk linear_reg_Test" width="1000px" height="1000px" />

```r
pred1 <- duration1
pred1
```

```
(Intercept) 
   4.204458 
```

==========================================================


```r
#Training - ML

eruption.lm2 <- train(eruptions ~ waiting,data=trainFaith,method="rlm")

plot(trainFaith$waiting,trainFaith$eruptions,ylab = "Eruption Duration (min)", xlab = "Waiting Time (min)"
     ,col = "blue", main = "Predict Old Faithful Eruption - Training (ML)")
lines(trainFaith$waiting,predict(eruption.lm2),lwd=1)
abline(mC <- rlm(eruptions ~ 1, data = trainFaith))
```

<img src="Old_Failful_Predict-figure/Train-1.png" title="plot of chunk Train" alt="plot of chunk Train" width="1000px" height="1000px" />

===================================================


```r
# Testing - ML
plot(testFaith$waiting,testFaith$eruptions,ylab = "Eruption Duration (min)", xlab = "Waiting Time (min)"
     ,col = "blue", main = "Predict Old Faithful Eruption - Testing (ML)")
lines(testFaith$waiting,pred2 <- predict(eruption.lm2,newdata = testFaith),lwd=2,col="black")
abline(mC <- lm(eruptions ~ 1, data = testFaith))

newdata <- data.frame(waiting = 80) #wrap the parameter 
#Then we apply the predict function to eruption.lm along with newdata. 
duration2 <- predict(eruption.lm2,newdata) #apply predict
points(waiting,duration2, col = "green", pch = 16, cex = 2)
```

<img src="Old_Failful_Predict-figure/Test_ML-1.png" title="plot of chunk Test_ML" alt="plot of chunk Test_ML" width="1000px" height="1000px" />

```r
pred2 <- duration2
pred2
```

```
       1 
4.210415 
```
