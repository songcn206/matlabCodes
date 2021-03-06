function [] = fourier6(tau)
% Funktion (fourier6.m) zur Approximation 
% der Fourier-Transformation eines Pulses 
% mit Hilfe der DFT
% Parameter: tau = Dauer des Pulses in s
%
% Testaufruf: fourier6(1.2e-6);

set(0, 'DefaultLineLineWidth',1.2);

%------Abgetasteter Puls
fmax = 4/tau;				% Frequenzbereich der Transformation 
d_f = 1/(tau*5);			% Frequenzaufl�sung
fs = 3*fmax;				% Abtastfrequenz
delta_t = 1/fs;			% Abtastperiode
N = fs/d_f;					% Anzahl Abtastwerte f�r die DFT
N = 2^(ceil(log2(N))); 	% 2 Potenz f�r die FFT

%------Resultierter diskreter Puls
n1 = round(tau/delta_t);      n2 = N-n1;
pulse = [ones(1,n1), zeros(1,n2)];

%------DFT-Transformation (Betrag)
X = fft(pulse, N);
X_f = abs(X)*delta_t;       % Skalierung f�r die Fourier-Tr.
X_shift = fftshift(X_f);

%------Korrekte Fourier-Transformation (Betrag)
w = linspace(-2*pi*(fs/2), 2*pi*(fs/2), 200);
X_ideal = abs(tau*(sin(w*tau/2)+eps)./(w*tau/2+eps));

%------Darstellungen
figure(1);          clf;
subplot(211), stem((0:N-1)*fs/N, X_f);  
title([' Betrag der DFT des Pulses (N = ',num2str(N),')']);
grid;               xlabel('Frequenz in Hz');
ylabel('Betrag in 1/Hz');
subplot(212), plot(w/(2*pi), X_ideal);   hold on; 
stem((-N/2:N/2-1)*fs/N, X_shift);                
hold off;       grid;
title(['Die Betraege der Fourier-Transformation und',...
      ' der DFT (mit Shift)']);
xlabel('Frequenz in Hz');     ylabel('Betrag in 1/Hz');


