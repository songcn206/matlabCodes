% Programm ls_1.m zur rekursiven L��sung der Least-Square Gleichung
% f��r die Koeffizienten eines FIR-Filters (Informationsform und Covarianzform)

clear;
randn('state', 176453);

% -------- FIR-Filter 
nf = 13;
hr = fir1(nf-1, 0.35)'; % oder
%hr = (0.8.^(0:nf-1))';

% ------- Gesch�tztes Filter und Initialisierungen
M = 15;
h = zeros(M,1);    % Anfangswert
Pinv = eye(M);
w = 1;
x_temp = zeros(M,1);
x_temp1 = zeros(nf,1);
noise = 0.2;       % Varianz des Messrauschens

% ------- Rekursive Anpassung (Informationsform)
nx = 20;
for n = 1:nx
    xn = randn(1);   % Laufender Eingang
    x_temp = [xn; x_temp(1:end-1)];   % Aktualisierung
    Pinv = Pinv + x_temp*w*x_temp';
    P = inv(Pinv);
    % gew�nschter Ausgang
    x_temp1 = [xn; x_temp1(1:end-1)];
    d = hr'*x_temp1;
    d = d + sqrt(noise)*randn(1);     % mit Messrauschen
    
    K = P*x_temp*w;
    y = h'*x_temp;
    e = d-y;
    h = h + K*e;
end;

% ------- Rekursive Anpassung (Covarianzform)
nx = 10000;
for n = 1:nx
    xn = randn(1);   % Laufender Eingang
    x_temp = [xn; x_temp(1:end-1)];   % Aktualisierung
    % gew�nschter Ausgang
    x_temp1 = [xn; x_temp1(1:end-1)];
    d = hr'*x_temp1;
    d = d + sqrt(noise)*randn(1);     % mit Messrauschen
    
    K = P*x_temp/(w+x_temp'*P*x_temp);
    y = h'*x_temp;
    e = d-y;
    h = h + K*e;
    P = (eye(M)-K*x_temp')*P/w;
end;

figure(1);   clf;
subplot(221), stem(0:nf-1, hr);
title(['Korrektes Filter']);
xlabel('i');   grid;

subplot(222), stem(0:length(h)-1, h);
title(['Identifiziertes Filter (Messrauschen \sigma^2 = ',num2str(noise),')']);
xlabel('i');   grid;
