function f = poiseuille_colebrook_friction(D,Re,e)
% Calculates Colebrook-White friction factor using Newton-Raohson method.
% The Colebrook-White friction correlation is based on that of Vijayan,
% Austregesilo and Teschendorff, 1995.
% Here, the friction factor corresponds to the value of f that approximates
% y to zero.

if length(Re) > 1
    f = 0*Re;
    for i = 1:length(Re)
        f(i) = colebrook_white_friction(D,Re(i),e);
    end
else
    fa = .01;
    %         y = 3.48 - 4*log10(2*e/D+9.35/Re/fa^.5) - fa^-.5;
    %         yp = .5*fa^-1.5 - 4*(-.5*9.35/Re*fa^-1.5)/(2*e/D+9.35/Re/fa^.5)/log(10);
    y = -2*log10(e/3.7/D + 2.51/Re/fa^.5) - fa^-.5;
    yp = .5*fa^-1.5 - 2/log(10)*(-.5*2.51/Re*fa^-1.5)/(e/3.7/D + 2.51/Re/fa^.5);

    f = fa - y/yp;
    nit = 1;
    while abs(f-fa) > 1e-6 && nit < 1e3
        fa = f;
        y = -2*log10(e/3.7/D + 2.51/Re/fa^.5) - fa^-.5;
        yp = .5*fa^-1.5 - 2/log(10)*(-.5*2.51/Re*fa^-1.5)/(e/3.7/D + 2.51/Re/fa^.5);
        f = fa - y/yp;
        nit = nit + 1;
    end
    if nit == 1e3
        disp('colebrook_white_friction not converged')
    else
        f = max(16/Re,f);
    end
end