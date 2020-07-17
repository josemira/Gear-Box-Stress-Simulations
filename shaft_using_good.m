clear all
clc
%% ---------    Total Moment Diagram    -------------
sl = 11.6; % shaft length

bl3 = 0; % bearing location 1
bl4 = 11.6; % bearing location 2 


gl3 = 2.7; %gear location 3

gl4 = 8.9; %gear location 4

g3tf = 153.87;
g4tf = -2699.309;

[Xt,ShearFt,BendMt]=SFBM('Shaft_Analysis_t',[sl,bl3,bl4],{'CF',g3tf,gl3},{'CF',g4tf,gl4});

pointI=7.4;
[~,location]=min(abs(Xt-pointI));
mI = BendMt(location);

pointJ=8.9;
[~,location]=min(abs(Xt-pointJ));
mJ = BendMt(location);

pointkeylj=7.9;
[~,location]=min(abs(Xt-pointkeylj));
mkeylj = BendMt(location);

pointkeyrj=9.9;
[~,location]=min(abs(Xt-pointkeyrj));
mkeyrj = BendMt(location);

pointK=10.5;%you can move it closer to actual location, this is conservative
[~,location]=min(abs(Xt-pointK));
mK = BendMt(location);

pointH=10.6;
[~,location]=min(abs(Xt-pointH));
mH = BendMt(location);

pointN=11.1;
[~,location]=min(abs(Xt-pointN));
mN = BendMt(location);

%% Starting Diameter for D5

Ma = mI; %at I
Tm = 201.52;

%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;
shldr = 'wlr';
surff = 'CD';
n = 1.5;

%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    %r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    %r = d*0.02;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end
   

Kf = Kt;
Kfs = Kts;


%-------   Se' ,Equation 6-8, pg.282   ----------
if Sut <= 200
    Sep = 0.5*Sut;
elseif Sut > 200
        Sep = 100;
end



kb = 0.9;


%-------   ka, Table 6-2,pg. 288   -------
if surff=='gd' %ground finish
        a = 1.34;
        b = -0.085;
        
elseif surff=='CD' %machine or cold drawn
        a = 2.7;
        b = -0.265;
        
elseif surff=='HR' %Hot Rolled
        a = 14.4;
        b = -0.718;
            
elseif surff=='AF' %As Forge
        a = 39.9;
        b = -0.995;    
end          
                
      ka = a*(Sut^b);
      
    %neglecting effects of kc, kd, ke, kf = 1
    kc=1;
    kd=1;
    ke=1;
    kf=1;

    
Se = ka*kb*kc*kd*ke*kf*Sep;

Ta=0;% Constant Torque
Mm=0;% fully reversible Moment


%---------    GoodMan -------

d = ((((16*n)/pi)*(((1/(Se*1000))*(((4*((Kf*Ma)^2))+(3*((Kfs*Ta)^2)))^0.5))+...
     ((1/(Sut*1000))*(((4*((Kf*Mm)^2))+(3*((Kfs*Tm)^2)))^0.5))))^(1/3));

   
%% Fillet from D4 - D5, Point I 
%Now using new diameter find safety factor, since previous diam was conservative
   
d=3;
   
shldr = 'wlr';
    

%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.02;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end
   


%-----  Stress Concentration Factors Equation 6-32, pg.295   ------
Kf = Kt;
Kfs = Kts;

%------------Endurance Limit Modification Factors------

%         Se = ka*kb*kc*kd*ke*kf*Sep;
    %neglecting effects of kc, kd, ke, kf = 1
    kc=1;
    kd=1;
    ke=1;
    kf=1;
       


%-------   ka, Table 6-2,pg. 288   -------
if surff=='gd' %ground finish
        a = 1.34;
        b = -0.085;       
elseif surff=='CD' %machine or cold drawn
        a = 2.7;
        b = -0.265;      
elseif surff=='HR' %Hot Rolled
        a = 14.4;
        b = -0.718;          
elseif surff=='AF' %As Forge
        a = 39.9;
        b = -0.995;  
end          
         
      ka = a*(Sut^b);
                     
%-------   kb, Equation 6-20, pg.288   -------
 if(0.11 <=d && d <= 2)
        kb = 0.879*(d^(-0.107));
 elseif (2 < d && d <=10)
        kb = 0.91*(d^(-0.157));
 end
%-----  Endurance Limit Equation 6-18, pg.287    --------          
        
      Se = ka*kb*kc*kd*ke*kf*Sep;

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_I = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

D5 = d;
D3 = D5;

%% Safety factor at point J left end of keyway

d=3;
Ma = mkeylj;


shldr = 'emk';
surff = 'CD';
%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.01;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
    r = d*0.02;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end
   
%-----  Stress Concentration Factors Equation 6-32, pg.295   ------
Kf = Kt;
Kfs = Kts;


