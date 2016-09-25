% Aufgabe 4

rs1={@(r) .25*(r+1); @(r) -.25*(r-3)};	% Dichtefunktion Empfangsvektor S1
rs2={@(r) .25*(r+3); @(r) -.25*(r-1)};	% Dichtefunktion Empfangsvektor S2

f2=figure(2); clf;
SUB=220;
subplot(SUB+1);
hold all;
plot([-1:0.01:3+0.01],[rs1{1}([-1:.01:1]) rs1{2}([1:.01:3])],'b');
plot([-3:0.01:1+0.01],[rs2{1}([-3:.01:-1]) rs2{2}([-1:.01:1])],'r');
legend('f_r(r|s1)','f_r(r|s2)');
title(sprintf(['Dichtefunktionen der Empfansvektoren',... 
	'\nAdditiv ueberlagertes Rauschen ist mittelwertfrei']))
xlim([-4,4]); ylim([0, .6]);
grid on;

n1={@(n) .25*(n+2); @(n) -.25*(n-2)};	% Dichtefunktion Empfangsvektor S1

subplot(SUB+2);
plot([-2:.01:2+.01], [n1{1}([-2:.01:0]) n1{2}([0:.01:2])],'b');
xlim([-2.5, 2.5]);
ylim([0, .6]);
grid on;


syms n;
mx_n = {int(n*n1{1}), int(n*n1{2}) };
int(n*n1{1},n,-2,0)
int(n*n1{2})
sx2_n = {int(n.^2*n1{1}), int(n.^2*n1{2}) };

subplot(SUB+3);
hold all;
mxN = eval([subs(mx_n{1},'n',[-2:.01:0]) subs(mx_n{2},'n',[0:.01:2])]);
plot([-2:.01:2+.01], mxN);
legend(sprintf('int(n*.25*(n+2))\nint(n*(-.25*(n-2)))'),'location','NorthOutside');
xlim([-2.5, 2.5]);
grid on;

subplot(SUB+4);
hold all;
sx2N = eval([subs(sx2_n{1},'n',[-2:.01:0]) subs(sx2_n{2},'n',[0:.01:2])]);
plot([-2:.01:2+.01], sx2N);
legend(sprintf('int(n^2*.25*(n+2))\nint(n^2*(-.25*(n-2)))'),'location','NorthOutside');
xlim([-2.5, 2.5]);
grid on;

% ezplot(sx2_n{1},[-2,0]);
% ezplot(sx2_n{2},[0,2]);
% yl2=[round(10 * min(eval(subs(sx2_n, 'n',[-2:0.1:2]))))/10,...
% 	round(10 * max(eval(subs(sx2_n, 'n',[-2:0.1:2]))))/10];
% xlim([-3,3]);
% ylim(yl);


