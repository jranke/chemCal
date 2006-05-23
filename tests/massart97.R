library(chemCal)
data(massart97ex3)
attach(massart97ex3)
yx <- split(y,x)
ybar <- sapply(yx,mean)
s <- round(sapply(yx,sd),digits=2)
w <- round(1/(s^2),digits=3)
weights <- w[factor(x)]
m <- lm(y ~ x,w=weights)
# The following concords with the book
inverse.predict(m, 15, ws = 1.67)
inverse.predict(m, 90, ws = 0.145)
