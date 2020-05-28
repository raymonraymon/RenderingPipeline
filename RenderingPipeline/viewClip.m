function viewClip(varargin)

%clf
hold on
for k=1:length(varargin)
    if isempty(varargin{k})
        continue
    end
    
    v= varargin{k}.vertices;
    
    
    if isfield(varargin{k}, 'faces')
        num= size(v,1);
        xdata= reshape(v(:,1), [3,num/3]);
        ydata= reshape(v(:,2), [3,num/3]);
        zdata= reshape(v(:,3), [3,num/3]);
        cdata= 1+0*xdata;

        patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
    else
        plot3(v(:,1), v(:,2), v(:,3), 'k*');
    end
end

% plot3([0 1], [0 0], [-1 -1], 'k');
% plot3([0 0], [0 1], [-1 -1], 'k');
% plot3([0 0], [0 0], [-1 0], 'k');

plot3([1 1], [1 1], [-1 1], 'r');
plot3([-1 -1], [1 1], [-1 1], 'r');
plot3([1 1], [-1 -1], [-1 1], 'r');
plot3([-1 -1], [-1 -1], [-1 1], 'r');

plot3([1 -1], [1 1], [1 1], 'r');
plot3([1 -1], [-1 -1], [1 1], 'r');
plot3([1 1], [1 -1], [1 1], 'r');
plot3([-1 -1], [1 -1], [1 1], 'r');

plot3([1 -1], [1 1], [-1 -1], 'r');
plot3([1 -1], [-1 -1], [-1 -1], 'r');
plot3([1 1], [1 -1], [-1 -1], 'r');
plot3([-1 -1], [1 -1], [-1 -1], 'r');

hold off
grid on
axis square
xlabel x
zlabel z
ylabel y
title('homogeneous space')
view(3);

end