#!/bin/bash
###############################################################
#   Bayesian Optimization based on Gaussian Processes
# Find the upper boundary shape s.t. a given pressure gradient 
#      for the TBL at the lower wall is maintained
###############################################################
# Saleh Rezaeiravesh, salehr@kth.se
# Yuki Morita, morita@kth.se
#--------------------------------------------------------------
set -eu # stop when error occurs
echo "process id = " $$
#---------------------------------------------
#  SETTINGS
#---------------------------------------------
iStart=11   # Starting iteration 
nRun=10   # number of times the script is run 
#nProcessors=30 # number of processors for calculation (check decomposeParDict & jobScript)
tEnd=`cut -f 7 OFinput.dat | sed -n 2p` # read from OFinput.dat
target=0   # terget value for beta
inlet_ignore=0.2   # ignore this region when assess the objective
outlet_ignore=0.1
bupAddress="/home/m/morita/OpenFOAM/morita-6/run/"   #directory to which OpenFOAM data at tEnd are backed up
caseName="test1"  #for saving figures and output data
#------------------------
# MAIN
#------------------------
if [ ! -d "$bupAddress$caseName" ]
then
   mkdir $bupAddress$caseName
fi
here=$PWD
for ((i=$iStart;i<$iStart+$nRun;i++)); do
    clear;
    #1. Generate a sample from the parameters space
    cd ./gpOptim
    python3 -c 'import gpOpt_TBL as X;X.nextGPsample()'
    cd ../

    #2. Grab sampled parameter and write yTopParams.in for blockMesh
    cd ./OFpre
    echo "main_pre.py"
    python3 main_pre.py
    cd ../

    #3. Run OpenFOAM
    cd ./OFcase
    echo "clean OFcase files"
    rm -rf processor*
    rm -rf postProcessing
    rm -rf constant/polyMesh/*
    foamListTimes -rm # delete time directories (except 0)
    
    blockMesh
    wait
    postProcess -func writeCellCentres -time 0 # write coordinate data (needed for post process)
    decomposePar
    
    echo "MAIN SIMULATION START"
    #bash OFrun.sh $nProcessors
    sbatch jobScript
    wait
    
    echo "MAIN SIMULATION END"
    reconstructPar -latestTime
    echo "COPY THE LATEST TIME DATA TO " $bupAddress$caseName/$tEnd-$i
    cp -r $tEnd $bupAddress$caseName/$tEnd-$i
    cd ../
    
    #4. Post-process OpenFOAM
    cd ./OFpost
    echo "main_post.py"
    python3 main_post.py $target $inlet_ignore $outlet_ignore
    cd ../
    
    #5. Post-process optimization
    cd ./gpOptim
    python3 -c 'import gpOpt_TBL as X;X.BO_update_convergence()'
    conv=$? # conv=1 if converged
    echo "isConv?" $conv
    python3 -c 'import gpOpt_TBL as X;X.gpSurface_plot()'
    cd ../

    echo "LOOP END"
    #get back to the current address (where this script is)
    cd $here
    if [ $conv = 1 ]; then
	echo "optimization is converged: i = " $i
	break
    fi
done

echo "FINISHED"
