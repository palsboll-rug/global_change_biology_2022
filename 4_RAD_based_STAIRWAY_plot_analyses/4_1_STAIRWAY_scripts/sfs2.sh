#!/bin/bash

#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --job-name=real_sfs
#SBATCH --mail-type=
#SBATCH --mail-user=


#load angsd. angsd should have been already installed.
#the angsd version used in paper was ver. 0.913
module load angsd

#----------
#Necessary information that should be provided to run the script
#----------
#.saf.idx file generate by the first step - script sfs.sh
input_file=$1 
#output file name
out_file=$2

#----------
#Commands
#----------
realSFS ${input_file} -P 10 >${out_file}.em
