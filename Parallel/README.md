# MPI Parallel Simulations in OpenFOAM  

All code can be found at: 
https://github.com/rlee32/OpenFOAM_Tutorials/tree/master/Parallel  

## Description
In this tutorial we parallelize a tutorial case. We use the built-in 
OpenFOAM MPI implementation and invoke a few built-in tools to help with setup 
and post-processing.  

## Outline
-Make and convert mesh.  
-Go over decomposeParDict file.  
-Decompose domain.  
-Run simulation in parallel.  
-Reconstruct output for viewing.  

## Commands
gmsh mesh/mesh.geo -3 -o test.msh  
gmshToFoam test.msh -case case
Modify boundary file:  
  -frontAndBack as empty  
  -wing as wall  
  -tunnel as wall  
decomposePar  
mpirun -np 4 simpleFoam -parallel  
reconstructPar -latestTime  

## Software
This tutorial was run successfully on:  
-Ubuntu 14.04 64-bit  
-OpenFOAM 3.0.0  
-Gmsh 2.11  