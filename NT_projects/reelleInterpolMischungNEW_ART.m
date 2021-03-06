%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reelle Schwingung, interpol, da- wandeln, mischen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;

%%%
hellblau=[0.2549, 0.71372549, 0.952941176];
dunkelblau=[0.070588235, 0.262745098, 0.607843137]

fa1=30e3;
Ta1=1/fa1;
fa2=4*fa1;
Ta2=1/fa2;
fLO=10e3;

fc=1000;
Tc=1/fc;
N=80e6*Tc;
t=[0:1:N-1]*Ta1;

phi=pi/9;   % Phasenverschiebung für Mischerschwingung
phi=0;
yS=cos(2*pi*fc*t);

fa=500;
fb=1500;

yS2=sin(2*pi*fa*t);
for k=fa+1:1:fb
    yS2=yS2+sin(2*pi*k*t);
end

%%%% Quasi- Kontinuierlich gegenüber fa1 %%%%
%
%

%%%% Interpolationen %%%%
ySx2=interp1(t,yS,[0:0.5:N-1]*Ta1);

% Erst verschieben in bp, dann interpol
yS2bp=yS2.*cos(2*pi*fLO*t);
yS2bpx2=interp1(t,yS2bp,[0:0.5:N-1]*Ta1);
yS2bpx4=interp1(t,yS2bp,[0:0.25:N-1]*Ta1);

% erst interpol. dann in bp verschieben
yS2x2=interp1(t,yS2,[0:0.5:N-1]*Ta1);
yS2x4=interp1(t,yS2,[0:0.25:N-1]*Ta1);
yS2x2bp=yS2x2.*cos(2*pi*fLO*[0:0.5:N-1]*Ta1);
yS2x4bp=yS2x4.*cos(2*pi*fLO*[0:0.25:N-1]*Ta1);

