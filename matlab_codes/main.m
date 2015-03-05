clear,home

Q = [.12 .41 .52];

output = 0*Q;
for i = 1:length(Q)
    output(i) = NCL_main(Q(i));
end
plot(Q,output),grid on