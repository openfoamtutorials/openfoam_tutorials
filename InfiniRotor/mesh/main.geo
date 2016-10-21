diameter = 16 * 0.0254;
separation = 1.2; // normalized by diameter

rotorLc = 0.02 * diameter;
symmetryLc = separation * rotorLc;
farDistance = 5.0 * diameter;
farLayers = 22;
farProgression = 1.2;

radius = 0.5 * diameter;
symmetryRadius = 0.5 * separation * diameter;

ce = 0;

Point(ce++) = {0, 0, 0, rotorLc}; c = ce;

Point(ce++) = {radius, 0, 0, rotorLc}; p = ce;
Point(ce++) = {0, radius, 0, rotorLc};
Point(ce++) = {-radius, 0, 0, rotorLc};
Point(ce++) = {0, -radius, 0, rotorLc};

Circle(ce++) = {p, c, p + 1}; l = ce;
Circle(ce++) = {p + 1, c, p + 2};
Circle(ce++) = {p + 2, c, p + 3};
Circle(ce++) = {p + 3, c, p};

Line Loop(ce++) = {l: l + 3}; rotorLoop = ce;
Plane Surface(ce++) = rotorLoop; rotorSurface = ce;
Recombine Surface{rotorSurface};

Point(ce++) = {symmetryRadius, symmetryRadius, 0, symmetryLc}; p = ce;
Point(ce++) = {-symmetryRadius, symmetryRadius, 0, symmetryLc};
Point(ce++) = {-symmetryRadius, -symmetryRadius, 0, symmetryLc};
Point(ce++) = {symmetryRadius, -symmetryRadius, 0, symmetryLc};

Line(ce++) = {p, p + 1}; l = ce;
Line(ce++) = {p + 1, p + 2};
Line(ce++) = {p + 2, p + 3};
Line(ce++) = {p + 3, p};

Line Loop(ce++) = {l: l + 3}; symmetryLoop = ce;
Plane Surface(ce++) = {symmetryLoop, rotorLoop}; symmetrySurface = ce;
Recombine Surface{symmetrySurface};

inlet[] = {};
outlet[] = {};
symmetry[] = {};
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
  Surface{symmetrySurface};
  Layers{ones[], layers[]};
  Recombine;
};
domainVolumes[] += {rotorEntities[1], farEntities[1]};
symmetry[] += {farEntities[{2, 3, 4, 5}]};
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
  Surface{symmetrySurface};
  Layers{1};
  Recombine;
};
Physical Volume("rotatingZone") = {rotorEntities[1]};
symmetry[] += {farEntities[{2, 3, 4, 5}]};
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
symmetry[] += {farEntities[{2, 3, 4, 5}]};
inlet[] += {rotorEntities[0], farEntities[0]};

Physical Surface("symmetry") = {symmetry[]}; 
Physical Surface("inlet") = {inlet[]};
Physical Surface("outlet") = {outlet[]};

Physical Volume("domainVolume") = {domainVolumes[]};