ySx2x2=interp1([0:0.5:N-1]*Ta1,ySx2,[0:0.25:N-1]*Ta1);
ySx4=interp1(t,yS,[0:0.25:N-1]*Ta1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NFFT = 2^nextpow2(N); % Next power of 2 from length of y
NFFT=N;
ticksFah = fa1/2*linspace(0,1,NFFT/2);
ticksFa = fa1/2*linspace(0,2,NFFT);
df=fa1/NFFT;

NFFTx2=2*N;
%NFFTx2 = 2^nextpow2(2*N); % Next power of 2 from length of y
ticksFahx2 = 2*fa1/2*linspace(0,1,NFFTx2/2);
ticksFax2 = 2*fa1/2*linspace(0,2,NFFTx2);
dfx2=2*fa1/NFFTx2;


NFFTx4=4*N;
ticksFahx4 = 4*fa1/2*linspace(0,1,NFFTx4/2);
ticksFax4 = 4*fa1/2*linspace(0,2,NFFTx4);
dfx2=4*fa1/NFFTx4;

Normierung='off';

% Mischen mit Feinmischer f=fa1
%ySIntbp=ySInt.*cos(2*pi*fa1*tx4+phi);
%ySIntbp=ySInt;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % sin(x)/x Filter wegen S&H der Konvertierung
% filDA1k=sin(pi*(Ta1)*ticksFx4x2)./(pi*ticksFx4x2);
% filDA4k=sin(pi*(Ta2)*ticksFx4x2)./(pi*ticksFx4x2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     filDA1k=filDA1k/max(abs(filDA1k));
%     filDA4k=filDA4k/max(abs(filDA4k));
% end;
% filDA1kdB=10*log10(abs(filDA1k));
% filDA4kdB=10*log10(abs(filDA4k));
% 
% YrectResp=fft(rectpuls(tx4/Ta2),NFFTx2)/(2*L);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x/sin(x) Korrekturfilter
%filCorDA1k=(Ta1*pi*ticksF)./sin(pi*(Ta1)*ticksF);
%filCorDA4k=(Ta2*pi*ticksFx4)./sin(pi*(Ta2)*ticksFx4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, fa1
YS=fft(yS,NFFT);
YSamp=abs(YS)/NFFT;
%YSamp=fftshift(YSamp/NFFT);

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSamp = YSamp/max(YSamp);
end;
YS_dB=10*log10(YSamp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, fa1
YS2=fft(yS2,NFFT);
YS2amp=abs(YS2)/NFFT;
%YSamp=fftshift(YSamp/NFFT);

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2amp = YS2amp/max(YS2amp);
end;
YS2_dB=10*log10(YS2amp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, x2 Nullen
%YSintx2Zeros=fft(ySIntx2Zeros,NFFTx2)/(2*L);
%disp(['max(abs(YSintx2Zeros)) = ',num2str(max(abs(YSintx2Zeros))),' = ',num2str(10*log10(max(abs(YSintx2Zeros)))),'dB']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, fa2
%YSx2=fft(ySx2,NFFTx2)/(2*L);
%YSx2=fftshift(YSx2/NFFTx2);
%YIQrf = YIQrf/max(abs(YIQrf));
%YSx2_dB=10*log10(abs(YSx2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, for interpoliert auf x2
YSx2=fft(ySx2,NFFTx2);
YSx2amp=abs(YSx2)/NFFTx2;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSx2amp = YSx2amp/max(YSx2amp);
end;
YSx2_dB=10*log10(YSx2amp);

YS2x2=fft(yS2x2,NFFTx2);
YS2x2amp=abs(YS2x2)/NFFTx2;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2x2amp = YS2x2amp/max(YS2x2amp);
end;
YS2x2_dB=10*log10(YS2x2amp);



YS2bpx2=fft(yS2bpx2,NFFTx2);
YS2bpx2amp=abs(YS2bpx2)/NFFTx2;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2bpx2amp = YS2bpx2amp/max(YS2bpx2amp);
end;
YS2bpx2_dB=10*log10(YS2bpx2amp);



YS2bpx4=fft(yS2bpx4,NFFTx2);
YS2bpx4amp=abs(YS2bpx4)/NFFTx4;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2bpx4amp = YS2bpx4amp/max(YS2bpx4amp);
end;
YS2bpx4_dB=10*log10(YS2bpx4amp);


YS2bp=fft(yS2bp,NFFT);
YS2bpamp=abs(YS2bp)/NFFT;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2bpamp = YS2bpamp/max(YS2bpamp);
end;
YS2bp_dB=10*log10(YS2bpamp);



YS2x2bp=fft(yS2x2bp,NFFTx2);
YS2x2bpamp=abs(YS2x2bp)/NFFTx2;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2x2bpamp = YS2x2bpamp/max(YS2x2bpamp);
end;
YS2x2bp_dB=10*log10(YS2x2bpamp);


YS2x4bp=fft(yS2x4bp,NFFTx4);
YS2x4bpamp=abs(YS2x4bp)/NFFTx4;

if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS2x4bpamp = YS2x4bpamp/max(YS2x4bpamp);
end;
YS2x4bp_dB=10*log10(YS2x4bpamp);

% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% IFFT TEST %%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nper=0.75;
% % gRng=[0:length(YSintbp)-1];
% % gRang=ticksFx4;
% % invSinc=Ta2*(pi*gRng*Ta2)./(sin(pi*gRng*Ta2));
% 
% corFilRngd=[filCorDA4k(1:0.4*fa2*dfx4) ones(1,length(filCorDA4k(0.4*fa2*dfx4:end)))];
% %pt2=figure(103);
% %plot(ticksFx4(1:900*dfx4),filCorDA4k(1:900*dfx4));grid on;
% %plot(ticksFx4,corFilRngd);grid on;
% 
% 
% ySiff = ifft((YS),NFFT/2)*L;
% %ySiffNorm = ySiff/max(abs(ySiff));
% 
% ySx2iff = ifft((YSintx2),NFFTx2)*0.5*L;
% %ySx2iffNorm = ySx2iff/max(abs(ySx2iff));
% 
% ySx4iff = ifft((YSint),NFFTx2)*0.5*L;
% %ySx4iffNorm = ySx4iff/max(abs(ySx4iff));
% 
% ySintbpiff = ifft((YSintbp.*corFilRngd),NFFTx2)*0.5*L;
% %ySintbpiffNorm = ySintbpiff/max(abs(ySintbpiff));
% 
% pt=figure(77);
% 
% subplot(221);
% hold on;
% plot(tk(1:Nper*Tc/Tak)*1e3,ySk(1:Nper*Tc/Tak),'r');grid on;
% stem(t(1:Nper*Tc/Ta1)*1e3,yS(1:Nper*Tc/Ta1),...
%     'r','Marker','o','MarkerFaceColor','r','LineWidth',2,'MarkerSize',4);grid on;
% legend('s1 zeitkontinuierlich','s1 mit fa1 abgetastet');
% xlabel('t / ms');
% ylim([-1.2 1.2]);
% hold off;box on;
% 
% subplot(222);
% hold on;
% plot(tk(1:Nper*Tc/Tak)*1e3,ySk(1:Nper*Tc/Tak),'r');grid on;
% title(['Normiert auf s1 - Zeitkontinuierlich']);
% stem(t(1:Nper*Tc/Ta1)*1e3,yS(1:Nper*Tc/Ta1),...
%     'r','Marker','o','MarkerFaceColor','r','LineWidth',3,'MarkerSize',4);grid on;
% stem(t(1:2*Nper*Tc/Ta1)*1e3*0.5,ySx2iff(1:2*Nper*Tc/(Ta1))/max(ySx2iff),...
%     'color','black','Marker','o','MarkerFaceColor','black','LineWidth',1,'MarkerSize',4);grid on;
% stem(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySx4iff(1:4*Nper*Tc/(Ta1))/max(ySx4iff),...
%     'color',dunkelblau,'Marker','+','LineWidth',1,'MarkerSize',14);grid on;
% legend('s1 - zeitkontinuierlich',...
%     's1 - abgetastetmit fa1 ',...
%     's1 - linear x2 Interpoliert',...
%     's1 - linear x4 Interpoliert'...
%     );
% xlabel('t / ms');
% ylim([-1.2 1.2]);
% hold off;box on;
% 
% subplot(223);
% hold on;
% plot(tk(1:Nper*Tc/Tak)*1e3,ySbpk(1:Nper*Tc/Tak)*max(ySintbpiff),'r');grid on;
% stem(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
%     'color',dunkelblau,'Marker','o','MarkerFaceColor',dunkelblau,...
%     'LineWidth',1,'MarkerSize',5);grid on;
% stairs(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
%     'color',dunkelblau,'LineWidth',1,'LineStyle','--');grid on;
% legend('s1 um fa1 verschoben - zeitkontinuierlich',...
%     's1 - linear x4 Interpoliert, um fa1 verschoben '...
%     );
% xlabel('t / ms')
% hold off;box on;
% 
% subplot(224);
% hold on;
% %plot(tk(1:Nper*Tc/Tak)*1e3,ySbpk(1:Nper*Tc/Tak),'r');grid on;
% stairs(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
%     'color',dunkelblau,'LineWidth',1);grid on;
% legend('s1 um fa1 verschoben - zeitkontinuierlich',...
%     's1 - linear x4 Interpoliert, um fa1 verschoben '...
%     );
% xlabel('t / ms')
% hold off;box on;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p1=figure(1);
YSCALE=[-100 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
subplot(221);
plot([0:df:4*fa1-df],[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc x2
subplot(223);
plot([0:df:4*fa1-df],[YSx2_dB YSx2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSx2\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  

subplot(222);
hold on;
stairs([0:1:Tc/Ta1-1]*Ta1,yS(1:Tc/Ta1),'b','MarkerFaceColor','b','MarkerSize',4);grid on;
stairs([0:0.5:Tc/Ta1-1]*Ta1,ySx2(1:1:2*Tc/Ta1-1),'r');grid on;
hold off;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('yS');
legend('ySx2');
set(gca, 'Layer','bottom')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc x2
subplot(222);
plot([0:df:4*fa1-df],[YS2_dB YS2_dB YS2_dB YS2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS2\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
ylim([-50 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  

subplot(224);
plot([0:df:4*fa1-df],[YS2x2_dB YS2x2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSx2\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
ylim([-50 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  




p7=figure(7);

subplot(421);
plot([0:df:2*fa1-df],[YS2_dB YS2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on; 


subplot(423);
plot([0:df:2*fa1-df],[YS2bp_dB YS2bp_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSbp\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on; 


subplot(425);
plot([0:df:2*fa1-df],[YS2bpx2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSbpx2\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  


subplot(427);
plot([0:df:2*fa1-df],[YS2x2bp_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSx2bp\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  



subplot(422);
plot([0:df:2*fa1-df],[YS2_dB YS2_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on; 


subplot(424);
plot([0:df:2*fa1-df],[YS2bp_dB YS2bp_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSbp\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 2*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on; 


subplot(426);
plot([0:2*df:4*fa1-df],[YS2bpx4_dB],'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSbpx4\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
ylim([-40 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  

tickFil=[-8*fa1:df:8*fa1];
filDA=0.5*sin(pi*tickFil/(4*fa1))./(pi*tickFil/(4*fa1));
filDA_dB=10*log10(abs(filDA));
subplot(428);
hold on;
plot([0:df:4*fa1-df],[YS2x4bp_dB],'b');grid on;
plot([0:df:4*fa1-df],[YS2bp_dB YS2bp_dB YS2bp_dB YS2bp_dB],'r');grid on;
%plot([0:df:4*fa1-df],[filDA_dB filDA_dB filDA_dB filDA_dB],'g');grid on;
hold off;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSx4bp\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
xlim([0 4*fa1]);
ylim([-50 0]);
line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
box on;  

f95=figure(98);
hold on;
plot(tickFil,filDA_dB,'g');grid on;
hold off;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa = 4x fa1=' num2str(4*fa1,'%.3e') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YSx4bp\_dB');
set(gca, 'Layer','bottom')
%ylim([YSCALE]);
%xlim([0 4*fa1]);
ylim([-40 0]);


%ylim([YSCALE]);
%xlim([0 4*fa1]);
box on;  
% ysIff = ifft(ifftshift(YS),NFFT);
% 
% subplot(422);
% plot(ticksFx2,abs([YS YS YS YS]),'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% legend('YS\_dB');
% set(gca, 'Layer','bottom')
% line([fa1 fa1],[0 1.2],'color','r','linestyle','--')
% line([2*fa1 2*fa1],[0 1.2],'color','r','linestyle','--')
% line([3*fa1 3*fa1],[0 1.2],'color','r','linestyle','--')
% ylim([0 1.2]);
% box on;   
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% % auf x4 interpol
% subplot(423);
% hold on;
% plot(ticksFx4x2,[YSint_dB YSint_dB],'b');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['x4 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],YSCALE,'color','r','linestyle','--')
% line([2*fa2 2*fa2],YSCALE,'color','r','linestyle','--')
% ylim(YSCALE);
% box on; 
% 
% subplot(424);
% hold on;
% plot(ticksFx4x2,abs([YSint YSint]),'b');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['x4 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],[0 1.2],'color','r','linestyle','--')
% line([2*fa2 2*fa2],[0 1.2],'color','r','linestyle','--')
% ylim([0 1.2]);
% box on; 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% % auf x4 interpol und mit fa1 gemischt
% subplot(425);
% hold on;
% plot(ticksFx4x2,[YSintbp_dB YSintbp_dB],'b');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['auf fa1 gemischt   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],YSCALE,'color','r','linestyle','--')
% line([2*fa2 2*fa2],YSCALE,'color','r','linestyle','--')
% ylim(YSCALE)
% box on; 
% 
% subplot(426);
% hold on;
% plot(ticksFx4x2,abs([YSintbp YSintbp]),'b');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['auf fa1 gemischt   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],[0 1.2],'color','r','linestyle','--')
% line([2*fa2 2*fa2],[0 1.2],'color','r','linestyle','--')
% ylim([0 1.2]);
% box on; 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% % auf x4 interpol und mit fa1 gemischt
% % nach DA- Wandlung
% subplot(427);
% hold on;
% plot(ticksFx4x2,[YSintbp_dB YSintbp_dB]+filDA4kdB,'b');grid on;
% plot(ticksFx4x2,filDA4kdB,'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],YSCALE,'color','r','linestyle','--')
% line([2*fa2 2*fa2],YSCALE,'color','r','linestyle','--')
% ylim(YSCALE)
% box on; 
% 
% subplot(428);
% hold on;
% plot(ticksFx4x2,abs([YSintbp YSintbp].*filDA4k),'b','LineWidth',1);grid on;
% %plot(ticksFx4x2,imag([YSintbp YSintbp].*filDA4k),'b');grid on;
% plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% %plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% line([fa2 fa2],[0 1.2],'color','r','linestyle','--')
% line([2*fa2 2*fa2],[0 1.2],'color','r','linestyle','--')
% ylim([0 1.2]);
% box on; 
% 
% 
% p22=figure(22);
% hold on;
% plot(ticksFx4x2*0.5,10*log10(abs([YSintx2 YSintx2])),'b');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['x2 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on; 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%    diskretes signal   %%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%    inverse FFT   %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p2=figure(2);
% 
% rev=[YSintbp YSintbp];%.*filDA4k;
% r=ifft(rev(1:end/2),NFFTx2);
% rSh=ifft(ifftshift(rev(1:end/2)),NFFTx2);
% rev2=YSintbp;%.*filDA4k;
% r2=ifft(conv(rev,[0.5 1 0.5]),NFFTx2);
% 
% 
% smod=(real(r)/max(real(r))).*cos(2*pi*4*fa1*tx4+0.6);
% smod2=imag(r2/max(real(r2))).*cos(2*pi*4*0*tx4x2(1:end/2));
% %s2=cos(2*pi*fc*tx4).*cos(2*pi*fa1*tx4).*cos(2*pi*4*0*tx4);
% 
% faN=0.5/250e-6;
% L=length(smod);
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% ticksF = faN*linspace(0,1,NFFT);
% 
% Ysmod=fft(smod,NFFT)/(L);
% %YSint=fftshift(YSint/NFFTx2);
% Ysmod = Ysmod/max(abs(Ysmod));
% Ysmod_dB=10*log10(abs(Ysmod));
% 
% Ys2=fft(r2,NFFT)/(L);
% %YSint=fftshift(YSint/NFFTx2);
% Ys2 = Ys2/max(abs(Ys2));
% Ys2_dB=10*log10(abs(Ys2));
% 
% subplot(411);
% hold on;
% stem([1:0.02/Ta2]*Ta2,real(r(1:0.02/Ta2))/max(real(r(1:0.02/Ta2))),...
%     'r','MarkerSize',6,'MarkerFaceColor','r');grid on;
% stairs([1:0.02/Ta2]*Ta2,real(rSh(1:0.02/Ta2))/max(real(rSh(1:0.02/Ta2))),...
%     'b','MarkerSize',4,'MarkerFaceColor','b');grid on;
% hold off;
% ylim([-1.1 1.1]);
% 
% subplot(412);
% stairs([1:0.02/Ta2]*Ta2,real(r(1:0.02/Ta2))/max(real(r(1:0.02/Ta2))));grid on;
% ylim([-1.1 1.1]);
% 
% subplot(413);
% stairs([1:0.02/Ta2]*Ta2,smod(1:0.02/Ta2));grid on;
% ylim([-1.1 1.1]);
% 
% subplot(414);
% hold on;
% plot(ticksFx4x2,[Ysmod_dB Ysmod_dB],'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 0]);
% box on; 

% subplot(424);
% hold on;
% plot(ticksF,Ys2_dB,'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 0]);
% box on; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
% auf x4 interpol und mit fa1 gemischt
% nach DA- Wandlung
% mischen auf 4*fa1
% subplot(423);
% hold on;
% plot(ticksFx4x2,[YSintbp_dB YSintbp_dB]+filDA4kdB,'b');grid on;
% plot(ticksFx4x2,filDA4kdB,'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 5]);
% box on; 
% 
% subplot(424);
% hold on;
% plot(ticksFx4x2,abs([YSintbp YSintbp].*filDA4k),'b','LineWidth',1);grid on;
% %plot(ticksFx4x2,imag([YSintbp YSintbp].*filDA4k),'b');grid on;
% plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% %plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on; 
% 






% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Jetzt nochmal ohne interpolation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fa1=4*1000;
% Ta1=1/fa1;
% n=2^15-1;
% fc=100;
% t=[0:1:4*(n+1)-1]*Ta1;
% 
% yS=cos(2*pi*fc*t);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % fft
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L=n;
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% ticksF = fa1/2*linspace(0,2,NFFT);
% ticksFx2 = fa1/2*linspace(0,4,2*NFFT);
% ticksFx4 = fa1/2*linspace(0,8,4*NFFT);
% 
% Normierung='on';
% % Mischen mit Feinmischer f=fa1
% ySIntbp=ySInt.*cos(2*pi*fa1*t);
% % sin(x)/x Filter wegen S&H der Konvertierung
% filDA4k=sin(pi*(Ta2)*ticksFx4x2)./(pi*ticksFx4x2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     filDA1k=filDA1k/max(abs(filDA1k));
%     filDA4k=filDA4k/max(abs(filDA4k));
% end;
% filDA1kdB=10*log10(abs(filDA1k));
% filDA4kdB=10*log10(abs(filDA4k));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, fa1
% YS=fft(yS,NFFT)/(L);
% %YS=fftshift(YS/NFFT);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YS = YS/max(abs(YS));
% end;
% YS_dB=10*log10(abs(YS));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, fa2
% %YSx2=fft(ySx2,NFFTx2)/(2*L);
% %YSx2=fftshift(YSx2/NFFTx2);
% %YIQrf = YIQrf/max(abs(YIQrf));
% %YSx2_dB=10*log10(abs(YSx2));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, for interpoliert auf x2
% YSintx2=fft(ySIntx2,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintx2 = YSintx2/max(abs(YSintx2));
% end;
% YSintx2_dB=10*log10(abs(YSintx2));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, interpoliert auf x4
% YSint=fft(ySInt,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSint = YSint/max(abs(YSint));
% end;
% YSint_dB=10*log10(abs(YSint));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% cos(fa1) mischen
% YSintbp=fft(ySIntbp,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintbp=YSintbp/max(abs(YSintbp));
% end;
% YSintbp_dB=10*log10(abs(YSintbp));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% DA- Wandlung des interpolierten 
% % und gemischten signals
% ySIntbpDA=conv(ySIntbp(2:end-1),[0.5 1 0.5]);
% YSintbpDA=fft(ySIntbpDA,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     ySIntbpDA=ySIntbpDA/max(abs(ySIntbpDA));
% end;
% YSintbpDA_dB=10*log10(abs(YSintbpDA));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, conv fa2
% YSintConv=fft(conv(ySInt(2:end-1),[0.5 1 0.5]),NFFTx2)/(2*L);
% %YSintConv=fftshift(YSintConv/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintConv=YSintConv/max(abs(YSintConv));
% end;
% YSintConv_dB=10*log10(abs(YSintConv));
% 
% 
% f2=figure(2);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% subplot(521);
% %plot(ticksFx4x2,[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
% plot(ticksFx2,[YS_dB YS_dB],'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% legend('YS\_dB');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on;   
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% subplot(525);
% %plot(ticksFx4x2,[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
% plot(ticksFx2,[YSintbp_dB],'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% legend('YS\_dB');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on;   


arr=sort(findall(0,'type','figure'));
%delete(arr(1:end-2))