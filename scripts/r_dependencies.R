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


