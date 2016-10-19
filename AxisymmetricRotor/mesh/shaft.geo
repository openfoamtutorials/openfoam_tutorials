//Inputs
Geometry.Tolerance = 1e-12;

rotorRadius = 8*0.0254; // m
hubRadius = 1*0.0254; // m
domainDistance = 5; // m

rotorTipLc = 0.01*rotorRadius;
rotorCenterLc = 4*rotorTipLc;
farLc = rotorRadius;

wedgeAngle = 5*Pi/180;

Point(1) = {hubRadius, 0, 0, rotorCenterLc};
Point(2) = {rotorRadius, 0, 0, rotorTipLc};
Point(3) = {rotorRadius, rotorTipLc, 0, rotorTipLc};
Point(4) = {hubRadius, rotorTipLc, 0, rotorCenterLc};

Point(5) = {hubRadius, -domainDistance, 0, farLc};
Point(6) = {domainDistance, -domainDistance, 0, farLc};
Point(7) = {domainDistance, domainDistance, 0, farLc};
Point(8) = {hubRadius, domainDistance, 0, farLc};

Line(10) = {1, 2};
Line(11) = {2, 3};
Line(12) = {3, 4};
Line(13) = {4, 1};
Line Loop(20) = {10:13};

Transfinite Line{11,13} = 2;

Line(14) = {4, 8};
Line(15) = {8, 7};
Line(16) = {7, 6};
Line(17) = {6, 5};
Line(18) = {5, 1};
Line Loop(19) = {10:12,14:18};

Plane Surface(22) = {19};
Plane Surface(23) = {20};
Transfinite Surface{23};
Recombine Surface{23};

Rotate {{0,1,0}, {0,0,0}, wedgeAngle/2}
{
  Surface{22, 23};
}
domainEntities[] = Extrude {{0,1,0}, {0,0,0}, -wedgeAngle}
{
  Surface{22,23};
  Layers{1};
  Recombine;
};

Physical Surface("wedge0") = {22, 23};
Physical Surface("wedge1") = {domainEntities[{0, 10}]};
Physical Surface("inlet") = {domainEntities[6]};
Physical Surface("tunnel") = {domainEntities[{5, 7, 9, 15}]};
Physical Surface("outlet") = {domainEntities[8]};

Physical Volume("rotatingZone") = {domainEntities[11]};
Physical Volume(1000) = {domainEntities[1]};






