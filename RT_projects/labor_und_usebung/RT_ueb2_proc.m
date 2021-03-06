% RT_ueb2
% y''(t)+3*y'(t)+2*y(t)=3*u(t)
clear all;
delete(findall(0,'type','line'));
f1=figure(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Von hand in Laplace- Bereich mit u(t)=step(t)
s=tf('s');
G1s=(s^2+5*s+3)/(s^3+3*s^2+2*s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G1s: von hand inverse Laplacetr. 
t1=[0:0.01:10];
y1=3/2+exp(-t1)-3/2*exp(-2*t1);
subplot(221);
plot(t1,y1); grid on;
title('Inverse Laplace- Transf. von Hand')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DGL über ode45 
f_2=@(t,y) ([y(2);-3*y(2)-2*y(1)+3]);
t_range2 = [0; 10]; y0 = [1; 2];
[t_steps2, y] = ode45(f_2, t_range2, y0);
subplot(222);
plot(t_steps2, y(1:end,1));grid on;
title('DGL "uber ode45');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System 2. Ordnung in Simulink
A=[0 1; -2 -3];
b=[0;3];
c=[1;0]';
x0=[1;2];
d=0;
[A1,b1,c1,d1]=linmod('sys2order');
[num2 den2]=ss2tf(A1,b1,c1,d1);
G2=tf(num2,den2);
subplot(223);
step(G2,10);grid on;
title('Standard Sys 2. Ordnung simulink');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigenes ss- model in simulink gebaut
[A3,b3,c3,d3]=linmod('RT_ueb2',[1 0],3);
[num3,den3]=ss2tf(A3,b3,c3,d3);
G3=tf(num3,den3);
subplot(224);
step(G3,10);grid on;
title('Eigenes Model in simulink gebaut');
