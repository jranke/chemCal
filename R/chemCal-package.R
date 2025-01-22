#' Calibration data from DIN 32645
#' 
#' Sample dataset to test the package.
#' 
#' 
#' @name din32645
#' @docType data
#' @format A dataframe containing 10 rows of x and y values.
#' @references DIN 32645 (equivalent to ISO 11843), Beuth Verlag, Berlin, 1994
#' 
#' Dintest. Plugin for MS Excel for evaluations of calibration data. Written by
#' Georg Schmitt, University of Heidelberg. Formerly available from the Website
#' of the University of Heidelberg.
#' 
#' Currie, L. A. (1997) Nomenclature in evaluation of analytical methods
#' including detection and quantification capabilities (IUPAC Recommendations
#' 1995).  Analytica Chimica Acta 391, 105 - 126.
#' @keywords datasets
#' @examples
#' 
#' m <- lm(y ~ x, data = din32645)
#' calplot(m)
#' 
#' ## Prediction of x with confidence interval
#' prediction <- inverse.predict(m, 3500, alpha = 0.01)
#' 
#' # This should give 0.07434 according to test data from Dintest, which 
#' # was collected from Procontrol 3.1 (isomehr GmbH) in this case
#' round(prediction$Confidence, 5)
#' 
#' ## Critical value:
#' crit <- lod(m, alpha = 0.01, beta = 0.5)
#' 
#' # According to DIN 32645, we should get 0.07 for the critical value
#' # (decision limit, "Nachweisgrenze")
#' round(crit$x, 2)
#' # and according to Dintest test data, we should get 0.0698 from
#' round(crit$x, 4)
#' 
#' ## Limit of detection (smallest detectable value given alpha and beta)
#' # In German, the smallest detectable value is the "Erfassungsgrenze", and we
#' # should get 0.14 according to DIN, which we achieve by using the method 
#' # described in it:
#' lod.din <- lod(m, alpha = 0.01, beta = 0.01, method = "din")
#' round(lod.din$x, 2)
#' 
#' ## Limit of quantification
#' # This accords to the test data coming with the test data from Dintest again, 
#' # except for the last digits of the value cited for Procontrol 3.1 (0.2121)
#' loq <- loq(m, alpha = 0.01)
#' round(loq$x, 4)
#' 
#' # A similar value is obtained using the approximation 
#' # LQ = 3.04 * LC (Currie 1999, p. 120)
#' 3.04 * lod(m, alpha = 0.01, beta = 0.5)$x
#' 
"din32645"





#' Calibration data from Massart et al. (1997), example 1
#' 
#' Sample dataset from p. 175 to test the package.
#' 
#' 
#' @name massart97ex1
#' @docType data
#' @format A dataframe containing 6 observations of x and y data.
#' @source Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S.,
#' Lewi, P.J., Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and
#' Qualimetrics: Part A, Chapter 8.
#' @keywords datasets
"massart97ex1"





#' Calibration data from Massart et al. (1997), example 3
#' 
#' Sample dataset from p. 188 to test the package.
#' 
#' 
#' @name massart97ex3
#' @docType data
#' @format A dataframe containing 6 levels of x values with 5 observations of y
#' for each level.
#' @source Massart, L.M, Vandenginste, B.G.M., Buydens, L.M.C., De Jong, S.,
#' Lewi, P.J., Smeyers-Verbeke, J. (1997) Handbook of Chemometrics and
#' Qualimetrics: Part A, Chapter 8.
#' @keywords datasets
#' @examples
#' 
#' # For reproducing the results for replicate standard measurements in example 8,
#' # we need to do the calibration on the means when using chemCal > 0.2
#' weights <- with(massart97ex3, {
#'   yx <- split(y, x)
#'   ybar <- sapply(yx, mean)
#'   s <- round(sapply(yx, sd), digits = 2)
#'   w <- round(1 / (s^2), digits = 3)
#' })
#' 
#' massart97ex3.means <- aggregate(y ~ x, massart97ex3, mean)
#' 
#' m3.means <- lm(y ~ x, w = weights, data = massart97ex3.means)
#' 
#' # The following concords with the book p. 200
#' inverse.predict(m3.means, 15, ws = 1.67)  # 5.9 +- 2.5
#' inverse.predict(m3.means, 90, ws = 0.145) # 44.1 +- 7.9
#' 
#' # The LOD is only calculated for models from unweighted regression
#' # with this version of chemCal
#' m0 <- lm(y ~ x, data = massart97ex3) 
#' lod(m0)
#' 
#' # Limit of quantification from unweighted regression
#' loq(m0)
#' 
#' # For calculating the limit of quantification from a model from weighted
#' # regression, we need to supply weights, internally used for inverse.predict
#' # If we are not using a variance function, we can use the weight from
#' # the above example as a first approximation (x = 15 is close to our
#' # loq approx 14 from above).
#' loq(m3.means, w.loq = 1.67)
#' # The weight for the loq should therefore be derived at x = 7.3 instead
#' # of 15, but the graphical procedure of Massart (p. 201) to derive the 
#' # variances on which the weights are based is quite inaccurate anyway. 
#' 
"massart97ex3"





