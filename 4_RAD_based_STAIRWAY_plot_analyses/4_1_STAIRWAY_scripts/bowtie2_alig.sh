#!/bin/bash

#SBATCH --ntasks=
#SBATCH --nodes=
#SBATCH --cpus-per-task=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --job-name=Bowtie2_alig
#SBATCH --mail-type=
#SBATCH --mail-user=
#SBATCH --array= (should be adjusted to the number of individuals in your IDs_file)
#SBATCH --output=Bowtie2_alig_%a


#load Bowtie2. Bowtie2 should have been already installed.
#the Bowtie2 version used in paper was ver. 2.2.8
module load Bowtie2

#----------
#Necessary information that should be provided to run the script
#----------
#path to the directory where the reference genome is stored, flowed by the bowtie name
genome_folder=$1 
#path to the directory where the samples are stored (the outputs from process_radtags)
samples_folder=$2
#path to the output folder
output_folder=$3
#File with the IDs to be considered. The "IDs_file" contains one ID per line (the ones used in the paper can be found in the folder "ID_files")
IDs_file=$4

#----------
#Commands
#----------
#read the "IDs_file" and create a job for each ID using array job from slurm.
line=$(sed -n "${SLURM_ARRAY_TASK_ID}{p;q;}" ${IDs_file})
#print the line that was read from the "IDs_file"
echo ${line}
#Run Bowtie2
bowtie2 -x ./${genome_folder} -1 ${samples_folder}/${line}.1.fq.gz -2 ${samples_folder}/${line}.2.fq.gz --very-sensitive -S ./${output_folder}/${line}.sam -X 600 --no-discordant 
