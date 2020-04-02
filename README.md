
# PCAmatchR

<!-- badges: start -->
<!-- badges: end -->
## Overview
The purpose of PCAmatchR is to match cases to controls based on genotype principal components.

<h2 id="install">

Installation

</h2>

To install the CRAN version:

    TBD

To install the development version from GitHub:

    devtools::install_github("machiela-lab/PCAmatchR")

<h2 id="available-functions">

Available functions

</h2>

<table>
<colgroup>
<col width="29%" />
<col width="70%" />
</colgroup>
<thead>
<tr class="header">
<th>Function</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>PCAmatchR</code></td>
<td>Main function. Weighted matching of controls to cases using PCA results.</td>
</tr>
<tr class="even">
<td><code>plot_matches</code></td>
<td>Plot matches from <code>PCAmatchR</code> output.</td>
</tr>
</tbody>
<table>
    
## Usage
``` r
##########
# N=100  #
##########
# Create Test Data
library(MASS)
library(factoextra)
library(DOS)

set.seed(18201) # make sure data is repeatable
N=100
Sigma <- matrix(.2,3,3)
diag(Sigma) <- 1
data<-matrix(MASS::mvrnorm(N, mu=rep(0, 3), Sigma, empirical = FALSE) , nrow=N, ncol = 3)

# User original data
mydata<- as.data.frame(data) # create dataframe
mydata$sex<- rbinom(n=100, size=1, prob=0.5)
mydata$race<- rbinom(n=100, size=2, prob=.50)
mydata$CaCo<- c(rep(1, 10), rep(0, 90)) # case control status

mydata$id<- c(1001:1100) # create an id variable
head(mydata)


# Preform PCA on user data
data.pca <- stats::prcomp(mydata[,1:3], scale = TRUE, center = TRUE)
summary(data.pca)


# Create Eigen values
eig.val <- factoextra::get_eigenvalue(data.pca)
eigen_values<- eig.val[,1]
eigen_values


# Create Individual PCs
data.ind <- factoextra::get_pca_ind(data.pca)
PCs<- as.data.frame(data.ind$coor) # This is the main loading for PCAmatchR
PCs$id<- mydata$id
head(PCs)


#################
# Run PCAmatchR #
#################

# 1 to 1 matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=1, num_variants= 3)
test$matches
test$weights


# 1 to 2 matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=2, num_variants= 3)
test$matches
test$weights


# 1 to 1 matching with exact "sex" matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=2, num_variants= 3, exact_match=c("sex"))
test$matches
test$weights



##########
# N=1000 #
##########
# Create Test Data
library(MASS)
library(factoextra)
library(DOS)

set.seed(18201) # make sure data is repeatable
N=1000
Sigma <- matrix(.2,3,3)
diag(Sigma) <- 1
data<-matrix(MASS::mvrnorm(N, mu=rep(0, 3), Sigma, empirical = FALSE) , nrow=N, ncol = 3)

# User original data
mydata<- as.data.frame(data) # create dataframe
mydata$sex<- rbinom(n=1000, size=1, prob=0.5)
mydata$race<- rbinom(n=1000, size=2, prob=.50)
mydata$CaCo<- c(rep(1, 100), rep(0, 900)) # case control status

mydata$id<- c(1001:2000) # create an id variable
head(mydata)


# Preform PCA on user data
data.pca <- stats::prcomp(mydata[,1:3], scale = TRUE, center = TRUE)
summary(data.pca)


# Create Eigen values
eig.val <- factoextra::get_eigenvalue(data.pca)
eigen_values<- eig.val[,1]
eigen_values


# Create Individual PCs
data.ind <- factoextra::get_pca_ind(data.pca)
PCs<- as.data.frame(data.ind$coor) # This is the main loading for PCAmatchR
PCs$id<- mydata$id
head(PCs)


#################
# Run PCAmatchR #
#################

# 1 to 1 matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=1, num_variants= 3)
test$matches
test$weights


# 1 to 5 matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=5, num_variants= 3)
test$matches
test$weights


# 1 to 2 matching with exact "sex" matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=2, num_variants= 3, exact_match=c("sex"))
test$matches
test$weights


# 1 to 1 matching with exact "sex" and "race" matching
test<- PCAmatchR(eigen_value= eigen_values, PC= PCs, data=mydata[,c(4:7)], ids=c("id"), z=c("CaCo") , controls=1, num_variants= 3, exact_match=c("sex", "race"))
test$matches
test$weights

```

``` r
library(PCAmatchR)
## basic example code
```

