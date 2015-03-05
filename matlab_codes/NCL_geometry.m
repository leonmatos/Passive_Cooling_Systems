function [s,z,ds,L,Lh,H,D,K,sh_in,sh_out,sc_in,sc_out] = NCL_geometry(arq)

luka = 0;

if nargin == 0
    [D,W,H,heater_orient,cooler_orient,Lh,Lc,...
        corner_to_heater,corner_to_cooler,K,tilt,n] = NCL_geometry_dlg();
    if tilt > 0
        tilt = -tilt;
    end
else
    fid = fopen(arq,'r');
    D = fscanf(fid,'%f\n',1)/1000;
    W = fscanf(fid,'%f\n',1);
    H = fscanf(fid,'%f\n',1);
    heater_orient = fscanf(fid,'%s\n',1);
    cooler_orient = fscanf(fid,'%s\n',1);
    Lh = fscanf(fid,'%f\n',1);
    Lc = fscanf(fid,'%f\n',1);
    corner_to_heater = fscanf(fid,'%f\n',1);
    corner_to_cooler = fscanf(fid,'%f\n',1);
    K = fscanf(fid,'%f\n',1);
    tilt = fscanf(fid,'%f\n',1);
    n = fscanf(fid,'%d\n',1);
    fclose(fid);
end

ahh = 0; ahc = 0;
if strcmp(heater_orient,'H')
    ahh = 1;
end
if strcmp(cooler_orient,'H')
    ahc = 1;
end

if Lh >= ahh*W+(1-ahh)*H
    error('Heater length exceeds loop dimensions!')
end

if Lc >= ahc*W+(1-ahc)*H
    error('Cooler length exceeds loop dimensions!')
end

if corner_to_heater + Lh >= ahh*W+(1-ahh)*H
    error('Inadequate heater position!')
end

if corner_to_cooler + Lc >= ahc*W+(1-ahc)*H
    error('Inadequate cooler position!')
end

L = 2*(W+H);
ds = L / n; % since this is a closed loop, the number of nodes is equal to the number of segments
s = linspace(0,L,n); % origin is at lower left corner

sh_in = (1-ahh)*W + corner_to_heater;
sh_out = sh_in + Lh;
sc_in = W + H + (1-ahc)*W + corner_to_cooler;
sc_out = sc_in + Lc;

v = find(s >= sh_in & s <= sh_out);
vh_in = v(1);
sh_in = min(s(v));
sh_out = max(s(v));
if sh_out - sh_in ~= Lh
    Lh = sh_out - sh_in;
end

v = find(s >= sc_in & s <= sc_out);
vc_in = v(1);
sc_in = min(s(v));
sc_out = max(s(v));
if sc_out - sc_in ~= Lc
    Lc = sc_out - sc_in;
end

i = 1;
x = 0*s;
z = 0*s;
while s(i) < W
    x(i) = s(i);
    z(i) = 0;
    i = i + 1;
end
while s(i) < W + H
    x(i) = W;
    z(i) = s(i)-W;
    i = i + 1;
end
while s(i) < W + H + W
    x(i) = W + H + W - s(i);
    z(i) = H;
    i = i + 1;
end
while s(i) < L
    x(i) = 0;
    z(i) = W + H + W + H - s(i);
    i = i + 1;
end
%% draw heater
xe = [1 1 -1 -1]*D;%.03*Lh;
ze = [0 Lh Lh 0];
Xe = [xe;ze];
ang = ahh*pi/2;
Xe = [cos(ang) sin(ang);-sin(ang) cos(ang)]*Xe;
xeh = Xe(1,:) + x(vh_in);
zeh = Xe(2,:) + z(vh_in);

%% draw cooler
xe = [-1 -1 1 1]*D;%.03*Lc;
ze = [0 -Lc -Lc 0];
Xe = [xe;ze];
ang = ahc*pi/2;
Xe = [cos(ang) sin(ang);-sin(ang) cos(ang)]*Xe;
xec = Xe(1,:) + x(vc_in);
zec = Xe(2,:) + z(vc_in);

if luka && ~ahc
    xe = [-.05*Lc,-tan(30/180*pi)*Lc,-tan(30/180*pi)*Lc+.1*Lc,0,...
        tan(30/180*pi)*Lc-.1*Lc,tan(30/180*pi)*Lc,.05*Lc];
    ze = [-.1*Lc/tan(30/180*pi)/2 -Lc -Lc -.1*Lc/tan(30/180*pi) -Lc -Lc -.1*Lc/tan(30/180*pi)/2];
    xec_bg = [0,-tan(30/180*pi)*Lc+.1*Lc,tan(30/180*pi)*Lc-.1*Lc];
    zec_bg = [-.1*Lc/tan(30/180*pi) -Lc -Lc];

    Xe = [xe;ze];
    ang = ahc*pi/2;
    Xe = [cos(ang) sin(ang);-sin(ang) cos(ang)]*Xe;
    xec = Xe(1,:) + x(vc_in);
    zec = Xe(2,:) + z(vc_in);

    if ~ahc
        Xe = [xec_bg;zec_bg];
        Xe = [cos(ang) sin(ang);-sin(ang) cos(ang)]*Xe;
        xec_bg = Xe(1,:) + x(vc_in);
        zec_bg = Xe(2,:) + z(vc_in);
    end
end

%% tilting
tilt = tilt*pi/180;

X = [x;z];
X = [cos(tilt) sin(tilt);-sin(tilt) cos(tilt)]*X;
x = X(1,:);
z = X(2,:);

X = [xeh;zeh];
X = [cos(tilt) sin(tilt);-sin(tilt) cos(tilt)]*X;
xeh = X(1,:);
zeh = X(2,:);

X = [xec;zec];
X = [cos(tilt) sin(tilt);-sin(tilt) cos(tilt)]*X;
xec = X(1,:);
zec = X(2,:);

if luka && ~ahc
    X = [xec_bg;zec_bg];
    X = [cos(tilt) sin(tilt);-sin(tilt) cos(tilt)]*X;
    xec_bg = X(1,:);
    zec_bg = X(2,:);
end

if nargin == 0
    hfig = figure(1);
    set(hfig, 'Position', [300 100 W/(W+H)*1000 H/(W+H)*800]);
    hold on
    if Lh/H < .2
        plot(x,z,'k')
    else
        plot(x,z,'.k')
    end
    fill(xeh,zeh,[1 0 0])
    fill(xec,zec,[.1 .8 1])
    if luka && ~ahc
        fill(xec_bg,zec_bg,[1 1 1])
    end
    hold off
    drawnow
end