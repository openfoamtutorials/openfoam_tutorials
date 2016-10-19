# Simulation of a 2D Bluff Body in a High-Speed Wake in OpenFOAM  

All code can be found at: 
https://github.com/rlee32/openfoam_tutorials/tree/master/BluffBodyWake

## Description
In this tutorial we set a bluff body (high drag, no/low lift) into the 
high-speed wake of an actuator disk. We shall see that this causes the bluff 
body to become a more aerodynamic body. The high-speed wake reduces the drag of 
this particular configuration by about a factor of 1.8 and the lift by about 
1.7 (the L/D ratio is about 0.5 in both cases). The high-speed wake also 
substantially mitigates large aerodynamic force oscillations.  

## Outline
-Generate mesh in Gmsh.  
-Convert mesh to OpenFOAM format.  
-Make internal baffle faces a pressure jump region.  
-Run the simulation.  

## Commands
gmsh mesh.geo -3 -o test.msh  
gmshToFoam test.msh -case case  
(Modify boundary file)  
  -tunnel and body as walls  
  -front_and_back as empty  
  -baffle as cyclic  
  -add baffleother and neighbourPatch entries  
createBaffles -case case -dict system/baffleDict -overwrite  
pimpleFoam  

## Software
-Ubuntu 14.04 64-bit  
-OpenFOAM 3.0.0  
-Gmsh 2.11  