clear all
clc

%% ---------    Total Moment Diagram    -------------

sl = 4.9; % shaft length

bl1 = 0; % bearing location 1
bl2 = 4.9; % bearing location 2 


gl1 = 2.7; %gear location 3


g1tf = -1029.4;%resultant force on gear 2

[Xt, ShearFt ,BendMt]=SFBM('Shaft_Analysis_t',[sl,bl1,bl2],{'CF',g1tf,gl1});

pointA=0.5;
[~,location]=min(abs(Xt-pointA));
mA = BendMt(location);

pointB=1;
[~,location]=min(abs(Xt-pointB));
mB = BendMt(location);

pointC=1.1;
[~,location]=min(abs(Xt-pointC));
mC = BendMt(location);

pointkeylZ=2.2;
[~,location]=min(abs(Xt-pointkeylZ));
mkeylZ = BendMt(location);

pointkeyrZ=3.2;
[~,location]=min(abs(Xt-pointkeyrZ));
mkeyrZ = BendMt(location);

pointF=4.2;
[~,location]=min(abs(Xt-pointF));
mF = BendMt(location);

pointE=4.4;
[~,location]=min(abs(Xt-pointE));
mE = BendMt(location);



%% Fillet at A
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;



Ma = mA; %at A
Tm = 201.52;
d = 1.25;


shldr = 'wlr';
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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_A = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%%  Fillet at B
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;



Ma = mB; %at A
Tm = 201.52;
d = 1.2;


shldr = 'wlr';
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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_B = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%% Fillet at C
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;


Ma = mC; %at A
Tm = 201.52;
d = 3;


shldr = 'rrg';
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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_C = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%% Safety factor at point Z left end of keyway
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;



Ma = mkeylZ; %at A
Tm = 201.52;
d = 3;


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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_mkeylZ = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%% Safety factor at point Z right end of keyway
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;



Ma = mkeyrZ; %at A
Tm = 0;
d = 3;


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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_mkeyrZ = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%% Fillet at E
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;


Ma = mE; %at A
Tm = 0;
d = 3;


shldr = 'wlr';
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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_E = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)

%% Fillet at F
%%% -------    1100 CD Steel
Sut = 203; 
Sy = 159;


Ma = mF; %at A
Tm = 0;
d = 1.125;


shldr = 'wlr';
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
    r = d*0.02;
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

sap = (32*Kf*Ma)/(pi*(d^3));
sam = (3*(((16*Kfs*Tm)/(pi*(d^3)))^2))^0.5;

nf = 1/((sap/(Se*1000))+(sam/(Sut*1000)));

ny = (Sy*1000)/(sap+sam);


Fillet_at_F = sprintf('nf = %s, ny = %d,   radius at fillet = %fin',nf,ny,r)
