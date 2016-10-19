itm = 0.0254; // for 'a * itm = b', where a is in inches, b in meters.

thickness = 0.125 * itm;
free_length = 1.5 * itm;
fixed_length = 0.5 * itm;
cell_depth = 1 * itm;
fillet_radius = thickness;

load = 150; // N, used just for calculating traction required on bracket end.
density = 2700; // kg / m^3, used just for output calculations.

fine_grid_size = 0.01 * thickness;
coarse_grid_size = 0.2 * thickness;

ce = 0;

Point(ce++) = {0,fixed_length,0,coarse_grid_size}; fixed_top_right = ce;
Point(ce++) = {-thickness,fixed_length,0,coarse_grid_size}; fixed_top_left = ce;
Point(ce++) = {-thickness-fillet_radius,thickness/2,0,fine_grid_size}; fillet_top_bottom = ce;
Point(ce++) = {-thickness,thickness/2+fillet_radius,0,fine_grid_size}; fillet_top_top = ce;
Point(ce++) = {-thickness-fillet_radius,thickness/2+fillet_radius,0,fine_grid_size}; 
  fillet_top_center = ce;
Point(ce++) = {-free_length,thickness/2,0,coarse_grid_size}; free_top = ce;
Point(ce++) = {-free_length,-thickness/2,0,coarse_grid_size}; free_bottom = ce;
Point(ce++) = {-thickness-fillet_radius,-thickness/2,0,fine_grid_size}; fillet_bottom_top = ce;
Point(ce++) = {-thickness,-thickness/2-fillet_radius,0,fine_grid_size}; fillet_bottom_bottom = ce;
Point(ce++) = {-thickness-fillet_radius,-thickness/2-fillet_radius,0,fine_grid_size}; 
  fillet_bottom_center = ce;
Point(ce++) = {0,-fixed_length,0,coarse_grid_size}; fixed_bottom_right = ce;
Point(ce++) = {-thickness,-fixed_length,0,coarse_grid_size}; fixed_bottom_left = ce;

lns[]={};
Line(ce++) = {fixed_top_right, fixed_top_left};lns[]+=ce;
Line(ce++) = {fixed_top_left, fillet_top_top};lns[]+=ce;
Circle(ce++) = {fillet_top_top, fillet_top_center, fillet_top_bottom};lns[]+=ce;
Line(ce++) = {fillet_top_bottom, free_top};lns[]+=ce;
Line(ce++) = {free_top, free_bottom};lns[]+=ce;
Line(ce++) = {free_bottom, fillet_bottom_top};lns[]+=ce;
Circle(ce++) = {fillet_bottom_top, fillet_bottom_center, fillet_bottom_bottom};lns[]+=ce;
Line(ce++) = {fillet_bottom_bottom, fixed_bottom_left};lns[]+=ce;
Line(ce++) = {fixed_bottom_left, fixed_bottom_right};lns[]+=ce;
Line(ce++) = {fixed_bottom_right, fixed_top_right};lns[]+=ce;

Line Loop(ce++) = lns[];
loop = ce;

Plane Surface(ce++) = loop; surf = ce;

ids[] = Extrude{0,0,cell_depth}
{
  Surface{surf};
  Recombine;
  Layers{1};
};

Physical Surface("fixedSurface") = {ids[11]};
Physical Surface("freeSurface") = {ids[{2:5,7:10}]};
Physical Surface("frontAndBack") = {surf,ids[0]};
Physical Surface("loadSurface") = {ids[6]};
Physical Volume("volume") = {ids[1]};

tip_area = cell_depth * thickness;
free_leg_volume = tip_area * (free_length - thickness);
fixed_leg_volume = tip_area * (fixed_length - thickness);
corner_volume = tip_area * thickness;
bracket_volume = free_leg_volume + fixed_leg_volume + corner_volume; 
Printf("Approx. Bracket Weight: %f g", 1e3 * density * bracket_volume);
Printf("Load Surface Area: %e sq. m.", tip_area);
I = ( cell_depth * thickness^3 ) / 12;
Printf("Leg Area Moment of Intertia: %e sq. m.", I);
Printf("Tip Load Traction: %e N/m^2", load / tip_area );
L = free_length - thickness - fillet_radius;
Printf("Cantilever Distance: %e m", L );
M = L * load;
y = thickness / 2;
sigma = M * y / I;
Printf("Analytical Max Stress at Cantilever Distance: %f MPa", sigma / 1e6 );
