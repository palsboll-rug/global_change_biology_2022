#!/bin/bash

#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --time=
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --job-name=SFS_angsd
#SBATCH --mail-type=
#SBATCH --mail-user=


#load angsd. angsd should have been already installed.
#the angsd version used in paper was ver. 0.913
module load angsd

#----------
#Necessary information that should be provided to run the script
#----------
#input the list of the location of the bam files
infile_bamlist=$1 
#input the reference genome (if in a different folder, include the path)
reference=$2
#output file name
output=$3
#minimum number of individuals (for this paper the equivalent to 80% of the individuals)
minInd=$4
#minimum depth (10  and 2 for this paper)
minIndDepth=$5
#genotype likelihood (2 for this paper - GATK model)
GL=$6

#----------
#Commands
#----------
angsd -dosaf 1 -GL ${GL} \
-bam ${infile_bamlist} \
-underFlowProtect 1 \
-fold 1 -anc ${reference} \
-minMapQ 10 -minQ 20 -minInd ${minInd} \
-minIndDepth ${minIndDepth} -uniqueOnly 1 \
-out ${output}