#' Function to plot matches from match_maker output
#'
#' @param data match_maker output
#' @param x_var Principal component 1
#' @param y_var Principal component 2
#' @param case_control Case or control status
#' @param line draw line
#'
#' @return A plot
#' @importFrom graphics legend plot segments
#' @export
#'
#' @examples
#'\donttest{plot_maker(data=match_maker_output,
#'                      x_var="PC1",
#'                      y_var="PC2",
#'                      case_control="case",
#'                      line=T)}
#'
plot_maker <- function(data=NULL, x_var=NULL, y_var=NULL, case_control=NULL, line=T)
{
  # Check function input
  if(is.null(data))
  {
    stop("Please specify the match_maker data frame.")
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

  plot(data$PC_matches[,x_var], data$PC_matches[,y_var], pch=20, xlab=x_var, ylab=y_var, col=c("blue","red")[factor(data$PC_matches[,case_control])])
  legend("bottomright", legend=(c("Controls","Cases")), pch=20, col=c("blue","red"), bty = "n")

  if(line==T)
  {
    pair <- 0
    for (i in 1:length(data$PC_matches[,1]))
    {
      if (data$PC_matches$match_final[i]!=pair)
      {
        case_x <- data$PC_matches[,x_var][i]
        case_y <- data$PC_matches[,y_var][i]
        pair <- data$PC_matches$match_final[i]
      }
      else
      {
        segments(case_x,case_y,data$PC_matches[,x_var][i],data$PC_matches[,y_var][i], col="gray", lty=3)
      }
    }
  }

}
