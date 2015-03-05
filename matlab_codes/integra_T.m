function int_Tdz = integra_T(T,z)

int_Tdz = .5*(T(1)+T(end))*(z(1)-z(end));
for j = 2:length(z)
    int_Tdz = int_Tdz + .5*(T(j)+T(j-1))*(z(j)-z(j-1));
end