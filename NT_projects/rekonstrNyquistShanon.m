%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rekonstruktion nach nyquist shanon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));

Tc=1e-6;
tc=[0:Tc:10-Tc];

f0=0.5;
f1=1;
f2=2;
f3=10;
f4=50;

fm=[f0 f1 f2 f3 f4];

yc=zeros(1,length(tc));
for i=1:length(fm)
    yc=yc+sin(2*pi*fm(i)*tc);
end

clf;
f1=figure(1);
SUB=310;

subplot(SUB+1);
hold all;
plot(tc(1:2/Tc),yc(1:2/Tc));
hold off;
grid on;
legend('yc');

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');





