function model= loadTeapot(reducedVersion)
% creates a teapot model

if nargin == 0
    reducedVersion= false;
end

%% vertices for the model
% spherical part
v= [1.5*cos(2*pi*[0:4]/5);
    1.5*sin(2*pi*[0:4]/5);
    zeros(1,5)];
v= [v, [2*cos(2*pi*[0:4]/5);
        2*sin(2*pi*[0:4]/5);
        ones(1,5)]];
v= [v, [cos(2*pi*[0:4]/5);
        sin(2*pi*[0:4]/5);
        2*ones(1,5)]];
% part of the peck?, Schnabel?
% vertex 6 is also part of it
v= [v, [v(:,6)+ (v(:,7)-v(:,6))/5]]; % 16
v= [v, [v(:,6)+ (v(:,10)-v(:,6))/5]]; % 17
v= [v, bsxfun(@plus, v(:,[6,16,17]), 0.5*(v(:,6)-v(:,1)))]; % 18, 19, 20
% Henkel
v= [v, [0.9*v(:,3)+0.1*v(:,8)]];
v= [v, [0.5*v(:,3)+0.5*v(:,8)]];
v= [v, [0.5*v(:,3)+0.5*v(:,8)]];
v(2,21:23)= [0, -0.3, 0.3];

v= [v, repmat(v(:,21:23), [1,4])];
v(1,24:35)= v(1,24:35)+ 1.6180;
v(3,24:35)= v(3,24:35)- 1;
rotY= @(phi) [cos(phi) 0 -sin(phi); 0 1 0; sin(phi) 0 cos(phi)];
v(:,24:26)= 1.05*rotY(-2*pi/6)* v(:,24:26);
v(:,27:29)= 1.10*rotY(-4*pi/6)* v(:,27:29);
v(:,30:32)= 1.15*rotY(-6*pi/6)* v(:,30:32);
v(:,33:35)= 1.20*rotY(-8*pi/6)* v(:,33:35);
v(1,24:35)= v(1,24:35)- 1.6180;
v(3,24:35)= v(3,24:35)+ 1;
v(3,:)= v(3,:)-1;

v= v';

%% faces that construct the object
f= [...
    1 3 2; % bottom, start
    1 4 3;
    1 5 4; % bottom, end
    1 2 6; % lower part
    2 7 6;
    2 3 7;
    3 8 7;
    3 4 8;
    4 9 8;
    4 5 9;
    5 10 9;
    5 1 10;
    1 6 10; % lower part, end
    6 7 11; % upper part
    7 12 11;
    7 8 12;
    8 13 12;
    8 9 13;
    9 14 13;
    9 10 14;
    10 15 14;
    10 6 15;
    6 11 15; % upper part, end
    6 16 18; % peck
    16 19 18;
    16 17 19;
    17 20 19;
    17 6 20;
    6 18 20; % peck end
    18 19 20; % peck top
%     21 22 23; % henkel?
%     24 25 26;
%     27 28 29;
%     30 31 32;
%     33 34 35; % henkel? ende
    21 22 24; % henkel
    22 25 24;
    22 23 25;
    23 26 25;
    23 21 26;
    21 24 26;
    24 25 27; %
    25 28 27;
    25 26 28;
    26 29 28;
    26 24 29;
    24 27 29;
    27 28 30; %
    28 31 30;
    28 29 31;
    29 32 31;
    29 27 32;
    27 30 32;
    30 31 33; %
    31 34 33;
    31 32 34;
    32 35 34;
    32 30 35;
    30 33 35; % henkel ende
    ];

if reducedVersion
    f(1:3,:)= [];
    f(21:end,:)= [];
end

%% normal vectors for each vertex in each frame (for lighting purposes)
vn=[1.5000         0   -1.0000; % 1-5 body, lower edge
    0.4635    1.4266   -1.0000;
   -1.2135    0.8817   -1.0000;
   -1.2135   -0.8817   -1.0000;
    0.4635   -1.4266   -1.0000;
    2.0000         0         0; % 6-10 body, center part
    0.6180    1.9021         0;
   -1.6180    1.1756         0;
   -1.6180   -1.1756         0;
    0.6180   -1.9021         0; %
    1.0000         0    1.0000; % 11-15 body, upper edge
    0.3090    0.9511    1.0000;
   -0.8090    0.5878    1.0000;
   -0.8090   -0.5878    1.0000;
    0.3090   -0.9511    1.0000;
    1 0 0; % schnabel 16-19
    -1 1.5 0;
    -1 -1.5 0;
    0 0 1; % 19
    0 0 -1;% 20 down
    0.1079         0   -0.2667; %21
    -0.0539   -0.3000    0.1333;
    -0.0539    0.3000    0.1333;
    -0.1859         0   -0.2381; %24
    0.0929   -0.3150    0.1190;
    0.0929    0.3150    0.1190;
   -0.3134         0    0.0439; %27
    0.1567   -0.3300   -0.0220;
    0.1567    0.3300   -0.0220;
   -0.1240         0    0.3067; % 30
    0.0620   -0.3450   -0.1533;
    0.0620    0.3450   -0.1533;
    0.2124         0    0.2721; % 33
   -0.1062   -0.3600   -0.1361;
   -0.1062    0.3600   -0.1361;   
    ];

