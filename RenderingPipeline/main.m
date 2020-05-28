% A straight forward implementation of the rendering pipeline.
% This script loads a 3d textured model, shows its position and orientation
% in world coordinates and renders it with 2 simple lighting models through
% a virtual camera. This is accomplished by 2 rotations, 2 translations and
% some perspective corrected projection. The model is culled (remove 
% unnecessary faces) and clipped (faces outside the view frustrum are 
% removed) to illustrate the optimization process inside the rendering 
% pipeline. At last the scene is rendered with 2 lighting models and
% shaders to show the most common illumination techniques.
%
% The main script is partitioned into dependent cells, that illustrate some
% of the more interesting steps of the rendering pipeline.

% The rendering pipeline is implemented as I understand it from this book:
% Mathematics for 3D Game Programming and Computer Graphics
% Third Edition (2012), Course Technology CENGAGE Learning
% Eirc Lengyel

% programmed by Karsten Bartecki
% 31.07.18

% todo:
% bugs in culling
% ground is not rendered properly
% clipping createGround tidy up
% load mdl
% save teapot as mdl
% blinn-phong
% nice demo-script: see different rendering techniques

% removed bugs from 1.0
% world2camera.m    wrong rotation matrix
% undesired clipping behavior
% bad implementation of the ground faces
% empty objects (due to clipping and culling) result in error messages
% during rendering

%% step 1: load some models and display them

clear
clc
close all

camera.pos= [-2 2 1]; % camera position and orientation
camera.dir= [0 0 pi/5]; % rotation around x, y then z axis
% right handed coordinate system

camera.near= 10; % distance of the clipping plane in front of the camera 
% (parallel) to the screen. Objects that are closer are partly or not at 
% all rendered. Set it always to some positive number (>= 0.5).
camera.far= 20; % distance of the other clipping plane. Set it to a bigger 
% number than camera.near
camera.alpha= 30/180*pi; % horizontal opening angle
camera.beta= 20/180*pi; % vertical opening angle


teapot= loadTeapot();
teapot.pos= [10 8 1];
teapot.dir= [0 0 -pi/4];

triangle= loadTriangle();
triangle.vertices= triangle.vertices*2;
triangle.vertices(end)=10;
triangle.pos= [10 12 1];
triangle.pos= [6 9 0];
triangle.dir= [-0.85*pi/2 0 -pi/4*1.7];

ground= createGround(camera);
points= createPointline(camera);
cube= createViewFrustrumPyramid(camera);
figure;
%clf
%figure(1);
%subfig(2,5,1,1);
subplot(2,5,1);
viewLocal(teapot);



ambient= [1.0;1.0;1.0;0.4]; % r g b a, ambient light color

point_source.vertices= [5 8 0.5]; % x y z, point source position
point_source.color= [1;1;1;1.5]; % r g b a, point source light color
point_source.attenuation= [0.5;0.5;0.2]; % const, lin, quadr. attenuation


% step 2: transforming the local coordinates into global ones

teapot= local2world(teapot);
triangle= local2world(triangle);
ground= local2world(ground);
points= local2world(points);
cube= local2world(cube);

%figure(2);
%subfig(2,5,2,2);
subplot(2,5,2);
%clf
viewGlobal(camera, teapot, point_source, triangle, ground, points, cube);

%% step 3: transforming into eye space/ camera space

%figure(3);
%subfig(2,5,3,3);
subplot(2,5,3);
%clf

teapot= world2camera(camera, teapot);
triangle= world2camera(camera, triangle);
point_source= world2camera(camera, point_source);
ground= world2camera(camera, ground);
points= world2camera(camera, points);
cube= world2camera(camera, cube);
viewEye(camera, teapot, point_source, triangle, ground, points, cube);


%% step 4: face culling? -> saves time

teapot= cull(teapot);  % removes faces, that point from the camera away
% ground= cull(ground);
triangle= cull(triangle);
%figure(4);
%subfig(2,5,4,4);
subplot(2,5,4);
viewModel(teapot);
title('local coordinates after culling');

%% step 5: homogeneous clip space

%figure(5);
%subfig(2,5,5,5);
subplot(2,5,5);
%clf
teapot= camera2homogeneous(camera, teapot);
point_source= camera2homogeneous(camera, point_source);
triangle= camera2homogeneous(camera, triangle);
ground= camera2homogeneous(camera, ground);
points= camera2homogeneous(camera, points);

teapot= clip(teapot);
viewModel(teapot);
triangle= clip(triangle);
ground= clip(ground);

viewClip(teapot, point_source, ground, triangle, points);
title('homogeneous space (after clipping)');

% step 5: fragment operations
% window space

%%  simple rasterizing, 1 arbitrary color per face
[frameBuffer, zBuffer]= rasterize1(400, 300, teapot, ground, triangle);
%figure(6);
%subfig(2,5,6,6);
subplot(2,5,6);
image(uint8(frameBuffer));
title('simple rasterization');

%figure(7);
%subfig(2,5,7,7);
subplot(2,5,7);
imagesc(zBuffer);
title('z Buffer')
colormap gray
%%
[frameBuffer, ~]= rasterize2(400, 300, teapot, ground, triangle);

%figure(8);
%subfig(2,5,8,8);
subplot(2,5,8);
image(uint8(frameBuffer));
title('texture rasterization');

%% step 6: lighting


frameBuffer= rasterize4(400, 300, ambient, point_source, teapot, ground, triangle);
%figure(9);
%subfig(2,5,9,9);
subplot(2,5,9);
image(uint8(frameBuffer));
title('flat shading');

%%
% point_source.color(4)= 3000;
% point_source.vertices(2)= 1; % height
frameBuffer= rasterize3(400, 300, ambient, point_source, teapot, ground, triangle);
%figure(10);
%subfig(2,5,10,10);
subplot(2,5,10);
image(uint8(frameBuffer));
title('gourand shading');
