#!/bin/bash
#SBATCH -J combineFiles
#SBATCH -q flex
#SBATCH -C knl 
#SBATCH -N 1 #--nodes
#SBATCH -n 30 #--ntasks
#SBATCH -c 4 #corespertasks
#SBATCH --time=48:00:00
#SBATCH --time-min=00:15:00 #the minimum amount of time the job should run
#SBATCH --error=%x-%j.err
#SBATCH --output=%x-%j.out
#SBATCH --mail-user=aramirezreyes@ucdavis.edu
#SBATCH --mail-type=BEGIN,END
#SBATCH --comment=96:00:00  #desired time limit
#SBATCH --signal=B:USR1@150 #sig_time (300 secs) should match your checkpoint overhead time
###SBATCH --signal=SIGTERM@600 #sig_time (300 secs) should match your checkpoint overhead time 
#SBATCH --requeue
#SBATCH --open-mode=append

############ FUNCTIONS TO REQUEUE THE JOB UNTIL IT IS DONE IN THE FLEX QUEUE ###############
# specify the command to use to checkpoint your job if any (leave blank if none) 
ckpt_command= 
max_timelimit=48:00:00

# requeueing the job if remaining time >0
. /usr/common/software/variable-time-job/setup.sh

my_func_trap() {
######################################################
# -------------- checkpoint application --------------
######################################################
    # insert checkpoint command here if any
    set -x
    $ckpt_command >&2
    trap '' SIGTERM
    scontrol requeue ${SLURM_JOB_ID} >&2
    scontrol update JobId=${SLURM_JOB_ID} TimeLimit=${requestTime} >&2
    trap - SIGTERM
    jobs -p | xargs kill # Send the SIGTERM once more, this time catching it.
    echo "I killed all my children"
    echo \$?: $? >&2
    set +x
    echo "Exiting..."
    exit 1
}

export -f my_func_trap

############## FUNCTIONS TO COMBINE THE FILES  #################
export UTIL_DIR=/global/cscratch1/sd/aramreye/SAMUTIL
### function to move the incomplete files so that they don't get in the way
move_incomplete() {
    mkdir -p incompletefiles
    find . -maxdepth 1 -name '*.nc' -size -"$successful_file_size"c -exec mv {} incompletefiles/ \;
}
### function to combine and move
function combine_and_move {
    file_name1=`echo $1 | sed 's/2Dcom_0/2Dcom/'`
    echo "*** file $file_name1 ***"
    $UTIL_DIR/2Dcom2nc_sep $file_name1 &&  mv "$file_name1"_* uncombined_files
}
export -f combine_and_move
### Function to know what is the size of a sucessfully combined netcdf
get_complete_file_size() {
    if [ -f successful_file_size.txt ]
    then
	successful_file_size=$(cat "successful_file_size.txt")
    else
	first_filename=$(find . -maxdepth 1 -name '*2Dcom_0' -print -quit)
	files_to_combine=`echo $first_filename | sed 's/2Dcom_0/2Dcom/'`
	nc_file=`echo $first_filename | sed 's/2Dcom_0/nc/'`
	$UTIL_DIR/2Dcom2nc_sep $files_to_combine && successful_file_size="$(wc -c <"$nc_file")"
	echo $successful_file_size > successful_file_size.txt
    fi
}

###### Setup things

requeue_job my_func_trap USR1
get_complete_file_size

############# START PROCESSING ##########################


if [ -d uncombined_files ] 
then
    move_incomplete
else
    mkdir uncombined_files
fi

find . -maxdepth 1 -name '*2Dcom_0' -print0 | xargs --replace=@ -0 -P $SLURM_NTASKS  bash -c 'combine_and_move $"@"' _ &

wait
