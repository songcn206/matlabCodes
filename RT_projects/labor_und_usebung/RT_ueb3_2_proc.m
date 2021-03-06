% RT_ueb2
% y''(t)+3*y'(t)+2*y(t)=3*u(t)
clear all;
delete(findall(0,'type','line'));
f1=figure(1);

SUB=321;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigenes ss- model in simulink gebaut
G1a=tf([1 2],[1 1]);
G1b=tf([1],[1 3]);
subplot(SUB);
step(G1a*G1b,10);grid on;
title('step(G1a*G1b)');

G2=tf([1 2],[1 4 3]);
subplot(SUB+1);
step(G2,10);grid on;
title('Step(G2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System 2. Ordnung tf Simulink
[A1,b1,c1,d1]=linmod('RT_ueb3_2a');
[num2 den2]=ss2tf(A1,b1,c1,d1);
G3=tf(num2,den2);
subplot(SUB+2);
step(G3,10);grid on;
title('Sys 2. Ordnung uber tf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System 2. Ordnung in Simulink
[A2,b2,c2,d2]=linmod('RT_ueb3_2b');
[num3 den3]=ss2tf(A2,b2,c2,d2);
G4=tf(num3,den3);
subplot(SUB+3);
step(G4,10);grid on;
title('Sys 2. Ordnung blockschaltbild');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Blocksumme Simulink
[A3,b3,c3,d3]=linmod('RT_ueb3_2c');
[num4 den4]=ss2tf(A3,b3,c3,d3);
G5=tf(num4,den4);
subplot(SUB+4);
step(G5,10);grid on;hold on;
[r,p,k]=residue(G5.num{1},G5.den{1})
title('Summe aus tfs');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_2=@(t,y) ([y(2);-3*y(1)-4*y(2)]);
%%% Inhomogenität der DGL 2. Ordnung b(t)=-cos(t)
t_range2 = [0; 10]; 
y0 = [1; -2];
[t_steps2, y] = ode45(f_2, t_range2, y0);

subplot(SUB+5);
plot(t_steps2, y);grid on;
title('aus tfs abgeleitete DGL');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%