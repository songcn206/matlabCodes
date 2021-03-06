%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WOK verfahren 
% K ist variabel und grösser 0.
% Wähle K um maximale geschw. zu erreichen ohne OS??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));

G1=tf([1 -8],[1 4 9],'Name','G1(s)')

MODE=1;

if MODE==0

    f1=figure(1);
    SUB=120;

    subplot(SUB+1);
    rlocus(G1);
    subplot(SUB+2);
    k=1/2.51;
    pzmap(feedback(G1*k,1))

    tin=[0:0.05:5];
    k=0.05;
    clear yy tt

    for i=1:10
        [yy(:,i) tt(:,i)]=step(feedback(G1*k*i,1),tin);
    end

    f2=figure(2);
    SUB=120;
    subplot(SUB+1);
    plot(tt,yy);
    subplot(SUB+2);
    step(feedback(G1*1/2.51,1),tin);
    hold all;
    step(feedback(G1*9/8,1),tin);
    step(feedback(G1*10/8,1),tin);
    hold off;

    legend('k=1/2.51 -> +-1*j','k=9/8 (Doppelpol)')

    f3=figure(3);
    SUB=120;
    subplot(SUB+1);
    P=nyquistoptions;
    P.ShowFullContour='off';

    hold all;
    nyquist(G1*1/2.51,P);
    nyquist(G1*9/8,P);
    nyquist(G1*11/8,P);
    hold off;
    legend('k=1/2.51 -> +-1*j','k=9/8 (Doppelpol)','k=11/8')

    subplot(SUB+2);
    hold all;
    step(feedback(G1*8.9/8,1),[0:0.1:100]);
    step(feedback(G1*9/8,1),[0:0.1:100]);
    step(feedback(G1*11/8,1),[0:0.1:100]);
    hold off;
    grid on;
    legend('k=8.9/8 (Noch stabil)','k=9/8 (Doppelpol, instabil)','k=11/8')
    ylim([-180 20]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    f4=figure(4);
    SUB=120;

    Pl=tf(10,[1 21 0]);
    C=tf([1 1],[1 0]);

    subplot(SUB+1);
    nyquist(C*Pl,P);
    axis([-1.2 1.2 -1.2 1.2]);

    subplot(SUB+2);
    hold all;
    bode(feedback(C*Pl,1)); grid on;
    bode(C*Pl); grid on;
    hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


f6=figure(6);
SUB=120;

syms p w K;
g1s=10*(p+1)/( p^2*(p+1)+20*p );
Cs=K*(p+1)/p;

Gts=simplify( subs( Cs*g1s/(1+Cs*g1s),'K',1) )
Gttf=sym2tf(Gts)

Gtj=subs(Gts,'p','j*w');

subplot(SUB+1);
rlocus(Gttf)

subplot(SUB+2);
pzmap(Gttf)


f7=figure(7);
SUB=120;

alpha=2;
K=1;
[num,den]=linmod('RT_ueb7_a2');
Gtot=tf(num,den);

subplot(SUB+1);
rlocus(Gtot)


clear po z;
alpha=2;
K=1e-6;
for i=1:20
    [num,den]=linmod('RT_ueb7_a2');
    Gtot=tf(num,den);
    [po(i,:) z(i,:)]=pzmap(Gtot);
    K=i*1.5; 
end


subplot(SUB+2);
%pzmap(Gtot)
hold all;
plot(real(po),imag(po),'X');
plot(real(z),imag(z),'o');
hold off;


f8=figure(8);
SUB=120;
alpha=2;
K=10e-3;

G0=K*10*(p+1)/(p^2*(p+21));
Gtot2=G0/(1+G0);
Gts2=sym2tf(simplify( subs( Gtot2,'K',K) ))

legStr=sprintf('K=%.1e:',K);
[num,den]=linmod('RT_ueb7_a2');
Gtot=tf(num,den);
hold all;
step(Gtot);
step(Gts2);

K=1e-1;
legStr=[legStr sprintf('K=%.1e',K)];
[num,den]=linmod('RT_ueb7_a2');
Gtot=tf(num,den);
step(Gtot);
hold off
legend(strsplit(legStr,':'));

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f5=figure(5);
SUB=220;

syms p w;
%g1s=1/( (p+1)*(p+5) );
g1s=10*(p+1)/( p^2*(p+21) );

g1j=subs(g1s,'p','j*w');
gz1j=10*(1+j*w);
gp1j=j*w;
gp2j=j*w;
gp3j=21+j*w;

wlog=logspace(-1,1,100)*5;
sol1=eval( subs(g1j,'w',wlog) );
sol2=eval( subs(gz1j,'w',wlog) ./ ( subs(gp1j,'w',wlog) .* subs(gp2j,'w',wlog) .* subs(gp3j,'w',wlog) ) );
sol2a=[subs(gz1j,'w',wlog);  subs(gp1j,'w',wlog);  subs(gp2j,'w',wlog);  subs(gp3j,'w',wlog)];

subplot(SUB+1);
plot(real(sol1),imag(sol1),'-o')
axis([-0.4 0 -0.4 0]);
title('Re und Im');
%set(gca,'DataAspectRatio',[1 1 1]);
grid on;

subplot(SUB+2);
%plot(wlog,abs(sol1),'-o')
hold all;
semilogx(abs(sol1),'-o')
hold off;
title('|G_0(w)|');
legend('sol1');
%set(gca,'DataAspectRatio',[1 1 1]);
grid on;

subplot(SUB+3);
%plot(abs(sol1),'-o')
hold all;
%semilogx(abs(sol2),'-')
semilogx(abs(sol2a(1,:)),'--')
semilogx(abs(sol2a(2,:)),'--')
semilogx(abs(sol2a(3,:)),'--')
semilogx(abs(sol2a(4,:)),'--')
semilogx(abs( prod(sol2a(2:end,:)) ), '--')
semilogx(abs(sol2a(1,:)./( prod(sol2a(2:end,:))) ))
hold off;
title('|G_0(w)|');
legend('z1: 10*(1+j*w)','p1: j*w','p2: j*w','p3: 21+j*w','den(s)');
%set(gca,'DataAspectRatio',[1 1 1]);
axis([0 100 0 200]);
grid on;

xlabel('w [0.5 ... 50]')

subplot(SUB+4);
%plot(abs(sol1),'-o')
hold all;
semilogx(abs(sol2a(1,:)./( prod(sol2a(2:end,:))) ))
hold off;
title('|G_0(w)|');
legend('sol2');
grid on;

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return


G1=tf([1 -8],[1 4 9],'Name','G1(s)');
G2=zpk([-2],[-1 -2 -6],1,'Name','G2(s)');
% Gtot=K*G1/(1+K*G1);

f1=figure(1);
SUB=120;

subplot(SUB+1);
rlocus(feedback(G2,1));

%Kk=linspace(1e-6,50,50);
Kk=logspace(-6,3,100);

for i=1:length(Kk)
    K=Kk(i);
    [p(i,:) z(i,:)]=pzmap(K*G2/(1+K*G2));
end


subplot(SUB+2);
hold on;
plot(real(p),imag(p),'x')
hold off;


return 
tt=[0:0.05:6];

i=1;
for K=0.1:0.05:1
    GtotK(i,:)=step(K*G1/(1+K*G1),tt);
    i=i+1;
end

plot(GtotK)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pl=tf(10,[1 21 0]);
C=tf([1 1],[1 0]);

nyquist(C*Pl,P);



ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

