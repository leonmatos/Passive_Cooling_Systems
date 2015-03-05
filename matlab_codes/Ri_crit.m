function Ri_crit = Ri_crit(St,D,Lv,Lw,Lt,Lh)

X = D/Lv;
Y = Lw/Lt;
Z = Lh/Lt;

A = 3.897*Y/X*exp(.7*X*Z);
B = (.105/Y+1.347*X*Z)/(1-29.308*X*Z);

Ri_crit = A*exp(-B*St);