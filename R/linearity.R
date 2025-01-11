#' Assess the linearity of a calibration curve
#' 
#' A function to create diagnostic plots for the assessment of the linearity of 
#' calibration data based on their point-to-point slope or the curvature. 
#' The underlying methods follow ISO 84 66-1:2021 and DIN 32 402-51:2017 
#' (German Industrial Norm).
#' 
#' The point-to-point slope method is based on the assumption that the slope 
#' between two points should not vary greatly within the linear range. 
#' 
#' The curvature method is similar to the point-to-point slope method. Here, 
#' the ratio between the instrument signal and the concentration of the 
#' calibration standard is assumed not to vary greatly within the linear range.
#' 
#' The use of the Mandel test is discouraged due to its limitations in the 
#' identification of non-linear behaviour of calibration curves (Andrade and 
#' Gomes-Carracedo, 2013). 
#' 
#' @param x numeric vector of independent values (usually concentrations).
#' @param y numeric vector of dependent values (usually the signal of the 
#' analytical device).
#' @param method character string. Supported methods are "slope" and 
#' "curvature".
#' @param tolerance numeric value between 0 and 1, describing the acceptable
#' deviation from the median of the slopes or the signal-to-concentration
#' ratio. The default tolerance is 10%.
#' @return returns a diagnostic plot 
#' 
#' @author Anıl Axel Tellbüscher
#' 
#' @importFrom graphics abline
#' @importFrom graphics lines
#' @importFrom stats median
#' 
#' @examples
#' # Continuous Flow Analysis (CFA) data
#' data(din38402b1)
#' 
#' # Point-to-point slope plot
#' linearity(din38402b1$conc, din38402b1$ext, method = "slope")
#' 
#' # Curvature plot
#' linearity(din38402b1$conc, din38402b1$ext, method = "curvature")
#' 
#' @references ISO 8466-1:2021. Water quality — Calibration and evaluation of 
#' analytical methods — Part 1: Linear calibration function
#' 
#' J. M. Andrade and M. P. Gomez-Carracedo (2013) Notes on the use of 
#' Mandel's test to check for nonlinearity in laboratory calibrations. 
#' Analytical Methods 5(5), 1145 - 1149.
#' 
#' @export
# Function to assess linearity of data using either slope or curvature method
linearity <- function(x, y, method = c("slope", "curvature"), tolerance = 0.1) {
  
  # Check data integrity
  # Ensure that x and y vectors have the same length
  stopifnot("x and y must have the same length!" = length(x) == length(y))
  
  method <- match.arg(method)
  
  # Calculate the 'result' based on the chosen method
  if (method == "slope") {
    # For the 'slope' method, calculate the difference between consecutive points
    x_diff = diff(x)        # Difference in x values
    y_diff = diff(y)        # Difference in y values
    result = y_diff / x_diff # Point-to-point slope (rate of change)
  } else if (method == "curvature") {
    # For the 'curvature' method, calculate the signal-to-concentration ratio
    result = y / x # Element-wise division of y by x
  }
  
  # Calculate the median of the results for tolerance check
  result_median <- median(result)
  
  # Define upper and lower tolerance boundaries
  upper_tolerance <- result_median + tolerance * result_median
  lower_tolerance <- result_median - tolerance * result_median
  
  # Create a data frame to store the result and corresponding indices
  df <- data.frame(result = result, index = 1:length(result))
  
  # Identify points that fall outside the tolerance range
  outside_tolerance <- rbind(
    subset(df, result > upper_tolerance), # Points above the upper tolerance
    subset(df, result < lower_tolerance)  # Points below the lower tolerance
  )
  
  # Basic scatter plot of the result against the index
  plot(result ~ index, data = df, 
       main = "linearity assessment", ylab = method, 
       pch = 16)
  
  # Draw a line connecting all the points to visualize the trend
  lines(df$index, df$result, col = "blue") # Blue line connecting points
  
  # Highlight points that are outside the tolerance range in red
  points(x = outside_tolerance$index, y = outside_tolerance$result, 
         pch = 16, col = "red")
  
  # Add a horizontal line at the median value of the result
  abline(h = result_median, col = "red")
  
  # Add dashed horizontal lines at the upper and lower tolerance limits
  abline(h = upper_tolerance, col = "red", lty = 3) # Upper tolerance
  abline(h = lower_tolerance, col = "red", lty = 3) # Lower tolerance
}
