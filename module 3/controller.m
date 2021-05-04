Fai = 10
Fbi = 10
distance = 6


Fa = Fai;
Fb = 0;
v0 = 0;
s0 = 0;
output = sim('KITTDynamicsFinal','StartTime','0','StopTime','6','FixedStep','0.01');
Fa = 0;
Fb = Fbi;
p = [m/(2*Fb) 0 -1*distance];
r = roots(p);

v0 = r(1);
s0 = 0;
output1 = sim('KITTDynamicsFinal','StartTime','0','StopTime','6','FixedStep','0.01');


plot(output.s.signals.values, output.v.signals.values);
hold on;
plot(output1.s.signals.values, output1.v.signals.values);
title('Velocity of the car');
xlabel('Distance [m]') 
ylabel('velocity [m/s]') 
hold off;
[xref,vref] = polyxpoly(output.s.signals.values, output.v.signals.values,output1.s.signals.values, output1.v.signals.values);
i = 1;
while(output.v.signals.values(i,1) < vref) %searching untill velocity is more then v
    i = i+1;
end
disp("Time to break untill velocity is more than " + vref + " m/s: " + output.v.time(i,1) + "s"); %plot velocity



