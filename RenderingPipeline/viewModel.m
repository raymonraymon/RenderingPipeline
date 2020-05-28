function viewModel(model)


if ~isempty(model.faces)
    f= model.faces';
    v= model.vertices(f(:),:);
    fn= model.normal_faces';
    vn= model.normal_vertices(fn(:),:);
    clear fn f
else
    v= model.vertices;
    vn= model.normal_vertices;
end





num= size(v,1)/3;

c= (v(1:3:end,:) + v(2:3:end,:) + v(3:3:end,:)) /3;
n= normals(v);

%clf

xdata= reshape(v(:,1), [3,num]);
ydata= reshape(v(:,2), [3,num]);
zdata= reshape(v(:,3), [3,num]);
cdata= 1+0*xdata;

patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');

% plot face normals
hold on
plot3(c(:,1), c(:,2), c(:,3), 'r*');
for k=1:size(c,1)
    plot3([c(k,1) c(k,1)+0.4*n(k,1)], ...
          [c(k,2) c(k,2)+0.4*n(k,2)], ...
          [c(k,3) c(k,3)+0.4*n(k,3)], 'r-');
end

for k=1:3:size(vn,1)
    c= v(k:k+2,:);
    n= vn(k:k+2,:)* 0.4;
    for l=1:3
        plot3([c(l,1) c(l,1)+n(l,1)], ...
              [c(l,2) c(l,2)+n(l,2)], ...
              [c(l,3) c(l,3)+n(l,3)], 'k-');
    end
end

hold off



view(3)
axis equal
title('local coordinates');
xlabel x
ylabel y
zlabel z
grid on

end