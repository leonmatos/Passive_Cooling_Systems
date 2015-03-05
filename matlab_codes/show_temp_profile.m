function show_temp_profile(w,T,s,sh_in,sh_out,sc_in,sc_out)

T = real(T);

s1 = s(s < sh_in);
T1 = T(s < sh_in);

s2 = s(s >= sh_in & s <= sh_out);
T2 = T(s >= sh_in & s <= sh_out);

s3 = s(s >= sh_out & s <= sc_in);
T3 = T(s >= sh_out & s <= sc_in);

s4 = s(s >= sc_in & s <= sc_out);
T4 = T(s >= sc_in & s <= sc_out);

s5 = s(s >= sc_out);
T5 = T(s >= sc_out);

plot(s1,T1)
hold on
plot(s2,T2,'r','Linewidth',2)
plot(s3,T3)
plot(s4,T4,'c','Linewidth',2)
plot(s5,T5)
title(w)
hold off
drawnow