%-------   Se' ,Equation 6-8, pg.282   ----------
if Sut <= 200
    Sep = 0.5*Sut;
elseif Sut > 200
        Sep = 100;
end

%-------   ka, Table 6-2,pg. 288   -------
if surff=='gd' %ground finish
        a = 1.34;
        b = -0.085;       
elseif surff=='CD' %machine or cold drawn
        a = 2.7;
        b = -0.265;      
elseif surff=='HR' %Hot Rolled
        a = 14.4;
        b = -0.718;          
elseif surff=='AF' %As Forge
            a = 39.9;
        b = -0.995;  
end          
         
      ka = a*(Sut^b);

%-------   kb, Equation 6-20, pg.288   -------
 if(0.11 <=d && d <= 2)
        kb = 0.879*(d^(-0.107));
 elseif (2 < d && d <=10)
        kb = 0.91*(d^(-0.157));
 end
%-----  Endurance Limit Equation 6-18, pg.287    --------          
        
      Se = ka*kb*kc*kd*ke*kf*Sep;

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));


key_left_of_point_J = sprintf('nf = %s, radius at left end of keyway = %fin',nf,r)

%% Safety factor at point J right end of keyway

d=3;
Ma = mkeyrj;


shldr = 'emk';
surff = 'CD';
%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.01;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
    r = d*0.02;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end

%-------   Se' ,Equation 6-8, pg.282   ----------
if Sut <= 200
    Sep = 0.5*Sut;
elseif Sut > 200
        Sep = 100;
end

%-----  Stress Concentration Factors Equation 6-32, pg.295   ------
Kf = Kt;
Kfs = Kts;

%-------   ka, Table 6-2,pg. 288   -------
if surff=='gd' %ground finish
        a = 1.34;
        b = -0.085;       
elseif surff=='CD' %machine or cold drawn
        a = 2.7;
        b = -0.265;      
elseif surff=='HR' %Hot Rolled
        a = 14.4;
        b = -0.718;          
elseif surff=='AF' %As Forge
            a = 39.9;
        b = -0.995;  
end          
         
      ka = a*(Sut^b);

%-------   kb, Equation 6-20, pg.288   -------
if(0.11 <=d && d <= 2)
        kb = 0.879*(d^(-0.107));
elseif (2 < d && d <=10)
        kb = 0.91*(d^(-0.157));
end
%-----  Endurance Limit Equation 6-18, pg.287    --------          
        
      Se = ka*kb*kc*kd*ke*kf*Sep;

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));


key_right_of_point_J = sprintf('nf = %s, radius at right end of keyway = %fin',nf,r)


%% Groove at K

Ma = mK;
Mm = 0;
Ta = 0;
Tm = 0;

d = 3;

shldr = 'rrg';

%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.01;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
    r = d*0.02;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end

Kf = Kt;



sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));


disp('Groove at K')
point_K = sprintf('nf = %s  groove: width = 0.103 in, depth = 0.081 in ',nf)

%from ARCON RING AND SPECIALTY  CORPORATION, pg. 13,1400-300----
%width = 0.103 in
%thickness = 0.093 in
%depth = 0.081 in

%% Fillet from D5 - D6, point H
Ma = mH;
Mm = 0;
Ta = 0;
Tm = 0;

d=2.5;

shldr = 'wlr';

%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.01;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
    r = d*0.02;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end


Kf = Kt;

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));


disp('Fillet at H')
Hval = sprintf('nf = %s, radius of fillet = %d',nf,r)

D6 = d;
D2 = D6;

%% Fillet from D6 - D7, point G
Ma = mN;
Mm = 0;
Ta = 0;
Tm = 0;

d=2.25;


shldr = 'shp';


r = d*0.02;


%-------   First Iteration Estimates for Kt and Kts   -------
%--------  Table 7-1, pg. 373  --------

%input shoulder/groove type
if shldr == 'shp' %sharp (r/d = 0.02)
    Kt = 2.7;
    Kts = 2.2;
    r = d*0.02;
elseif shldr == 'wlr' %well rounded (r/d = 0.1)
    Kt = 1.7;
    Kts = 1.5;
    r = d*0.01;
elseif shldr == 'emk' %end-mill keyseat(r/d = 0.02)
    Kt = 2.14;
    Kts = 3;
    r = d*0.02;
elseif shldr == 'rrg' %reatining ring groove
    Kt = 5;
    Kts = 3;
end





Kf = Kt;


sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));



%disp('Fillet at N')
Nval = sprintf('nf = %s, radius of fillet = %d',nf,r);

%% Final Diameter Values

disp('D4 = 3.6 in')
disp('D3 = D5 = 3 in')
disp('D2 = D6 = 2.5 in')
disp('D1 = D7 = 2.25 in')



 
