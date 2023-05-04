#!/bin/bash
#PBS -N testsam
#PBS -A UCDV0026
#PBS -l walltime=00:10:00
#PBS -q regular
#PBS -j oe
#PBS -k eod
#PBS -l select=1:ncpus=32:mpiprocs=32:ompthreads=1
#PBS -m abe
#PBS -M linyao@ucdavis.edu

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

mpiexec_mpt ./SAM_ADV_MPDATA_SGS_TKE_RAD_CAM_MICRO_SAM1MOM > log.txt

