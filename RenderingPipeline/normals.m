function n= normals(v)
% v is (3m) x 3, a set of 3 vertices in 3d space
% n is m x 3, so the normal for each triangle


v21= v(2:3:end,:) - v(1:3:end,:); % vector from 1 to 2
v31= v(3:3:end,:) - v(1:3:end,:);

v21= bsxfun(@rdivide, v21, sqrt(sum(v21.*v21,2)));
v31= bsxfun(@rdivide, v31, sqrt(sum(v31.*v31,2)));

v31= v31 - bsxfun(@times, v21, sum(v31.*v21,2));
v31= bsxfun(@rdivide, v31, sqrt(sum(v31.*v31,2)));

n= cross(v21, v31);

end