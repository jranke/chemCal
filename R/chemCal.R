calm <- function(data)
{
    y <- data[[2]]
    x <- data[[1]]
    m <- lm(y ~ x)
    s <- summary(m)
    if (s$coefficients[1,4] > 0.05) 
    {
        m <- lm(y ~ x - 1)
        s <- summary(m)
        m$intercept <- FALSE
    } else {
        m$intercept <- TRUE
    }
    class(m) <- "calm"
    m$yname <- names(data)[[1]]
    m$xname <- names(data)[[2]]
    return(m)    
}
predict.calm <- predict.lm
print.calm <- print.lm
summary.calm <- summary.lm
plot.calm <- function(x,...,
    xunit="",yunit="",measurand="",
    level=0.95)
{
    m <- x
    x <- m$model$x
    y <- m$model$y
    newdata <- data.frame(x = seq(0,max(x),length=250))
    pred.lim <- predict(m, newdata, interval = "prediction",level=level)
    conf.lim <- predict(m, newdata, interval = "confidence",level=level)
    if (xunit!="") {
        xlab <- paste("Concentration in ",xunit)
    } else xlab <- m$xname
    if (yunit=="") yunit <- m$yname
    if (measurand!="") {
        main <- paste("Calibration for",measurand)
    } else main <- "Calibration"
    plot(1,
        xlab = xlab,
        ylab = yunit,
        type = "n", 
        main = main,
        xlim = c(0,max(x)), 
        ylim = range(pred.lim)
    )
    points(x,y, pch = 21, bg = "yellow")
    matlines(newdata$x, pred.lim, lty = c(1, 4, 4), 
        col = c("black", "red", "red"))
    matlines(newdata$x, conf.lim, lty = c(1, 3, 3), 
        col = c("black", "green4", "green4"))

    legend(min(x), 
        max(pred.lim, na.rm = TRUE), 
        legend = c("Fitted Line", "Confidence Bands", 
            "Prediction Bands"), 
        lty = c(1, 3, 4), 
        lwd = 2, 
        col = c("black", "green4", "red"), 
        horiz = FALSE, cex = 0.9, bg = "gray95")
}
predictx <- function(m,yobs,level=0.95)
{
    s <- summary(m)    
    xi <- m$model$x
    yi <- m$model$y
    n <- length(yi)
    p <- length(yobs)
    if (p > 1) {
        varyobs <- var(yobs)
    } else {
        varyobs <- 0
    }
    if (!m$intercept) {
        b1 <- summary(m)$coef["x","Estimate"]
        varb1 <- summary(m)$coef["x","Std. Error"]^2
        xpred <- mean(yobs)/b1
        varxpred <- (varyobs + xpred^2 * varb1) / b1^2
        sdxpred <- sqrt(varxpred) 
    } else 
    {
        b0 <- summary(m)$coef["(Intercept)","Estimate"]
        b1 <- summary(m)$coef["x","Estimate"]
        S <- summary(m)$sigma
        xpred <- (mean(yobs) - b0)/b1
        sumxxbar <- sum((xi - mean(xi))^2) 
        yybar <- (mean(yobs) - mean(yi))^2
        sdxpred <- (S/b1) * (1/p + 1/n + yybar/(b1^2 * sumxxbar))^0.5
    }
    t <- qt((1 + level)/2,n - 2)
    confxpred <- t * sdxpred

    result <- c(estimate=xpred,sdxpred=sdxpred,confxpred=confxpred)
}
