# Structural Simulation in OpenFOAM: Cantilever Beam (How to Avoid Sharp Corner Stress Singularities)

All code can be found at: https://github.com/rlee32/openfoam_tutorials/tree/master/Bracket  

## Description
Here we will simulate a cantilever beam in OpenFOAM, using the solidDisplacementFoam solver, and validate the results by comparison to analytical models. A mesh is made in Gmsh and shear loads (AKA traction) are specified in the OpenFOAM case files. We discuss how to work around the stress singularities at square corners by moving the point of singularity so it does not affect the results.  
For some additional description of the solver, please see: http://cfd.direct/openfoam/user-guide/platehole/.  

## Outline
-Go over mesh.  
-Go over boundary conditions and load specification.  
-Run the solver.  

## Commands
gmsh mesh/cantilever.geo -3 -o cantilever.msh  
gmshToFoam cantilever.msh -case case  
changeDictionary  
solidDisplacementFoam > log  
-When viewing results in ParaFoam, you may have to advance one time step in order to see sigmaEq selectable in the fields menu. Otherwise, you may only see T and D.  
python sigma.py  
-observe convergence in sigmaEq file  

## Software
-Ubuntu 14.04 64-bit  
-OpenFOAM 3.0.0  
-Gmsh 2.11  


