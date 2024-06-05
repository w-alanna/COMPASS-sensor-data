#!/bin/bash

#SBATCH --account fme200002
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --time 00:05:00
#SBATCH --job r_example
#SBATCH --mail-user=alanna.hart@pnnl.gov
#SBATCH --output=/compass/fme200002/ahart/COMPASS-sensor-data/example_%A_%a.out
#SBATCH --error=/compass/fme200002/ahart/COMPASS-sensor-data/example_%A_%a.err

# README -----------------------------------------------------------------------
# Run the example script for parallizing an R script
# It uses a SLURM array task to lauch jobs on four compute nodes
#
# TO SUBMIT THE JOB:
#
# sbatch --array=1-20 /compass/fme200002/ahart/COMPASS-sensor-data/run_qaqc.sl
#
# TO CHECK PROGRESS:
#
# squeue
#
# When the job is done you should see four *.out and *.err files, one for 
# each compute node the job was sent to; and 40 CSV data output files in 
# the example_output_dir/, one for each invocation of do_the_thing() in the R script
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

