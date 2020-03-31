#' Function to plot matches
#'
#' @param data PCAmatchR output
#' @param x_var Principal component 1
#' @param y_var Principal component 2
#' @param case_control Case or control status
#' @param line line
#'
#' @return A plot
#' @export
#'
#' @examples
#'\dontrun{plot_matches(data=PCAmatchR_output,
#'                      x_var="PC1",
#'                      y_var="PC2",
#'                      case_control="case",
#'                      line=T)}
#'
plot_matches <- function(data=NULL, x_var=NULL, y_var=NULL, case_control=NULL, line=T)
{
  # Check function input
  if(is.null(data))
  {
    stop("Please specify the PCAmatchR data frame.")
  }
  if(is.null(x_var))
  {
    stop("Please specify the X variable for plotting.")
  }
  if(is.null(x_var))
  {
    stop("Please specify the Y variable for plotting.")
  }
  if(is.null(case_control))
  {
    stop("Please specify the case indicator variable for plotting.")
  }

  plot(data$matches[,x_var], data$matches[,y_var], pch=20, xlab=x_var, ylab=y_var, col=c("blue","red")[factor(data$matches[,case_control])])
  legend("bottomright", legend=(c("Controls","Cases")), pch=20, col=c("blue","red"), bty = "n")

  if(line==T)
  {
    pair <- 0
    for (i in 1:length(data$matches[,1]))
    {
      if (data$matches$match_final[i]!=pair)
      {
        case_x <- data$matches[,x_var][i]
        case_y <- data$matches[,y_var][i]
        pair <- data$matches$match_final[i]
      }
      else
      {
        segments(case_x,case_y,data$matches[,x_var][i],data$matches[,y_var][i], col="gray", lty=3)
      }
    }
  }

}
