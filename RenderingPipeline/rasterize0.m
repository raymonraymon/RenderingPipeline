function [frame, zBuffer]= rasterize0(width, height, varargin)
% monocolor frame to test the rasterizing process
% no z-Buffer, random colors

frame= zeros(height, width, 3); % rgb image
zBuffer= -1.1+zeros(height, width); % depth buffer
% frame and zBuffer use u,v coordinates = pixel coordinates on screen
% (u,v) == (0,0) -> top left
% (u,v) == (+,0) -> goes to the right
% (u,v) == (0,+) -> goes down

% us= linspace(-1, 1, width);
% vs= linspace(-1, 1, height);

for k=1:length(varargin)
    v_= varargin{k}.vertices;
    vn_= varargin{k}.normal_vertices;
    vt_= varargin{k}.texture_vertices;
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
    
    for l=1:3:size(v_,1)
        red= reshape([255;0;0], 1, 1, 3);
        color= reshape(floor(255*(rand(3,1))), 1, 1, 3);
        
        v= v_(l:l+2,:);
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
        
        frame(topV, topU, :)= red;
        frame(medV, medU, :)= red;
        frame(botV, botU, :)= red;
%         image(frame/255);
        
        if topV~=medV
            medStep= (medU-topU) /(medV-topV);
            botStep= (botU-topU) /(botV-topV);
            
            p0l= topU;
            p0r= topU;
            if medStep < botStep
                pl= medStep;
                pr= botStep;
            else
                pl= botStep;
                pr= medStep;
            end
            
            for m= topV:medV
                idx= round(p0l):round(p0r);
                frame(m, idx, :)= repmat(color, [1, length(idx), 1]);
                p0l= p0l+ pl;
                p0r= p0r+ pr;
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
            
            for m= botV:-1:medV
                idx= round(p0l):round(p0r);
                frame(m, idx, :)= repmat(color, [1, length(idx), 1]);
                p0l= p0l- pl;
                p0r= p0r- pr;
            end
        end   
        
    end
    
end


end