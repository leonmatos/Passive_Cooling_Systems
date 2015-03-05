function Ri = Ri(T,z,Lv,Lt,f)

int_Tdz = integra_T(T,z);

Ri = Lv/Lt*f/2/int_Tdz;