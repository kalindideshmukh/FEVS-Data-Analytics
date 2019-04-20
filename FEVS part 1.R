#IDS 462
##FEVS - Part 1
#Kalindi Deshmukh 654386343
library(tidyverse)
library(lubridate)
library(car) 
library(effects)
library(psych)
library(corrplot)
library(gmodels)

FEVS <- read.csv("FEVS_2017_PRDF.csv", header=T)
View(FEVS)
summary(FEVS)
dplyr::glimpse(FEVS)
str(FEVS)
table(is.na(FEVS))
dim(FEVS)
View(colSums(is.na(FEVS))) 

# It is preferable to view NAs in percentage
missingFEVS <- round(colSums(is.na(FEVS))/nrow(FEVS),2)

View(missingFEVS) 

FEV2<-FEVS


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
FEV4<-FEV4[!(FEV4sample$AGENCY=="XX"),]

#avg satisafction
satisafcation<- (FEV4$Q71+FEV4$Q70+FEV4$Q69+FEV4$Q68+FEV4$Q67+FEV4$Q66+FEV4$Q65+FEV4$Q64+FEV4$Q63) 
FEV4$OS<-(satisafcation)/9
plot(density(FEV4$OS))

#Agency types Recoding
FEV4$AgencyType[FEV4$AGENCY=="CM"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="DL"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="DN"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="EP"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="GS"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="IN"]<-"Large"



FEV4$AgencyType[FEV4$AGENCY=="NN"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="ST"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="SZ"]<-"Large"
FEV4$AgencyType[FEV4$AGENCY=="TD"]<-"Large"

FEV4$AgencyType[FEV4$AGENCY=="AM"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="CU"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="DR"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="ED"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="EE"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="FC"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="FQ"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="FT"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="HU"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="IB"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="NF"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="NL"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="NQ"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="NU"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="OM"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="SB"]<-"Medium"
FEV4$AgencyType[FEV4$AGENCY=="SE"]<-"Medium"

FEV4$AgencyType[FEV4$AGENCY=="BG"]<-"Small"
FEV4$AgencyType[FEV4$AGENCY=="BO"]<-"Small"
FEV4$AgencyType[FEV4$AGENCY=="CT"]<-"Small"
FEV4$AgencyType[FEV4$AGENCY=="RR"]<-"Small"
FEV4$AgencyType[FEV4$AGENCY=="SN"]<-"Small"

FEV4$AgencyType[FEV4$AGENCY=="AF"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="AG"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="AR"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="DD"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="DJ"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="HE"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="HS"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="NV"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="TR"]<-"Very Large"
FEV4$AgencyType[FEV4$AGENCY=="VA"]<-"Very Large"

FEV4$AgencyType[FEV4$AGENCY=="XX"]<-"Other"


table(is.na(FEV4$AgencyType))
#EEI op
leader<- (FEV4$Q53+FEV4$Q54+FEV4$Q56+FEV4$Q60+FEV4$Q61) 
FEV4$EE1<-(leader)/5

relationship<-(FEV4$Q47+FEV4$Q48+FEV4$Q49+FEV4$Q51+FEV4$Q52)
FEV4$EE2<-(relationship)/5

roles<-(FEV4$Q3+FEV4$Q4+FEV4$Q6+FEV4$Q11+FEV4$Q12)
FEV4$EE3<-(roles)/5
FEV4$EEI<-(FEV4$EE1+FEV4$EE2+FEV4$EE3)/3
plot(density(FEV4$EEI))

#NIQ
fair<- (FEV4$Q23+FEV4$Q24+FEV4$Q37+FEV4$Q38+FEV4$Q25) 
FEV4$IQFair<-(fair)/5

openIQ<- (FEV4$Q32+FEV4$Q34+FEV4$Q45+FEV4$Q55) 
FEV4$IQOpen<-(openIQ)/4

cooperative<- (FEV4$Q58+FEV4$Q59) 
FEV4$IQCooperative<-(cooperative)/2

supportive<- (FEV4$Q42+FEV4$Q46+FEV4$Q48+FEV4$Q49+FEV4$Q50) 
FEV4$IQSupportive<-(supportive)/5

empowering<- (FEV4$Q2+FEV4$Q3+FEV4$Q11+FEV4$Q30) 
FEV4$IQEmpowering<-(empowering)/4

FEV4$NewIQ<-(FEV4$IQFair+FEV4$IQOpen+FEV4$IQCooperative+FEV4$IQSupportive+FEV4$IQEmpowering)/5
plot(density(FEV4$NewIQ))

