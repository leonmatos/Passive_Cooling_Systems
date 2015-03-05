function f = churchill_friction(D,Re,e)

if length(Re) > 1
    f = 0*Re;
    for i = 1:length(Re)
        f(i) = churchill_friction(D,Re(i),e);
    end
else
    A = (-2.457*log((7/Re)^.9 + .27*e/D))^16;
    B = (37530/Re)^16;
    f = 8*((8/Re)^12 + 1/(A+B)^1.5)^(1/12);
end