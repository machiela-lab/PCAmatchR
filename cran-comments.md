## This is the fourth release
* Adds requested changes to package to make the `optmatch` package conditionally suggested
in examples and testthat.
* Create static vignette.
* Other minor changes
 
## Test environments
* local OS X install, R 4.1.2
* local Windows 10 install, R 3.6.3
* win-builder, (devel, oldrelease, release)
* Rhub:
  * Windows Server 2022, R-devel, 64 bit
  * Windows Server 2008 R2 SP1, R-release, 32/64 bit
  * Ubuntu Linux 20.04.1 LTS, R-release, GCC
  * Fedora Linux, R-devel, clang, gfortran
  * Debian Linux, R-devel, clang, ISO-8859-15 locale
 
## R CMD check results
There were no ERRORs or WARNINGs.
 
There was 1 NOTE:
 
* checking package dependencies ... NOTE
  Package suggested but not available for checking: 'optmatch'
 
The requested changes from CRAN to make `optmatch` conditionally suggested addresses
this note.
 
## Reverse Dependency Check
None found
 
## Submitted by contributor/co-author
 