#Agency questions
FEV4$agencyqes<-round((FEV4$Q29+FEV4$Q30+FEV4$Q31+FEV4$Q32+FEV4$Q33+FEV4$Q34
                 +FEV4$Q35+FEV4$Q36+FEV4$Q37+FEV4$Q38
                 +FEV4$Q39+FEV4$Q40+FEV4$Q41)/13)
FEV4$agencyqes<-as.factor(FEV4$agencyqes)

#Top Positive Repsonse Index
FEV4$TPRI<-round((FEV4$Q7+FEV4$Q8+FEV4$Q13+FEV4$Q12+FEV4$Q5+FEV4$Q16
                 +FEV4$Q28+FEV4$Q49+FEV4$Q6+FEV4$Q42)/10)


## load outlier detection function 
outliers <- function(column) {
  lowerq <- as.vector(quantile(column)[2]) # returns 1st quartile
  upperq <- as.vector(quantile(column)[4]) # returns 1st quartile
  iqr <- upperq-lowerq  
  
  # Moderate outliers
  
  mod.outliers.upper <- (iqr * 1.5) + upperq
  mod.outliers.lower <- lowerq - (iqr * 1.5)
  mod.outliers <- which(column > mod.outliers.upper | 
                          column < mod.outliers.lower)
  #print(paste("Moderate outlier:", mod.outliers))
  #Extreme outliers
  
  extreme.outliers.upper <- (iqr * 3) + upperq
  extreme.outliers.lower <- lowerq - (iqr * 3)
  extreme.outliers<-which(column > extreme.outliers.upper 
                          | column < extreme.outliers.lower)
  print(paste("Extreme outlier:", extreme.outliers))
  
}

boxplot(FEV4$OS)
boxplot(FEV4$NewIQ)
boxplot(FEV4$EEI)

#sampling
numrowsFEV <- nrow(FEV4)
samp4 <- round(numrowsFEV*0.30,0)
set.seed(462) 
samp44 <- sample(numrowsFEV, samp4) 
FEV4sample <- FEV4[samp44,]
dim(FEV4sample)


#univariate anlysis
#FEV4sample$OS<-round(FEV4sample$OS)
plot(density(FEV4sample$OS))
describe(FEV4sample$OS)
#vars     n mean   sd median trimmed  mad min max range skew kurtosis se
#X1    1 54863 3.56 0.91   3.67    3.61 0.82   1   5     4 -0.5    -0.14  0


#power transform
summary(powerTransform(FEV4sample$OS))
plot(density(FEV4$OS^1.5))

plot(density(FEV4sample$EEI) )
hist(FEV4sample$EEI, main= "Univariate analysis of EEI", col= "red")
describe(FEV4sample$EEI)
#vars     n mean   sd median trimmed  mad min max range skew kurtosis se
#X1    1 54863 3.88 0.83      4    3.96 0.79   1   5     4 -0.9     0.62  0

plot(density(FEV4sample$NewIQ))
hist(FEV4sample$NewIQ, main= "Univariate analysis of New IQ" ,col="red")
describe(FEV4sample$NewIQ)
#vars     n mean   sd median trimmed mad min max range  skew kurtosis se
#X1    1 54863 3.74 0.88    3.9    3.82 0.8   1   5     4 -0.77     0.28  0

plot(density(FEV4sample$TPRI))
hist(FEV4sample$TPRI, main= "Univariate analysis of TPRI" ,col="red")
describe(FEV4sample$TPRI)
#vars     n mean   sd median trimmed  mad min max range  skew kurtosis se
#X1    1 54863 4.31 0.57    4.3    4.36 0.59   1   5     4 -1.16     2.62  0

FEV4sample$AgencyType<-as.factor(FEV4sample$AgencyType)
plot(FEV4sample$AgencyType, main= "Agency Distribution")
#Very Large

plot(FEV4sample$agencyqes, main= "Agency question responses Distribution")
#4
# detect and remove outlier 
#OSoutliers<-outliers(FEV4sample$OS) 

#FEV5 <- FEV4[-c(mod.o)] #if I ha dmultiple, -c() or filter function

#Bivariate anlaysis

