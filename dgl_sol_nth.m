%%% DGL Sys n-ter ordnung
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_3=@(t,y) ([y(2);-y(1)-y(2)])
%%% Inhomogenität der DGL 2. Ordnung b(t)=-cos(t)
t_range2 = [0; 20]; y0 = [1,2];
[t_steps2, y] = ode45(f_3, t_range2, y0);
f1=figure(1);
subplot(211);
plot(t_steps2, y(1:end,1));grid on;
%axis([-5 2 -2 30])
subplot(212);
plot(y(:,1),y(:,2));grid on;%%% Trajektorie in der Phasenebene 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%