makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(patsubst %/,%, $(dir $(makefile_path)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
conda_path := $(makefile_dir)/miniconda3/bin/conda
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

Miniconda3-latest-MacOSX-x86_64.sh:
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

miniconda3/bin/conda: Miniconda3-latest-MacOSX-x86_64.sh
	bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $(makefile_dir)/miniconda3

miniconda3/envs/dependencies: environment.yaml miniconda3/bin/conda
	$(conda_path) env create --name dependencies --file $<

conda_update: environment.yaml
	source $(activate_path) dependencies && \
		conda env update -f=$< && echo 'done' > conda_update

packages/hrdtools/DESCRIPTION:
	mkdir -p packages/hrdtools && \
		svn checkout https://svn01.bcgsc.ca/svn/personal/ezhao/projects/signatures/trunk/hrdtools/ packages/hrdtools

r_packages: miniconda3/envs/dependencies packages/hrdtools/DESCRIPTION
	source $(activate_path) dependencies && \
		echo 'Installing R packages into this R install:' `which R` && \
		export R_LIBS=$(r_libs) && \
		export LD_LIBRARY_PATH=$(conda_libs) && \
		$(rscript_path) r_dependencies.R && \
		source $(deactivate_path) && \
		echo 'installed packages' > r_packages

miniconda3/envs/dependencies/etc/conda/activate.d/env_vars.sh: miniconda3/envs/dependencies
	mkdir -p miniconda3/envs/dependencies/etc/conda/activate.d && echo "export R_LIBS=$(r_libs)" > $@
