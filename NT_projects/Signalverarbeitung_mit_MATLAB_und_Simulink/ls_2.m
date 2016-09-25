% Programm ls_2.m zur rekursiven L��sung der Least-Square Gleichung
% f��r die Koeffizienten eines FIR-Filters (Covarianzform)

clear;
%randn('state', 176453);

% -------- FIR-Filter 
nf = 13;
hr = fir1(nf-1, 0.35)'; % oder
%hr = (0.8.^(0:nf-1))';

% ------- Gesch�tztes Filter und Initialisierungen
M = 15;
w = 1;  % Forgetting Faktor
x_temp1 = zeros(nf,1); % F��r das korrekte Filter
x_temp = zeros(M,1);   % F��r das zu identif. Filter
noise = 0.1;       % Varianz des Messrauschens

h = zeros(M,1);     P = eye(M);   % Anfangswerte

% ------- Rekursive Anpassung
nx = 500;
for n = 1:nx
    xn = randn(1);   % Laufender Eingang
    x_temp = [xn; x_temp(1:end-1)];   % Aktualisierung
    % gew�nschter Ausgang
    x_temp1 = [xn; x_temp1(1:end-1)];
    d = hr'*x_temp1;
    d = d + sqrt(noise)*randn(1);     % mit Messrauschen
    
    K = P*x_temp/(1/w + x_temp'*P*x_temp);
    y = h'*x_temp;
    e = d-y;
    h = h + K*e;
    P = P/w-K*x_temp'*P/w;
end;

figure(1);   clf;
subplot(221), stem(0:nf-1, hr);
title(['Korrektes Filter']);
xlabel('i');   grid;

subplot(222), stem(0:length(h)-1, h);
title(['Identifiziertes Filter (Messrauschen \sigma^2 = ',num2str(noise),')']);
xlabel('i');   grid;
