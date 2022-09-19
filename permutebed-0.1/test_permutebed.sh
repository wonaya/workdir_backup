#!/bin/bash

#SBATCH -J testpermutebed-api
#SBATCH -o permutebed.%j.out
#SBATCH -e permutebed.%j.err
#SBATCH -p development
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -A Springer_Vaughn

#input
BED1=/iplant/home/jawon/API_test/2C_peaks.broadPeak
BED2=/iplant/home/jawon/API_test/8C_peaks.broadPeak
#mappable
MAPPABLE=/iplant/home/jawon/API_test/maize_chrOnly_Ns.bed
#fai
FAI=/iplant/home/jawon/API_test/Zea_mays.AGPv3.23_without_scaffold.fa.fai
PERM=100
EXCLUDEBED=

module load biocontainers

module load bedtools

# Fetch data from iPlant Data Store
iget -fT $BED1 .
iget -fT $BED2 . 
iget -fT $MAPPABLE . 
iget -fT $FAI .
iget -fT $EXCLUDEBED .

INPUT1_F=$(basename ${BED1})
INPUT2_F=$(basename ${BED2})
MAPPABLE_F=$(basename ${MAPPABLE})
FAI_F=$(basename ${FAI})
EXCLBED_F=$(basename ${EXCLUDEBED})
 
# Build up an ARGS string for the program
ARGS="--permutate_n $PERM "
if [ "${EXCLBED_F}" != "" ]; then ARGS="${ARGS} --excl ${EXCLBED_F} "; fi
echo "python permutebed-0.1.py --test_1 ${INPUT1_F} --test_2 ${INPUT2_F} --fai ${FAI_F} ${ARGS}"
# Run the actual program
python chipcompare-0.3.py --test_1 ${INPUT1_F} --test_2 ${INPUT2_F} --fai ${FAI_F} ${ARGS}

rm ${INPUT1_F} ${INPUT2_F} ${MAPPABLE_F} ${FAI_F}
