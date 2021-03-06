% Lead lag glieder,
% parameter au bode diagramm bestimmen,
% Uebung A5.2 

delete(findall(0,'type','line'));

% Lag- Glied "nacheilend"
% G(s)=k*(1+T*s)/(1+a*T*s)  a > 1

syms p;
k=10;
sk=10;

%%%%%%%%%%%%%%%%%%%%%%%
% Uebertragungsglieder
%%%%%%%%%%%%%%%%%%%%%%%
s1=1/(p+1);
s2=1/(p+1)^2;
s3=1/(p+1)^3*(1+p/40);


sys1=sym2tf(s1);
sys2=sym2tf(s2);
sys3=sym2tf(s3);
syst=sym2tf((s3*s1*s2))
%SUB=330;
SUBS=[4 3];
wrange={1e-1,1e2};
s=tf('s');


%%%%%%%%%%%%%%%%%%%%%%%
% Lead glied
%%%%%%%%%%%%%%%%%%%%%%%
clear T a k;
syms T a k;
leadSym=k*(1+T*p)/(1+a*T*p);

T=3;  
a=0.5e-1;
k=1;
lead=sym2tf(eval(leadSym))

wp=1/(T*a);
wn=1/T;
phimax=atan(sqrt(wp/wn)*(1-a)/(1+a*wp/wn))*180/pi;

sprintf('wn=%.2f  wp=%.2f  phimax=%.2fdeg  sqrt(wp*wn)=%.2frad  wp-wn=%.2frad  20*log10(k/a)=%.2fdB',...
    wn,wp,phimax,sqrt(wp*wn),wp-wn,20*log10(k/a))

f6=figure(6);
%%%%%%%%%%%%%%%%%%%%%%%
% subplot 1
%%%%%%%%%%%%%%%%%%%%%%
% Bode
subplot(SUBS(1),SUBS(2),[1 4]);
bode(sys3,wrange);
grid on;
title(['sys3=' char(tf2sym(sys3))])
%legend('sys4');

% nyquist 
P = nyquistoptions;
P.ShowFullContour = 'off'; 
subplot(SUBS(1),SUBS(2),[7 10]);
nyquist(sys3,P)


%%%%%%%%%%%%%%%%%%%%%%%
% subplot 2
%%%%%%%%%%%%%%%%%%%%%%
% Bode
subplot(SUBS(1),SUBS(2),[1 4]+1);
bode(lead,wrange);grid on;
line([wn wn],[-90 45],'color','red','linestyle','--','LineWidth',1);
line([wp wp],[-90 45],'color','red','linestyle','--','LineWidth',1);
%line([1e-1 1e3],[45 45],'color','red','linestyle','--','LineWidth',1);
%legend('lead');
title({['lead=' char(leadSym)];char(tf2sym(lead))})

% nyquist
subplot(SUBS(1),SUBS(2),[7 10]+1);
nyquist(lead,P)

%%%%%%%%%%%%%%%%%%%%%%%
% subplot 3
%%%%%%%%%%%%%%%%%%%%%%
% Bode
subplot(SUBS(1),SUBS(2),[1 4]+2);
hold all;
bode(lead*sys3,wrange),grid on;
bode(sys3,wrange),grid on;
line([wn wn],[-270 45],'color','red','linestyle','--','LineWidth',1);
line([wp wp],[-270 45],'color','red','linestyle','--','LineWidth',1);
hold off;
legend('lead*sys4','sys3');

% nyquist
subplot(SUBS(1),SUBS(2),[7 10]+2);
hold all;
nyquist(lead*sys3,P)
nyquist(sys3,P)
hold off;
%legend('lead*sys4');
legend('lead*sys4','sys3');



return

f7=figure(7);

T=0.5;  % 1/0.7
a=0.1;
k=1;
%lead=sym2tf(k*(1+T*p)/(1+a*T*p));
lead=sym2tf(1*(1+(1/5)*p)/(1+(1/15)*p));
leadv(1)=sym2tf(1*(1+(1/5)*p)/(1+(1/15)*p));
leadv(2)=sym2tf(1*(1+(1/4)*p)/(1+(1/20)*p));
leadv(3)=sym2tf(1*(1+(1/6)*p)/(1+(1/20)*p));
Tg=0.5;
s3=sym2tf(1/(1+Tg*p)^3);
s2=sym2tf(1/(1+Tg*p)^2);
s1=sym2tf(1/(1+Tg*p));
wp=1/(T*a);
wn=1/T;
phimax=atan(sqrt(wp/wn)*(1-a)/(1+a*wp/wn))*180/pi;

