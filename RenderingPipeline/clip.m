function mdl= clip(mdl)
% more general version of an clipping algorithm, as it applies the earlier
% algorithm iteratively to consider all cutting planes
%
% a set of faces is cut by special planes. Their attributes are
% interpolated accordingly. In order for this algorithm to work, the
% cutting planes must be perpendicular towards the coordinate axes.

% mdl= teapot;

if isempty(mdl)
    return
end


v= mdl.vertices;
vn= mdl.normal_vertices;
if isempty(mdl.texture_vertices)
    vt= mdl.vertex_colors;
else
    vt= mdl.texture_vertices;
end

va= [vn, vt];
clear vn vt


% define a plane in the following fashion
% [axis-index; offset]
% AXIS-INDEX is the index of the coordinate axis, which is cut by the plane
% OFFSET defines the relative position of the cut
% sign(AXIS-INDEX) defines the direction of the plane normal

planes= [1 -1  2 -2  3 -3;
        -1  1 -1  1 -1  1]; % defines the interior of the unit cube
% planes= [1;-0.5];
% planes= [ 2 -1 ; -1 -0.5];
% planes= [-1 2;-0.5 -1];


for l=1:size(planes,2)
    new_v= zeros(size(v,1)*2, 3);
    new_va= zeros(size(va,1)*2, size(va,2));
    new_idx= 1;
    
    idx_outside= v(:,abs(planes(1,l))) < planes(2,l);
    if sign(planes(1,l)) < 0
        idx_outside= ~idx_outside;
    end
    
    for k=1:3:size(v,1)
       v_= v(k:k+2,:);
       va_= va(k:k+2,:);
       
%        clf;
%        xlabel x
%        ylabel y
%        zlabel z
%        grid on
%        hold on
%        patch(v_(:,1), v_(:,2), v_(:,3), [1;1;1], 'FaceAlpha', 0.3, 'EdgeColor', 'b');
%        view(3)
       
       num_vertices_outside= sum(idx_outside(k:k+2));
       
       
       switch num_vertices_outside
           case 3 % all vertices are outside the bounding box.
               % So either the face is outside and needs not be rendered 
               % or is very big. For the sake of simplicity, the later case
               % is not implemented, which might result in display errors
               % in case of too large triangles.
           case 2 % 2 vertices are outside the box -> replace face with up 
               % to 3? new faces, depending on how many bounding box planes
               % are cut. For simplicity, only accurate results are
               % provided for intersection with 1 plane.

               idx_out= find(idx_outside(k:k+2));
               idx_in= find(~idx_outside(k:k+2));
               p0= v_(idx_in,:);
               p1= v_(idx_out(1),:);
               p2= v_(idx_out(2),:);

               plane_idx= abs(planes(1,l));
               p10= p1-p0; % vector from vertex p0 (inside) to vertex p1
               t1= (planes(2,l)-p0(plane_idx))/p10(plane_idx); % calculating 
               % intersection from p0 to p1 on the plane
               p1p= p0+t1*p10; % p1p is the intersection point

               p20= p2-p0;
               t2= (planes(2,l)-p0(plane_idx))/p20(plane_idx);
               p2p= p0+t2*p20;


               new_v(new_idx +idx_in-1,:)= p0;
               new_v(new_idx +idx_out(1)-1,:)= p1p;
               new_v(new_idx +idx_out(2)-1,:)= p2p;
%                patch(new_v(new_idx:new_idx+2,1), new_v(new_idx:new_idx+2,2), ...
%                      new_v(new_idx:new_idx+2,3), [1;1;1], 'FaceAlpha', 0.6, 'EdgeColor', 'r');
                 
               new_va(new_idx +idx_in-1,:)= va_(idx_in, :);
               new_va(new_idx +idx_out(1)-1,:)= t1   * va_(idx_out(1), :) + ...
                                               (1-t1)* va_(idx_in, :);
               new_va(new_idx +idx_out(2)-1,:)= t2   * va_(idx_out(2), :) + ...
                                               (1-t2)* va_(idx_in, :);

               new_idx= new_idx +3;

           case 1 % 1 vertex outside -> replace face with 2 new 
               % faces, depending on how many bb planes are cut. Same
               % simple assumption as above; so 1 face is edited and 1 is
               % added.
               idx_out= find(idx_outside(k:k+2));
               idx_in= find(~idx_outside(k:k+2));
               p0= v_(idx_in(1),:);
               p1= v_(idx_in(2),:);
               p2= v_(idx_out,:); % outside

               plane_idx= abs(planes(1,l));
               p21= p2-p1;
               t1= (planes(2,l)-p1(plane_idx))/p21(plane_idx);
               p1p= p1+t1*p21;

               p20= p2-p0;
               t2= (planes(2,l)-p0(plane_idx))/p20(plane_idx);
               p2p= p0+t2*p20;

               % first triangle
               new_v(new_idx:new_idx+2,:)= v_;
               new_v(new_idx+idx_out-1,:)= p1p;
               new_va(new_idx:new_idx+2,:)= va_;
               new_va(new_idx+idx_out-1,:)= va_(idx_out,:) + ...
                                        (1-t1) *(va_(idx_in(2),:)-va_(idx_out,:));

%                patch(new_v(new_idx:new_idx+2,1), new_v(new_idx:new_idx+2,2), ...
%                      new_v(new_idx:new_idx+2,3), [1;1;1], 'FaceAlpha', 0.6, 'EdgeColor', 'r');
               new_idx= new_idx +3;

               % second triangle
               new_v(new_idx:new_idx+2,:)= [p1p; p2p; v_(idx_in(1),:)];
               new_va(new_idx+0,:)= va_(idx_out,:) + (1-t1) *(va_(idx_in(2),:)-va_(idx_out,:));
               new_va(new_idx+1,:)= va_(idx_out,:) + (1-t2) *(va_(idx_in(1),:)-va_(idx_out,:));
               new_va(new_idx+2,:)= va_(idx_in(1),:);

               n= normals(v_);
               n_= normals(new_v(new_idx:new_idx+2,:));
               if sum(abs(n - n_)) > 0.5 
                   new_v([new_idx,new_idx+1],:)= new_v([new_idx+1,new_idx],:);
                   new_va([new_idx,new_idx+1],:)= new_va([new_idx+1,new_idx],:);
               end
%                patch(new_v(new_idx:new_idx+2,1), new_v(new_idx:new_idx+2,2), ...
%                      new_v(new_idx:new_idx+2,3), [1;1;1], 'FaceAlpha', 0, 'EdgeColor', 'r');
               new_idx= new_idx +3;

           case 0 % all vertices inside the box
               % do nothing
               new_v(new_idx:new_idx+2,:)= v(k:k+2,:);
               new_va(new_idx:new_idx+2,:)= va(k:k+2,:);
               new_idx= new_idx +3;
           otherwise
               error('this cannot be happening');
       end
    end

    new_va(:,1:3)= bsxfun(@rdivide, new_va(:,1:3), sqrt(sum(new_va(:,1:3).*new_va(:,1:3),2)));
    
    v= new_v(1:new_idx-1,:);
    va= new_va(1:new_idx-1,:);
end





mdl.vertices= v;
mdl.normal_vertices= va(:,1:3);

if isempty(mdl.texture_vertices)
    mdl.vertex_colors= va(:,4:end);
else
    mdl.texture_vertices= va(:,4:end);
end

% viewModel(mdl);


end