#' Cadmium concentrations measured by AAS as reported by Rocke and Lorenzato
#' (1995)
#' 
#' Dataset reproduced from Table 1 in Rocke and Lorenzato (1995).
#' 
#' 
#' @name rl95_cadmium
#' @docType data
#' @format A dataframe containing four replicate observations for each of the
#' six calibration standards.
#' @source Rocke, David M. und Lorenzato, Stefan (1995) A two-component model
#' for measurement error in analytical chemistry. Technometrics 37(2), 176-184.
#' @keywords datasets
"rl95_cadmium"





#' Toluene amounts measured by GC/MS as reported by Rocke and Lorenzato (1995)
#' 
#' Dataset reproduced from Table 4 in Rocke and Lorenzato (1995). The toluene
#' amount in the calibration samples is given in picograms per 100 µL.
#' Presumably this is the volume that was injected into the instrument.
#' 
#' 
#' @name rl95_toluene
#' @docType data
#' @format A dataframe containing four replicate observations for each of the
#' six calibration standards.
#' @source Rocke, David M. und Lorenzato, Stefan (1995) A two-component model
#' for measurement error in analytical chemistry. Technometrics 37(2), 176-184.
#' @keywords datasets
"rl95_toluene"





#' Example data for calibration with replicates from University of Toronto
#' 
#' Dataset read into R from
#' \url{https://sites.chem.utoronto.ca/chemistry/coursenotes/analsci/stats/files/example14.xls}.
#' 
#' 
#' @name utstats14
#' @docType data
#' @format A tibble containing three replicate observations of the response for
#' five calibration concentrations.
#' @source David Stone and Jon Ellis (2011) Statistics in Analytical Chemistry.
#' Tutorial website maintained by the Departments of Chemistry, University of
#' Toronto.
#' \url{https://sites.chem.utoronto.ca/chemistry/coursenotes/analsci/stats/index.html}
#' @keywords datasets
"utstats14"





#' Nitrite calibration data
#' 
#' Example dataset B.1 from DIN 38402 with concentrations in µg/L and the extinction
#' as response measured using continuous flow analysis (CFA) according to 
#' ISO 13395.
#' 
#' @name din38402b1
#' @docType data
#' @format A tibble containing 12 concentration levels with the respective 
#' instrument response values.
#' @references DIN 38402-51:2017-05, Beuth Verlag, Berlin. 
#' https://dx.doi.org/10.31030/2657448
#' @keywords datasets
"din38402b1"





#' Copper calibration data
#' 
#' Example dataset B.3 from DIN 38402. Cu was measured according to ISO 11885,
#' using ICP-OES. The concentration are reported in mg/L and the response as 
#' counts/s, describing the count of photons that are detected by the 
#' photomultiplier detector of the device.
#' 
#' @name din38402b3
#' @docType data
#' @format A tibble containing 13 concentration levels and the respective 
#' instrument response values.
#' @references DIN 38402-51:2017-05, Beuth Verlag, Berlin. 
#' https://dx.doi.org/10.31030/2657448
#' @keywords datasets
"din38402b3"





#' Carbamazepin calibration data
#' 
#' Example dataset B.6 from DIN 38402 measured using LC-MS/MS. The 
#' concentrations are reported in in µg/L and the response in arbitrary
#' units (AU).
#' 
#' @name din38402b6
#' @docType data
#' @format A tibble containing 12 concentration levels and the respective 
#' instrument response values.
#' @references DIN 38402-51:2017-05, Beuth Verlag, Berlin. 
#' https://dx.doi.org/10.31030/2657448
#' @keywords datasets
"din38402b6"





#' Iron calibration data
#' 
#' Example dataset C.3 from DIN 38402 determined by ion chromatography.
#' Concentrations are reported in mg/L and the extinction as response.
#' 
#' @name din38402c3
#' @docType data
#' @format A tibble containing 10 concentration levels and the respective 
#' response values.
#' @references DIN 38402-51:2017-05, Beuth Verlag, Berlin. 
#' https://dx.doi.org/10.31030/2657448
#' @keywords datasets
"din38402c3"

