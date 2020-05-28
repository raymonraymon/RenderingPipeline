%%
%https://blog.csdn.net/wangdingqiaoit/article/details/51570001
clear all
clc
close all
[v,F]=readOFF('ExampleElephant.off');
%N = per_vertex_normals(v,F);
NF = compute_face_normal(v,F);
NF = NF';
%%
subplot(1,2,1);
drawMesh(v, F, 'facecolor','g','edgecolor','k','FaceAlpha',.1);
%%
[sizev,~]=size(v);
[sizeF,~]=size(F);
v=[v,ones(sizev,1)];


% change num to modify view direction
num =48000;
target= v(num,1:3);
forward =- target + mean(v(:,1:3));
forward = forward./norm(forward,2);
cameraPos=target - 50*forward;


up=[0,0,1];
up = up./norm(up,2);

side = cross(forward,up);
side = side./norm(side,2);

%%

%%

viewmatrix=[side(1) side(2) side(3) -dot(side,cameraPos);
    up(1) up(2) up(3) -dot(up,cameraPos);
    -forward(1) -forward(2) -forward(3) dot(forward,cameraPos);
    0       0       0        1];

ViewPos=viewmatrix*v';

%%

if 1   
%透视投影
%https://www.cnblogs.com/hefee/p/3820610.html
alpha = pi/6;
beta = pi/5;
n= 10;
f=200;
dxnear1 = cameraPos+n*forward+side*n*tan(alpha/2)-up*n*tan(beta/2);
dxnear2 = cameraPos+n*forward-side*n*tan(alpha/2)+up*n*tan(beta/2);

dynear1 = cameraPos+n*forward+up*n*tan(beta/2)+side*n*tan(alpha/2);
dynear2 = cameraPos+n*forward-up*n*tan(beta/2)-side*n*tan(alpha/2);


dxfar1 = cameraPos+f*forward+side*f*tan(alpha/2)-up*f*tan(beta/2);
dxfar2 = cameraPos+f*forward-side*f*tan(alpha/2)+up*f*tan(beta/2);

dyfar1 = cameraPos+f*forward+up*f*tan(beta/2)+side*f*tan(alpha/2);
dyfar2 = cameraPos+f*forward-up*f*tan(beta/2)-side*f*tan(alpha/2);

Vcone = [dxnear1;dxnear2;dynear1;dynear2;dxfar1;dxfar2;dyfar1;dyfar2];

Fcone = [1 4 2 3 ;5 8 6 7;1 5 8 4;4 8 6 2;7 6 2 3; 1 5 7 3 ];
hold on
patch('Faces',Fcone,'Vertices',Vcone,'FaceColor','red','FaceAlpha',.3)
view(3);
axis equal
hold on
plot3(cameraPos(:,1),cameraPos(:,2),cameraPos(:,3),'*r');
hold on
plot3(target(:,1),target(:,2),target(:,3),'*g');
  

l=-n*tan(alpha/2);
r=n*tan(alpha/2);
b=-n*tan(beta/2);
t=n*tan(beta/2);

projMatrix=[2*n/(r-l) 0         (r+l)/(r-l)   0;
    0           2*n/(t-b) (t+b)/(t-b)   0;
    0           0         -(f+n)/(f-n)  -2*n*f/(f-n);
    0           0         -1            0];

else
%正交投影
l=-30;
r=30;
b=-20;
t=20;
n=10;
f = 100;

dxnear1 = cameraPos+n*forward+side*l+up*b;
dxnear2 = cameraPos+n*forward+side*l+up*t;
dynear1 = cameraPos+n*forward+side*r+up*t;
dynear2 = cameraPos+n*forward+side*r+up*b;


dxfar1 = cameraPos+f*forward+side*l+up*b;
dxfar2 = cameraPos+f*forward+side*l+up*t;
dyfar1 = cameraPos+f*forward+side*r+up*t;
dyfar2 = cameraPos+f*forward+side*r+up*b;

Vcone = [dxnear1;dxnear2;dynear1;dynear2;dxfar1;dxfar2;dyfar1;dyfar2];

Fcone = [1 2 3 4 ;5 6 7 8;2 6 7 3;3 7 8 4; 1 5 8 4 ;2 6 5 1 ];
hold on
patch('Faces',Fcone,'Vertices',Vcone,'FaceColor','red','FaceAlpha',.3)
view(3);
axis equal
hold on
plot3(cameraPos(:,1),cameraPos(:,2),cameraPos(:,3),'*r');
hold on
plot3(target(:,1),target(:,2),target(:,3),'*g');

projMatrix=[2/(r-l)   0          0        -(r+l)/(r-l);
    0           2/(t-b)    0        -(t+b)/(t-b);
    0           0         -2/(f-n)  -(f+n)/(f-n);
    0           0          0         1];
end

projPos = projMatrix*ViewPos;
projPos = projPos';

%perspective Divide
for i =1:sizev
    projPos(i,1:4) = projPos(i,1:4)/projPos(i,4);
end
NDCPos = projPos(:,1:3);

%%
subplot(1,2,2);drawMesh(NDCPos, F, 'facecolor','g','edgecolor','y');
axis off