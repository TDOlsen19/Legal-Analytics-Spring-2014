  > #Load packages
  > library(caret)
Loading required package: lattice
Loading required package: ggplot2
> library(corrplot)
> library(doSNOW)

> registerDoSNOW(makeCluster(3, type= "SOCK"))

  > corrplot(cor(wine[, -c(13,15)]), method = "number", tl.cex = 0.5)
Error in is.data.frame(x) : object 'wine' not found
> wine <- read.csv("http://www.nd.edu/~mclark19/learn/data/goodwine.csv")
> 
  > corrplot(cor(wine[, -c(13,15)]), method = "number", tl.cex = 0.5)
> 
  > set.seed(1234) #so that the indices will be the same when re-run
> trainIndices = createDataPartition(wine$good, p = 0.8, list = F)
> wanted = !colnames(wine) %in% c("free.sulfur.dioxide", "density", "quality", "color", "white")
> wine_train = wine[trainIndices, wanted] #remove quality and color, as well as density and others
> wine_test = wine[-trainIndices, wanted]
> 
  > wine_trainplot = predict(preProcess(wine_train[,-10], method="range"), wine_train[,-10])
> featurePlot(wine_trainplot, wine_train$good, "box")
> 
  > set.seed(1234)
> cv_opts = trainControl(method="cv", number=10)
> knn_opts = data.frame(.k=c(seq(3, 11, 2), 25, 51, 101)) #odd to avoid ties

> results_knn = train(good~., data=wine_train, method="knn", preProcess="range", trControl=cv_opts, tuneGrid = knn_opts)
> results_knn
k-Nearest Neighbors 

5199 samples
9 predictors
2 classes: 'Bad', 'Good' 

Pre-processing: re-scaling to [0, 1] 
Resampling: Cross-Validated (10 fold) 

Summary of sample sizes: 4679, 4680, 4680, 4679, 4679, 4678, ... 

Resampling results across tuning parameters:
  
  k    Accuracy  Kappa  Accuracy SD  Kappa SD
3    0.751     0.455  0.0158       0.0366  
5    0.75      0.449  0.0186       0.0445  
7    0.748     0.444  0.0176       0.0421  
9    0.751     0.448  0.0185       0.0427  
11   0.751     0.45   0.0175       0.0409  
25   0.753     0.45   0.0196       0.0471  
51   0.745     0.429  0.0176       0.0412  
101  0.743     0.42   0.0128       0.033   

Accuracy was used to select the optimal model using
the largest value.
The final value used for the model was k = 25. 
> 
  > preds_knn = predict(results_knn, wine_test[,-10])
> confusionMatrix(preds_knn, wine_test[,10], positive='Good')
Confusion Matrix and Statistics

Reference
Prediction Bad Good
Bad  281  130
Good 195  692

Accuracy : 0.7496         
95% CI : (0.7251, 0.773)
No Information Rate : 0.6333         
P-Value [Acc > NIR] : < 2.2e-16      

Kappa : 0.445          
Mcnemar's Test P-Value : 0.0003851      

Sensitivity : 0.8418         
Specificity : 0.5903         
Pos Pred Value : 0.7802         
Neg Pred Value : 0.6837         
Prevalence : 0.6333         
Detection Rate : 0.5331         
Detection Prevalence : 0.6834         
Balanced Accuracy : 0.7161         

'Positive' Class : Good           
