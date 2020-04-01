context("PCAmatchR")

 ##### Generate sample data to be used in test_that
 set.seed(18201) # make sure data is repeatable
 N=100
 Sigma <- matrix(.2,3,3)
 diag(Sigma) <- 1
 data<-matrix(mvrnorm(N, mu=rep(0, 3), Sigma, empirical = FALSE) , nrow=N, ncol = 3)

 # User original data
 mydata<- as.data.frame(data) # create dataframe
 mydata$sex<- rbinom(n=100, size=1, prob=0.5)
 mydata$race<- rbinom(n=100, size=2, prob=.50)
 mydata$CaCo<- c(rep(1, 10), rep(0, 90)) # case control status

 mydata$id<- c(1001:1100) # create an id variable
 # head(mydata)

 # Preform PCA on user data
 data.pca <- stats::prcomp(mydata[,1:3], scale = TRUE, center = TRUE)
 # summary(data.pca)

 # Create Eigen values
 eig.val <- factoextra::get_eigenvalue(data.pca)
 eigen_values<- eig.val[,1]
 # eigen_values

 # Create Individual PCs
 data.ind <- factoextra::get_pca_ind(data.pca)
 PCs<- as.data.frame(data.ind$coor) # This is the main loading for PCAmatchR
 PCs$id<- mydata$id
 # head(PCs)


test_that("PCamtachR throws error with invalid arguments", {
  skip_on_cran()

  expect_error(PCAmatchR(eigen_value = NULL,
                         PC = PCs,
                         data = mydata[,c(4:7)],
                         ids = c("id"),
                         case_control = c("CaCo"),
                         num_controls = 1,
                         num_PCs = 3)
               )
  expect_error(PCAmatchR(eigen_value = eigen_values,
                         PC = NULL,
                         data = mydata[,c(4:7)],
                         ids = c("id"),
                         case_control = c("CaCo"),
                         num_controls = 1,
                         num_PCs = 3)
               )
  expect_error(PCAmatchR(eigen_value = eigen_values,
                         PC = PCs,
                         data = NULL,
                         ids = c("id"),
                         case_control = c("CaCo"),
                         num_controls = 1,
                         num_PCs = 3)
               )
  expect_error(PCAmatchR(eigen_value = eigen_values,
                         PC = PCs,
                         data = mydata[,c(4:7)],
                         ids = NULL,
                         case_control = c("CaCo"),
                         num_controls = 1,
                         num_PCs = 3)
               )
  expect_error(PCAmatchR(eigen_value = eigen_values,
                         PC = PCs,
                         data = mydata[,c(4:7)],
                         ids = c("id"),
                         case_control = NULL,
                         num_controls = 1,
                         num_PCs = 3)
               )

 }
)

test_that("PCAmatchR works", {
  skip_on_cran()

  expect_named(PCAmatchR(eigen_value= eigen_values,
                                PC = PCs,
                                data = mydata[,c(4:7)],
                                ids = c("id"),
                                case_control = c("CaCo"),
                                num_controls = 1,
                                num_PCs = 3)
              )

 }
)
