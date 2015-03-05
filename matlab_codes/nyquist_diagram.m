% Nyquist plot of Nayak's 1995 equation for linear stability analysis
% home
% load('St10Gr8e11');
% save('vijayan_last_run','St','Gr','Re','Q','U','L','H','Lh','D','A','V','phi','j1','j2','j3','j4','jh','b','p','Ts','DTss','z','s','T')
% clear
run_file = 'vijayan_last_run';
c = 0:.1:60;
Y = ones(length(c),1)*nan;
for k = 1:length(c)
    n = 0 + c(k)*1i;
    Y(k) = nayak_characteristic_function(n,run_file);
end
figure(1)
plot(real(Y),imag(Y),'r',0,0,'ob'),grid on