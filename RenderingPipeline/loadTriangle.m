function mdl= loadTriangle()


v= [sqrt(1/2) 0 0;
    -sqrt(1/2) 0 0;
    0 0 1];

f= [1 3 2];

vn= [0 -1 0];
fn= [1 1 1];

colors= eye(3)*255;

mdl.vertices= v;
mdl.faces= f;
mdl.normal_vertices= vn;
mdl.normal_faces= fn;
mdl.vertex_colors= colors;

mdl.texture= [];
mdl.texture_faces= [];
mdl.texture_vertices= [];


end