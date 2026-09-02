#!/bin/bash
#BSUB -n 1
#BSUB -W 7200
#BSUB -J sim2
#BSUB -o stdout.%J
#BSUB -e stderr.%J
# #BSUB -x
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=10]"
#BSUB -q cnr
module load openmpi-gcc
module load R
Rscript 02_main.R
