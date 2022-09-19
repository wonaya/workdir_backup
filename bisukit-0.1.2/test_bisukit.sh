#!/bin/bash

#SBATCH -J bisukit-api
#SBATCH -o bisukit.%j.out
#SBATCH -e bisukit.%j.err
#SBATCH -p serial
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 12:00:00
#SBATCH -A Springer_Vaughn
#SBATCH --mail-user=jawon@tacc.utexas.edu
#SBATCH --mail-type=end

#input bam
input1=AT_1
input2=AT_2
#OT1=/scratch/02114/wonaya/zed_align-test/CpG_OT_293424_GGTAGC_L005_R1_001.fastq_bismark_bt2_pe.txt
#OT2=/scratch/02114/wonaya/zed_align-test/CpG_OT_293426_GTGCTA_L005_R1_001.fastq_bismark_bt2_pe.txt
#OB1=/scratch/02114/wonaya/zed_align-test/CpG_OB_293424_GGTAGC_L005_R1_001.fastq_bismark_bt2_pe.txt
#OB2=/scratch/02114/wonaya/zed_align-test/CpG_OB_293426_GTGCTA_L005_R1_001.fastq_bismark_bt2_pe.txt
OT1=CpG_OT_SRR5626947_1_bismark_bt2_pe.txt
OT2=CpG_OT_SRR5626948_1_bismark_bt2_pe.txt
OB1=CpG_OB_SRR5626947_1_bismark_bt2_pe.txt
OB2=CpG_OB_SRR5626948_1_bismark_bt2_pe.txt
#mappable
#GENOME=/scratch/02114/wonaya/zed_align-test/Zea_mays.AGPv3.23_without_scaffold.fa
#LIB=/iplant/home/jawon/applications/bisukit-0.1.2/stampede/lib.tar.gz
GENOME=TAIR.fa
LIB=lib.tar.gz
#param
context=CpG
cores=16
specie=AT
qvalue=0.01
dmc=1
cpg=3
diffmeth=20

# module part
module purge
module load TACC
module load python/2.7.12

tar -zxf R-2.15.1.tar.gz
export LD_LIBRARY_PATH="$PWD/R-2.15.1/lib64/R/lib/:$LD_LIBRARY_PATH"
export PATH="$PWD/R-2.15.1/bin/:$PATH"
tar -zxf lib.tar.gz
tar -zxf R.tar.gz

export PYTHONPATH="$PWD/lib/python:/opt/apps/intel16/python/2.7.12/lib/python2.7/site-packages"
export R_LIBS="$PWD/lib/tempRlibs:$R_LIBS"

/work/02114/wonaya/software/icommands/iget -fT $LIB . 
LIB_F=$(basename ${LIB})

# Fetch data from iPlant Data Store
OT1_F=$(basename ${OT1})
OT2_F=$(basename ${OT2})
OB1_F=$(basename ${OB1})
OB2_F=$(basename ${OB2})
GENOME_F=$(basename ${GENOME})
 
# Build up an ARGS string for the program
ARGS="--qvalue $QVALUE --dmc $DMC --cpg $CPG --diffmeth $DIFFMETH --cores $CORES --specie $SPECIE --context $CONTEXT"
if [[ $CTOT1 = *[!\ ]* ]]; then CTOT1_F=$(basename ${CTOT1}) ; ARGS="${ARGS} --ctot1 ${CTOT1_F} "; fi
if [[ $CTOT2 = *[!\ ]* ]]; then CTOT2_F=$(basename ${CTOT2}) ; ARGS="${ARGS} --ctot2 ${CTOT2_F} "; fi
if [[ $CTOB1 = *[!\ ]* ]]; then CTOB1_F=$(basename ${CTOB1}) ; ARGS="${ARGS} --ctob1 ${CTOB1_F} "; fi
if [[ $CTOB2 = *[!\ ]* ]]; then CTOB2_F=$(basename ${CTOB2}) ; ARGS="${ARGS} --ctob2 ${CTOB2_F} "; fi
# Run the actual program
#echo "python bisukit.py --name1 ${NAME1} --name2 ${NAME2} --ot1 ${OT1_F} --ot2 ${OT2_F} --ob1 ${OB1_F} --ob2 ${OB2_F} --genome ${GENOME_F} ${ARGS}"
echo "python bisukit.py --ot1 ${OT1_F} --ot2 ${OT2_F} --ob1 ${OB1_F} --ob2 ${OB2_F} --genome ${GENOME_F} --qvalue $qvalue --dmc $dmc --cpg $cpg --diffmeth $diffmeth --cores 16 --specie $specie --context $context --name1 $input1 --name2 $input2"
python bisukit.py --name1 ${NAME1} --name2 ${NAME2} --ot1 ${OT1_F} --ot2 ${OT2_F} --ob1 ${OB1_F} --ob2 ${OB2_F} --genome ${GENOME_F} ${ARGS}
#rm ${INPUT1_F} ${INPUT2_F} ${GENOME}
