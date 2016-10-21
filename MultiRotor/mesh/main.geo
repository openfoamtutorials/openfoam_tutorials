

diameter = 26 * 0.0254;
separation = 1.2; // normalized by diameter
rotors = 4;

rotorLc = 0.02 * diameter;
farLc = 0.5 * diameter;
farDistance = 5.0 * diameter;
farLayers = 22;
farProgression = 1.2;

wedge = 2.0 * Pi / rotors;
offset = separation * diameter * 0.5 / Sin(0.5 * wedge);
radius = 0.5 * diameter;

ce = 0;

Point(ce++) = {0, -offset, 0, rotorLc}; p = ce;
Point(ce++) = {0, 0, 0, rotorLc};
Point(ce++) = {0, -0.5 * diameter, 0, rotorLc};

Point(ce++) = {Cos(Pi/6.0) * radius, Sin(Pi/6.0) * radius, 0, rotorLc}; cp = ce;
Point(ce++) = {-Cos(Pi/6.0) * radius, Sin(Pi/6.0) * radius, 0, rotorLc};

Point(ce++) = {Sin(wedge/2.0) * farDistance, Cos(wedge/2.0) * farDistance - offset, 0, farLc}; fp = ce;
Point(ce++) = {-Sin(wedge/2.0) * farDistance, Cos(wedge/2.0) * farDistance - offset, 0, farLc};
Point(ce++) = {Sin(wedge/2.0) * separation * diameter * 0.5, Cos(wedge/2.0) * separation * diameter * 0.5 - offset, 0, rotorLc};
Point(ce++) = {-Sin(wedge/2.0) * separation * diameter * 0.5, Cos(wedge/2.0) * separation * diameter * 0.5 - offset, 0, rotorLc};


Line(ce++) = {fp + 2, fp}; f = ce;
Line(ce++) = {fp + 3, fp + 1};
Circle(ce++) = {fp, p, fp + 1};
Line(ce++) = {p, fp + 2};
Line(ce++) = {p, fp + 3};

Circle(ce++) = {p + 2, p + 1, cp}; c = ce;
Circle(ce++) = {p + 2, p + 1, cp + 1};
Circle(ce++) = {cp, p + 1, cp + 1};

Line Loop(ce++) = {c, (c + 2), -(c + 1)}; rotorLoop = ce;
Plane Surface(ce++) = {rotorLoop}; rotorSurface = ce;
Recombine Surface{rotorSurface};

Line Loop(ce++) = {f, f + 2, -(f + 1), -(f + 4), f + 3}; farLoop = ce;
Plane Surface(ce++) = {farLoop, rotorLoop}; farSurface = ce;
Recombine Surface{farSurface};

inlet[] = {};
outlet[] = {};
symmetry[] = {};
slip[] = {};
domainVolumes[] = {};

// extrusion data
ones[] = {1};
layer = 1.0 / ((1.0 - farProgression^farLayers) / (1.0 - farProgression));
layers[] = {layer};
h = layer;
For k In {2:farLayers}
  ones[] += {1};
  layer *= farProgression;
  h += layer;
  layers[] += {h};
EndFor
// Bottom layer
rotorEntities[] = Extrude {0, 0, -farDistance} 
{
  Surface{rotorSurface};
  Layers{ones[], layers[]};
  Recombine;
};
farEntities[] = Extrude {0, 0, -farDistance} 
{
  Surface{farSurface};
  Layers{ones[], layers[]};
  Recombine;
};
domainVolumes[] += {rotorEntities[1], farEntities[1]};
symmetry[] += {farEntities[{2, 4, 5, 6}]};
slip[] += {farEntities[3]};
outlet[] += {rotorEntities[0], farEntities[0]};
// Middle layer
rotorEntities[] = Extrude {0, 0, rotorLc} 
{
  Surface{rotorSurface};
  Layers{1};
  Recombine;
};
farEntities[] = Extrude {0, 0, rotorLc} 
{
  Surface{farSurface};
  Layers{1};
  Recombine;
};
Physical Volume("rotatingZone") = {rotorEntities[1]};
symmetry[] += {farEntities[{2, 4, 5, 6}]};
slip[] += {farEntities[3]};
domainVolumes[] += {farEntities[1]};
// Top layer
rotorEntities[] = Extrude {0, 0, farDistance} 
{
  Surface{rotorEntities[0]};
  Layers{ones[], layers[]};
  Recombine;
};
farEntities[] = Extrude {0, 0, farDistance} 
{
  Surface{farEntities[0]};
  Layers{ones[], layers[]};
  Recombine;
};
domainVolumes[] += {rotorEntities[1], farEntities[1]};
symmetry[] += {farEntities[{2, 4, 5, 6}]};
slip[] += {farEntities[3]};
inlet[] += {rotorEntities[0], farEntities[0]};

Physical Surface("tunnel") = {slip[]}; 
Physical Surface("symmetry") = {symmetry[]}; 
Physical Surface("inlet") = {inlet[]};
Physical Surface("outlet") = {outlet[]};

Physical Volume("domainVolume") = {domainVolumes[]};

