function [frame, zBuffer]= rasterize2(width, height, varargin)
% implemented z-Buffer, texture mapping

frame= zeros(height, width, 3); % rgb image
zBuffer= 1.5+zeros(height, width); % depth buffer
% frame and zBuffer use u,v coordinates = pixel coordinates on screen
% (u,v) == (0,0) -> top left
% (u,v) == (+,0) -> goes to the right
% (u,v) == (0,+) -> goes down

for k=1:length(varargin)
    if isempty(varargin{k})
        continue
    end
    
    v_= varargin{k}.vertices;
    vc_= varargin{k}.vertex_colors;
    vt_= varargin{k}.texture_vertices;
    texture= double(varargin{k}.texture);
    [Xt, Yt]= meshgrid(linspace(0,1,size(texture,2)), linspace(1,0,size(texture,1)));
    
    % v contains vertex information: x, y, z
    % x: horizontal, + -> to the right  - -> to the left
    % y: vertical, + -> up   -  -> down
    % z: depth, - -> into the screen  + -> out of the screen, to the viewer
    %
    %     y             :
    %      A            :    *-----> u
    %      |     /      :    |
    %      |   /        :    |
    %      | /   x      :    |
    % -----*---->       :    V v
    %    / |            :
    %  V z |            :
    % vertex info          screen values
    
    if isempty(vc_)
    
        for l=1:3:size(v_,1)
            color= reshape([0;255;0], 1, 1, 3);

            v= v_(l:l+2,:);
            vt= vt_(l:l+2,:);
            v(:,1)= 1+(-v(:,1)+1)*(width-1)/2;
            v(:,2)= 1+(-v(:,2)+1)*(height-1)/2; % y,z -> u,v (float, not int)
            % v: (u, v, depth)

            [~, idx]= sort(v(:,2));
            topV= round(v(idx(1),2));
            topU= round(v(idx(1),1));
            medV= round(v(idx(2),2));
            medU= round(v(idx(2),1));
            botV= round(v(idx(3),2));
            botU= round(v(idx(3),1));

            if topV~=medV
                medStep= (medU-topU) /(medV-topV);
                botStep= (botU-topU) /(botV-topV);

                % positions on the image
                p0l= topU;
                p0r= topU;
                if medStep < botStep
                    pl= medStep;
                    pr= botStep;
                else
                    pl= botStep;
                    pr= medStep;
                end

                % corresponding depth information of the model
                z0l= v(idx(1), 3);
                z0r= v(idx(1), 3);
                if medStep < botStep
                    zl= (v(idx(2),3)-v(idx(1),3)) /(medV-topV);
                    zr= (v(idx(3),3)-v(idx(1),3)) /(botV-topV);
                else
                    zr= (v(idx(2),3)-v(idx(1),3)) /(medV-topV);
                    zl= (v(idx(3),3)-v(idx(1),3)) /(botV-topV);
                end

                % vertex information on the texture
                t0l= vt(idx(1), :);
                t0r= vt(idx(1), :);
                if medStep < botStep
                    tl= (vt(idx(2),:)-vt(idx(1),:)) /(medV-topV);
                    tr= (vt(idx(3),:)-vt(idx(1),:)) /(botV-topV);
                else
                    tr= (vt(idx(2),:)-vt(idx(1),:)) /(medV-topV);
                    tl= (vt(idx(3),:)-vt(idx(1),:)) /(botV-topV);
                end


                for m= topV:medV
                    ids= round(p0l):round(p0r);
                    z= zBuffer(m, ids);
                    zs= linspace(z0l,z0r,length(ids));
                    xts= linspace(t0l(1), t0r(1), length(ids));
                    yts= linspace(t0l(2), t0r(2), length(ids));
                    ids= ids(zs < z);
                    xts= xts(zs < z);
                    yts= yts(zs < z);

                    frame(m, ids, 1)= interp2(Xt, Yt, texture(:,:,1), xts, yts, 'nearest');
                    frame(m, ids, 2)= interp2(Xt, Yt, texture(:,:,2), xts, yts, 'nearest');
                    frame(m, ids, 3)= interp2(Xt, Yt, texture(:,:,3), xts, yts, 'nearest');
                    zBuffer(m, ids)= zs(zs < z);
                    p0l= p0l +pl;
                    p0r= p0r +pr;
                    z0l= z0l +zl;
                    z0r= z0r +zr;
                    t0l= t0l +tl;
                    t0r= t0r +tr;
    %                 image(frame/255);
    %                 imagesc(zBuffer);
    %                 pause(0.01);
                end
            end

            if botV~=medV
                medStep= (medU-botU) /(medV-botV);
                topStep= (topU-botU) /(topV-botV);

                p0l= botU;
                p0r= botU;
                if medStep > topStep
                    pl= medStep;
                    pr= topStep;
                else
                    pl= topStep;
                    pr= medStep;
                end

                % corresponding depth information of the model
                z0l= v(idx(3), 3);
                z0r= v(idx(3), 3);
                if medStep > topStep
                    zl= (v(idx(2),3)-v(idx(3),3)) /(medV-botV);
                    zr= (v(idx(1),3)-v(idx(3),3)) /(topV-botV);
                else
                    zr= (v(idx(2),3)-v(idx(3),3)) /(medV-botV);
                    zl= (v(idx(1),3)-v(idx(3),3)) /(topV-botV);
                end


                % vertex information on the texture
                t0l= vt(idx(3), :);
                t0r= vt(idx(3), :);
                if medStep > topStep
                    tl= (vt(idx(2),:)-vt(idx(3),:)) /(medV-botV);
                    tr= (vt(idx(1),:)-vt(idx(3),:)) /(topV-botV);
                else
                    tr= (vt(idx(2),:)-vt(idx(3),:)) /(medV-botV);
                    tl= (vt(idx(1),:)-vt(idx(3),:)) /(topV-botV);
                end


                for m= botV:-1:medV                
                    ids= round(p0l):round(p0r);
                    z= zBuffer(m, ids);
                    zs= linspace(z0l,z0r,length(ids));
    %                 ids= ids(zs < z);

                    xts= linspace(t0l(1), t0r(1), length(ids));
                    yts= linspace(t0l(2), t0r(2), length(ids));
                    ids= ids(zs < z);
                    xts= xts(zs < z);
                    yts= yts(zs < z);

                    frame(m, ids, :)= repmat(color, [1, length(ids), 1]);
                    frame(m, ids, 1)= interp2(Xt, Yt, texture(:,:,1), xts, yts, 'nearest');
                    frame(m, ids, 2)= interp2(Xt, Yt, texture(:,:,2), xts, yts, 'nearest');
                    frame(m, ids, 3)= interp2(Xt, Yt, texture(:,:,3), xts, yts, 'nearest');

                    zBuffer(m, ids)= zs(zs < z);
                    p0l= p0l -pl;
                    p0r= p0r -pr;
                    z0l= z0l -zl;
                    z0r= z0r -zr;
                    t0l= t0l -tl;
                    t0r= t0r -tr;
    %                 image(frame/255);
    %                 pause(0.01);
                end
            end
        end
    else % vertex colors
        
        for l=1:3:size(v_,1)
            v= v_(l:l+2,:);
            vc= vc_(l:l+2,:);
            v(:,1)= 1+(-v(:,1)+1)*(width-1)/2;
            v(:,2)= 1+(-v(:,2)+1)*(height-1)/2; % y,z -> u,v (float, not int)
            % v: (u, v, depth)

            [~, idx]= sort(v(:,2));
            topV= round(v(idx(1),2));
            topU= round(v(idx(1),1));
            medV= round(v(idx(2),2));
            medU= round(v(idx(2),1));
            botV= round(v(idx(3),2));
            botU= round(v(idx(3),1));

            if topV~=medV
                medStep= (medU-topU) /(medV-topV);
                botStep= (botU-topU) /(botV-topV);

                % positions on the image
                p0l= topU;
                p0r= topU;
                if medStep < botStep
                    pl= medStep;
                    pr= botStep;
                else
                    pl= botStep;
                    pr= medStep;
                end

                % corresponding depth information of the model
                z0l= v(idx(1), 3);
                z0r= v(idx(1), 3);
                if medStep < botStep
                    zl= (v(idx(2),3)-v(idx(1),3)) /(medV-topV);
                    zr= (v(idx(3),3)-v(idx(1),3)) /(botV-topV);
                else
                    zr= (v(idx(2),3)-v(idx(1),3)) /(medV-topV);
                    zl= (v(idx(3),3)-v(idx(1),3)) /(botV-topV);
                end

                % vertex color
                c0l= vc(idx(1), :);
                c0r= vc(idx(1), :);
                if medStep < botStep
                    cl= (vc(idx(2),:)-vc(idx(1),:)) /(medV-topV);
                    cr= (vc(idx(3),:)-vc(idx(1),:)) /(botV-topV);
                else
                    cr= (vc(idx(2),:)-vc(idx(1),:)) /(medV-topV);
                    cl= (vc(idx(3),:)-vc(idx(1),:)) /(botV-topV);
                end


                for m= topV:medV
                    ids= round(p0l):round(p0r);
                    z= zBuffer(m, ids);
                    zs= linspace(z0l,z0r,length(ids));
                    r= linspace(c0l(1), c0r(1), length(ids));
                    g= linspace(c0l(2), c0r(2), length(ids));
                    b= linspace(c0l(3), c0r(3), length(ids));
                    ids= ids(zs < z);
                    r= r(zs < z);
                    g= g(zs < z);
                    b= b(zs < z);

                    frame(m, ids, 1)= r;
                    frame(m, ids, 2)= g;
                    frame(m, ids, 3)= b;
                    zBuffer(m, ids)= zs(zs < z);
                    p0l= p0l +pl;
                    p0r= p0r +pr;
                    z0l= z0l +zl;
                    z0r= z0r +zr;
                    c0l= c0l +cl;
                    c0r= c0r +cr;
    %                 image(frame/255);
    %                 imagesc(zBuffer);
    %                 pause(0.01);
                end
            end

            if botV~=medV
                medStep= (medU-botU) /(medV-botV);
                topStep= (topU-botU) /(topV-botV);

                p0l= botU;
                p0r= botU;
                if medStep > topStep
                    pl= medStep;
                    pr= topStep;
                else
                    pl= topStep;
                    pr= medStep;
                end

                % corresponding depth information of the model
                z0l= v(idx(3), 3);
                z0r= v(idx(3), 3);
                if medStep > topStep
                    zl= (v(idx(2),3)-v(idx(3),3)) /(medV-botV);
                    zr= (v(idx(1),3)-v(idx(3),3)) /(topV-botV);
                else
                    zr= (v(idx(2),3)-v(idx(3),3)) /(medV-botV);
                    zl= (v(idx(1),3)-v(idx(3),3)) /(topV-botV);
                end


                % vertex color
                c0l= vc(idx(3), :);
                c0r= vc(idx(3), :);
                if medStep > topStep
                    cl= (vc(idx(2),:)-vc(idx(3),:)) /(medV-botV);
                    cr= (vc(idx(1),:)-vc(idx(3),:)) /(topV-botV);
                else
                    cr= (vc(idx(2),:)-vc(idx(3),:)) /(medV-botV);
                    cl= (vc(idx(1),:)-vc(idx(3),:)) /(topV-botV);
                end


                for m= botV:-1:medV                
                    ids= round(p0l):round(p0r);
                    z= zBuffer(m, ids);
                    zs= linspace(z0l,z0r,length(ids));
                    r= linspace(c0l(1), c0r(1), length(ids));
                    g= linspace(c0l(2), c0r(2), length(ids));
                    b= linspace(c0l(3), c0r(3), length(ids));
                    ids= ids(zs < z);
                    r= r(zs < z);
                    g= g(zs < z);
                    b= b(zs < z);
                    
                    frame(m, ids, 1)= r;
                    frame(m, ids, 2)= g;
                    frame(m, ids, 3)= b;

                    zBuffer(m, ids)= zs(zs < z);
                    p0l= p0l -pl;
                    p0r= p0r -pr;
                    z0l= z0l -zl;
                    z0r= z0r -zr;
                    c0l= c0l -cl;
                    c0r= c0r -cr;
    %                 image(frame/255);
    %                 pause(0.01);
                end
            end
        end
        
    end
    
end


end