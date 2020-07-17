clear all;
%close all;
clc;

% All units in terms of lbf and inch (including psi)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                             FEM Inputs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shaft geometry
sec_num=7; % total section number
d_sec=[2.25 2.5 3 3.6 3 2.5 2.25]; % diameter of each section
L_sec=[1 0.5 3.2 3.2 3.2 0.5 1]; % length of each section


% load information
%F=[967.32 -2708.53]; % tangential
F=[-352.078 -985.82]; % radial
x_F=[3.2 9.4]; % load positions

% bearing location
x_b=[0 13.9]; % bearing positions

% Element number
nElements = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate mesh
x_sec=zeros(1,sec_num+1);
for i=2:sec_num+1
    x_sec(i)=x_sec(i-1)+L_sec(i-1);
end
x_part=sort([x_sec x_F x_b]); % position of all partitions 

L_shaft=sum(L_sec); % total length of shaft
nEle_part=zeros(1,length(x_part)-1);
L=[];
d=[];
for i=1:length(x_part)-2
    nEle_part(i)=round(nElements*(x_part(i+1)-x_part(i))/L_shaft); % element number in each partition
    Le=(x_part(i+1)-x_part(i))/nEle_part(i);
    L=[L Le*ones(1,nEle_part(i))]; % element length vector
    for j=1:sec_num 
        if (x_sec(j)<=x_part(i))&&(x_part(i)<x_sec(j+1)) % identify the section of elements
            d=[d d_sec(j)*ones(1,nEle_part(i))]; % eleement diameter vector
            break;
        end
    end
end
nEle_part(end)=nElements-sum(nEle_part(1:end-1));
Le=(x_part(end)-x_part(end-1))/nEle_part(end);
L=[L Le*ones(1,nEle_part(end))];
d=[d d_sec(end)*ones(1,nEle_part(end))];

F1node=0;
for j=1:find(x_part==x_F(1))-1
    F1node=nEle_part(j)+F1node;
end
F1node=F1node+1;

F2node=0;
for j=1:find(x_part==x_F(2))-1
    F2node=nEle_part(j)+F2node;
end
F2node=F2node+1;

pinnode=0;
for j=1:find(x_part==x_b(1))-1
    pinnode=nEle_part(j)+pinnode;
end
pinnode=pinnode+1;

rollernode=0;
for j=1:find(x_part==x_b(2))-1
    rollernode=nEle_part(j)+rollernode;
end
rollernode=rollernode+1;

F1=F(1);
F2=F(2);

% material properties
YM=5300000; % Young's modulus unit: psi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


A = pi*d.^2/4; % vector of element cross-sectional area
I = pi*d.^4./64; % vector of element moment of inertia
nNodes = nElements + 1; % number of nodes
nDof = 3*nNodes; % degrees of freedom


E = YM*ones(1,nElements); % vector of element modulus of elasticity
% Step 1: Construct element stiffness matrix
k = zeros(6,6,nElements);
for n = 1:nElements
k11 = A(n)*E(n)/L(n); k22 = 12*E(n)*I(n)/L(n)^3;
k23 = 6*E(n)*I(n)/L(n)^2; k33 = 4*E(n)*I(n)/L(n);
k36 = 2*E(n)*I(n)/L(n);
k(:,:,n) = [ ...
k11 0 0 -k11 0 0;
0 k22 k23 0 -k22 k23;
0 k23 k33 0 -k23 k36;
-k11 0 0 k11 0 0;
0 -k22 -k23 0 k22 -k23;
0 k23 k36 0 -k23 k33];
end


% Step 2: Combine element stiffness matrices to form global stiffness
% matrix
shift = 0;
Ke = zeros(nDof,nDof,nElements);
for n = 1:nElements
    for i = 1:6
        for j = 1:6
            Ke(i+shift,j+shift,n) = k(i,j,n);
        end
    end
    shift = shift + 3;
end
K = sum(Ke,3);

F = zeros(nDof,1);
F(3*(F1node-1)+2) = F1;
F(3*(F2node-1)+2) = F2;

% Step 3: Reduce global stiffness and force matrices with constraints --
% remove columns from right to left, and rows from bottom to top.
Kr = K; Fr = F;
Kr(:,3*(rollernode-1)+2) = []; Kr(3*(rollernode-1)+2,:) = [];
Kr(:,3*(pinnode-1)+2) = []; Kr(3*(pinnode-1)+2,:) = [];
Kr(:,3*(pinnode-1)+1) = []; Kr(3*(pinnode-1)+1,:) = [];
Fr(3*(rollernode-1)+2) = [];
Fr(3*(pinnode-1)+2) = [];
Fr(3*(pinnode-1)+1) = [];

% Step 4: Solve for unknown displacements
Ur = Kr\Fr;

% Step 5: Solve for forces -- first augment Ur with constrained
% displacements
U = [ Ur(1:3*(pinnode-1)); 0 ; 0; ...
Ur(3*(pinnode-1)+1:3*(rollernode-1)-1); ...
0; Ur(3*(rollernode-1):end) ];
F = K*U;
x=zeros(1,nNodes);
for i=2:nNodes
    x(i)=x(i-1)+L(i-1);
end
Uy = U(2:3:end);
slope=U(3:3:end);

figure (3)
plot(x,Uy,'b+-'); grid on; title('Simply supported stepped shaft');
xlabel('Position along shaft (inch)'); ylabel('Deflection (inch)');

figure (4)
plot(x,slope,'b+-'); grid on; title('Simply supported stepped shaft');
xlabel('Position along shaft (inch)'); ylabel('slope (rad)');

fprintf ('==============  FEM Output =================\n')
fprintf ('- slope at first bearing: %s rad\n', num2str(slope(pinnode)))
fprintf ('- slope at second bearing: %s rad\n', num2str(slope(rollernode)))
fprintf ('- slope at first gear: %s rad\n', num2str(slope(F1node)))
fprintf ('- slope at second gear: %s rad\n', num2str(slope(F2node)))
fprintf ('- displacement at first gear: %s in\n', num2str(Uy(F1node)))
fprintf ('- displacement at second gear: %s in\n', num2str(Uy(F2node)))
fprintf ('===========================================\n')

