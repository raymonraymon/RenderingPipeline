function mdl= local2world(mdl)
% the vertices of a model in its local coordinate system are transformed
% into the global coordinate system

dir= mdl.dir;
pos= mdl.pos;

v= mdl.vertices;
v= v* rot(dir)';
v= bsxfun(@plus, v, pos);
mdl.vertices= v;

if isfield(mdl,'normal_vertices') & ~isempty(mdl.normal_vertices)
    vn= mdl.normal_vertices;
    vn= vn* rot(dir)';
    mdl.normal_vertices= vn;
end

end