# Space Capsule Atmospheric Entry Simulation in OpenFOAM  

All code can be found at:  
https://github.com/rlee32/openfoam_tutorials/tree/master/SpaceCapsule  

## Description  
Here we simulate supersonic reentry of a generically-shaped space capsule. 
We will use an axisymmetric configuration. Some specifics of the sonicFoam 
solver will be discussed and bow shocks in the solution will be observed.  

## Outline  
-Create mesh in Gmsh.  
-Convert the mesh and change the boundary file.  
-Run the simulation and view post-processed results.  

## Commands
gmsh mesh.geo -3 -o test.msh  
gmshToFoam test.msh -case case  
(Modify boundary file)   
  -vehicle as wall  
  -wedge0 and wedge1 as wedge  
  -tunnel as slip  
sonicFoam  

## Software
-Ubuntu 14.04 64-bit  
-OpenFOAM 3.0.0  
-Gmsh 2.11  