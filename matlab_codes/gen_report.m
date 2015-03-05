% fprintf(fid, '# vtk DataFile Version 1.0\n');
% fprintf(fid,'%f %f %f\n',fm.x(i),fm.y(i),fm.z(i));

%% naming and opening the file
dir = './reports/';
serial = num2str(datenum(date)-datenum('01-Jan-2014'));
for i = 1:99
    if i < 10
        seq = ['00',num2str(i)];
    else
        seq = ['0',num2str(i)];
    end
    fid = fopen([dir,serial,'_',date,'_',seq,'.dat'], 'r');
    if fid < 0
        break
    end
end
filename = [dir,serial,'_',date,'_',seq];
filename = [filename, '.dat'];
fid = fopen(filename, 'w');

%% header
fprintf(fid,date);
fprintf(fid,'\n\n');

%% inputs
fprintf(fid,'INPUTS\n\n');
fprintf(fid,'L = %2.4f m\n',L);
fprintf(fid,'H = %2.4f m\n',H);
fprintf(fid,'Lh = %2.4f m\n',Lh);
fprintf(fid,'D = %2.4f m\n',D);
fprintf(fid,'n = %d\n',n);
fprintf(fid,'p0 = %2.4f bar\n',p0);
fprintf(fid,'T0 = %2.4f C\n',T0);
fprintf(fid,'Ts = %2.4f C\n',Ts);
fprintf(fid,'perturbation = %2.2f\n',perturbation);
fprintf(fid,'b = %2.4f\n',b);
fprintf(fid,'p = %2.4f\n',p);
fprintf(fid,'g = %2.4f m/s2\n',g);
fprintf(fid,'CFL = %2.2f\n',CFL);
fprintf(fid,'St = %2.4f\n',St);
fprintf(fid,'Gr = %2.4e\n',Gr);
fprintf(fid,'time discretizaiton = %s\n\n',time_disc);

%% calculated variables
fprintf(fid,'CALCULATED VARIABLES\n\n');
fprintf(fid,'U = %2.4f kW/m2/K\n',U);
fprintf(fid,'Q = %2.4f kW\n',Q);
fprintf(fid,'steady state mass flow = %2.4f kg/s\n',Wss);
fprintf(fid,'steady state temp. diff. = %2.4f C\n',DTss);
fprintf(fid,'heat inut  = %2.4f kW\n',Q);
fprintf(fid,'steady state vol. flux = %2.4f dm3/min\n',v*A*60*1000);
fprintf(fid,'steady state flow velocity = %2.4f m/s\n',v);
fprintf(fid,'mean friction coeff. = %2.4f\n',p/(Re^b));
fprintf(fid,'Re = %2.4f\n\n',Re);

%% dynamic variables
fprintf(fid,'DYNAMIC VARIABLES\n\n');
fprintf(fid,'wss = %2.4f\n',w0);
fprintf(fid,'mean wmax = %2.4f\n',mean(wmax));
fprintf(fid,'mean wmin = %2.4f\n',mean(wmin));
fprintf(fid,'mean w = %2.4f\n',mean(w));
fprintf(fid,'thetaI = %2.4f\n',thetaI);
fprintf(fid,'approach in cooler (C): %2.4f\n',Tmin - Ts);
fprintf(fid,'-----------------------\n');
%%
fclose(fid);
print('-dpng',[dir,serial,'_',date,'_',seq])