% fouriertrans vs fourierreihe
% 

Fsam=1000;      % Abtastfrequenz
Tsam=1/Fsam;
tmin=-4;        % Beobachtungsdauer
tmax=4;

t=[tmin:Tsam:tmax];

rect=@(x) (0.5*sign(x)+0.5);

A=1;
f0=1/5;

s= @(x) A*(cos(2*pi*f0*x)-1/3*cos(3*2*pi*f0*x)+1/5*cos(5*2*pi*f0*x));
f1=figure(1);
plot(t,s(t))
grid on;
grid('minor')
legend('s(t)');
title('Periodisch, nur gerade Anteile');

% Fourierreihe

T0=1/f0;
% function to calc complex fourier- coefitients
syms x k;
ck= @(k) 1/T0*int(A*(cos(2*pi*f0*x)-1/3*cos(3*2*pi*f0*x)+1/5*cos(5*2*pi*f0*x))*exp(i*2*pi*f0*k*x),x,-T0/2,T0/2);

f=-5:1:5;

f2=figure(2);
stem(f,abs(ck(f)),'o','MarkerFaceColor','r')
grid on;
xlim([-6,6]);
%T0/2;
ylim([-0.2, 0.8]);
legend('|S(f)|');
title('Amplitudenspektrum');

s2= @(x) (A*(cos(2*pi*f0*x)-1/3*cos(3*2*pi*f0*x)+1/5*cos(5*2*pi*f0*x)).*(rect(x+T0/2)-rect(x-T0/2)));

f3=figure(3);
plot(t,s2(t))
grid on;
grid('minor')
legend('s2(t)');
title('A-Periodisch');

sf=s2(t);

syms F;
int(A*(cos(2*pi*f0*x)-1/3*cos(3*2*pi*f0*x)+1/5*cos(5*2*pi*f0*x))*exp(1i*2*pi*F*x),x,-T0/2,T0/2)

FT1= @(F) (F.*(1/exp(5*pi*F*i)).*(exp(10*pi*F*1i) - 1).*(65*F.^4 - 82*F.^2 + 3277/125)*1i)./(30*pi*(5*F.^6 - 7*F.^4 + (259*F.^2)/125 - 9/125));

FT2 = @(F) int(A*(cos(2*pi*f0*x)-1/3*cos(3*2*pi*f0*x)+1/5*cos(5*2*pi*f0*x))*exp(1i*2*pi*F*x),x,-T0/2,T0/2);
FM=@(F) F.*(1./(pi-pi*F.^2)+1/(3*pi*F.^2-27*pi)+1/(125*pi-5*pi*F.^2)).*sin(pi.*F);
FM = dotExpansion(FM);
f = -5:1:5;
f4=figure(4);
disp(FM(f))
plot(f,FM(f))
