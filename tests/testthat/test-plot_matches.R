context("plot_matches")

 ##### Input PCAmatchR sample data to be used in test_that

 # Create PC data frame
 pcs<- as.data.frame(sample_PCs_1000G[,c(1,5:24)])

 # Create eigen values vector
 eigen_vals<- c(eigenvalues)$eigen_values

 # Create Covarite data frame
 cov_data<- sample_PCs_1000G[,c(1:4)]

 # Generate a case status variable
 cov_data$case <- ifelse(cov_data$pop=="ESN", c(1), c(0))


test_that("plot_matches throws error with invalid arguments", {

  PCAmatchR_output<- PCAmatchR(PC = pcs,
                               eigen_value = eigen_vals,
                               data = cov_data,
                               ids = c("sample"),
                               case_control="case",
                               num_controls = 1,
                               num_PCs = dim(cov_data)[1])


  expect_error(plot_matches(data=NULL,
                            x_var="PC1",
                            y_var="PC2",
                            case_control="case",
                            line=T)
  )
  expect_error(plot_matches(data=PCAmatchR_output,
                            x_var=NULL,
                            y_var="PC2",
                            case_control="case",
                            line=T)
  )
  expect_error(plot_matches(data=PCAmatchR_output,
                            x_var="PC1",
                            y_var=NULL,
                            case_control="case",
                            line=T)
  )
  expect_error(plot_matches(data=PCAmatchR_output,
                            x_var="PC1",
                            y_var="PC2",
                            case_control=NULL,
                            line=T)
  )

 }
)

test_that("plot_matches works", {
  expect_error(plot<-plot_matches(data=PCAmatchR_output,
                            x_var="PC1",
                            y_var="PC2",
                            case_control="case",
                            line=T),
               NA)

 }
)

