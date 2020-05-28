function mdl= createViewFrustrumPyramid(camera)

% plot pyramid shaped bounding box
xn= camera.near;
xf= camera.far;
yn= xn* tan(camera.alpha/2);
zn= xn* tan(camera.beta/2);
yf= xf* tan(camera.alpha/2);
zf= xf* tan(camera.beta/2);

v= [ xn  xn  xn xn   xf  xf xf xf;
    -yn -yn  yn yn  -yf -yf yf yf;
    -zn  zn zn -zn  -zf zf zf -zf]';
mdl.vertices= v;

f= [
    1 2 3;
    3 4 1;
    5 6 7;
    7 8 5;
    1 5 2;
    2 5 6;
    2 6 3;
    3 6 7;
    3 7 4;
    4 7 8;
    4 8 1;
    1 8 5];


mdl.faces= f;
mdl.normal_vertices= [];
mdl.normal_faces= [];
mdl.vertex_colors= [];

mdl.texture= [];
mdl.texture_faces= [];
mdl.texture_vertices= [];

mdl.dir= camera.dir;
mdl.pos= camera.pos;

end