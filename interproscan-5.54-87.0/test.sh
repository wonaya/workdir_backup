#!/bin/bash 

ml tacc-singularity
singularity run -B $PWD:/data -B /scratch/projects/tacc/bio/interproscan/interproscan-5.54-87.0/data:/opt/interproscan/data docker://agbase/interproscan:5.54-87 -i Bos10k.fa -d outdir_10000 -f tsv,json,xml,gff3 -g -D AgBase
