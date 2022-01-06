#!/bin/bash

#SBATCH --ntasks=
#SBATCH --nodes=
#SBATCH --cpus-per-task=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --job-name=sam_to_bam
#SBATCH --mail-type=
#SBATCH --mail-user=
#SBATCH --output=sam_to_bam
#SBATCH --array=(should be adjusted to the number of individuals in your IDs_file)


#load Bowtie2. Bowtie2 should have been already installed.
#the Bowtie2 version used in paper was ver. 2.2.8
module load SAMtools

#----------
#Necessary information that should be provided to run the script
#----------
#File with the IDs to be considered. The "IDs_file" contains one ID per line (the ones used in the paper can be found in the folder "ID_files")
IDs_file=$1
#path to the directory where the sam files are stored. It is also the directory where the bam files will be created
Folder=$2

#----------
#Commands
#----------
#read the "IDs_file" and create a job for each ID using array job from slurm.
#The "IDs_file" contains one ID per line (the ones used in the paper can be found in the folder "ID_files")
line=$(sed -n "${SLURM_ARRAY_TASK_ID}{p;q;}" ${IDs_file})
#convert the sam file to bam
samtools view -bS ${Folder}/${line}.sam > ${Folder}/${line}.bam
#sort bam file
samtools sort ${Folder}/${line}.bam > ${Folder}/${line}_sorted.bam

