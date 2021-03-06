% Programm kalman_filter_2.m zur Initialisierung des Modells 
% kalman_filter2.mdl in dem eine St�runterdr�ckung 
% mit Kalman-Filter simuliert wird

% -------- Lesen einer realen St�rung
[stoerung,fs,nbits]=wavread('140.wav');
fs
Ts = 1/fs;

% -------- Filter zur Simulation der Musik
nf = 64;    % Filter L�nge
hmusik = fir1(nf-1, 0.4);

% -------- Filter zur Simulation des St�rungspfads
nf = 18;
%hr = fir1(nf-1, 0.2);
hr = 0.8.^(0:nf-1);

% -------- Gesch�tztes zu identifizierendes Filter
M = 20;        % Filter L�nge
h = zeros(1,M);
QM = 0.01;     % Varianz des Messrauschens
QP = eye(M)*0;    % Kein Prozessrauschen

% -------- Aufruf der Simulation
sim('kalman_filter2',[0, 0.4]);

% -------- Darstellungen
figure(1);     clf;
subplot(321), plot(yout.time, yout.signals.values(:,3));
title('Gestoertes Signal d[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);

subplot(323), plot(yout.time, yout.signals.values(:,1));
title('Ideales Signal n[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);


subplot(325), plot(yout.time, yout.signals.values(:,2));
title('Entstoertes Signal d[k]-y[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);


subplot(222), plot(yout.time, ...
    yout.signals.values(:,1)-yout.signals.values(:,2));
title('Ideales - Entstoertes Signal n[k]-e[k]');
xlabel('Zeit in s');    grid;

koeffizienten = squeeze(koeff.signals.values(:,:,end));
subplot(224), plot(0:length(koeffizienten)-1, koeffizienten(:,1), '*',...
    0:length(koeffizienten)-1, koeffizienten(:,2));
title('Ideales (hr) und gelerntes Filter (h)');
grid;
hold on
plot(0:length(koeffizienten)-1, koeffizienten(:,1));
hold off
% -------- Leistungsspektraldichte der St��rung
figure(2);
nfft = 1024
[psd,f] = pwelch(stoerung(1:5:end,1), hamming(nfft), nfft/4, nfft, fs/5);
subplot(211), plot(f, 10*log10(psd));
title('Leistungsspektraldichte der Stoerung');
xlabel('Hz');    grid;

