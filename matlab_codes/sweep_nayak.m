function Y = sweep_nayak()
x = complex_roots_nayak();
c = 0:.01:40;
Y = ones(length(c),1)*nan;
for k = 1:length(c)
    n = 0*real(x)+c(k)*1i;
    Y(k) = nayak_characteristic_function(n);
end
figure(1)
plot(real(Y),imag(Y)),grid on