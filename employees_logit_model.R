setwd("G:\\Desktop\\R\\HomeWork\\DS-3")
why = read.csv("HR_comma_sep.csv")
str(why)
summary(why)
install.packages("caTools")
library(caTools)
install.packages("ROCR")
library(ROCR)
library(googleVis)
library(ggplot2)
library(caret)
library(gbm)
library(MASS)
library(rpart.plot)

boxplot(satisfaction_level ~ left, data = why, xlab = "Satisfaction level",
        ylab = "Left", cex.lab = 1.2, main = "How Satisfaction level affects on Leaving", 
        col = c("green","red"))


boxplot(last_evaluation ~ left, data = why, xlab = "Last evaluation",
        ylab = "Left", cex.lab = 1.2, main = "How Last evaluation affects on Leaving", 
        col = c("green","red"))


boxplot(number_project ~ left, data = why, xlab = "Number of projects",
        ylab = "Left", cex.lab = 1.2, main = "How Number of projects affects on Leaving", 
        col = c("green","red"))


boxplot(average_montly_hours ~ left, data = why, xlab = "Average montly hours",
        ylab = "Left", cex.lab = 1.2, main = "How Average montly hours affects on Leaving", 
        col = c("green","red"))

boxplot(time_spend_company ~ left, data = why, xlab = "Time spend in company",
        ylab = "Left", cex.lab = 1.2, main = "How Time spend in company affects on Leaving", 
        col = c("green","red"))


leave = glm(left ~ satisfaction_level + last_evaluation 
            + number_project + average_montly_hours + time_spend_company 
            + Work_accident + promotion_last_5years + salary, 
            data = why, family=binomial)
summary(leave)

set.seed(88)
split = sample.split(why$left, SplitRatio = 0.75)
split

Test = subset(why, split == FALSE)
Train = subset(why, split == TRUE)

leave = glm(left ~ satisfaction_level + last_evaluation 
            + number_project + average_montly_hours + time_spend_company 
            + Work_accident + promotion_last_5years + salary, 
            data = Train, family=binomial)
summary(leave)

TrainPredict = predict(leave, type="response")
TrainPrediction = prediction(TrainPredict, Train$left)
TrainPerf = performance(TrainPrediction, "tpr", "fpr")

plot(TrainPerf, colorize=TRUE, 
     print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

TestPredict = predict(leave, newdata = Test, type="response")

t = table(Test$left, TestPredict>0.431)
t
(t[1,1]+t[2,2])/sum(t)

library(randomForest)
Train$left = as.factor(Train$left)
Test$left = as.factor(Test$left)
mod_RF <- randomForest(left ~ ., data = Train)
plot(mod_RF, main = "Model 3")
pred_RF <- predict(mod_RF, Test, type="response")
pred_RF
confusionMatrix(pred_RF, Test$left)
l = fitted.values(leave)
l[8485]
which.max(fitted.values(leave))
