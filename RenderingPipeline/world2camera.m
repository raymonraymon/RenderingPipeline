function mdl= world2camera(camera, mdl)

v= mdl.vertices;
vp= mdl.vertices;
v= bsxfun(@plus, v, -camera.pos);
v= v* rot(camera.dir);

if isfield(mdl, 'faces')
    f= mdl.faces';
    v= v(f(:),:);
end

v(:,[1,2])= -v(:,[1,2]);
mdl.vertices= v;

%% transforming the normals

if isfield(mdl, 'normal_vertices') & ~isempty(mdl.normal_vertices)
    vn= mdl.normal_vertices;
    fn= mdl.normal_faces';

    src= vp(f(:),:);
    dest= src+ vn(fn(:),:);

    src= bsxfun(@plus, src, -camera.pos);
    src= src* rot(-camera.dir)';
    dest= bsxfun(@plus, dest, -camera.pos);
    dest= dest* rot(-camera.dir)';

    vn= dest- src;
    vn(:,[1,2])= -vn(:,[1,2]);

    mdl.normal_faces= [];
    mdl.normal_vertices= vn;
end


if isfield(mdl, 'faces')
    mdl.faces= [];
end

%% changing the texture coordinates into another representation

if isfield(mdl, 'texture') & ~isempty(mdl.texture)
    vt= mdl.texture_vertices;
    ft= mdl.texture_faces';
    vt= vt(ft(:),:);

    mdl.texture_faces= [];
    mdl.texture_vertices= vt;
end
    
%%

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
% for k=1:size(vn, 1)
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