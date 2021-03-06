%function zufallsproz_sinusmuster ()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Zufallsprozesse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TU- Darmstadt pdf:    Signale/Zufallsprozesse
% E. Hänsler und G. Schmidt, TU Darmstadt, Seite 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bsp.: Zufallsprozess mit sinusförmigen Musterfunktionen und
% zufälliger phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    isOpen = matlabpool('size') > 0;
    c = parcluster

    if ~isOpen
        matlabpool open 12
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('fig','var')
	delete(findall(fig(:),'type','line'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w0 = 2*pi;
NEXP = 150;							% n experimente
xm = @(t, phi) sin(w0*t+phi);			% Musterfunktion
tt = linspace(0,1.2,50);				% auf Zeitinterval

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dichtefunktion auf Interval [0,pi/2]
% = 2/pi	für 0 <= phi <= pi/2
% = 0		sonst
%
fp_p = @(phi) 2/pi*((0<=phi)&(phi<=pi/2));   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vektoren mit Zufallsvariablen phi
% Gleichverteilt, rand() 
% uniformly distributed random variable
%
phiu = 2/pi*rand(1, NEXP);				

%%---------------------------------------------------------------------------
% normrand(mu, sigma, ...) generates random numbers from the
% normal distribution with mean parameter mu and standard
% deviation parameter sigma
%
mu = 0; sigma=1;						% Sollte Gaußverteilt sein ??!
phig = 2/pi*normrnd(mu,sigma,1,NEXP);	% Zufallsvariablen Gaußverteilt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xmu = zeros(50,NEXP);					% malloc
xmg = zeros(50,NEXP);					% malloc

for k = 1:NEXP
    xmu(:,k) = xm(tt,phiu(k));			% Prozessvektor, phi Gleichverteilt
    xmg(:,k) = xm(tt,phig(k));			% Prozessvektor, phi Gaußverteilt
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erwartungswert, Moment 1. Ordnung berechnen:
% integrand:  Produkt aus Muster- und Dichtefunktion 
% Integralschranken von +-inf auf 0,pi/2 gesetzt weil Dichtefkt.
% nur in diesem Intervall ungleich 0 ist
%
syms t p;
mx1 = int(xm(t,p)*2/pi, p ,0 ,pi/2);	
mx1 = str2func(['@(t)' char(mx1)]);

%%%%%%%% Musterlösung %%%%%%%%%%%%%%%%%% 
mx1mu = @(t)2*sqrt(2)/pi*sin(w0*t+pi/4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%	Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
fig(1) = figure(1); SUB = 220;

subplot(SUB+1);
hold all; 
plot(tt, xmu); grid on;				% plotten des gesammten prozesses
xlim([tt(1), tt(end)]);

t1 = 1;								% Scharmittel berechnen zum Zeitpunkt t1
ord = find(tt >= t1, 1,'first');	% Wegen auflösung sollte der index
									% angepasst werden --> ord~t1
y1n = feval(mx1,tt);				% mx1 Vektor
y1mu = feval(mx1mu,tt);				% mx1 Vektor von Musterlösung
plot(tt, y1mu,'g-','LineWidth',3); 
grid on; hold all;
plot(tt, y1n,'b--'); 


%% Scharmittel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
ordv = round(linspace(1,length(tt),length(tt)/5));	% jeden 5. Wert aus tt
scharMags = xmu(ordv,:);			% amplituden aller Experimente 
									% zu jedem 5. Zeitpunkt
mean(scharMags);

amp = xmu(ord,:);					% amplituden aller Experimente
scharMean = mean(amp);				% Scharmittel berechnen
disp(['scharMeanmittel bei ' num2str(tt(ord)) 's: ' num2str(scharMean)]);
plot(tt(ord), scharMean,'x','MarkerSize',15,'LineWidth',2); 
line([tt(ord) tt(ord)],[-1,1],'Color','red')
line([(1-0.1)*tt(ord) (1+0.1)*tt(ord)],[scharMean scharMean],'Color','red')

ampg = xmg(ord,:);					% amplituden aller Experimente
scharMeang = mean(ampg);			% Scharmittel berechnen
disp(['scharMeanmittel Gauss bei ' num2str(tt(ord)) 's: ' num2str(scharMeang)]);
plot(tt(ord), scharMeang,'x','MarkerSize',15,'LineWidth',2); 
line([tt(ord) tt(ord)],[-1,1],'Color','blue')
line([(1-0.1)*tt(ord) (1+0.1)*tt(ord)],[scharMeang scharMeang],'Color','blue')

fig(2)=figure(2);
cdfplot(amp); hold all
cdfplot(ampg);
legend('amp','ampg');

%%
figure(fig(1));
subplot(SUB+2);

plot(tt, y1mu,'Color','green','LineWidth',3); grid on; hold all;
plot(tt, y1n,'b--'); 
xlim([tt(1), tt(end)]);
legend('E\{x(t)\} musterloesung','matlab - berechnet')

line([tt(ord) tt(ord)],[-1,1],'Color','red')
line([(1-0.1)*tt(ord) (1+0.1)*tt(ord)],[scharMean scharMean],'Color','red')
disp('')

subplot(SUB+3);
plot(amp);
line([0 NEXP],[1 1]*scharMean,'Color','red','Linestyle','--');
legend( ['Amplituden des Prozesses, t=' num2str(tt(ord)) 's'],...
        ['Scharmittel bei t=' num2str(tt(ord)) 's: ' num2str(scharMean)] );
xlabel('Experiment n');
grid on;
ylim([-1,1]);

dist = distMagn(amp,length(amp),'all');     % Verteilung berechnen

subplot(SUB+4);
plot(dist,'x','LineWidth',1);
% line([0 NEXP],[1 1]*scharMean,'Color','red','Linestyle','--');
legend(sprintf('Amplituden Verteilung \nzum Zeitpunkt t=%.4gs', tt(ord))); 
xlabel('Amplitude');
grid on;



return

% phi = [0:.01:1];
% f2 = figure(2); clf;
% ezplot(@(x) xm(x,phi(1)),[0,2*pi])
% hold all; grid on;

%%
% y = evrnd(0,3,100,1);
% cdfplot(y)
% hold on
% x = -20:0.1:10;
% f = evcdf(x,0,3);
% plot(x,f,'m')
% legend('Empirical','Theoretical','Location','NW')
% 
% 
% 
% yg = wgn(100,1,0);
% end