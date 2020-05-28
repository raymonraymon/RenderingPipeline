function mdl= camera2homogeneous(camera, mdl)

% normal vectors aren't projected correctly?

if isempty(mdl)
    return
end

if ~isfield(mdl, 'faces')
    zn= -camera.near;
    zf= -camera.far;
    xn= abs(zn* tan(camera.alpha/2));
    yn= abs(zn* tan(camera.beta/2));

    v= mdl.vertices;

    v= [-v(:,2), v(:,3), -v(:,1)];

    M= [2*zn/(2*xn), 0 , 0, 0;
        0, 2*zn/(2*yn), 0, 0;
        0, 0, -(zn+zf)/(zf-zn), -2*zn*zf/ (zf-zn);
        0 0 -1 0];
    v= M* [v'; ones(1, size(v,1))];
    v= bsxfun(@rdivide, v, v(end,:));
    v= v(1:3,:)';

    mdl.vertices= v;
    
else
    
    zn= -camera.near;
    zf= -camera.far;
    xn= abs(zn* tan(camera.alpha/2));
    yn= abs(zn* tan(camera.beta/2));

    v= mdl.vertices;
    vn= mdl.normal_vertices;

    v= [-v(:,2), v(:,3), -v(:,1)];
    vn= 0.001*[-vn(:,2), vn(:,3), -vn(:,1)];%+ v;

    M= [2*zn/(2*xn), 0 , 0, 0;
        0, 2*zn/(2*yn), 0, 0;
        0, 0, -(zn+zf)/(zf-zn), -2*zn*zf/ (zf-zn);
        0 0 -1 0];
    v= M* [v'; ones(1, size(v,1))];
%     vn= M* [vn'; ones(1, size(vn,1))];
    v= bsxfun(@rdivide, v, v(end,:));
%     vn= bsxfun(@rdivide, vn, vn(end,:));
    v= v(1:3,:)';
%     vn= (vn(1:3,:)'-v);
    vn= bsxfun(@rdivide, vn, sqrt(sum(vn.*vn,2)));

    % num= size(v,1);
    % xdata= reshape(v(:,1), [3,num/3]);
    % ydata= reshape(v(:,2), [3,num/3]);
    % zdata= reshape(v(:,3), [3,num/3]);
    % cdata= 1+0*xdata;
    % 
    % patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
    % hold on
    % for k=1:size(v,1)
    %     plot3([v(k,1) v(k,1)+vn(k,1)], [v(k,2) v(k,2)+vn(k,2)], [v(k,3) v(k,3)+vn(k,3)], 'r');
    % end
    % hold off
    mdl.vertices= v;
    mdl.normal_vertices= vn;

end

end