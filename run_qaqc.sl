#!/bin/bash

#SBATCH --account fme200002
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 30
#SBATCH --time 00:05:00

# README -----------------------------------------------------------------------
# Run the example script for parallizing an R script
# It uses a SLURM array task to lauch jobs on four compute nodes
#
# TO SUBMIT THE JOB:
#
# sbatch --array=1-30 /compass/fme200002/ahart/COMPASS-sensor-data/run_qaqc.sl
#
# TO CHECK PROGRESS:
#
# squeue
#
# ------------------------------------------------------------------------------

. /etc/profile.d/modules.bash
module purge
module load gcc/11.3.0
module load pnnl_proxies/1.0
module load r/4.4.0

# Change directory into the example
# Recommended: use renv to assure you have the correct virtual environment
cd /compass/fme200002/ahart/COMPASS-sensor-data

# R script to run 
EXAMPLE_SCRIPT="/compass/fme200002/ahart/COMPASS-sensor-data/qaqc_compass.R"

# run script with the slurm array index as the only argument to the script 
Rscript $EXAMPLE_SCRIPT $SLURM_ARRAY_TASK_ID

