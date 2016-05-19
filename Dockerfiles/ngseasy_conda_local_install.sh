#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

## version
VERSION="0.1"

INSTALL_DIR="/home/${USER}"

echo "Installing to [${INSTALL_DIR}]"

cd ${INSTALL_DIR} && pwd

wget https://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh && \
/bin/bash ./Anaconda2-4.0.0-Linux-x86_64.sh -b -p ${INSTALL_DIR}/anaconda2 && \
rm -v ./Anaconda2-4.0.0-Linux-x86_64.sh
echo "Anaconda is being installed at [${INSTALL_DIR}/anaconda2]"

# add conda bin to path
export PATH=$PATH:${INSTALL_DIR}/anaconda2/bin
echo 'PATH=$PATH:${INSTALL_DIR}/anaconda2/bin' >> /home/${USER}/.bashrc

# setup conda
conda update -y conda
conda update -y conda-build
conda update -y --all
mkdir -p ${INSTALL_DIR}/anaconda2/conda-bld/linux-64 ${INSTALL_DIR}/anaconda2/conda-bld/osx-64
conda index ${INSTALL_DIR}/anaconda2/conda-bld/linux-64 ${INSTALL_DIR}/anaconda2/conda-bld/osx-64

## add channels
conda config --add channels bioconda
conda config --add channels r
conda config --add channels sjnewhouse


## ngs tools
wget https://github.com/KHP-Informatics/ngseasy/blob/f1000_dev/Dockerfiles/ngs_conda_tool_list.txt

## create ngseasy environment python >=2.7 for ngs tools
conda create --yes --name ngseasy --file ngs_conda_tool_list.txt
source activate ngseasy

rm -v ./ngs_conda_tool_list.txt

## update nextflow
nextflow self-update

# list
TIME_STAMP=`date +"%d-%m-%y"`
conda list -e > ${INSTALL_DIR}/anaconda2/ngseasy-spec-file-${TIME_STAMP}.txt
