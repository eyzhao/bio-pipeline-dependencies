makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(patsubst %/,%, $(dir $(makefile_path)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
bin_dir := $(makefile_dir)/miniconda2/bin
conda_path := $(bin_dir)/conda
activate_path := $(makefile_dir)/miniconda2/bin/activate
deactivate_path := $(makefile_dir)/miniconda2/bin/deactivate
rscript_path := $(makefile_dir)/miniconda2/envs/dependencies/bin/Rscript
snakemake_path := $(makefile_dir)/miniconda2/envs/dependencies/bin/snakemake
conda_libs := $(makefile_dir)/miniconda2/envs/dependencies/lib
r_libs := $(makefile_dir)/miniconda2/envs/dependencies/lib/R/library
env_dir := $(makefile_dir)/miniconda2/envs/dependencies

all: miniconda2/bin/conda \
	miniconda2/envs/dependencies \
	r_packages \
	miniconda2/envs/dependencies/etc/conda/activate.d/env_vars.sh

Miniconda2-latest-Linux-x86_64.sh:
	wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh

miniconda2/bin/conda: Miniconda2-latest-Linux-x86_64.sh
	bash Miniconda2-latest-Linux-x86_64.sh -b -p $(makefile_dir)/miniconda2

miniconda2/envs/dependencies: miniconda2/bin/conda
	$(conda_path) create --name dependencies python=2.7 -y && \
	. miniconda2/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	conda install -c bioconda docopt snakemake -y && \
	conda install -c conda-forge r-docopt r-devtools r-roxygen2 r-cowplot r-stringr r-tidyverse r-doparallel -y && \
	pip install --upgrade https://github.com/Theano/Theano/archive/master.zip && \
	pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip && \
	pip install cancerscope

conda_update: miniconda2/envs/dependencies
	. miniconda2/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	conda env update -f=$< && echo 'done' > conda_update

r_packages: miniconda2/envs/dependencies
	. miniconda2/etc/profile.d/conda.sh && \
	conda activate dependencies && \
	echo 'Installing R packages into this R install:' `which R` && \
	export R_LIBS=$(r_libs) && \
	export LD_LIBRARY_PATH=$(conda_libs) && \
	$(rscript_path) scripts/r_dependencies.R && \
	echo 'installed packages' > r_packages

miniconda2/envs/dependencies/etc/conda/activate.d/env_vars.sh: miniconda2/envs/dependencies
	mkdir -p miniconda2/envs/dependencies/etc/conda/activate.d && echo "export R_LIBS=$(r_libs)" > $@
