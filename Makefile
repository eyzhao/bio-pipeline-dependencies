makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(patsubst %/,%, $(dir $(makefile_path)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
bin_dir := $(makefile_dir)/miniconda3/bin
conda_path := $(bin_dir)/conda
activate_path := $(makefile_dir)/miniconda3/bin/activate
deactivate_path := $(makefile_dir)/miniconda3/bin/deactivate
rscript_path := $(makefile_dir)/miniconda3/envs/dependencies/bin/Rscript
snakemake_path := $(makefile_dir)/miniconda3/envs/dependencies/bin/snakemake
conda_libs := $(makefile_dir)/miniconda3/envs/dependencies/lib
r_libs := $(makefile_dir)/miniconda3/envs/dependencies/lib/R/library
env_dir := $(makefile_dir)/miniconda3/envs/dependencies

all: miniconda3/bin/conda \
	miniconda3/envs/dependencies \
	r_packages \
	miniconda3/envs/dependencies/etc/conda/activate.d/env_vars.sh

Miniconda3-latest-Linux-x86_64.sh:
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

miniconda3/bin/conda: Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b -p $(makefile_dir)/miniconda3

miniconda3/envs/dependencies: miniconda3/bin/conda
	$(conda_path) create --name dependencies -y && \
	. miniconda3/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	conda install -c bioconda docopt snakemake -y && \
	conda install -c conda-forge r-docopt r-devtools r-roxygen2 r-cowplot r-stringr r-tidyverse r-doparallel -y && \
	conda install -y -c r r-mass r-rcpp r-doparallel r-foreach r-igraph r-rstan && \
	conda install -y -c conda-forge r-igraph r-loo r-nnls r-rmutil r-purrr && \
	conda install -y -c bioconda bioconductor-bsgenome

conda_update: miniconda3/envs/dependencies
	. miniconda3/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	conda env update -f=$< && echo 'done' > conda_update

r_packages: miniconda3/envs/dependencies
	. miniconda3/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	echo 'Installing R packages into this R install:' `which R` && \
	export R_LIBS=$(r_libs) && \
	export LD_LIBRARY_PATH=$(conda_libs) && \
	$(rscript_path) scripts/r_dependencies.R && \
	echo 'installed packages' > r_packages

miniconda3/envs/dependencies/etc/conda/activate.d/env_vars.sh: miniconda3/envs/dependencies
	mkdir -p miniconda3/envs/dependencies/etc/conda/activate.d && echo "export R_LIBS=$(r_libs)" > $@
