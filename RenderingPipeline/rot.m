function M= rot(phi)
% returns a 3x3 matrix describing counterclockwise rotations along x-, y- 
% and then z-axis

M= [1,0,0;0,cos(phi(1)),-sin(phi(1));0,sin(phi(1)),cos(phi(1))];
M= [cos(phi(2)),0,sin(phi(2));0,1,0;-sin(phi(2)),0,cos(phi(2))]* M;
M= [cos(phi(3)),-sin(phi(3)),0;sin(phi(3)),cos(phi(3)),0;0,0,1]* M;

end