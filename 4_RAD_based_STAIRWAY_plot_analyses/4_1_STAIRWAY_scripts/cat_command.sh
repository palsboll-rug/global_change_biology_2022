#!/bin/bash

# input ($1) is a plain text file with sample IDs, one per line

while read -r id
do
	cat library1_${id}.1.fq.gz  library2_${id}.1.fq.gz > combined_${id}.1.fq.gz
	cat library1_${id}.2.fq.gz  library2_${id}.2.fq.gz > combined_${id}.2.fq.gz
	cat library1_${id}.rem.1.fq.gz  library2_${id}.rem.1.fq.gz > combined_${id}.rem.1.fq.gz
	cat library1_${id}.rem.2.fq.gz  library12_${id}.rem.2.fq.gz > combined_${id}.rem.2.fq.gz
done < ${1}