vn= bsxfun(@rdivide, vn, sqrt(sum(vn.*vn, 2)));

%% mapping where to put each normal vertex
fn=[...
    20 20 20; % bottom, start
    20 20 20;
    20 20 20; % bottom, end
    
    1 2 6; % lower part
    2 7 6;
    2 3 7;
    3 8 7;
    3 4 8;
    4 9 8;
    4 5 9;
    5 10 9;
    5 1 10;
    1 6 10; % lower part, end	
    6 7 11; % upper part
    7 12 11;
    7 8 12;
    8 13 12;
    8 9 13;
    9 14 13;
    9 10 14;
    10 15 14;
    10 6 15;
    6 11 15; % upper part, end
    
    16 17 16; % peck
    17 17 16;
    17 18 17;
    16 18 17;
    18 16 18;
    16 16 18; % peck end
    19 19 19; % peck top
    
    21 22 24; % henkel
    22 25 24;
    22 23 25;
    23 26 25;
    23 21 26;
    21 24 26;
    24 25 27; %
    25 28 27;
    25 26 28;
    26 29 28;
    26 24 29;
    24 27 29;
    27 28 30; %
    28 31 30;
    28 29 31;
    29 32 31;
    29 27 32;
    27 30 32;
    30 31 33; %
    31 34 33;
    31 32 34;
    32 35 34;
    32 30 35;
    30 33 35; % henkel ende
    ];

if reducedVersion
    fn(1:3,:)= [];
    fn(21:end,:)= [];
end

%% vertices (2D) on a texture

% relative coordinates with origin in the lower left corner of the image
% first is x, then y coordinate

vt= [0.1000 0.0500; % black
    0.1333 0.0125;
    0.1000 0.0125;
    0.007 0.0125; % red
    0.015 0.0125;
    0.015 0.0250;
% repeating pattern start: up, mid, down
    0.2666 0.9000;
    0.2666 0.5250;
    0.2666 0.2500;
% repeating pattern end: up, mid, down
    0.6934 0.9000;
    0.6934 0.5250;
    0.6934 0.2500;
% handle 13-18
    0.3466 0.1875;
    0.4333 0.1875;
    0.3466 0.140;
    0.4333 0.140;
    0.3466 0.1000;
    0.4333 0.1000;];

%% which 3D vertex is mapped on what face-vertex

ft= [...
     4     5     6; % ground
     4     5     6;
     4     5     6;
% main body, lower part
     9     12    8;
     12    11    8;
     9     12    8;
     12    11    8;
     9     12    8;
     12    11    8;
     9     12    8;
     12    11    8;
     9     12    8;
     12    11    8;
% main body, upper part
     8    11  7;
     11   10  7;
     8    11  7;
     11   10  7;
     4    5   6;
     4    5   6;
     8    11  7;
     11   10  7;
     8    11  7;
     11   10  7;
% peck
     4    5    6;
     4    5    6;
     4    5    6;
     4    5    6;
     4    5    6;
     4    5    6;
     1    2    3;
% handle
    16   14   15;
    14   13   15;
    4    5    6;
    4    5    6;
    18   16   17;
    16   15   17;
    16   14   15;
    14   13   15;
    4    5    6;
    4    5    6;
    18   16   17;
    16   15   17;
    16   14   15;
    14   13   15;
    4    5    6;
    4    5    6;
    18   16   17;
    16   15   17;
    16   14   15;
    14   13   15;
    4    5    6;
    4    5    6;
    18   16   17;
    16   15   17;
    ];

if reducedVersion
    ft(1:3,:)= [];
    ft(21:end,:)= [];
end

%% remaining stuff

img= imread('teapot.png');
% rng(54897);
% img= randi(255, floor(size(img,1)/4), floor(size(img,2)/4), 3);

model.vertices= v;
model.faces= f;
model.normal_faces= fn;
model.normal_vertices= vn;
model.texture= img;
model.texture_faces= ft;
model.texture_vertices= vt;
model.vertex_colors= [];

%% script to find the normals for the handle

% for l=21:3:35
%     l
%     c= (v(l,:)+v(l+1,:)+v(l+2,:)) /3
%     v(l+0,:)-c
%     v(l+1,:)-c
%     v(l+2,:)-c
% end

% %% plotting
% f= model.faces';
% v= model.vertices(f(:),:);
% fn= model.normal_faces';
% vn= model.normal_vertices(fn(:),:);
% 
% clf
% num= length(v);
% xdata= reshape(v(:,1), [3,num/3]);
% ydata= reshape(v(:,2), [3,num/3]);
% zdata= reshape(v(:,3), [3,num/3]);
% cdata= 1+0*xdata;
% 
% patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
% hold on
% for k=1:length(vn)
%     plot3([v(k,1) v(k,1)+vn(k,1)], ...
%           [v(k,2) v(k,2)+vn(k,2)], ...
%           [v(k,3) v(k,3)+vn(k,3)], 'r');
% end
% hold off
% view(3)
% grid on
% xlabel x
% ylabel y
% zlabel z


end