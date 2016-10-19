//Inputs
angle_of_attack = 5*Pi/180;
airfoil_chord = 1;
ground_height = 0.5*airfoil_chord;
boundary_distance = 10*airfoil_chord;
boundary_gridsize = 0.1*boundary_distance;
transition_gridsize = 0.1*airfoil_chord;
airfoil_gridsize = 0.005*airfoil_chord;
cell_depth = airfoil_chord;
te_omit = 0;

ce = 0;

Include "NACA2412.geo";
points[] ={};
For k In {0:airfoil_points-1}
	Point(ce++) = {
		airfoil_chord*airfoil_x[k],
		airfoil_chord*airfoil_y[k],
		0,
		airfoil_gridsize};
	If(k < airfoil_points-te_omit)
		points[] += ce;
	EndIf
EndFor

Rotate{ {0,0,1}, {0,0,0}, -angle_of_attack }
{
	Point{points[]};
}

BSpline(ce++) = points[];spline_id = ce;
Line(ce++) = {points[airfoil_points-1],points[0]};te_line = ce;

pts[]={};
Point(ce++) = {-boundary_distance,-boundary_distance,0,boundary_gridsize};
pts[]+=ce;
Point(ce++) = {boundary_distance,-boundary_distance,0,boundary_gridsize};
pts[]+=ce;
Point(ce++) = {boundary_distance,boundary_distance,0,boundary_gridsize};
pts[]+=ce;
Point(ce++) = {-boundary_distance,boundary_distance,0,boundary_gridsize};
pts[]+=ce;

lns[] = {};
Line(ce++) = pts[{0,1}];lns[]+=ce;
Line(ce++) = pts[{1,2}];lns[]+=ce;
Line(ce++) = pts[{2,3}];lns[]+=ce;
Line(ce++) = pts[{3,0}];lns[]+=ce;


// // Grid field
Field[1] = Attractor;
// Field[1].NodesList = {e1};
Field[1].NNodesByEdge = 200;
Field[1].EdgesList = {spline_id};
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = airfoil_gridsize;
Field[2].LcMax = boundary_gridsize;
Field[2].DistMin = 0.05*airfoil_chord;
Field[2].DistMax = 0.5*boundary_distance;
Field[7] = Min;
Field[7].FieldsList = {2};
Background Field = 7;






Line Loop(ce++) = lns[]; boundary_loop = ce;
Line Loop(ce++) = {spline_id,te_line}; spline_loop = ce;

Plane Surface(ce++) = {boundary_loop, spline_loop}; extrude_surface = ce;

new_entities[] = 
Extrude{0,0,cell_depth}
{
	Surface{extrude_surface};
	Layers{1};
	Recombine;
};

Physical Surface("frontAndBack") = {extrude_surface,new_entities[0]};
Physical Surface("tunnel") = new_entities[{2,4}];
Physical Surface("inlet") = new_entities[5];
Physical Surface("outlet") = new_entities[3];
Physical Surface("wing") = new_entities[{6,7}];
Physical Volume(1000) = new_entities[1];

