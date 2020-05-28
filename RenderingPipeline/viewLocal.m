function viewLocal(model)
% displays a 3d model


f= model.faces;
v= model.vertices;
vn= model.normal_vertices;
fn= model.normal_faces;

c= zeros(size(f,1), 3);
n= zeros(size(f,1), 3);
for k=1:size(c,1)
    c(k,:)= mean(v(f(k,:),:), 1);
    n(k,:)= cross(v(f(k,2),:)-v(f(k,1),:), v(f(k,3),:)-v(f(k,1),:));
    n(k,:)= 0.2*n(k,:)/ norm(n(k,:));
end
%clf

if ~isempty(model.faces)
    patch('Faces', model.faces, 'Vertices', v, 'FaceAlpha', 0, 'EdgeColor', 'b');
else
    num= size(v,1);
    xdata= reshape(v(:,1), [3,num/3]);
    ydata= reshape(v(:,2), [3,num/3]);
    zdata= reshape(v(:,3), [3,num/3]);
    cdata= 1+0*xdata;

    patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
end

% plot face normals
hold on
% plot3(c(:,1), c(:,2), c(:,3), 'r.');
% for k=1:size(c,1)
%     plot3([c(k,1) c(k,1)+n(k,1)], ...
%           [c(k,2) c(k,2)+n(k,2)], ...
%           [c(k,3) c(k,3)+n(k,3)], 'r-');
% end

for k=1:size(fn,1)
    c= v(f(k,:),:);
    n= vn(fn(k,:),:)* 0.2;
    for l=1:3
        plot3([c(l,1) c(l,1)+n(l,1)], ...
              [c(l,2) c(l,2)+n(l,2)], ...
              [c(l,3) c(l,3)+n(l,3)], 'g-');
    end
end

hold off



view(3)
% axis equal
title('local coordinates');
xlabel x
ylabel y
zlabel z
grid on

end