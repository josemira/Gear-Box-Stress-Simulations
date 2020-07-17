clear all
clc
%% -------------VM Diagram--------------

sl = 11.6; % shaft length

bl3 = 0; % bearing location 1
bl4 = 11.6; % bearing location 2 


gl3 = 2.7; %gear location 3

gl4 = 8.9; %gear location 4


%% ----------      Tangential xz plane        -----------------

g3tf = 967.32;%gear 3 tangential force
g4tf = -2708.53;%gear 4 tangential force

[Xxz, ShearFxz ,BendMxz]=SFBM('Shaft_Analysis_xz',[sl,bl3,bl4],{'CF',g3tf,gl3},{'CF',g4tf,gl4});

point1=2.7;
[~,location]=min(abs(Xxz-point1));
m3t = BendMxz(location)

point2=8.9;
[~,location]=min(abs(Xxz-point2));
m4t = BendMxz(location)


%% ----------      Radial xy plane        -----------------

g3rf = -352.078;
g4rf = -985.82;

[Xxy,ShearFxy,BendMxy]=SFBM('Shaft_Analysis_xy',[sl,bl3,bl4],{'CF',g3rf,gl3},{'CF',g4rf,gl4});

point1=2.7;
[~,location]=min(abs(Xxy-point1));
m3r = BendMxy(location)

point2=8.9;
[~,location]=min(abs(Xxy-point2));
m4r = BendMxy(location)


%% ---------    Total Moment Diagram    -------------

% M3 = ((m3r^2)+(m3t^2))^0.5


% M4 = ((m4r^2)+(m4t^2))^0.5


sl = 11.6; % shaft length

bl3 = 0; % bearing location 1
bl4 = 11.6; % bearing location 2 


gl3 = 2.7; %gear location 3

gl4 = 8.9; %gear location 4

g3tf = 153.87;
g4tf = -2699.309;

[Xt,ShearFt,BendMt]=SFBM('Shaft_Analysis_t',[sl,bl3,bl4],{'CF',g3tf,gl3},{'CF',g4tf,gl4});

% point1=2.95;
% [~,location]=min(abs(Xxy-point1));
% m3r = BendMxy(location);
% % 
% point2=10.95;
% [~,location]=min(abs(Xxy-point2));
% m4r = BendMxy(location);


