function corners= viewEye(camera, varargin)

%clf
hold on
plot3([0 -1], [0 0], [0 0], 'r');
plot3(0, 0, 0, 'ro');
plot3([0, 1],...
      [0, 0],...
      [0, 0], 'k');
plot3([0, 0],...
      [0, 1],...
      [0, 0], 'k');
plot3([0, 0],...
      [0, 0],...
      [0, 1], 'k');


% plot pyramid shaped bounding box
xn= camera.near;
xf= camera.far;
yn= xn* tan(camera.alpha/2);
zn= xn* tan(camera.beta/2);

plot3([-xn -xn], [yn yn], [-zn zn], 'r');
plot3([-xn -xn], [-yn -yn], [-zn zn], 'r');
plot3([-xn -xn], [-yn yn], [zn zn], 'r');
plot3([-xn -xn], [-yn yn], [-zn -zn], 'r');

yf= xf* tan(camera.alpha/2);
zf= xf* tan(camera.beta/2);

plot3([-xf -xf], [yf yf], [-zf zf], 'r');
plot3([-xf -xf], [-yf -yf], [-zf zf], 'r');
plot3([-xf -xf], [-yf yf], [zf zf], 'r');
plot3([-xf -xf], [-yf yf], [-zf -zf], 'r');

plot3([-xn -xf], [yn yf], [zn zf], 'r');
plot3([-xn -xf], [-yn -yf], [-zn -zf], 'r');
plot3([-xn -xf], [yn yf], [-zn -zf], 'r');
plot3([-xn -xf], [-yn -yf], [zn zf], 'r');

corners.vertices= ...
         [-xn yn zn;
          -xn yn -zn;
          -xn -yn zn;
          -xn -yn -zn;
          -xf yf zf;
          -xf yf -zf;
          -xf -yf zf;
          -xf -yf -zf;
          linspace(-xf,-xn,10)' linspace(-yf,-yn,10)' linspace(-zf,-zn,10)'];

for l=1:length(varargin)
    v= varargin{l}.vertices;
    
    if ~isfield(varargin{l}, 'faces')
        plot3(v(:,1), v(:,2), v(:,3), 'k*');
    else
        num= size(v,1);
        xdata= reshape(v(:,1), [3,num/3]);
        ydata= reshape(v(:,2), [3,num/3]);
        zdata= reshape(v(:,3), [3,num/3]);
        cdata= 1+0*xdata;

        patch(xdata, ydata, zdata, cdata, 'FaceAlpha', 0, 'EdgeColor', 'b');
    end

end
hold off
view(3)
axis equal
grid on
xlabel z
ylabel x
zlabel y
title('eye-space');

end