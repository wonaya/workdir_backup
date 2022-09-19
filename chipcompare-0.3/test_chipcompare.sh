#!/bin/bash

#SBATCH -J chipcompare-api
#SBATCH -o chipcompare.%j.out
#SBATCH -e chipcompare.%j.err
#SBATCH -p development
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -A Springer_Vaughn

#input
REPTINPUT1=/iplant/home/shared/ncsu-plantreplication/07-21-14_Maize_RelicationTiming_Hiseq/mitotic-vs-endocycle/equal_EML/07_mitotic/ratio_segmentation.gff3
CHIPINPUT2=/iplant/home/jawon/API_test/8C_peaks.broadPeak
#mappable
MAPPABLE=/iplant/home/jawon/API_test/maize_chrOnly_Ns.bed
#fai
FAI=/iplant/home/jawon/API_test/Zea_mays.AGPv3.23_without_scaffold.fa.fai
PERM=100
MAX_MACS=100
MIN_MACS=50
# Unpack the bin.tgz file containing python scripts
 
module load bedtools

# Fetch data from iPlant Data Store
iget -fT $REPTINPUT1 .
iget -fT $CHIPINPUT2 . 
iget -fT $MAPPABLE . 
iget -fT $FAI .

INPUT1_F=$(basename ${REPTINPUT1})
INPUT2_F=$(basename ${CHIPINPUT2})
MAPPABLE_F=$(basename ${MAPPABLE})
FAI_F=$(basename ${FAI})
 
# Build up an ARGS string for the program
ARGS="--permutate_n $PERM --max_macs $MAX_MACS --min_macs $MIN_MACS"
 
# Run the actual program
python repchipcompare-0.1.py --test_1 ${INPUT1_F} --test_2 ${INPUT2_F} --Ncoord ${MAPPABLE_F} --fai ${FAI_F} ${ARGS}

rm ${INPUT1_F} ${INPUT2_F} ${MAPPABLE_F} ${FAI_F}