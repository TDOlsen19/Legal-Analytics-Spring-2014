> library(randomForest)
randomForest 4.6-7
Type rfNews() to see new features/changes/bug fixes.
Warning message:
  package 'randomForest' was built under R version 3.0.3 
> library(party)
Loading required package: grid
Loading required package: zoo

Attaching package: 'zoo'

The following objects are masked from 'package:base':
  
  as.Date, as.Date.numeric

Loading required package: sandwich
Loading required package: strucchange
Loading required package: modeltools
Loading required package: stats4
Warning messages:
  1: package 'party' was built under R version 3.0.3 
2: package 'zoo' was built under R version 3.0.3 
3: package 'sandwich' was built under R version 3.0.3 
4: package 'strucchange' was built under R version 3.0.3 
> load(url("http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic3.sav"))
> dim(titanic3)
[1] 1309   14
> attributes(titanic3)

> titanic3[1:5, ]
pclass survived                            name    sex
1    1st        1   Allen, Miss. Elisabeth Walton female
2    1st        1  Allison, Master. Hudson Trevor   male
3    1st        0    Allison, Miss. Helen Loraine female
4    1st        0 Allison, Mr. Hudson Joshua Crei   male
5    1st        0 Allison, Mrs. Hudson J C (Bessi female
                                            age sibsp parch ticket     fare   cabin    embarked
                                            1 29.0000     0     0  24160 211.3375      B5 Southampton
                                            2  0.9167     1     2 113781 151.5500 C22 C26 Southampton
                                            3  2.0000     1     2 113781 151.5500 C22 C26 Southampton
                                            4 30.0000     1     2 113781 151.5500 C22 C26 Southampton
                                            5 25.0000     1     2 113781 151.5500 C22 C26 Southampton
                                            boat body                       home.dest
                                            1    2   NA                    St Louis, MO
                                            2   11   NA Montreal, PQ / Chesterville, ON
                                            3        NA Montreal, PQ / Chesterville, ON
                                            4       135 Montreal, PQ / Chesterville, ON
                                            5        NA Montreal, PQ / Chesterville, ON
                                            > set.seed(1234)
                                            > ind <- sample(2, nrow(titanic3), replace=TRUE, prob=c(0.50, 0.50))
                                            > titanic.train <- titanic3[ind==1]
                                            Error in `[.data.frame`(titanic3, ind == 1) : undefined columns selected
                                            > titanic.train <- titanic3[ind==1,]
                                            > titanic.test <- titanic3[ind==2, ]
                                            > 
                                              > titanic.survival.train = glm(survived ~ pclass + sex +pclass:sex + age + sibsp, family = binomial(logit), data = titanic.train)
                                            > summary(titanic.survival.train)
                                            
                                            Call:
                                              glm(formula = survived ~ pclass + sex + pclass:sex + age + sibsp, 
                                                  family = binomial(logit), data = titanic.train)
                                            
                                            Deviance Residuals: 
                                              Min       1Q   Median       3Q      Max  
                                            -3.1909  -0.6174  -0.4401   0.4189   2.3564  
                                            
                                            Coefficients:
                                              Estimate Std. Error z value Pr(>|z|)
                                            (Intercept)        5.43907    0.88464   6.148 7.83e-10
                                            pclass2nd         -2.17403    0.84839  -2.563  0.01039
                                            pclass3rd         -4.07038    0.79710  -5.107 3.28e-07
                                            sexmale           -4.45588    0.77614  -5.741 9.41e-09
                                            age               -0.04379    0.01046  -4.188 2.82e-05
                                            sibsp             -0.26690    0.14665  -1.820  0.06877
                                            pclass2nd:sexmale  0.66065    0.92499   0.714  0.47509
                                            pclass3rd:sexmale  2.44578    0.84068   2.909  0.00362
                                            
                                            (Intercept)       ***
                                              pclass2nd         *  
                                              pclass3rd         ***
                                              sexmale           ***
                                              age               ***
                                              sibsp             .  
                                            pclass2nd:sexmale    
                                            pclass3rd:sexmale ** 
                                              ---
                                              Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                            
                                            (Dispersion parameter for binomial family taken to be 1)
                                            
                                            Null deviance: 721.33  on 536  degrees of freedom
                                            Residual deviance: 447.44  on 529  degrees of freedom
                                            (125 observations deleted due to missingness)
                                            AIC: 463.44
                                            
                                            Number of Fisher Scoring iterations: 6
                                            
                                            > # Random Forests
                                              > 
                                              > titanic.survival.train.rf = randomForest(as.factor(survived) ~ pclass + sex + age +sibsp, data = titanic.train, ntree = 5000, importance = TRUE, na.action = na.omit)
                                            > titanic.survival.train.rf
                                            
                                            Call:
                                              randomForest(formula = as.factor(survived) ~ pclass + sex + age +      sibsp, data = titanic.train, ntree = 5000, importance = TRUE,      na.action = na.omit) 
                                            Type of random forest: classification
                                            Number of trees: 5000
                                            No. of variables tried at each split: 2
                                            
                                            OOB estimate of  error rate: 17.5%
                                            Confusion matrix:
                                              0   1 class.error
                                            0 290  34   0.1049383
                                            1  60 153   0.2816901
                                            > 
                                              > # Conditional Tree
                                              > titanic.survival.train.ctree = ctree(as.factor(survived) ~ pclass + sex + age + sibsp, data = titanic.train)
                                            > titanic.survival.train.ctree
                                            
                                            Conditional inference tree with 5 terminal nodes
                                            
                                            Response:  as.factor(survived) 
                                            Inputs:  pclass, sex, age, sibsp 
                                            Number of observations:  662 
                                            
                                            1) sex == {female}; criterion = 1, statistic = 216.071
2) pclass == {3rd}; criterion = 1, statistic = 49.951
3)*  weights = 98 
2) pclass == {1st, 2nd}
4)*  weights = 129 
1) sex == {male}
5) age <= 3; criterion = 0.988, statistic = 10.424
6)*  weights = 13 
5) age > 3
7) pclass == {1st}; criterion = 0.997, statistic = 14.358
8)*  weights = 84 
7) pclass == {2nd, 3rd}
9)*  weights = 338 
> plot(titanic.survival.train.ctree)