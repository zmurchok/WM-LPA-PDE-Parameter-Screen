#!/bin/bash
#SBATCH --mail-user=cole.zmurchok@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=10:00:00       # 10 hours
#SBATCH --mem=16G    # parpool requires a fair amount of ram
#SBATCH --array=1-6
#SBATCH --output=job%A_task_%a.out

module load MATLAB/2018a   # load the default version of MATLAB from LMod

matlab -nodisplay -nosplash < main${SLURM_ARRAY_TASK_ID}.m
