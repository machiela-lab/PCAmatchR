#' Principal components of 2504 individuals from the 1000 Genome Project
#'
#' A sample dataset containing information about population, gender, and
#' 20 principal components calculated from the 2504 individuals in Phase 3
#' of the 1000 Genomes Project.
#'
#' @format A data frame with 2504 rows and 24 variables:
#' \describe{
#'   \item{sample}{sample ID number}
#'   \item{pop}{three letter designation of 1000 Genomes reference population}
#'   \item{super_pop}{three letter designation of 1000 Genomes reference super population}
#'   \item{gender}{gender of individual}
#'   \item{PC1}{principal component 1}
#'   \item{PC2}{principal component 2}
#'   \item{PC3}{principal component 3}
#'   \item{PC4}{principal component 4}
#'   \item{PC5}{principal component 5}
#'   \item{PC6}{principal component 6}
#'   \item{PC7}{principal component 7}
#'   \item{PC8}{principal component 8}
#'   \item{PC9}{principal component 9}
#'   \item{PC10}{principal component 10}
#'   \item{PC11}{principal component 11}
#'   \item{PC12}{principal component 12}
#'   \item{PC13}{principal component 13}
#'   \item{PC14}{principal component 14}
#'   \item{PC15}{principal component 15}
#'   \item{PC16}{principal component 16}
#'   \item{PC17}{principal component 17}
#'   \item{PC18}{principal component 18}
#'   \item{PC19}{principal component 19}
#'   \item{PC20}{principal component 20}
#'
#' }
#' @examples
#' \donttest{head(PCs_1000G)}
#' \donttest{genome_PC <- PCs_1000G}
#' \donttest{# Create PCs
#'            PC <- as.data.frame(genome_PC[,c(1,5:24)])
#'            head(PC)}
#'
#' @source \url{https://www.internationalgenome.org}
"PCs_1000G"
