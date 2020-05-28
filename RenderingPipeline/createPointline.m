function mdl= createPointline(camera)
% creates some equidistant 3D points to show how they look in homogeneous
% coordinates

% plot pyramid shaped bounding box
xn= camera.near;
xf= camera.far;
yn= xn* tan(camera.alpha/2);
zn= xn* tan(camera.beta/2);
yf= xf* tan(camera.alpha/2);
zf= xf* tan(camera.beta/2);

mdl.vertices= [linspace(xf,xn,10)' linspace(-yf,-yn,10)' linspace(-zf,-zn,10)'];


mdl.pos= camera.pos;
mdl.dir= camera.dir;

end