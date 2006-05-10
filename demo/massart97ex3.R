library(chemCal)
data(massart97ex3)
attach(massart97ex3)
yx <- split(y,factor(x))
ybar <- sapply(yx,mean)
s <- round(sapply(yx,sd),digits=2)
w <- round(1/(si^2),digits=3)
data.frame(x=levels(factor(x)),ybar,s,w)

weights <- w[factor(x)]
m <- lm(y ~ x,w=weights)
inverse.predict(m,15,ws=1.67)
inverse.predict(m,90,ws=0.145)

calplot(m)
