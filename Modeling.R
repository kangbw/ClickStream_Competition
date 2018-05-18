
######################### modeling ##########################

library(caret)
intrain <- createDataPartition(data_pre$GENDER,p=0.8)[[1]]

training <- data_pre[intrain,]
testing <- data_pre[-intrain,]

str(training)

model_logis <- train(GENDER~., data=training, method='LogitBoost')
predictions <- predict(model_logis, testing) 
c1 <- confusionMatrix(testing$GENDER, predictions)
c1 # 65.13%

model_pca_logis <- train(GENDER~., data=training, preProcess='pca',
                         method='LogitBoost', trControl= trainControl(preProcOptions =
                                                                        list(thresh = 0.8)))
predictions2 <- predict(model_pca_logis, testing)
c2 <- confusionMatrix(testing$GENDER, predictions2)
c2 #62.53%

model_svm <- train(GENDER~., data=training, method='svmRadialSigma')
predictions3 <- predict(model_svm, testing)
c3 <- confusionMatrix(testing$GENDER, predictions3)
c3 #68.34%

real_pre_modelsvm <- predict(model_svm, agg_TR_tested)
head(real_pre_modelsvm)
agg_TR_tested$GENDER <- real_pre_modelsvm
Result <- agg_TR_tested[,c(1,52)]
write.csv(Result, file='103_강병욱.csv')

model_svm2 <- train(GENDER~., data=training, method='svmRadialSigma',
                    preProcess='pca', trControl= trainControl(preProcOptions =
                                                                list(thresh = 0.8)))
predictions4 <- predict(model_svm2, testing)
c4 <- confusionMatrix(testing$GENDER, predictions4)
c4 #67.13

model_C50Tree <- train(GENDER~., data=training, method='C5.0')
prediction5 <- predict(model_C50Tree, testing)
c5 <- confusionMatrix(testing$GENDER,prediction5)
c5 #68.14

model_svmln <- train(GENDER~., data=training, method='svmLinear')
prediction6 <- predict(model_svmln, testing)
c6 <- confusionMatrix(prediction6, testing$GENDER)
c6 # 65.73%

str(agg_TR_tested)

model_svmpoly <- train(GENDER~., data=training, method='svmPoly')
prediction7 <- predict(model_svmpoly, testing)
c7 <- confusionMatrix(prediction7, testing$GENDER)
c7 #65.93