sprintf('wn=%.2f  wp=%.2f  phimax=%.2fdeg  sqrt(wp*wn)=%.2frad  wp-wn=%.2frad  20*log10(k/a)=%.2fdB',...
    wn,wp,phimax,sqrt(wp*wn),wp-wn,20*log10(k/a))


subplot(121);
hold all;
%bode(s1);
for i=1:1
    hbod=bodeplot(leadv(i));grid on;
    line([5*i 5*i],[-90 45],'color','red','linestyle','--','LineWidth',1);
    line([15*i 15*i],[-90 45],'color','red','linestyle','--','LineWidth',1);
end
%bode(s1*lead);grid on;
hold off;
%line([wn wn],[-90 45],'color','red','linestyle','--','LineWidth',1);
%line([wp wp],[-90 45],'color','red','linestyle','--','LineWidth',1);
line([1e-1 1e4],[45 45],'color','red','linestyle','--','LineWidth',1);

subplot(122);
hold all;
line([-1 1], [1 -1],'color','red','linestyle','--');
nyquist(s1,P)
nyquist(leadv(1),P)
%axis([-1 1 -1 1]);
set(gca,'DataAspectRatio',[1,1,1])
hold off;
hh=findall(0,'type','figure');

delete(hh(1));

return;


subplot(SUB+1);
hold all;
bode(sys1,sys2,sys3),grid on;
bode(syst,'--b'),grid on;
%legend(char(s1),char(s2),char(s3),char(s1*s2*s3));
cla reset;





bode(lead,{1e-2,1e2});grid on

cla reset;

s4=1/(p+1);
bode(syst,'--b'),grid on;
legend('sys4');

f1=figure(1)

subplot(SUB+2);
pv=[0.1 1 10 25]
hold all;


for i=1:length(pv)
    gs(i,:)=(1/( (s+10)*(s+1+pv(i))*(s+1-pv(i))));
    bode(gs(i,:),{1e-2,1e3}),grid on;
end


legend([strsplit(sprintf('pv=%.2f ',pv(1:end)),' ')])
cla reset;

bode(100*lead*1/((s+1)*(s+2)*(s+5)),{1e-1,1e2}),grid on;



return 

nyquist(100*lead*1/(s+1)^3);
f3=figure(3);

P = nyquistoptions;
P.ShowFullContour = 'off'; 
nyquist(gs,P);

return



p=-5;
z=-40;
k=4;

cs=zpk([z],[p],k)
SUBS=[4;4];

f1=figure(1);
hold all;

syms p;
T=1/10;
k=30;

clear vsys

aa=[10 5 1 0.8 0.5 0.1];
for i=1:length(aa)
    a=aa(i);
    vsys(:,i)=sym2tf(k*(1+T*p)/(1+a*T*p))
end

subplot(SUBS(1),SUBS(2),[1 2 5 6 9 10]);

legs=[];
hold all;
for i=1:length(get(vsys,'num'))
    bode(vsys(i));grid on;
    legs=[sprintf('a=%.1f',0.15) legs ];
end

title(sprintf('k*(1+T*p)/(1+a*T*p  || T=%.2f || k=%.1f',T,k))

%legend([strsplit(sprintf('a=%.1f T=%.1f k=%.1f:',atk),':')])
legend([strsplit(sprintf('a=%.2f ',aa(1:end)),' ')])


subplot(SUBS(1),SUBS(2),[3 4 7 8]);

return


subplot(SUBS(1),SUBS(2),3);
pzmap(vsys)

subplot(SUBS(1),SUBS(2),6);
rlocus(vsys)

subplot(SUBS(1),SUBS(2),7);
step(lag);
grid on;

subplot(SUBS(1),SUBS(2),8);
impulse(vsys)
grid on;

subplot(SUBS(1),SUBS(2),9);
P = nyquistoptions;
P.ShowFullContour = 'off'; 
nyquist(vsys,P);

f2=figure(2);
sys=stack(2,tf(1,[1 2]),tf(1,[2 1 2]))

bode(sys)
