#!/bin/bash

#SBATCH --nodes=
#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --partition=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --job-name=process_radtags
#SBATCH --mail-type=
#SBATCH --mail-user=


#load Stacks. Stacks should have been already installed.
#the Stacks version used in paper was ver. 1.47
module load Stacks

#----------
#Necessary information that should be provided to run the script
#----------
#input the working directory. All the files should be in also be in this directory
#it is also where the output will be created
input_folder=$1
#name of the output directory
output_folder=$2
#file containing the individual ID and barcode list
barcodes_file=$3
# first enzyme used in the ddRAD protocol
enzyme1=$4
# second enzyme used in tje ddRAD protocol
enzyme2=$5

#----------
#process_radtags command
#----------
process_radtags -P -p ./${input_folder}/ \
-o ./${output_folder}/ \
-b ./${barcodes_file} \
--inline_index --renz_1 ${enzyme1} --renz_2 ${enzyme2} \
-r -c -q -i gzfastq
