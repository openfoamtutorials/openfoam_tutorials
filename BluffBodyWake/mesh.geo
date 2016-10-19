//Gmsh

body_width = 0.254;
body_height = 1.778;
body_tilt = 25*Pi/180;
body_top_left_corner[] = {0,0,0};
body_lc = body_width / 20;

domain_size = 10*body_height;
domain_lc = body_width;

fan_height = 6*0.0254;
fan_width = 32*0.0254;
fan_lc = fan_width / 10;
fan_separation = fan_width;


ce = 0; // current entity ID.

Function draw_rectangle
  // the outline of the rectangle is output from this function.
  // In: top_left_corner[] = {}; lc = ; W = ; H = ;
  pts[] = {};
  Point(ce++) = {top_left_corner[0], top_left_corner[1], 0, lc}; 
  pts[]+=ce;
  Point(ce++) = {top_left_corner[0], top_left_corner[1]-H, 0, lc};
  pts[]+=ce;
  Point(ce++) = {top_left_corner[0]+W, top_left_corner[1]-H, 0, lc};
  pts[]+=ce;
  Point(ce++) = {top_left_corner[0]+W, top_left_corner[1], 0, lc};
  pts[]+=ce;
  lns[] = {};
  Line(ce++) = {pts[0], pts[1]}; lns[]+=ce;
  Line(ce++) = {pts[1], pts[2]}; lns[]+=ce;
  Line(ce++) = {pts[2], pts[3]}; lns[]+=ce;
  Line(ce++) = {pts[3], pts[0]}; lns[]+=ce;
Return

Function rotate_lines
  // In: lns[] = {}; rotation_center[] = {}; rotation = ;
  If ( rotation > 0 )
    Rotate{ {0,0,1}, { rotation_center[0], rotation_center[1], 0 }, rotation }
    {
      Line{lns[]};
    }
  EndIf
Return


top_left_corner[] = body_top_left_corner[];
W = body_width;
H = body_height;
lc = body_lc;
  Call draw_rectangle;
rotation_center[] = body_top_left_corner[];
rotation = body_tilt;
  Call rotate_lines;
Line Loop(ce++) = {lns[]};
body_loop = ce;

top_left_corner[] = {body_width/2-fan_width/2, fan_separation, 0};
W = fan_width;
H = fan_height;
lc = fan_lc;
  Call draw_rectangle;
rotation_center[] = body_top_left_corner[];
rotation = body_tilt;
  Call rotate_lines;
Line Loop(ce++) = {lns[]};
fan_loop = ce;

top_left_corner[] = {-domain_size/2, domain_size/2, 0};
W = domain_size;
H = domain_size;
lc = domain_lc;
Call draw_rectangle;
Line Loop(ce++) = {lns[]};
domain_loop = ce;

Plane Surface(ce++) = {domain_loop, body_loop, fan_loop};
main_surface = ce;

cell_depth = 0.1;
new_entities[] = 
Extrude{0,0,cell_depth}
{
  Surface{main_surface};
  Layers{1};
  Recombine;
};

Plane Surface(ce++) = {fan_loop};
fan_surface = ce;

cell_depth = 0.1;
new_entities2[] = 
Extrude{0,0,cell_depth}
{
  Surface{fan_surface};
  Layers{1};
  Recombine;
};

Physical Surface("body") = {new_entities[{6:9}]};
Physical Surface("baffle") = {new_entities[10]};
Physical Surface("inlet") = {new_entities[2]};
Physical Surface("outlet") = {new_entities[4]};
Physical Surface("front_and_back") = {main_surface, new_entities[0], 
  new_entities2[0], fan_surface};
Physical Surface("tunnel") = {new_entities[{3,5}]};
Physical Volume("volume") = {new_entities[1], new_entities2[1]};

