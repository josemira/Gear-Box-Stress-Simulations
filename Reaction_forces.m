
%% Gear Forces
W23r=540;     %469.44;
W23t=197;     %1289.78;
W54r=885;    %1314.43;
W54t=2431;     %3611.38;

%366
%% Beam
%  .75    2.75               8.75    10.75
% -----------------------------------------
%   ^      ^                  ^        ^
%   |      |                  |        |
%   B3     G3                 G4       B4
l1=.75;       %.75;
l2=2.75;      %2.75;
l3=8.5;       %8.75;
l4=10.75;     %10.75;
l5=11.5;      %12;
%%

R_B4y=abs(((l2-l1)*W23r+(l3-l1)*W54r)/(l4-l1));
R_B4z=abs(((l2-l1)*W23t-(l3-l1)*W54t)/(l4-l1));
R_B3y=abs(((l4-l3)*W54r+(l4-l2)*W23r)/(l4-l1));
R_B3z=abs((-(l4-l3)*W54t+(l4-l2)*W23t)/(l4-l1));


%% x-y plane
%        W23r               W54r
%         v                  v
% ------------------------------------------
%  ^                                  ^
%  R_B3y                             R_B4y

%% y-z plane
%        W23t                        R_B4z
%         v                            v 
% ------------------------------------------
%  ^                          ^
% R_B3z                      W54t 

%% Reaction Plots
% x-y plane
seg1x=[l1,l2,l2,l1]; 
seg1y=[R_B3y,R_B3y,0,0]; 
seg2x=[l2,l3,l3,l2];
seg2y=[R_B3y-W23r,R_B3y-W23r,0,0];
seg3x=[l3,l4,l4,l3];
seg3y=[R_B3y-W23r-W54r,R_B3y-W23r-W54r,0,0];
seg4x=[l4,l5,l5,l4];
seg4y=[R_B3y-W23r-W54r+R_B4y,R_B3y-W23r-W54r+R_B4y,0,0];

figure
title('x-y plane')
hold on
fill([0,0],[0,0],'black')
fill(seg1x,seg1y,'blue')
fill(seg2x,seg2y,'green')
fill(seg3x,seg3y,'red')
fill(seg4x,seg4y,'magenta')
xlabel('inches')
ylabel('Load')

% y-z plane
seg1x=[l1,l2,l2,l1]; 
seg1y=[R_B3z,R_B3z,0,0]; 
seg2x=[l2,l3,l3,l2];
seg2y=[R_B3z-W23t,R_B3z-W23t,0,0];
seg3x=[l3,l4,l4,l3];
seg3y=[R_B3z-W23t+W54t,R_B3z-W23t+W54t,0,0];
seg4x=[l4,l5,l5,l4];
seg4y=[R_B3z-W23t+W54t-R_B4z,R_B3z-W23t+W54t-R_B4z,0,0];

figure
title('z-y plane')
hold on
fill([0,0],[0,0],'black')
fill(seg1x,seg1y,'blue')
fill(seg2x,seg2y,'green')
fill(seg3x,seg3y,'red')
fill(seg4x,seg4y,'magenta')
xlabel('inches')
ylabel('Load')












