% clear,home
function [D,W,H,heater_orient,cooler_orient,Lh,Lc,...
    corner_to_heater,corner_to_cooler,K,tilt,n] = NCL_geometry_dlg()

prompt={'Loop diameter (mm)','Loop width (m)','Loop height (m)','Heater orientation (H or V)',...
    'Cooler orientation (H or V)',...
    'Heater length (m)','Cooler length (m)',...
    'Distance from corner to heater inlet (m)',...
    'Distance from corner to cooler inlet (m)','local losses','Tilting angle (degrees, CW)',...
    'Number of mesh nodes'};

name='Loop configuration';
numlines=1;
%% read previous input (if existent)
fid = fopen('last_geom_data.dat','r');
if fid > 0
    D = num2str(fscanf(fid,'%f\n',1));
    W = num2str(fscanf(fid,'%f\n',1));
    H = num2str(fscanf(fid,'%f\n',1));
    heater_orient = fscanf(fid,'%s\n',1);
    cooler_orient = fscanf(fid,'%s\n',1);
    Lh = num2str(fscanf(fid,'%f\n',1));
    Lc = num2str(fscanf(fid,'%f\n',1));
    corner_to_heater = num2str(fscanf(fid,'%f\n',1));
    corner_to_cooler = num2str(fscanf(fid,'%f\n',1));
    K = num2str(fscanf(fid,'%f\n',1));
    tilt = num2str(fscanf(fid,'%f\n',1));
    n = num2str(fscanf(fid,'%d\n',1));
    fclose(fid);
    defaultanswer={D,W,H,heater_orient,cooler_orient,...
        Lh,Lc,corner_to_heater,corner_to_cooler,K,tilt,n};
else
    defaultanswer={'10','3','3','H','H','1','1','.1','.1','0','0','100'};
end
%%
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

out = inputdlg(prompt,name,numlines,defaultanswer,options);

D = str2double(out{1})/1000;
W = str2double(out{2});
H = str2double(out{3});
heater_orient = out{4};
cooler_orient = out{5};
Lh = str2double(out{6});
Lc = str2double(out{7});
corner_to_heater = str2double(out{8});
corner_to_cooler = str2double(out{9});
K = str2double(out{10});
tilt = str2double(out{11});
n = str2double(out{12});

fid = fopen('last_geom_data.dat','w');
fprintf(fid,'%2.4f\n',D*1000);
fprintf(fid,'%2.4f\n',W);
fprintf(fid,'%2.4f\n',H);
fprintf(fid,'%s\n',heater_orient);
fprintf(fid,'%s\n',cooler_orient);
fprintf(fid,'%2.4f\n',Lh);
fprintf(fid,'%2.4f\n',Lc);
fprintf(fid,'%2.4f\n',corner_to_heater);
fprintf(fid,'%2.4f\n',corner_to_cooler);
fprintf(fid,'%2.4f\n',K);
fprintf(fid,'%2.4f\n',tilt);
fprintf(fid,'%d\n',n);
fclose(fid);