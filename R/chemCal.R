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
plot.calm <- function(m,
    xunit="",yunit="",measurand="",
    level=0.95)
{
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
predictx.calm <- function(m,measurements)
{
    s <- summary(m)    
    xi <- m$model$x
    yi <- m$model$y
    n <- length(yi)
    yobs <- newdata[[1]]
    p <- length(yobs)
    if (!m$intercept)
    {
        varb1 <- summary(m)$coef["x","Std. Error"]^2
        xpred <- mean(yobs)/b1
        varxpred <- (varyobs + xpred^2 * varb1) / b1^2
        sdxpred <- sqrt(varxpred) 
    } else 
    {
        b0 <- summary(m)$coef["(Intercept)","Estimate"]
        b1 <- summary(m)$coef["xi","Estimate"]
        xpred <- (mean(yobs) - b0)/b1
        sumxxbar <- sum((xi - mean(xi))^2) 
        if (!syobs)
        {
            yybar <- (mean(yobs) - mean(yi))^2
            sdxpred <- (S/b1) * (1/p + 1/n + yybar/(b1^2 * sumxxbar))^0.5
        } else
        {
            sdxpred <- ((varyobs^0.5/b1) + (S/b1)^2 * (1/n + ((xpred - mean(xi))^2)/sumxxbar))^0.5
        }
    }
    t <- qt((1 + level)/2,ntot - 2)
    confxpred <- t * sdxpred

    result <- c(estimate=xpred,sdxpred=sdxpred,syobs=syobs,
        confxpred=confxpred)
    digits <- max(c(3,round(log10(xpred/confxpred)) + 2))
    roundedresult <- round(result,digits=digits)
    confidenceinterval <- paste(roundedresult["estimate"],"+-",
        roundedresult["confxpred"],xunit)
    roundedresult[["confidenceinterval"]] <- confidenceinterval
    invisible(roundedresult)
}
calpredict <- function(yobs,xi,yi,xunit="",level=0.95,intercept=FALSE,syobs=FALSE)
{
    if (length(xi)!=length(yi))
    {
        cat("xi and yi have to be of the same length\n")
    }
    xi <- xi[!is.na(yi)]
    yi <- yi[!is.na(yi)]
    n <- length(yi)
    p <- length(yobs)
    if (!intercept)
    {
        m <- lm(yi ~ xi - 1)
    } else 
    {
        m <- lm(yi ~ xi)
    }
    S <- summary(m)$sigma
    b1 <- summary(m)$coef["xi","Estimate"]

    if (syobs)
    {
        if (is.numeric(syobs))
        {
            varyobs <- syobs^2
            ntot <- n
        } else
        {
            if (length(yobs)==1)
            {
                cat("yobs has to contain more than one number vector, if you use syobs=TRUE\n")
            }
            varyobs <- var(yobs)
            ntot <- n + p
        }
    } else
    {
        varyobs <- S^2
        ntot <- n
    }

    if (!intercept)
    {
        varb1 <- summary(m)$coef["xi","Std. Error"]^2
        xpred <- mean(yobs)/b1
        varxpred <- (varyobs + xpred^2 * varb1) / b1^2
        sdxpred <- sqrt(varxpred) 
    } else 
    {
        b0 <- summary(m)$coef["(Intercept)","Estimate"]
        b1 <- summary(m)$coef["xi","Estimate"]
        xpred <- (mean(yobs) - b0)/b1
        sumxxbar <- sum((xi - mean(xi))^2) 
        if (!syobs)
        {
            yybar <- (mean(yobs) - mean(yi))^2
            sdxpred <- (S/b1) * (1/p + 1/n + yybar/(b1^2 * sumxxbar))^0.5
        } else
        {
            sdxpred <- ((varyobs^0.5/b1) + (S/b1)^2 * (1/n + ((xpred - mean(xi))^2)/sumxxbar))^0.5
        }
    }
    t <- qt((1 + level)/2,ntot - 2)
    confxpred <- t * sdxpred

    result <- c(estimate=xpred,sdxpred=sdxpred,syobs=syobs,
        confxpred=confxpred)
    digits <- max(c(3,round(log10(xpred/confxpred)) + 2))
    roundedresult <- round(result,digits=digits)
    confidenceinterval <- paste(roundedresult["estimate"],"+-",
        roundedresult["confxpred"],xunit)
    roundedresult[["confidenceinterval"]] <- confidenceinterval
    invisible(roundedresult)
}

multical <- function(cf,df,intercept=FALSE)
{
    rf <- data.frame(name=levels(df$name))
    substances <- colnames(df)[-1]
    for (s in substances)
    {
        r <- vector()
        for (sample in levels(df$name))
        {
            tmp <- calpredict(subset(df,name==sample)[[s]],
                cf[["conc"]],cf[[s]],
                intercept=intercept)
            r <- c(r,tmp[["confidenceinterval"]])
        }
        rf[[s]] <- r
    }
    return(rf)
}
