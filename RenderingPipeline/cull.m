function mdl= cull(mdl)

v= mdl.vertices;

n= normals(v);
n= sign(n(:,1))';
n= repmat(n, [3,1]);
n= n(:);

idx= n < 0; % this is not entirely correct
try
    mdl.vertices(idx,:)= [];
    mdl.normal_vertices(idx,:)= [];
    mdl.texture_vertices(idx,:)= [];
catch err
    mdl= [];
end
    
end