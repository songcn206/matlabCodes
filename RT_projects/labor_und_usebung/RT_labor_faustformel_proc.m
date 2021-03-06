% Ueberschwingweite und Anstiegszeit in Abh. des Dämpfungsmaßes
delete(findall(0,'type','line'))
delete(findall(0,'type','text'))

SUB=120;
SUB1=110;
wn=1;
D=1;

% [A,b,c]=linmod('RT_labor_Faustformel')
% [num1,den1]=linmod('RT_labor_Faustformel')
dt=0.1;

D=[0.1:0.05:0.9];    % Vektor für schritte des Dämpfungsmaß
T=[1.1:0.5:10.1];
tt=[0:dt:200];     % Zeit
    

f1=figure(1);

syms wn da s

sys1s=wn^2/(s^2+2*wn*da*s+wn^2);
pretty(sys1s)

sys1sOrig=sys1s;
yvec=zeros(5,length(tt));

wnr=1;

for i=1:5
    sys1s=subs(sys1sOrig,[wn da],[wnr 0.2*i]);
    sys1=sym2tf(sys1s)
    [YY TT]=step(sys1,tt);axis([0 20 0 1.8]),grid on;
    yvec(i,1:end)=YY;
    legVec(i,:)=sprintf('da=%.1f',(0.2*i));
    
end
    plot(TT,yvec);grid on;
    legend(legVec);
    title(sprintf('Step Response, wn=%.1f',wnr));

    xlim([0,40]);
% Aus Mathematica
% y1=subs( (-exp(tt*(-da-sqrt(-1+da^2))) + exp(tt*(-da+sqrt(-1+da^2))) + 2*sqrt(-1+da^2) )/( 2*sqrt(-1+da^2) ),[wn da],[1 0.3] )


f2=figure(2);

Dopt=5;              % Optimaler Overshoot, 5%

for i=1:length(D)
    for k=1:length(T)
        sys2=tf(1,[T(k)^2 2*T(k)*D(i) 1]);
        [Y,TT,X]=step(sys2,tt);
        os(i,k)=100*(max(Y)-1.0);
    end
end

subplot(SUB+1);
schr=ones(1,length(D))*Dopt;
plot(D,schr,'r');hold on;
plot(D,os);grid on; 
xlabel('Dämpfungsmaß D')
ylabel('Overshoot [%]')

set(gca,'FontName','Helvetica')
hh=findall(gcf,'type','text');
set(hh,'FontName','Helvetica')

axis([D(1) D(end) 0 80])
hold off;
text(-0.05,5,'5% OS');

% Die Überschwingweite %OS ist unabhängig von T bzw. von der 
% Kreisfrequenz wn
%
%OS=exp(-D*pi/sqrt(1-D^2))

Tr=zeros(length(D),length(T));

hold all;
ctr=1;


for i=1:length(D)
    for k=1:length(T)
        sys2=tf(1,[T(k)^2 2*T(k)*D(i) 1]);
        [Y,TT,X]=step(sys2,tt);
    
        while Y(ctr)<1
            ctr=ctr+1;
        end
        Tr(i,k)=ctr*dt;
        ctr=1;
        legVec2{k}=sprintf('wn=%.0f',k);
    end
end

legVec2
subplot(SUB+2);

plot(D,Tr);grid on; 
legend(legVec2);
xlabel('Dämpfungsmaß D')
ylabel('T_{rise} [sec]')


break;


for i=1:length(D)
    for k=1:length(T)
        sys1=tf(1,[T(k)^2 2*T(k)*D(i) 1]);
        [Y,TT,X]=step(sys1,tt);
        
    end
end
