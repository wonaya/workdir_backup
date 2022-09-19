#!/bin/bash

#SBATCH -J deeptools-test
#SBATCH -o deeptools.%j.out
#SBATCH -e deeptools.%j.err
#SBATCH -p serial
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -A Thompson_Replication

#input max of 10 bams
bam1=sample_1.bam
bam2=sample_2.bam
bam3=
bam4=
bam5=
bam6=
bam7=
bam8=
bam9=
bam10=

#param
bins=1000
cormethod=pearson
log10=0
removeoutliers=0


module load biocontainers
module load python samtools/ctr-1.9--h91753b0_5
module load deeptools/ctr-3.2.0--py_0

ARGS= ""
ARGS="${ARGS} ${bam1} ${bam2} "
if [ "${bam3}" != "" ]; then ARGS="${ARGS} ${bam3}"; fi
if [ "${bam4}" != "" ]; then ARGS="${ARGS} ${bam4}"; fi
if [ "${bam5}" != "" ]; then ARGS="${ARGS} ${bam5}"; fi
if [ "${bam6}" != "" ]; then ARGS="${ARGS} ${bam6}"; fi
if [ "${bam7}" != "" ]; then ARGS="${ARGS} ${bam7}"; fi
if [ "${bam8}" != "" ]; then ARGS="${ARGS} ${bam8}"; fi
if [ "${bam9}" != "" ]; then ARGS="${ARGS} ${bam9}"; fi
if [ "${bam10}" != "" ]; then ARGS="${ARGS} ${bam10}"; fi

echo ${ARGS}

for x in $(ls $ARGS) ;
do samtools sort $x -o $x.sorted.bam ; mv $x.sorted.bam $x ; samtools index $x ;
done

ARGS2=""
ARGS2="-bs $bins -b $ARGS -out multibam"

# Run the actual program
echo "multiBamSummary bins ${ARGS2}"
multiBamSummary bins ${ARGS2}

ARGS3=""
ARGS3="--corMethod $cormethod --plotNumbers"
if [ ${log10} -eq 1 ]; then ARGS3="${ARGS} --log10 "; fi
if [ ${removeoutliers} -eq 1 ]; then ARGS3="${ARGS} --removeOutliers "; fi
plotCorrelation --corData multibam.npz --plotFile multibam_heatmap.png --whatToPlot heatmap ${ARGS3}
plotCorrelation --corData multibam.npz --plotFile multibam_scatter.png --whatToPlot scatterplot ${ARGS3}

