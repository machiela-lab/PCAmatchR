context("match_maker")

 ##### Input match_maker sample data to be used in test_that

 # Create PC data frame
 pcs<- as.data.frame(PCs_1000G[,c(1,5:24)])

 # Create eigen values vector
 eigen_vals<- c(eigenvalues_1000G)$eigen_values

 # Create Covarite data frame
 cov_data<- PCs_1000G[,c(1:4)]

 # Generate a case status variable
 cov_data$case <- ifelse(cov_data$pop=="ESN", c(1), c(0))

 test_that("match_maker throws an error without optmatch loaded", {
   expect_error(match_maker(PC = pcs,
                            eigen_value = eigen_vals,
                            data = cov_data,
                            ids = c("sample"),
                            case_control = c("case"),
                            num_controls = 1,
                            num_PCs = dim(cov_data)[1])
                )

  }
)

library(optmatch)

test_that("PCamtachR throws error with invalid arguments", {
  expect_error(match_maker(PC = NULL,
                         eigen_value = eigen_vals,
                         data = cov_data,
                         ids = c("sample"),
                         case_control = c("case"),
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
               )
  expect_error(match_maker(PC = pcs,
                         eigen_value = NULL,
                         data = cov_data,
                         ids = c("sample"),
                         case_control = c("case"),
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
  )
  expect_error(match_maker(PC = pcs,
                         eigen_value = eigen_vals,
                         data = NULL,
                         ids = c("sample"),
                         case_control = c("case"),
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
  )
  expect_error(match_maker(PC = pcs,
                         eigen_value = eigen_vals,
                         data = cov_data,
                         ids = NULL,
                         case_control = c("case"),
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
  )
  expect_error(match_maker(PC = pcs,
                         eigen_value = eigen_vals,
                         data = cov_data,
                         ids = c("sample"),
                         case_control = NULL,
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
  )

 }
)

test_that("match_maker works", {
  expect_named(match_maker(PC = pcs,
                         eigen_value = eigen_vals,
                         data = cov_data,
                         ids = c("sample"),
                         case_control = c("case"),
                         num_controls = 1,
                         num_PCs = dim(cov_data)[1])
              )

 }
)

test_that("matches has correct dimensions", {
  test1<- match_maker(PC = pcs,
                    eigen_value = eigen_vals,
                    data = cov_data,
                    ids = c("sample"),
                    case_control = c("case"),
                    num_controls = 1,
                    num_PCs = dim(cov_data)[1])
  expect_equal(dim(test1$matches)[1], 198)
  expect_equal(dim(test1$matches)[2], 8)
 }
)

test_that("weights has correct dimension", {
  test1<- match_maker(PC = pcs,
                    eigen_value = eigen_vals,
                    data = cov_data,
                    ids = c("sample"),
                    case_control = c("case"),
                    num_controls = 1,
                    num_PCs = dim(cov_data)[1])
  expect_equal(dim(test1$weights)[2], 20)

 }
)

test_that("match_maker throws an error without optmatch loaded", {
  expect_named(match_maker(PC = pcs,
                           eigen_value = eigen_vals,
                           data = cov_data,
                           ids = c("sample"),
                           case_control = c("case"),
                           num_controls = 1,
                           num_PCs = dim(cov_data)[1])
  )

}
)

