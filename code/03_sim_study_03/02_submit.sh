#!/usr/bin/bash
#
# Script:  02_submit.sh
# Usage: For submitting multiple batch jobs to the NC State HPC.
# Author: Jeffrey W. Doser
#
# To run, type:
#     ./02_submit.sh
#  Script must have execute permissions, i.e.,
#     chmod u+x 02_submit.sh

module load openmpi-gcc
module load R

# Some quick checks

#Read in variables
start_row=1

# NOTE this is hardcoded to send out all 25 different scenarios at once. Then 
# all 100 simulations are run for that specific scenario. 
for i in {1..25}
do 

  echo "Submit job = row:$i"
  
  bsub -n 1 -W 7200 -R span[hosts=1] -R "rusage[mem=5]" -q cnr -oo out.02_main_test.$i -eo err.02_main_test.$i "Rscript 02_main.R $i"

  ((start_row++))

done
