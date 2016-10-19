This folder contains a sub-utility that converts raw airfoil point data 
that you might find online into a Gmsh-palatable form.  

dat2geo.py: converts your raw airfoil point data into a geo file to be included 
in the main.geo script. You have to change the variable in main.geo to point 
to the desired airfoil geo file.  

main.geo: generates the geometry from your specified airfoil geo file.  
