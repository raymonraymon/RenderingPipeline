%视锥体可视化
clear
clc
close all
cameraPos=[3 5 3];
target= -cameraPos + [140,10,160];
up=[0,0,1];
up = up./norm(up,2);
forward=target-cameraPos;
forward = forward./norm(forward,2);
side = cross(forward,up);
side = side./norm(side,2);

%%
alpha = pi/6;%水平视角
beta = pi/4;%垂直视角(可以通过定义横纵比)
n= 1;%近锥平面离相机原点的距离
f=20;

dxnear1 = n*forward+side*n*tan(alpha/2)-up*n*tan(beta/2);
dxnear2 = n*forward-side*n*tan(alpha/2)+up*n*tan(beta/2);

dynear1 = n*forward+up*n*tan(beta/2)+side*n*tan(alpha/2);
dynear2 = n*forward-up*n*tan(beta/2)-side*n*tan(alpha/2);


dxfar1 = f*forward+side*f*tan(alpha/2)-up*f*tan(beta/2);
dxfar2 = f*forward-side*f*tan(alpha/2)+up*f*tan(beta/2);

dyfar1 = f*forward+up*f*tan(beta/2)+side*f*tan(alpha/2);
dyfar2 = f*forward-up*f*tan(beta/2)-side*f*tan(alpha/2);

Vcone = repmat(cameraPos,8,1) +[dxnear1;dxnear2;dynear1;dynear2;dxfar1;dxfar2;dyfar1;dyfar2];

Fcone = [1 4 2 3 ;5 8 6 7;1 5 8 4;4 8 6 2;7 6 2 3; 1 5 7 3 ];

patch('Faces',Fcone,'Vertices',Vcone,'FaceColor','red','FaceAlpha',.3)
view(3);
axis equal

hold on;

plot3(cameraPos(:,1),cameraPos(:,2),cameraPos(:,3),'*r');
hold on
%%
cameraPos= cameraPos + 3* forward;

Vcone = repmat(cameraPos,8,1) +[dxnear1;dxnear2;dynear1;dynear2;dxfar1;dxfar2;dyfar1;dyfar2];

patch('Faces',Fcone,'Vertices',Vcone,'FaceColor','green','FaceAlpha',.8)
hold on;
plot3(cameraPos(:,1),cameraPos(:,2),cameraPos(:,3),'*g');