# Two numeric variables
#plot
#EEI OS
plot(FEV4sample$EEI~FEV4sample$OS, col="steelblue", pch=20, cex=0.75, main= "EEI~OS", xlab="OS", ylab= "EEI")
abline(lm(log(FEV4sample$EEI+1)~log(FEV4sample$OS+1), data=FEV4sample), col="red", lwd=2)
cor.test(FEV4sample$EEI, FEV4sample$OS)  # pretty good, 0.8827 but ..very tiny p value..hence yes correlated

#NIQ OS
plot(FEV4sample$NewIQ~FEV4sample$OS, col="steelblue", pch=20, cex=0.75, main= "NewIQ~OS", xlab="OS", ylab= "NewIQ")
abline(lm(log(FEV4sample$NewIQ+1)~log(FEV4sample$OS+1), data=FEV4sample), col="red", lwd=2)
cor.test(FEV4sample$NewIQ, FEV4sample$OS) #0.88266

#TPRI~OS
plot(FEV4sample$TPRI~FEV4sample$OS, col="steelblue", pch=20, cex=0.75, main= "TPRI~OS", xlab="OS", ylab= "TPRI")
abline(lm(log(FEV4sample$TPRI+1)~log(FEV4sample$OS+1), data=FEV4sample), col="red", lwd=2)
cor.test(FEV4sample$TPRI, FEV4sample$OS) #0.73544

# TEST Correlation matrix

cols<-c("OS","EEI","NewIQ", "TPRI")
cormat <- cor(FEV4sample[,cols])
round(cormat,2)
library(corrplot)
corrplot(cormat, method="circle", addCoef.col="grey", type="upper") 

#factor and numeric

aggregate(OS ~ DSEX, data = FEV4sample, FUN="mean", na.rm=T)
aggregate(OS ~ DSEX, data = FEV4sample, FUN="sd", na.rm=T)

est_modelS <- aov(log(OS+1)~DSEX, data=FEV4sample)
summary(est_modelS) #not significant!

# Plot

boxplot(OS ~ DSEX, data=FEV4sample, main="Comparing Gender with Job Satisfaction", 
        xlab="SEX", ylab="Satisfaction", col=c("orange", "steelblue")) #almost similar

#DEDUC
aggregate(OS ~ DEDUC, data = FEV4sample, FUN="mean", na.rm=T)
est_modelDD <- aov(log(OS+1)~DEDUC, data=FEV4sample)
summary(est_modelDD) #correlated!

# Plot
boxplot(OS ~ DEDUC, data=FEV4sample, main="Comparing Degree level with Job Satisfaction", 
        xlab="Gender", ylab="Overall Satisfaction", col=c("orange", "steelblue")) #almost similar C

#DFEDTEN
aggregate(OS ~ DFEDTEN, data = FEV4sample, FUN="mean", na.rm=T)
est_modelDT <- aov(log(OS+1)~DFEDTEN, data=FEV4sample)
summary(est_modelDT) #correlated!

# Plot
boxplot(OS ~ DFEDTEN, data=FEV4sample, main="Comparing  FEd Govt with JOb Satisfaction", 
        xlab="Federal Tenure", ylab="Overall Satisafction", col=c("orange", "steelblue")) #C

#DSUPER
aggregate(OS ~ DSUPER, data = FEV4sample, FUN="mean", na.rm=T)
est_modelDS <- aov(log(OS+1)~DSUPER, data=FEV4sample)
summary(est_modelDS) #correlated!

# Plot
boxplot(OS ~ DSUPER, data=FEV4sample, main="Comparing Supervisory status with Overall Satisfaction", 
        xlab="Supervisory Status", ylab="Satisfaction", col=c("orange", "steelblue")) #B

#DMINORITY
aggregate(OS ~ DMINORITY, data = FEV4sample, FUN="mean", na.rm=T)
est_modelDMin <- aov(log(OS+1)~DMINORITY, data=FEV4sample)
summary(est_modelDMin) #same

# Plot
boxplot(OS ~ DMINORITY, data=FEV4sample, main="Compaaring  Minority  wrt Job Satisfaction", 
        xlab="Minority", ylab="Satisfaction", col=c("orange", "steelblue"))

#DLEAVING
aggregate(OS ~ DLEAVING, data = FEV4sample, FUN="mean", na.rm=T)
est_modelDLeave <- aov(log(OS+1)~DLEAVING, data=FEV4sample)
summary(est_modelDLeave) #significant

# Plot
boxplot(OS ~ DLEAVING, data=FEV4sample, main="Compaaring Leaving wrt Satisfaction", 
        xlab="Leaving", ylab="Satisfaction", col=c("orange", "steelblue")) #A


