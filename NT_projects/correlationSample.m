% Korrelationen
% 
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AKF mit matlab fkt xcorr()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1=figure(1);
N=1024;                 % Number of samples
f1=1;                   % Frequency of the sinewave
FS=200;                 % Sampling Frequency
n=0:N-1;                % Sample index numbers
x=sin(2*pi*f1*n/FS);    % Generate the signal, x(n)
t=[1:N]*(1/FS);         % Prepare a time axis

subplot(330+1);         % Prepare the figure
plot(t,x);grid on;      % Plot x(n)
title('Sinwave of frequency 1000Hz [FS=8000Hz]');
xlabel('Time, [s]');
ylabel('Amplitude');

Rxx=xcorr(x);           % Estimate its autocorrelation
Rxx2=xcorr(x,x);           % Estimate its autocorrelation

subplot(330+4);         % Prepare the figure
hold all;
plot(Rxx);grid on;      % Plot the autocorrelation
plot(Rxx2);grid on;      % Plot the autocorrelation
hold off;
title('Autocorrelation function of the sinewave');
xlabel('lags');
ylabel('Autocorrelation');
legend('Rxx','Rxx2');
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AKF mit eigener funktion autocorr()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p2=figure(2);
N=1024;
f1=1;
FS=200;
n=0:N-1;
x=sin(2*pi*f1*n/FS);
t=[1:N]*(1/FS);

subplot(330+2);
plot(t,x);grid on;
title('Sinwave of frequency 1000Hz [FS=8000Hz]');
xlabel('Time, [s]');
ylabel('Amplitude');

Rxx=autocorr(x);

subplot(330+5);
plot(Rxx);grid on;
title('Selfmade Autocorrelation function of the sinewave');
xlabel('lags');
ylabel('Autocorrelation');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KKF mit matlab funktion xcorr()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p3=figure(3);
N=2^10;                 % Number of samples to generate
f1=1;                    % Frequency of the sinewave
fs=200;                 % Sampling frequency
Ts=1/fs;
n=[0:1:N-1]*Ts;                % Sampling index

x1=sin(2*pi*f1*n(1:end/3));
x2=sin(2*pi*3*f1*n(1:end/3));  % Generate x(n)
x3=sin(2*pi*f1*n(1:end/3+1)+0.4);  % Generate x(n)
x=[x1 x2 x3];
y=x+10*randn(1,N);      % Generate y(n)

pl=420;
subplot(pl+1);
plot(t,x);grid on;
title('Pure Sinewave');

subplot(pl+2);
plot(t,y);grid on;
title('y(n), Pure Sinewave + Noise');

Rxy=xcorr(x,y);         % Estimate the cross correlation
Ryx=xcorr(y,x);         % Estimate the cross correlation
subplot(4,2,[3 4]);
hold all;
plot(Rxy,'b');grid on;
plot(Ryx,'r');grid on;
hold all off;
legend('Rxy','Ryx');
title('Cross correlation');
xlim([0 2*N]);

Rxx2=xcorr(x);         % Estimate the auto correlation
Rxx2a=xcorr(x,x);         % Estimate the auto correlation
subplot(4,2,[5 6]);
hold all;
plot(Rxx2);grid on;
plot(Rxx2a);grid on;
hold off;
legend('Rxx2','Rxx2a');
title('Auto correlation');
xlim([0 2*N]);

Ryy=xcorr(y);         % Estimate the auto correlation
subplot(4,2,[7 8]);
hold on;
plot(Ryy,'r');grid on;
hold off;
legend('Ryy');
title('Auto correlation');
xlim([0 2*N]);



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Impulslaufzeitmessung (Radar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p4=figure(4);
N=256;                 % Number of samples to generate
fs=1;                 % Sampling frequency
Ts=1/fs;
n=[0:1:N-1]*Ts;                % Sampling index
plength=8;  % Tx Pulslaenge = 4samples
pdelay=39;  % Rx Pulsedelay
pdelay2=140;  % Rx Pulsedelay
pA=5;     % Tx Pulse gain
pAttd=0.4;     % Rx Pulse attenuation     

x=[pA*ones(1,plength) zeros(1,N-plength)]; 
xd=zeros(1,N); 
xd(pdelay:pdelay+plength-1)=pA*pAttd*ones(1,plength); % Rechteckimpuls fuer 4 samples, sonst null
%xd(pdelay2:pdelay2+plength-1)=pA*pAttd*ones(1,plength); % Rechteckimpuls fuer 4 samples, sonst null

% NOISE
r=xd+1*randn(1,N);        % Generate y(n)
Y=xcorr(r,x);
Yrr=xcorr(r);

Rrx=Y(end/2:end);
[dummy maxRrx]=max(Rrx);


pl4=320;
subplot(pl4+1);
hold all;
plot(n,x,'b');grid on;
plot(n,xd,'r');grid on;
hold off;
title('x(n), Tx Pulse, pure Rx Pulse');
legend('x','xd');
xlim([0 N]);

subplot(pl4+2);
hold all;
plot(n,x,'b');grid on;
plot(n,r,'r');grid on;
hold off;
title('x(n), Tx Pulse, noisy Rx Pulse');
legend('x','r');
xlim([0 N]);

subplot(pl4+3);
hold all;
plot(n,Rrx,'b');grid on;
hold off;
title([ 'Rrx(n)'...   
        '   KKFmax @ ' num2str(maxRrx, '%.2f')]);
line([maxRrx maxRrx],[1.2*min(Rrx) 1.2*max(Rrx)],'color','r','linestyle','--')
ylim([1.2*min(Rrx) 1.2*max(Rrx)]);
legend('Rrx');
xlim([0 N]);

subplot(pl4+4);
hold all;
plot([-N+1:N-1],Y,'b');grid on;
hold off;
title('Rrx(n)');
legend('Y');
xlim([-N N]);

subplot(pl4+5);
hold all;
plot([-N+1:N-1],Yrr,'b');grid on;
hold off;
title('Yrr(n)');
legend('Yrr');
xlim([-N N]);

arr=sort(findall(0,'type','figure'));
%delete(arr(1:end-1))
return
%%
ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');