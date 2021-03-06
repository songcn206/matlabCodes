% Programm firpm_ls11.m zur Untersuchung der 
% firpm- und firls-Filter

clear;

% -------- Einfaches Beispiel f�r ein Tiefpassfilter 
nord = 18;
f = [0 0.4 0.5 1];
m = [1 1 0 0];
W = [100, 1]; % Gewichtung der Wichtigkeiten der B�nder

b_pm = firpm(nord, f, m, W);
b_ls = firls(nord, f, m, W);

% Frequenzg�nge
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);
[H_ls, w] = freqz(b_ls, 1, nf);

figure(1),    clf;
subplot(211),
plot(w/pi, [abs(H_pm), abs(H_ls)]);
xlabel('2f/fs');    grid;
La = axis;  axis([La(1:2), 0, 1.1]);
title(['firpm- und firls-Filter (linear) (Ordnung = ',...
        num2str(nord),'; W = [',num2str(W),'] )']);

subplot(212),
plot(w/pi, [20*log10(abs(H_pm)), 20*log10(abs(H_ls))]);
xlabel('2f/fs');    grid;
ylabel('dB');
La = axis;  axis([La(1:2), -60, 10]);
title('firpm- und firls-Filter (logarithmisch)');






