function mdl= createGround(camera)

mdl= createViewFrustrumPyramid(camera);
mdl= local2world(mdl);

mdl.dir(1:2)= 0;
v= mdl.vertices;
v= bsxfun(@plus, v, -mdl.pos);
v= v* rot(mdl.dir);
mdl.vertices= v;

v= mdl.vertices;

mxX= max(v(:,1));
mnX= min(v(:,1));
mxY= max(v(:,2));
mnY= min(v(:,2));


mdl.vertices= [mnX mxX mxX mnX;
        mnY mnY mxY mxY;
        zeros(1,4)]';

mdl.faces= [1 2 3;3 4 1];

vn= [0 0 1];
fn= [1 1 1;
     1 1 1];
 
colors= repmat([239 228 176], [6, 1]);

mdl.normal_vertices= vn;
mdl.normal_faces= fn;
mdl.vertex_colors= colors;

mdl.texture= [];
mdl.texture_faces= [];
mdl.texture_vertices= [];

mdl.pos= camera.pos;
mdl.pos(3)= 0;
% mdl.dir= camera.dir;
mdl.dir= [0 0 camera.dir(3)];

% v= mdl.vertices;
% v= bsxfun(@plus, v, -mdl.pos);
% v= v* rot(mdl.dir);
% mdl.vertices= v;


end