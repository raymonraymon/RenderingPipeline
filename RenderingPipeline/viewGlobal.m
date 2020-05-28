function viewGlobal(camera, varargin)

vec= rot(camera.dir);

%clf
hold on
plot3(camera.pos(1), camera.pos(2), camera.pos(3), 'ro');
plot3([camera.pos(1), camera.pos(1)+vec(1,1)],...
      [camera.pos(2), camera.pos(2)+vec(2,1)],...
      [camera.pos(3), camera.pos(3)+vec(3,1)], 'r');
plot3([camera.pos(1), camera.pos(1)-vec(1,1)],...
      [camera.pos(2), camera.pos(2)-vec(2,1)],...
      [camera.pos(3), camera.pos(3)-vec(3,1)], 'k');
plot3([camera.pos(1), camera.pos(1)-vec(1,2)],...
      [camera.pos(2), camera.pos(2)-vec(2,2)],...
      [camera.pos(3), camera.pos(3)-vec(3,2)], 'k');
plot3([camera.pos(1), camera.pos(1)+vec(1,3)],...
      [camera.pos(2), camera.pos(2)+vec(2,3)],...
      [camera.pos(3), camera.pos(3)+vec(3,3)], 'k');
grid on

for k=1:length(varargin)
    model= varargin{k};

    v= model.vertices;
    
    if ~isfield(model, 'faces')
        plot3(v(:,1), v(:,2), v(:,3), 'k*');
    else
        if isfield(model, 'faces') && isempty(model.faces)
            num= size(v,1);
            xdata= reshape(v(:,1), [3,num/3]);
            ydata= reshape(v(:,2), [3,num/3]);
            zdata= reshape(v(:,3), [3,num/3]);
            cdata= 1+0*xdata;

            patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
        else
            patch('Faces', model.faces, 'Vertices', v, 'FaceAlpha', 0, 'EdgeColor', 'b');
        end
    end
end

hold off
view(3)
axis equal
title('global coordinates');
xlabel x
ylabel y
zlabel z
end