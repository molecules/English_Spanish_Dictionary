#!/usr/bin/bash -l
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 
# # Create conda base installation
# ## Assumes miniconda install script already downloaded
# # Run in "batch" mode (-b) using the prefix (i.e. directory) "conda"
# bash Miniconda3-latest-Linux-x86_64.sh -b -p conda
# 
# # Activate base conda environment
# source conda/bin/activate
# 
# # Set channel priority so that conda-forge has the highest priority, since it
# #   tends to have the newest/best packages
# conda config --add channels defaults
# conda config --add channels bioconda
# conda config --add channels conda-forge
# conda config --set channel_priority strict

conda install --yes \
    r-base `# basic R (should be at least R-4.2.2)` \
    r-rmarkdown `# render R markdown files as PDF` \
    r-styler `# style help for R code` \
    r-tidyverse `# dplyr, furrr, ggplot2` \
    r-tinytex `# additinoal dependency needed to create PDF documents` \
    texlive-core `# additinoal dependency needed to create PDF documents` \

