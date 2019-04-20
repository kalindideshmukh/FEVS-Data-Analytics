#=

#Kalindi Deshmukh
#FEVS Part 2

library(car)
library(corrplot)
library(FactoMineR)
library(ggbiplot)
library(nFactors)
library(psych)
library(rgl)
library(tidyverse)
library(car)
library(Deducer)
library(rms)

#The aim is to help the Federal Govt agency to do Factor analysis and build a good regression model on the
#FEVS data that contains several survey questions answered by their employees.

#Loading and cleaning the data
FEV3 <- read.csv("FEVS_2017_PRDF.csv", header=T, na.strings=c("","X"))

str(FEV3)
missingFEV3 <- round(colSums(is.na(FEV3))/nrow(FEV3),2)
View(missingFEV3)
# Wrangle 
#= 
FEV4 <- FEV3 %>% drop_na() 
View(FEV4)
table(is.na(FEV4))
#FALSE 
FEV4<-FEV4[-c(80)] #dropped last column

#sampling of 1000

numrowsFEV <- nrow(FEV4)
#samp4 <- round(numrowsFEV*0.054,0)
set.seed(462) 
samp44 <- sample(numrowsFEV, 1000) 
FEV4sample <- FEV4[samp44,]
dim(FEV4sample)
str(FEV4sample)
#Data is ready for further operations

# For Factor Analysis, steps are as follows
#scaling the data
FEV_scale <- data.frame(scale(FEV4sample[,-c(1:8)])) #removed factors

corrplot(cor(FEV_scale), method="circle", addCoef.col="grey", type="upper")

# Consider number of factors
fa.parallel(FEV_scale, fa="both", n.iter=100) # both argument for FA and PCA
fa.parallel(FEV_scale, fa="both", n.iter=100, show.legend=F)
#Parallel analysis suggests that the number of factors =  10  and the number of components =  6 
## Perform FA 
#= 
# Many methods to extract factors (unlike PCA)
F_Fact <- factanal(FEV_scale, 10) 
F_Fact$loadings
F_Fact
#Test of the hypothesis that 10 factors are sufficient.
#The chi square statistic is 5932.85 on 1820 degrees of freedom.
#The p-value is 0 

#In every factor analysis, there are the same number of factors as there are variables.  
#Each factor captures a certain amount of the overall variance in the observed variables, and the 
#factors are always listed in order of how much variation they explain.
#With the help of the loadings, we can identify if they are loading together, plus they show the latent "factors"
# and also the linear relationships with them.
#After carefully observing the loadings, I can say that the primary factors are Factor 1, 2 and 3, as the groups
#are loading together and there seems a relation between them.

#The reports on survey findings suggests an
#Employee Engagement Index, which is based on three subfactors (Leaders Lead,Supervisors, Intrinsic Work Experience)
#The questions corresponding to leaders lead are Q. 53, 54, 56, 60, and 61. We can see that they are loading highly
#well in the second factor with a threshold of 60% and demonstarate being loading highly together till the Factor 7.
#The questions corresponding to Supervisors are Q. 47, 48, 49, 51, and 52. We can see that they are loading highly
#well in the first factor with a threshold of 60% and demonstarate being loading highly together till the Factor 6.
#The questions corresponding to Supervisors are Q. 3, 4, 6, 11, and 12. It can be seen that the values are less than cutoff
# And are loaded together with Fcator 4.

#Apart from The EEI questions, the other questions that seem to load highly together with observations are
#Q 4, 5, 7, 8, 14, 43, 44, 45, 46, 50, 66.
#So, these would be the others I would like to sugesst to my team.

#To cross check with EEI
#Let's assume the EEI as a blackbox. Instead of checking eaach question, I will define the
#subfactors as variables and check the data for loading.

leader<- (FEV4sample$Q53+FEV4sample$Q54+FEV4sample$Q56+FEV4sample$Q60+FEV4sample$Q61) 
relationship<-(FEV4sample$Q47+FEV4sample$Q48+FEV4sample$Q49+FEV4sample$Q51+FEV4sample$Q52)
workex<-(FEV4sample$Q3+FEV4sample$Q4+FEV4sample$Q6+FEV4sample$Q11+FEV4sample$Q12)
EEI<- data.frame(leader,relationship,workex)
EEI<-EEI/5

#scaling
EEI_s <- data.frame(scale(EEI)) #removed factors
corrplot(cor(EEI_s), method="circle", addCoef.col="grey", type="upper")

#Supervisor's relationship and work-ex have a corr of 0.65
#Supervisor's relationship and leader's lead have a corr of 0.58
#work-ex and leader's lead have highest corr of 0.68
# Consider number of factors
fa.parallel(EEI_s, fa="both", n.iter=100) # both argument for FA and PCA
fa.parallel(EEI_s, fa="both", n.iter=100, show.legend=F)

## Perform FA 
#= 
# Many methods to extract factors (unlike PCA)
F_Fact_EEI <- factanal(EEI_s, 1) 
F_Fact_EEI$loadings

