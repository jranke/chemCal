require(chemCal)
data(massart97ex3)
attach(massart97ex3)
yx <- split(y, x)
ybar <- sapply(yx, mean)
s <- round(sapply(yx, sd), digits = 2)
w <- round(1 / (s^2), digits = 3)
weights <- w[factor(x)]
m <- lm(y ~ x, w = weights)
#calplot(m)

inverse.predict(m, 15, ws = 1.67)  # 5.9 +- 2.5
inverse.predict(m, 90, ws = 0.145) # 44.1 +- 7.9

m0 <- lm(y ~ x) 
lod(m0)

loq(m0)
loq(m, w.loq = 1.67)
