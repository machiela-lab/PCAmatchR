#' All eigenvalues of 2504 individuals from the 1000 Genome Project
#'
#' A sample dataset containing all the eigenvalues
#' calculated from 2504 individuals in the Phase 3 data
#' release of the 1000 Genomes Project. The principal
#' component analysis was conducted using PLINK.
#'
#' @format A data frame with 2504 rows and 1 variable:
#' \describe{
#'   \item{eigen_values}{calculated eigennvalues}
#' }
#'
#' @examples
#'   eigenvalues_all_1000G
#' \donttest{genome_values <- eigenvalues_all_1000G
#'           values <- c(genome_values)$eigen_values
#' }
#'
#' @source {Machiela Lab}
"eigenvalues_all_1000G"