#Agency Type
aggregate(OS ~ AgencyType, data = FEV4sample, FUN="mean", na.rm=T)
est_modelAtype <- aov(log(OS+1)~AgencyType, data=FEV4sample)
summary(est_modelAtype) 

# Plot
boxplot(OS ~ AgencyType, data=FEV4sample, main="Compaaring Agency type  wrt Satisfaction", 
        xlab="Agency type", ylab="Satisfaction", col=c("orange", "steelblue"))


#modeling
modF <- lm(OS~EEI+NewIQ+DSEX+DSUPER+DLEAVING+AgencyType+agencyqes+TPRI, data=FEV4sample)
summary(modF)

modF1 <- lm(OS~EEI+NewIQ, data=FEV4sample)
summary(modF1) #0.7952


modF2 <- lm(OS~EEI+NewIQ+TPRI, data=FEV4sample)
summary(modF2)  #0.7962 #10

modF3 <- lm(OS~EEI+NewIQ+TPRI+DEDUC, data=FEV4sample)
summary(modF3)  #0.7962 #no diff

modF3 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN, data=FEV4sample)
summary(modF3)  #0.7969 #little diff #6

modF4 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DSEX, data=FEV4sample)
summary(modF4) #almost same 

modF5 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING, data=FEV4sample)
summary(modF5) #0.8033 #significant

modF6 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER, data=FEV4sample)
summary(modF6) #0.8041 #64

modF7 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY, data=FEV4sample)
summary(modF7) #0.8042#1

modF8 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType, data=FEV4sample)
summary(modF8) #0.8042 #no

modF9 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType+agencyqes, data=FEV4sample)
summary(modF9) #0.8246 #significant

FEV4sample$AgencyType<-relevel(FEV4sample$AgencyType, ref=3)
modF10 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType+agencyqes, data=FEV4sample)
summary(modF10) #0.8246 same

FEV4sample$DEDUC<-relevel(FEV4sample$DEDUC, ref=2)
modF11 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType+agencyqes+DEDUC, data=FEV4sample)
summary(modF11) #0.8246 same

FEV4sample$DSUPER<-relevel(FEV4sample$DSUPER, ref=1)
modF12 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType+agencyqes+DEDUC, data=FEV4sample)
summary(modF12) #0.8246 same

#interaction


# Used when we suspect that the effect of a predictor might vary at different values (levels)
# This means, that the relationships between an IV and the DV is dependent on the value of another IV

modI1 <- lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType:agencyqes, data=FEV4sample)
summary(modI1)
plot(effect(term="AgencyType:agencyqes", mod=modI1))
plot(effect(term="AgencyType:agencyqes", mod=modI1, default.levels=20), multiline=T) # overlaid 



modF13 <- lm(OS~EEI+NewIQ, data=FEV4sample)
summary(modF13) #0.7952
plot(modF13)


sqrt(vif(modF13))>2

#########################################################################################################
# Diagnostics 
#=
plot(modF9) # This is a great way to identify multiple possible concerns with the model 
# For example, outliers. 
# Better yet: 
par(mfrow=c(2,2)) # This function sets up the plotting canvas to 2x2, so that we don't need to go through them one by one. Now again:  
plot(modF9)
# We could also plot diagnostics using residuals, such as: 
dev.off() 
plot(predict (modF9), residuals (modF9))
plot(hatvalues(modF9)) 
identify(hatvalues(modF9), col="steelblue") # Neat, but this interactive feature doesn't always work, so: 
# And we can compute measures of influence directly 
tail(sort(cooks.distance(modF9)))

# We can also run a test 
outlierTest(modF9) # only 515 

# Our diagnostics indicate "prime suspects"

# We could remove these observations, and re-run our model 
outliers <- c(396688 ,332693,437413,386600,466120 ,337341 ,216499 ,190320,448832, 254238)
FEV4sample2 <- FEV4sample[-outliers,]
modF9.1<-lm(OS~EEI+NewIQ+TPRI+DFEDTEN+DLEAVING+DSUPER+DMINORITY+AgencyType+agencyqes, data=FEV4sample2)
summary(modF9.1)
# Did all this work pay off? 
# We can only compare models with the same DV and same data
anova(modF9,modF1, test="Chisq") # Yes, the two are significantly different (last one is much better)
# But really, we want to know to find the extent to which our models have improved, after "cleaning"
summary(modF9.1)$adj.r.squared-summary(modF9)$adj.r.squared # 0
