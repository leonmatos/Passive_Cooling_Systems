function root = complex_roots_nayak()
path('../../matlab_lib',path)
% hfig2 = figure(2);
% set(hfig2, 'Position', [600 250 400 400]);
% hfig1 = figure(1);
% set(hfig1, 'Position', [150 250 400 400]);
k = 0;
nitmax = 1000;
x = zeros(nitmax,1)*nan;
y = zeros(nitmax,1)*nan;
x(1) = -1+0i;
x(2) = 0+2i;
y(1) = nayak_characteristic_function(x(1));
y(2) = nayak_characteristic_function(x(2));
p = [2 2];
for k = 3:nitmax
    x(k) = p(1)+p(2)*1i;
%     y = 10*x.^3-2*x.^2+1*x+100+10*cos(x)+0*x.*exp(5*x);
    y(k) = nayak_characteristic_function(x(k));
%     figure(1)
%     plot(0,0,'ob',real(x),imag(x),'.-g'),grid on
%     figure(2)
%     plot(0,0,'or',real(y),imag(y),'.-k'),grid on
%     drawnow
    % x angle
    alpha = angle_3_complex_numbers(x(k-2:k));
    % y anlge
    beta = angle_3_complex_numbers(y(k-2:k));
    %
    A = alpha/beta;
    %
    u0 = [real(x(k)-x(k-1)) imag(x(k)-x(k-1))];
    v0 = [real(y(k)-y(k-1)) imag(y(k)-y(k-1))];
    B = norm(u0)/norm(v0);
    %
    d = norm(y(k));
    beta = angle_3_complex_numbers([y(k-1:k);0+0i]);
    p = next_complex_point((pi-abs(beta))/pi*.5*d,beta,u0,x(k),A,B);
    if norm(y(k)) < 1e-4
        break
    end
end
if k == nitmax
    fprintf('not converged...\n')
else
    fprintf('convergence achieved!\n')
    fprintf('x = %1.4f+%1.4fi\n',real(x(k)),imag(x(k)))
end
root = x(k);
% pause
% close(hfig1)
% close(hfig2)