#After cross checking, I can say that it is fine to go ahead with the three subfactors of EEI. However, there is a little
#skepticism about work-ex. Plus, it was seen that some of the quetsions of subfactors
#did not load with the other questions in the subfactors. That will be cleared in the next question.


#Q2
FEV4sample$leader<-leader
FEV4sample$leader<-FEV4sample$leader/5

FEV4sample$relationship<- relationship
FEV4sample$relationship<- FEV4sample$relationship/5

FEV4sample$workex<-workex
FEV4sample$workex<- FEV4sample$workex/5

#Use DLEAVING as the dependent variable where No=0; All other levels = 1.

FEV4sample$DLEAVING2 <- ifelse(FEV4sample$DLEAVING== "A", "0", "1")
FEV4sample$DLEAVING2<- as.factor(FEV4sample$DLEAVING2)

#Building a good regression model to predict employee attrition
#Using the factors, questions identified in the previous question, I will build a model 
#to check the best one for the FEV survey
#To do so, we should check the AIC value=> the lower the values, the better the fit!

#Let's start with EEI subfactors
FEV_lm <- glm(DLEAVING2~leader+relationship,data=FEV4sample, family="binomial")
summary(FEV_lm)
#AIC: 1075.8; looking at astericks, I can say that leader and supervisors relationship are significant

#Let's add the dubious variable work-ex
FEV_lm2 <- glm(DLEAVING2~leader+relationship+workex,data=FEV4sample, family="binomial")
summary(FEV_lm2)
#AIC: 1045.3
#AIC reduced, so we are good to go ahead with work-ex subfactor.

#Let's try separately with the questions of EEI that loaded highly together
FEV_lm3 <- glm(DLEAVING2~Q53+Q54+Q61+Q47+Q48+Q49+Q51+Q52,data=FEV4sample, family="binomial")
summary(FEV_lm3)
#AIC AIC: 1082
#AIC increased. So, let's adhere to our subfactors model and build upon it.

FEV_lm4 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7+Q8+Q14,data=FEV4sample, family="binomial")
summary(FEV_lm4)
#AIC: 1039.5

FEV_lm5 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7,data=FEV4sample, family="binomial")
summary(FEV_lm5)
#AIC: 1036.4

FEV_lm6 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7+Q4,data=FEV4sample, family="binomial")
summary(FEV_lm6)
#AIC: 1038.2 => Remove Q4
FEV_lm7 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7+Q66,data=FEV4sample, family="binomial")
summary(FEV_lm7)
#AIC: 1035.3

FEV_lm8 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7+Q66+Q50,data=FEV4sample, family="binomial")
summary(FEV_lm8)
#AIC: 1033.9

FEV_lm9 <- glm(DLEAVING2~ leader+relationship+workex+Q5+Q7+Q66+Q50+Q43+Q44+Q45+Q46,data=FEV4sample, family="binomial")
summary(FEV_lm9)
#AIC: 1041.7

#So we will go with 8th model.

#Interpretation from the 8th model is that
#Keeping all other variables constant,increase in one unit of leader's lead,
#relationship, workex, Q5, Q66, Q60 reduces the log odds of DLEAVING2 by 0.01723, 0.07937, 0.50006, 0.39679,
#0.22673, 0.20389 respectively. And, increase in one unit of Q7 increases the log odds of DLEAVING2 by 0.24659.

# a. We can  get confidence intervals for each estimate 
confint(FEV_lm8, level = 0.99)

# b. It is easier to convert log odds to odds ratios
# using the exponent function 
exp(coef(FEV_lm8))
#leader's lead decreases the odds of DLEAVING2 by 2%
# workex decreases the odds of DLEAVING2 by 40%  
#Supervisor's relationship decreases the odds of DLEAVING2 by 8%
#Q5 decreases the odds of DLEAVING2 by 37%
#Q7 increases the odds of DLEAVING2 by 27%%
#Q66 decreases the odds of DLEAVING2 by 21%
#Q50 decreases the odds of DLEAVING2 by 19%

# c. It is often more useful to also get confidence intervals 
# for predictions
exp(confint(FEV_lm8))
# So, workex, the odds of Leaving are 
# between 45-82% lower than those who did not have.

# Second, test the difference 
anova(FEV_lm, FEV_lm8, test="Chisq") #annova over models
# only if we the first mode uses variables in the second  
# answer is: yes! 

# Now re-run the previous procedure 
exp(confint(FEV_lm8))
# has not changed much
 
#To predict the attrition:
predict(FEV_lm8, # now select the variables in the model 
        FEV4sample[1:10, c("leader","relationship","workex","Q5","Q7","Q66","Q50")], 
        type="response")

#I got the first 10 probabilities as follows:
#0.28597010 0.44718989 0.72773194 0.50342522 0.23753303 0.12345556 0.20823469 0.09644424 0.16756415 0.37540383 

#Conclusion:
#After rigorous analysis and building models, I conclude that work-ex and Q5 are significant factors for the analysis.
# This can be followed by other variables.
#As a consultant I would suggest the Federal Govt to go ahead with the following variables of the survey data:
# Work-ex, Leader's lead, Supervisors' relationship, Q5, Q7, Q66, Q50.

