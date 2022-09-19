#!/bin/bash

#SBATCH -J repliscan.api
#SBATCH -o repliscan.%j.out
#SBATCH -e repliscan.%j.err
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 06:00:00
#SBATCH -A iPlant-Collabs

REFERENCE=/work/02114/wonaya/genome/maize/Zea_mays.AGPv4.33/Zea_mays.AGPv4.dna.chrom.fa.fa
BAMTXT=/scratch/02114/wonaya/NCSU/07-21-14_Maize_RelicationTiming_Hiseq/bams_agpv4/input_ds.txt

module purge
module load TACC
module load biocontainers
module load bedtools/ctr-2.27.1--1
module load samtools/ctr-1.9--h91753b0_5

export PATH=$PWD:$PATH

ARGS=""
# Build up an ARGS string for the program

# Run the actual program
repliscan_removing_blacklist.py -r ${REFERENCE} -f input_ds.txt
