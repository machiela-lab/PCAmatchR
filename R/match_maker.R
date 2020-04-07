#' match_maker
#'
#' @param PC Individual level principle components.
#' @param eigen_value Computed eigen value for each PC. Used to calculate the percent variance explained by each PC.
#' @param data Dataframe containing id and case/control status. Optionally includes covariate data for exact matching.
#' @param ids The unique id variable contained in both "PC" and "data."
#' @param case_control The case control status variable.
#' @param num_controls The number of controls to match to each case. Default is 1:1 matching.
#' @param num_PCs The total number of PCs calculated within the PCA. Default is 1000.
#' @param exact_match Optional variables contained in the dataframe on which to perform exact matching (i.e. sex, race, etc.).
#' @param weight_dist When set to true, matches are produced based on PC weighted Mahalanobis distance. Default is TRUE.
#' @param weights Optional user defined weights used to compute the weighted Mahalanobis distance metric.
#'
#' @return A list of matches and weights.
#' @importFrom utils capture.output
#' @export
#'
#' @examples
#' \dontrun{library(optmatch)}
#' \dontrun{test<- match_maker(PC= pcs,
#'                             eigen_value= eigen_vals,
#'                             data=cov_data,
#'                             ids=c("sample"),
#'                             case_control=c("case"),
#'                             num_controls=1,
#'                             num_PCs= dim(cov_data)[1],
#'                             exact_match= NULL,
#'                             weight_dist=TRUE)}
#'
match_maker <- function(PC=NULL, eigen_value=NULL, data=NULL, ids=NULL, case_control=NULL, num_controls=1, num_PCs= 1000, exact_match=NULL, weight_dist=TRUE, weights=NULL){

  ################################
  # Check for "optmatch" package #
  ################################

  if (!"optmatch" %in% tolower((.packages()))) {
    stop('The package optmatch (>= 0.9-1) not loaded.  To run the PCAmatchR match_maker()
          function, you must manually install and load the "optmatch" package first and
          agree to the terms of its license.  This is required due to software license
          issues.'
    )
  }

  #####################
  # Warnings Messages #
  #####################

  # Error if Eigen values and weights are both supplied
  if(length(eigen_value) > 0 & length(weights) >0 ){
    stop("Please specify either eigen values or weights.")
  }


  # Check Number of PCs equals number of eigen values/weights
  if(length(eigen_value) > 0){
    if((dim(PC)[2]-1) != length(eigen_value) ){
      stop("Number of PCs should equal number of eigen values.")
    }

  } else if (length(weights) > 0){
    if((dim(PC)[2]-1) != length(weights) ){
      stop("Number of PCs should equal number of supplied weights.")
    }
  }


  # User defined dataframe
  if(is.null(data)){
    stop("Please specify the data frame which contains id and case/control status variables.")
  }


  # User defined IDs
  if(is.null(data[ids])){
    stop("Please specify the ID variable in the dataframe.")
  }

  if(is.null(PC[ids])){
    stop("Please specify the ID variable in the PC data.")
  }


  # User defined Case control status
  if(is.null(data[case_control])){
    stop("Please specify the case/control status variable.")
  }


  # Number of variants used to calculate weights
  if(num_PCs== 1000 & weight_dist== TRUE){
    warning("Weights computed assuming 1,000 total PCs. Number of PCs can be defined using the num_PCs variable.")
  }


  # Percent Variance Explained sums to less than or equal to 1
  if(length(eigen_value) > 0){
    if(weight_dist== TRUE & sum(eigen_value) > num_PCs + 0.000001){
      stop("Ensure percent variance explained of PCs sums to less than or equal to 1.")
    }
  }


  ################
  # End Warnings #
  ################


  # Check for exact matches
  if(is.null(exact_match)){
    exact_class <- rep(1,nrow(data))

  } else if (length(exact_match) !=0){

    exact_class<- do.call(paste, c(data[exact_match], sep=""))
  }

  PC_combine1<- as.data.frame(cbind(data, exact_class))

  PC_combine<- merge(PC, PC_combine1[c(ids, case_control, "exact_class")], by=ids)
  rownames(PC_combine)<- PC_combine[[ids]]
  PC_combine<- PC_combine[order(-PC_combine[case_control]),]


  # Create Loop for exact matching
  matched_results<- list()

  for (k in levels(as.factor(PC_combine$exact_class))){

    PC_subset<- PC_combine[which(PC_combine$exact_class==k),]
    PC_subset_cases    <- PC_subset[PC_subset[case_control] == 1,]
    PC_subset_controls <- PC_subset[PC_subset[case_control] == 0,]

    # Create Distance Matrix

    n <- dim(PC_subset)[1]
    m1 <- sum(PC_subset[case_control])
    m0 <- n-m1

    distance_matrix <- matrix(NA, m1, n - m1)

    rownames(distance_matrix) <- PC_subset_cases[ids][PC_subset_cases[case_control] == 1]
    colnames(distance_matrix) <- PC_subset_controls[ids][PC_subset_controls[case_control] == 0]


    # Fill distance matrix with Mahalanobis distance

    # Un-weighted Mahalanobis distance

    if(weight_dist==FALSE){
      PC_data<- as.matrix(PC_combine[,-match(c(ids, case_control, "exact_class"), names(PC_combine))])

      PC_subset_cases<- as.matrix(PC_subset_cases[,-match(c(ids, case_control, "exact_class"), names(PC_subset_cases))])
      PC_subset_controls<- as.matrix(PC_subset_controls[,-match(c(ids, case_control, "exact_class"), names(PC_subset_controls))])

      cov<- solve(cov(PC_data)) #taken out of loop to speed up computations, based on all PCs

      weight_output<- NULL

      for (j in 1:ncol(distance_matrix)){
        X<- sweep(PC_subset_cases, 2, PC_subset_controls[j,], "-")

        distance_matrix[,j]<- diag(X %*% cov %*% t(X))
      }

      distance_matrix<- sqrt(distance_matrix)
    } else{


      # Weighted Mahalanobis distance

      PC_data<- as.matrix(PC_combine[,-match(c(ids, case_control, "exact_class"), names(PC_combine))])

      PC_subset_cases<- as.matrix(PC_subset_cases[,-match(c(ids, case_control, "exact_class"), names(PC_subset_cases))])
      PC_subset_controls<- as.matrix(PC_subset_controls[,-match(c(ids, case_control, "exact_class"), names(PC_subset_controls))])

      weight_matrix <- matrix(0,dim(PC_data)[2],dim(PC_data)[2])

      if(length(eigen_value) >0){
        diag(weight_matrix) <- eigen_value/num_PCs
      } else {
        diag(weight_matrix) <- weights
      }

      cov<- weight_matrix %*% solve(cov(PC_data)) #taken out of loop to speed up computations

      weight_output<- as.data.frame(rbind(diag(weight_matrix)))
      colnames(weight_output) <- c(paste("w",c(1:dim(PC_data)[2]),sep=""))

      for (j in 1:ncol(distance_matrix)){
        X<- sweep(PC_subset_cases, 2, PC_subset_controls[j,], "-")

        distance_matrix[,j]<- diag(X %*% cov %*% t(X))
      }

      distance_matrix<- sqrt(distance_matrix)
    }



    # Create Matches
    match <- optmatch::pairmatch(distance_matrix, data=PC_subset, controls=num_controls, remove.unmatchables=TRUE)

    matched<- as.data.frame(cbind(PC_subset, match))

    # Order the data by case status and match
    matched_ordered<- matched[order(matched$match, -matched[case_control]),]

    # Remove records with no match
    matched_ordered2<- matched_ordered[which(!is.na(matched_ordered$match)),]

    # Pull match distance
    matched_distance<- c()

    for (l in levels(matched_ordered2$match)){
      dis_id<- matched_ordered2[ids][matched_ordered2["match"] == as.character(l)]

      invisible(capture.output(dis_values<-distance_matrix[dput(as.character(dis_id[1])),dput(as.character(dis_id[-1]))]))
      matched_distance<- c(matched_distance, 0, dis_values)
    }

    matched_ordered2$match_distance<- matched_distance

    # Combine class matches
    matched_ordered2$match_class<- paste(matched_ordered2$exact_class, matched_ordered2$match, sep="-")

    # Save Final Matches
    matched_results[[k]]<- matched_ordered2


  } # End Loop

  # Combine exact matches

  matches_final<- do.call(rbind, matched_results)
  matches_final$match_final<- cumsum(!duplicated( matches_final[ncol(matches_final)]))

  merged_matches<- merge(data,  matches_final[c(ids, "exact_class", "match_final", "match_distance")], by=ids)
  merged_matches<- merged_matches[order(merged_matches$match_final, -merged_matches[case_control]),]
  rownames(merged_matches)<- 1:nrow(merged_matches)
  colnames(merged_matches)[colnames(merged_matches) == "exact_class"] <- "match_strata"


  # Merge matches with PC data
  merged_PC<- merge(merged_matches, PC, by=ids)
  merged_PC<- merged_PC[order(merged_PC$match_final, -merged_PC[case_control]),]
  rownames(merged_PC)<- 1:nrow(merged_PC)

  returnlist<- (list(matches= merged_matches, weights= weight_output, PC_matches= merged_PC, NULL=NULL))
  returnlistfinal<- returnlist[-which(sapply(returnlist, is.null))]
  return(returnlistfinal)
}

#################
# End match_maker #
#################
