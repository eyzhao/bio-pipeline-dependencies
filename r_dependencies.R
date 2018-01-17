.libPaths(.libPaths()[1])
print(sprintf('Installing packages into %s', .libPaths()))

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 

suppressMessages(source("https://bioconductor.org/biocLite.R"))

bioc_package <- function(pkgname) {
    if (is.installed(pkgname)) {
        print(sprintf('%s already installed.', pkgname))
    } else {
        biocLite(pkgname)
    }
}

cran_package <- function(pkgname) {
    if (is.installed(pkgname)) {
        print(sprintf('%s already installed.', pkgname))
    } else {
        install.packages(pkgname, repos='http://cran.us.r-project.org')
    }
}

custom_package <- function(pkgname, pkgpath) {
    if (is.installed(pkgname)) {
        print(sprintf('%s already installed', pkgname))
    } else {
        library(devtools)
        install(pkgpath)
    }
}

bioc_package('copynumber')
bioc_package('signeR')

cran_package('nnls')
cran_package('dbscan')
cran_package('cowplot')
cran_package('deconstructSigs')
cran_package('mutSignatures')
cran_package('cancerTiming')
cran_package('rjags')
cran_package('coda')
cran_package('R.matlab')
cran_package('GenSA')
cran_package('rmutil')
cran_package('ggraph')

# Install the latest rmarkdown
if (getOption('unzip') == '') {
    options(unzip = 'internal')
}

devtools::install_github('rstudio/rmarkdown')

custom_package('hrdtools', 'packages/hrdtools')

