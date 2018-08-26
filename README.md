# Anaconda-based Dependency Environment for Biological Data Analyses

[Anaconda](https://anaconda.org/) provides convenient package management for data science dependencies. Not only can Anaconda manage Python packages, it can also be used to install other programming languages such as R, and manage their packages. [Environments](https://conda.io/docs/user-guide/tasks/manage-environments.html) can be defined to document and facilitate easy installation of package sets, including specifying version numbers. This is helpful for reproducible data analyses.

Most of my packages developed for biological data analyses rely on many dependencies, all of which are bundled here. This Anaconda virtual environment can be installed and executed on a Unix-based terminal using the following commands.

```{bash}
git clone https://github.com/eyzhao/bio-pipeline-dependencies.git
make
source miniconda3/bin/activate dependencies
```

Some packages, for example [SignIT](https://www.github.com/eyzhao/SignIT), use a specific branch or tag of this environment. This can be accessed as follows:

```{bash}
git clone https://github.com/eyzhao/bio-pipeline-dependencies.git
cd bio-pipeline-dependencies
git checkout tags/SignIT-paper-dependencies
make
```

Note that this environment was designed and tested on Linux, CentOS6. Anaconda is made to be cross-platform. As packages and repositories are constantly in flux, there is always the possibility that things could break. Please don't hesitate to raise an issue here if this should occur.
