# The system for atmospheric modelling (SAM) as used by the Yang Climate Group at NERSC

This repository hosts a working version of SAM to be compiled for the KNL nodes of NERSC.

Important:

Try to familiarize with cori's documentation prior to use.
Try to read SAMs manual that you can find here in the DOC folder.

# Instructions to compile and run an experiment in Cori

## To get this copy of SAM:

1. Navigate to your desired folder in your home directory. Clone this repository by doing `git clone https://github.com/Yang-Climate-Group/SystemForAtmosphericModelling.git`

## To compile and launch this example experiment: 

1. Go to exp/64x64/run/runtorce1.csh
2. Modify the file runtorce1.csh by adding your email in the 9th line and removing one initial `#`
3. Submit the job running the command `sbatch runtorce1.csh`
4. You can see the status of your jobs by running the command `squeue --me`

This will send a job in the "debug" queue to Cori. This script will first compile the code and then run it. The compiled code will be at your scratch filesystem. You can see it by doing `ls $SCRATCH/sam3d/64x64/rceprofile1/exe.sam`. The output data will appear in `ls $SCRATCH/sam3d/64x64/rceprofile1/exe.sam/OUT_2D` and the same but with 3D in the end.

## To create a different experiment: 

1. Copy the folder 64x64 to MyNewExperiment (or whatever you like) by doing `cp -r 64x64 MyNewExperiment`
2. Do the appropriate modifications to your code and put them in MyNewExperiment/64x64/srcmods
3. Navigate to MyNewExperiment/64x64/run/ and copy the file runtorce1.csh to one with another name. Open this new file in your favorite text editor and modify your desired parameters. In particular modify the line run_name to give your new run a descriptive name.
4. In this same file change the qos to `regular` instead of `debug` and the your desired time. For more information about the different quality of service see [NERSC queue policy](https://docs.nersc.gov/jobs/policy/)


## Explanation

### The exp/ folder contains a folder called 64x64. As its name indicates each set of experiments you run with SAM should have their own folder in exp.

exp/64x64 has some other inside folders:

* init_snd contains initial soundings for different temperatures
* srcmods contains modified source files: to modify the model you would copy the source file you are interested in from SRC, paste it here and then copy it. The submission script will substitute your modified files in place of the original ones. This also contains the definition of your domain in domain.f90.
* run is where the submission script appears. The submission script contains instructions that are specific to the cori machine and the nodes you want to use, as well as your namelists
* input contains files used for the initialization of the model, like the vertical levels used.

Other files of interest:

- readme: in here you could explain what experiment you want to run. In this example, Da Yang describes the modification he did to the file "buoyancy.f90"

# Instructions to merge the output files into a netCDF

As explained by the SAM manual (please read it!) each process in SAM will output a different file. To create a netCDF it is necessary to merge all the files for each timestep into one netCDF file. SAM has a program to do this on the folder UTIL. This program works on each timestep individually, so you need to create a script to apply it to many files. 

To combine all the data for your simulations:

1. Compile the functions. Go to the folder UTIL and run the command `make` to compile all of it.
2. Go to the folder SCRIPTS and take a look at the files `slurm_job_2dcombine.bash` and `slurm_job_combine3d.bash` **CHANGE my email on the appropriate line in both files!** 
3. Change the line UTIL_DIR to point to the directory where you compiled in step 1. Good advice is to have the compiled code in your scratch system.
4. Copy each of these files to your `OUT_3D` and `OUT_2D` folders, respectively, and submit then by running the command `sbatch slrum_job_2dcombine.bash` and a similar one for the 3d file.

## Explanation
These jobs will submit a job to the compute nodes in the flex QoS and will combine all of your data. It will stop and restart many times because the Flex QoS is cheap, but has fast turnaround. In the end it will leave netCDF files in your `OUT_3D` and in your `OUT_2D` folders. 

My scripts are not perfect but they have been useful for me. If you don't have that many files, take a look at the scripts in the folder SCRIPTS/FILES. Those were written by Marat Khairoutdinov and you may be able to remix them to suit your needs.



  * Think about updating to newest version


** Contrubutions by Argel Ramirez Reyes **
# SAMcopy
