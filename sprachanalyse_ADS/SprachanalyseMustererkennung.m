%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testimplementierung Sprachanalyse nach der "Ungarischen Methode"    @@@MDB
% ( Kuhn-Munkres-Algorithmus ) / Frequenzmethode nach Habr et al.
%
% http://de.wikipedia.org/wiki/Ungarische_Methode
% 08-11-2014
% ADS
%
% 10-11-2014    Rücksprache mit Hr. Schäfer
%
% * Zur Filterung/Gleichrichtung:
%   Sprachinformation wird auf einen Grundton aufmoduliert, Frauen haben 
%   Grundtöne irgendwo um 250Hz, bei Männern etwa die Hälfte, 125Hz
%   Durch Gleichrichten (Einweg- oder Vollweg-) und anschließender
%   DC- Entkopplung wird die modulierte Information unabhängig vom Grundton
%   (Frauen und männer sollen Gleichermaßen Kommandos geben können)
%   weiterverarbeitet.
% * Der Grundton könnte nach einer Vollweggleichrichtung auch mit einem
%   "running average" Algorithmus gedämpft werden... 
%    (alternative laut H. Schäfer... 
%
%   In Matlab:
%   data = [1:0.2:4]';
%   windowSize = 5;
%   filter(ones(1,windowSize)/windowSize,1,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SAVEPOS = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   save window pos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START_OF_MANIPULATION

figpos=[ [3052,-28,718,820];
		[1601,-13,718,820];
		[960,29,958,447];
		[4,29,958,447];
		[960,555,958,447];
		[4,555,958,447]];

figHdl = [22;21;13;12;11;10];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

for null=0:1 %SAVEPOS
    if SAVEPOS 
        disp('null\n')

hd = findall(0,'type','figure');
hd(hd > 100) = [];

for k=1:length(hd)
    posNew(k,:) = get(hd(k),'Position');
end


options.Interpreter = 'none';
options.Default = 'No';
qstring = 'refresh figure position matrix?';

ret = questdlg(qstring,'Write access?','Yes','No',options)

if strcmp(ret,'Yes')
    hd = findall(0,'type','figure');
    hd(hd > 100) = [];
    if isempty(hd)
        break;
    end

    command = ['cp UngarischeMethode.m ' sprintf('UngarischeMethode_%s.m', timeDate('-')) ];
    [status,cmdout] = unix(command);
    if status
        error('backup not successfull');
    end

    for k=1:length(hd)
        posNew(k,:) = get(hd(k),'Position');
    end
   
	%%%%%%%%%%%%%%
    fd=fopen('UngarischeMethode.m', 'rt+');
    str = {};
    ftell(fd);
    for n=1:100
        if ~isempty(strfind(fgetl(fd),'START_OF_MANIPULATION'))
            ftell(fd);
            %%%%%%%%%%%%%%
            str(1) = {sprintf('\r\nfigpos=[ [%i,%i,%i,%i]', posNew(1,:))}

            for m=1:size(posNew,1)-1  % m- positionsvektoren 
                str(m+1) = {sprintf(';\r\n\t\t[%i,%i,%i,%i]',posNew(m+1,:))}
            end
            str(end+1) = {'];'}
            %%%%%%%%%%%%%%
            
            str2 = sprintf('\n\nfigHdl = %s;\r\n\r\n', mat2str(hd))
            %%%%%%%%%%%%%%
            fwrite(fd, [cell2mat(str) str2]);
            break
        end
    end
    fclose(fd);
end
%end
%save(TIPS_TRICKS.m, 'figpos','-append')
%%
for k=1:length(figHdl)
    set(figHdl(k),'Position',figpos(k,1:4))
end
%%

    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%         Time            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Zeitbereich, testen der Funktionen zur Klassifizierung
%%%     Running average Grundton- Filter testen (nach Gleichrichtung)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
norm={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... % Reference
          'wavefiles/CoolEditPro/AN_frau_Norm.wav',...
         'wavefiles/CoolEditPro/AUS_mann_Norm.wav',...
          'wavefiles/CoolEditPro/AN_mann_Norm.wav'};
fname = norm;

fnameR = cellfun(@strsplit, fname,[repmat({'/';},1,length(fname))], 'UniformOutput', false);
for k=1:length(fname)
    fnameR(k) = fnameR{k}(3);
end

clear mi wavObj lh;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wave dateien laden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [W opt] = readCutWav(fname);     
    wobj = {W opt};
    fs = wobj{2}(1).fmt.nSamplesPerSec



%% -------------------------------------------------------------------------
% Spektren Plotten
% --------------------------------------------------------------------------
% clear YLI YLG
% specObj = {W ffopt};
% fv = ffopt.freqLin;
% NFFT = ffopt.NFFT;
% syms X
% 
% XSCAL = 0.05;
% XSCAL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));
% 
% 
% f11.f = figure(11);
% clf;
% SUB=210;
% 
% f11.su(1) = subplot(SUB+1); hold all;
% f11.su(2) = subplot(SUB+2); hold all;



% X- Vektor mit lin. Frequenzen
% Y- Matritzen lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SF = fv(1:length(fv)*XSCAL);
% for k=1:size(Y,2)
%     YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
%     YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
% end


% Spektrum der Testsignale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for k=1:min(size(Y))
% %    f11.p(k) = plot(SF, YLI(:,k)'); 
%     f11.p(k) = plot(SF, YLI(:,k)'); 
% end

% title(f11.su(1),'Referenz- und Test Spektren, linear')
% title(f11.su(2),'Referenz- und Test Spektren, y- logarithmisch')
% 
% set(f11.su(1),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
% set(f11.su(2),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
% grid(f11.su(1), 'on');
% grid(f11.su(2), 'on');
% % legend(f11.su(1), {''},'Interpreter','none');
% legend(f11.su(1), {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
% %legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));
% 


%set(p(1,1),'Color',[1 1 1]*0.55);
% set(f11.p(1,1),'Color','blue');
% set(f11.p(1,2),'Color','green');
% set(f11.p(1,3),'Color','red');

% f11.su(1); hold off;
% f11.su(2); hold off;

for k=1:min(size(Y))
    f11.p(1,k) = plot(f11.su(1), SF, YLI(:,k)); 
end

title(f11.su(1),'Referenz- und Test Spektren, linear')
title(f11.su(2),'Referenz- und Test Spektren, y- logarithmisch')
FMAX = 500;
set(f11.su(1),'XLim',[0 FMAX]);
set(f11.su(2),'XLim',[0 FMAX]);
grid(f11.su(1), 'on');
grid(f11.su(2), 'on');
legend(f11.su(1),  {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
legend(f11.su(2),  {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
%legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));

%set(p(1,1),'Color',[1 1 1]*0.55);
% set(p(:,1),'Color','black');
set(f11.p(1,1),'Color','blue');
set(f11.p(1,2),'Color','green');
set(f11.p(1,3),'Color','red');

f11.su(1); hold off;
f11.su(2); hold off;

return



%%
f11.fig=figure(11);
clf;
%SUB=(100*min(size(Y)) + 10);
SUB=210;

f11.su(1) = subplot(SUB+1); hold all;
f11.su(2) = subplot(SUB+2); hold all;


% X- Vektor mit lin. Frequenzen
% Y- Matritzen lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SF = fv(1:length(fv)*XSCAL);
for k=1:size(Y,2)
    YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
    YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
end

% untere Y- Grenze für log. diagramm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MINY_LOG = round(0.1*min(YLG(:)))*10;

% X- Vektor mit lin. Frequenzen
% Y- Vektoren für das gefüllte 
% Referenz- Signal, lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fix=fv(1:length(fv)*XSCAL+1);
fix=fv(1:length(fv)*XSCAL);

% untere Y- Grenze für log. diagramm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MINY_LOG = round(0.1*min(YLG(:)))*10;

% X- Vektor mit lin. Frequenzen
% Y- Vektoren für das gefüllte 
% Referenz- Signal, lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    fix=fv(1:length(fv)*XSCAL+1);
    fix=fv(1:length(fv)*XSCAL);

    fiy=[0; 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)); 0];
    fiyLg=[MINY_LOG; 10*log10( 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)) ); MINY_LOG];

    % Referenz- Signale mit fill
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(f11.su(1));
    f11.p(1,1)=fill(fix, fiy,[1 1 1]*.8);
    set(f11.p(1,1),'EdgeColor',[1 1 1]*.55);

    subplot(f11.su(2));
    f11.p(2,1)=fill(fix, fiyLg,[1 1 1]*.8);
    set(f11.p(2,1),'EdgeColor',[1 1 1]*.55);
end

% Spektrum der Testsignale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:min(size(Y))
    f11.p(1,k) = plot(f11.su(1), SF, YLI(:,k)'); 
end

title(f11.su(1),'Referenz- und Test Spektren, linear')
title(f11.su(2),'Referenz- und Test Spektren, y- logarithmisch')

set(f11.su(1),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
set(f11.su(2),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
grid(f11.su(1), 'on');
grid(f11.su(2), 'on');
% legend(f11.su(1), {''},'Interpreter','none');
legend(f11.su(1), {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
%legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));

%set(p(1,1),'Color',[1 1 1]*0.55);
set(f11.p(1,1),'Color','blue');
set(f11.p(1,2),'Color','green');
set(f11.p(1,3),'Color','red');

f11.su(1); hold off;
f11.su(2); hold off;

for k=1:min(size(Y))
    f11.p(1,k) = plot(f11.su(1), SF, YLI(:,k)); 
end

title(f11.su(1),'Referenz- und Test Spektren, linear')
title(f11.su(2),'Referenz- und Test Spektren, y- logarithmisch')
FMAX = 500;
set(f11.su(1),'XLim',[0 FMAX]);
set(f11.su(2),'XLim',[0 FMAX]);
grid(f11.su(1), 'on');
grid(f11.su(2), 'on');
legend(f11.su(1),  {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
legend(f11.su(2),  {'acw: orig'; 'facw: filtered'; 'fdcw: rect+fil'},'Interpreter','none');
%legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));

%set(p(1,1),'Color',[1 1 1]*0.55);
% set(p(:,1),'Color','black');
set(f11.p(1,1),'Color','blue');
set(f11.p(1,2),'Color','green');
set(f11.p(1,3),'Color','red');

f11.su(1); hold off;
f11.su(2); hold off;

return


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D- Spektrogram plotten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[~,~,T,P]=spectrogram(W(:,end),200,199,256,fs);
if 0
    [~,~,T,P]=spectrogram(W(:,end),200,200/2,256,fs);
    %[~,~,T,P]=spectrogram(W(:,end),tres,tres/2,fres,fs);
    I=flipud(-log(P));
    % I is the image of spectrogram in 2D matrix now

    % I want to plot this spectrogram in 3d
    h = surf(I.*-1);
    set(h, 'edgecolor','none');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%         Time            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hier wird die Analyse im Zeitbereich durchgeführt .....    bis 11.11.14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
norm={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... % Reference
          'wavefiles/CoolEditPro/AN_frau_Norm.wav',...
         'wavefiles/CoolEditPro/AUS_mann_Norm.wav',...
          'wavefiles/CoolEditPro/AN_mann_Norm.wav'};

noisy={  'wavefiles/CoolEditPro/AN_frau_White5.wav',... % Reference
        'wavefiles/CoolEditPro/AUS_frau_White5.wav',...
        'wavefiles/CoolEditPro/AN_mann_Norm.wav',...
        'wavefiles/CoolEditPro/AN_frau_White2.wav'};

fname = noisy;
fname = norm;

fnameR = cellfun(@strsplit, fname,[repmat({'/';},1,length(fname))], 'UniformOutput', false);
for k=1:length(fname)
    fnameR(k) = fnameR{k}(3);
end

clear mi wavObj lh;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Info struct in kaputte waves einfügen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    list = dir('/home/mainster/CODES_local/CoolEditPro');
    list = {list(:).name}
    pre=repmat( {'/home/mainster/CODES_local/CoolEditPro/'}, 1,length(list))
    %
    list= strcat(pre,list) 

    idx=find(~cellfun(@isempty, strfind(list,('.wav'))))
    REP=list(:,idx)
    waveWriteBasicStruct(REP)
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grundton entfernen durch abs() und 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    for k=1:2
        fd=fopen(fname{k},'r+');% wave als raw file öffnen
        fseek(fd,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
    %    fwrite(fd,[3 0]);       % "compression code" mit 0x03 überschreiben
         fwrite(fd,[1 0]);       % 10-11-14: ...mit 0x01 (no compression überschreiben
        fclose(fd);             
        [yinc{k},~,~,optscTmp{k}]=wavread(fname{k});
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wave dateien laden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[W opt] = readCutWav(fname);     % Wave- Dateien importieren
wavObj = {W opt};
fs = wavObj{2}(1).fmt.nSamplesPerSec;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D- Spektrogram plotten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[~,~,T,P]=spectrogram(W(:,end),200,199,256,fs);

[~,~,T,P]=spectrogram(W(:,end),200,200/2,256,fs);
%[~,~,T,P]=spectrogram(W(:,end),tres,tres/2,fres,fs);
I=flipud(-log(P));
% I is the image of spectrogram in 2D matrix now

% I want to plot this spectrogram in 3d
h = surf(I.*-1);
set(h, 'edgecolor','none');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Anwenden der Frequenz Methode nach Hagr
% ------------------------------------------------------------------------
% 5x5 Matritzen werden wie folgt aufgebaut:
%   In der 1. Spalte werden 5 aufeinander folgende Abtastwerte des
%   Referenz- Signals platziert. Entsprechend werden die Spalten 2...4 mit
%   je 5 Abtastwerten von Testsignalen befüllt. In die 5. Spalte werden
%   dummy Werte eingetragen, hier wird die Variante mit der größten
%   vorkommenden Matrixkomponente genutzt. 
%
%   Von jedem Element in der Matrix wird jetzt der entsprechende Zeilen-
%   und Spalten- Mittelwert subtrahiert und der Mittelwert der gesamten
%   Matrize hinzu addiert.
%
%   Pro Spalte / Testsignal darf nur ein Element als optimale Teillösung
%   gewählt werden. Die Elemente müssn so gewählt werden, dass ihre Summe
%   minimal wird. Werden die Positionen (ij) der Elemente einer optimale
%   Lösung zu einer Gruppe zusammengefasst, spricht man von der Trans-
%   versalen dieser Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mi = freqMethodeHabr(wavObj);   % Anwenden der Frequenz Methode nach Habr
%mi = -mi;
%%
%delete(findall(0,'type','line'));
tt=[0:5:(length(wavObj{1})-1)]/(wavObj{2}(1).fmt.nSamplesPerSec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotten der
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f21 = figure(21);
clf;
SUB=(100*(min(size(mi))-1) + 10);
for k=1:min(size(mi))-1
%     hold off;
    su(k)=subplot(SUB+k);
    hold all;
    p(1,k) = plot(tt, mi(:,1)); 
    p(2,k) = plot(tt, mi(:,k+1)); 
    grid on;
end
%%
subplot(su(1));
lh1=legend(strcat({'q1: ','q2: '},fnameR([1,2])),'Interpreter','none');
subplot(su(2));
lh2=legend(strcat({'q1: ','q3: '},fnameR([1,3])),'Interpreter','none');
subplot(su(3));
lh3=legend(strcat({'q1: ','q4: '},fnameR([1,4])),'Interpreter','none');
set(su,'Box','on')


hold off;
set(p(1,1:3),'Color',[1 1 1]*0.35);
set(p(2,1),'Color','red');
set(p(2,2),'Color','green');
set(p(2,3),'Color','blue')
if max(mi(:)) < 0
    set(su(1:3),'YLim',[round(100*min(mi(:)))/100 0]);
else
    set(su(1:3),'YLim',[0 round(100*max(mi(:)))/100]);
end

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vergleichen der Komponenten der optimalen Lösungen
% ------------------------------------------------------------------------
% Die Matrix mi (mi = freqMethodeHabr(wavObj);) beschreibt den Verlauf der
% optimalen Lösung.
% Sie beinhaltet m Spaltenvektoren (m Signalverläufe), von denen jeder
% Vektor den Verlauf der Teillösungen beschreibt.
%
% mi(:,1)-mi(:,k) --> Referenz minus Signal k
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Differenz zum referenz- Signal
delta=[];
for k=2:min(size(mi))
    delta(:,k-1) = mi(:,1)-mi(:,k);
end

f22 = figure(22);
clf;
SUB=310;
%%
for k=1:min(size(mi))-1
    sud(k) = subplot(SUB+k);
    pd(k) = plot(tt, delta(:,k));
    grid on;
%    lh(k) = legend(['delta: ' fnameR{k+1} ': sum = ' num2str(sum(delta(:,k)))]);
    lhd(k) = legend([ 'delta: ' fnameR{k+1} ]);
    set(lhd(k),'Interpreter','none');
end

pn = {'Color'};
pv = {'red';'green';'blue'};
set(pd, pn,pv);

set(cell2mat(ol.getWrap(sud,'Title')'),{'String'},...
    {['Int(q1-q2) = ' num2str(sum(delta(:,1))) '    ',...
      'Int(|q1-q2|) = ' num2str(sum(abs(delta(:,1))))];...
     ['Int(q1-q2) = ' num2str(sum(delta(:,2))) '    ',...
      'Int(|q1-q2|) = ' num2str(sum(abs(delta(:,2))))];...
     ['Int(q1-q2) = ' num2str(sum(delta(:,3))) '    ',...
      'Int(|q1-q2|) = ' num2str(sum(abs(delta(:,3))))]} );
%%

for k=1:length(figHdl)
%    set(figHdl(k),'Position',figpos(k,1:4))
end

return

%%
sprintf('%s\n',ds)
A=[[1 2 9 8];[3 0 3 2];[7 4 1 4];[4 2 7 7]]
[sop, C, TR, Y]=habr(A)

TRA=[TR{1};[1 2 3 4]]    % In TR{1} sind zeilennummern eingetragen, spalte von 1...4


for k=1:4
    dd{k}=[TR{1}(k),k];
    disp(Y(TR{1}(k),k))
end

% for k=1:4
%     disp(Y(dd(k)))
% end
% 

[smres opt] = readCutWav('wavefiles/CoolEditPro/AN_frau_Norm_smres.wav');
wavObjS = {abs(smres) opt};
fs=wavObjS{2}.fmt.nSamplesPerSec;
tt=[0:1:length(wavObjS{1})-1]/fs;

f30=figure(30);
SUB=210;
clear div divv

div=round(length(wavObjS{1})/100);
for k=1:100
    divv(k,:)=((k-1)*div)+1:(k-0)*div;
    wavprt(k,:)=wavObjS{1}(divv(k,:));
end

% divv(2,:)=div:2*div-1
% divv(3,:)=2*div:3*div-1
%
for k=1:1
    sub(k)=subplot(SUB+k);
    stem(divv(k,:),wavprt(k,:))
%     stem(tt(divv(k,:)),wavObjS{1}(divv(k,:)))
%      xlim([round((1+(k-1)*div)),round((1+k*div))]/fs)
end

sub(2)=subplot(SUB+2);

stem(diff(wavprt(1,:)))



for k=1:4
    disp(Y(TR{1}(k),TR{2}(k)))
end

if 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%         FFT             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hier wird die Analyse wird im Frequenzbereich (FFT) durchgeführt .....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vergleichen von verschiedenen Ansätzen zur unterdrückung des Grundtons
% der menschlichen Stimme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /home/mainster/CODES_local/matlab_workspace/

% norm={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... % Reference
%         'wavefiles/CoolEditPro/AUS_frau_Norm.wav',...
%          'wavefiles/CoolEditPro/AN_mann_Norm.wav',...
%         'wavefiles/CoolEditPro/AUS_mann_Norm.wav'};
% 
% noisy={  'wavefiles/CoolEditPro/AN_frau_White5.wav',... % Reference
%         'wavefiles/CoolEditPro/AUS_frau_White5.wav',...
%         'wavefiles/CoolEditPro/AN_mann_White5.wav',...
%         'wavefiles/CoolEditPro/AN_mann_Norm.wav',...
%         'wavefiles/CoolEditPro/AN_frau_White2.wav'};

clearvars -except ol fig*; 
delete(findall(0,'type','line'));

    
% 
% *_Norm.wav:   original wave datei aus sprachgenerator
% *_f1.wav:     wave über idealen Vollweggleichrichter und anschließendem CR Hochpass in LTspice 
% *_f2.wav:     wave über idealen Vollweggleichrichter und anschließendem CR Hochpass in LTspice 
test={   'wavefiles/CoolEditPro/AUS_frau_Norm.wav',... 
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_50.wav',...
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_100.wav',...
          'wavefiles/CoolEditPro/aus_frau_lt_cr_n1_150.wav'};

fname = test;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Info struct in kaputte waves einfügen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% list = dir('/home/mainster/CODES_local/CoolEditPro');
% list = {list(:).name}
% pre=repmat( {'/home/mainster/CODES_local/CoolEditPro/'}, 1,length(list))
% %
% list= strcat(pre,list) 
% 
% idx=find(~cellfun(@isempty, strfind(list,('.wav'))))
% REP=list(:,idx)
% waveWriteBasicStruct(REP)



fnameR = cellfun(@strsplit, fname,[repmat({'/';},1,length(fname))], 'UniformOutput', false);
for k=1:length(fname)
    fnameR(k) = fnameR{k}(3);
end

[obj stru] = readCutWav(fname);     % Wave- Dateien importieren
wavObj = {obj stru};
%%
% y1 = wavObj{1}(:,1);
% y = wavObj{1};

% FFT der wavedaten
%%%%%%%%%%%%%%%%%%%%%
% fs = wavObj{2}{1}.fmt.nSamplesPerSec;
% L = length(y1);
% tt = [0:1:L-1]/fs;
% 
% p21=figure(21);
% plot(tt,y1)
% title('Ref Signal time domain');
% grid on;
% set(gca,'XLim',[0 round(1e2*tt(end))/1e2]);
% 
% 
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y1 = fft(y1,NFFT)/L;
% f = fs/2*linspace(0,1,NFFT/2+1);

[Y, ffopt] = genSpectraMatrix(wavObj);
specObj = {Y ffopt};
fv = ffopt.freqLin;
NFFT = ffopt.NFFT;
syms X


XSCAL = 0.05;
XSCAL = 1;
XSCAL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));
%XSCALFIL = double(solve(length(fv)*X==round(length(fv)*XSCAL),X));

% Plot Spektrum
%%%%%%%%%%%%%%%%%%%%%

f10=figure(10);
clf;
%SUB=(100*min(size(Y)) + 10);
SUB=210;


su(1) = subplot(SUB+1); hold all;
su(2) = subplot(SUB+2); hold all;

% X- Vektor mit lin. Frequenzen
% Y- Matritzen lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SF = fv(1:length(fv)*XSCAL);
for k=1:size(Y,2)
    YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
    YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
end

% untere Y- Grenze für log. diagramm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MINY_LOG = round(0.1*min(YLG(:)))*10;

% X- Vektor mit lin. Frequenzen
% Y- Vektoren für das gefüllte 
% Referenz- Signal, lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fix=fv(1:length(fv)*XSCAL+1);
fix=fv(1:length(fv)*XSCAL);

fiy=[0; 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)); 0];
fiyLg=[MINY_LOG; 10*log10( 2*abs(Y(2:round(XSCAL*(NFFT/2+1-1)),1)) ); MINY_LOG];
%%
% Referenz- Signale mit fill
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot(su(1));
% p(1,1)=fill(fix, fiy,[1 1 1]*.8);
% set(p(1,1),'EdgeColor',[1 1 1]*.55);
% subplot(su(2));
% p(2,1)=fill(fix, fiyLg,[1 1 1]*.8);
% set(p(2,1),'EdgeColor',[1 1 1]*.55);

% Spektrum der Testsignale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:min(size(Y))
    p(1,k) = plot(su(1), SF, YLI(:,k)); 
    p(2,k) = plot(su(2), SF, YLG(:,k)); 
end

title(su(1),'Referenz- und Test Spektren, linear')
title(su(2),'Referenz- und Test Spektren, y- logarithmisch')
FMAX = 500;
set(su(1),'XLim',[0 FMAX]);
set(su(2),'XLim',[0 FMAX]);
grid(su(1), 'on');
grid(su(2), 'on');
legend(su(1), fnameR,'Interpreter','none');
legend(su(2), fnameR,'Interpreter','none');
%legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));

%set(p(1,1),'Color',[1 1 1]*0.55);
set(p(:,1),'Color','black');
set(p(:,2),'Color','blue');
set(p(:,3),'Color','green');
set(p(:,4),'Color','red');

su(1); hold off;
su(2); hold off;

%%










% Differenz der Testsignal- Spektren
% zur Referenz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Differenzen bilden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f11=figure(11);
clf;
SUB=210;

su(1) = subplot(SUB+1); hold all;
su(2) = subplot(SUB+2); hold all;

SF = fv(1:length(fv)*XSCAL);
YLI=[];
YLG=[];
for k=1:size(Y,2)
    YLI(:,k) = abs( 2*abs( Y(1:XSCAL*(NFFT/2+1),1) ) - 2*abs( Y(1:XSCAL*(NFFT/2+1),k) )); 
    YLG(:,k) = 10*log10(YLI(:,k));
end

for k=2:min(size(Y))
    p(1,k) = plot(su(1), SF, YLI(:,k)); 
    p(2,k) = plot(su(2), SF, YLG(:,k)); 
end

title(su(1),'Differenz (ohne algorithmus) Test- Ref Spektrum, linear')
title(su(2),'Differenz (ohne algorithmus) Test- Ref Spektrum, y- logarithmisch')

set(su(1),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
set(su(2),'XLim',[0 round(fv(round(length(fv)*XSCAL)))]);
grid(su(1), 'on');
grid(su(2), 'on');
legend(su(1), fnameR(2:end),'Interpreter','none');
legend(su(2), fnameR(2:end),'Interpreter','none');
%legend(su(1), strrep(fnameR,{'wN','mN'},{'_frau_N','_man_N'}));

%set(p(1,1),'Color',[1 1 1]*0.55);
set(p(:,2),'Color','blue');
set(p(:,3),'Color','green');
set(p(:,4),'Color','red');

su(1); hold off;
su(2); hold off;

%% Habr Freq. Methode auf Spektrum
% anwenden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mf = freqMethodeHabr(specObj);

f12 = figure(12);
clf;
%SUB=(100*min(size(Y)) + 10);
SUB=210;
su(1) = subplot(SUB+1); hold all;
su(2) = subplot(SUB+2); hold all;

% X- Vektor mit lin. Frequenzen
% Y- Matritzen lin. und log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SF = fv(1:length(fv)*XSCAL);
for k=1:size(Y,2)
    YLI(:,k) = 2*abs( Y(1:XSCAL*(NFFT/2+1),k) ); 
    YLG(:,k) = 10*log10( 2*abs(Y(1:XSCAL*(NFFT/2+1),k)) );
end

% Spektrum der Testsignale nach
% Anwendung des Algorithmus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=2:min(size(Y))
    p(1,k) = plot(su(1), SF, YLI(:,k)); 
    p(2,k) = plot(su(2), SF, YLG(:,k)); 
end
title(su(1),sprintf('Spektrum der Testsignale nach \nAnwendung des Algorithmus, linear'))
title(su(2),sprintf('Spektrum der Testsignale nach \nAnwendung des Algorithmus, log'))
% Differenz zum referenz- Signal
delta=[];
for k=2:min(size(mf))
    delta(:,k-1) = mf(:,1)-mf(:,k);
end

f13 = figure(13);
clf;
%SUB=310;
q=min(size(delta));

if ~mod(q,2)
    SUB=(100*q/2 + 10*q/2);
else
    SUB=(100*q + 10);
end


str={};
for k=1:min(size(mf))-1
    su(k) = subplot(SUB+k);
    pd(k) = plot(delta(:,k));
    grid on;
    str{k}=sprintf('delta: %s\nsum = %.3g 1/sum = %3g',...
        fnameR{k+1}, sum(delta(:,k)), 1/sum(delta(:,k))); 
    hleg(k) = legend(str{k});
end
set(hleg(:),'Interpreter','none');
[w idx]=min(sum(delta(:,:)));
%%
if length(fnameR) > 4
    m1=msgbox(sprintf(['RefSig #: %d\t%s\t \n',...
        repmat('Signal #: %d\t%s\t%.3g\n',1,min(size(delta)) )],...
        1,fnameR{1}, 2,fnameR{2},sum(delta(:,1)),...
        3,fnameR{3}, sum(delta(:,2)),4,fnameR{4},sum(delta(:,3)),...
        5,fnameR{5},sum(delta(:,4))))
else 
    m1=msgbox(sprintf(['RefSig #: %d\t%s\t \n',...
        repmat('Signal #: %d\t%s\t%.3g\n',1,min(size(delta)) )],...
        1,fnameR{1}, 2,fnameR{2},sum(delta(:,1)),...
        3,fnameR{3}, sum(delta(:,2)),4,fnameR{4},sum(delta(:,3))))
end


[C id]=min(sum(delta(:,1:3)));
id = id + 1;

w1=warndlg(fnameR{id})
set(w1,'Position',[1112          620        197.6           76])
set(m1,'Position',[1268.8        687.2        231.2        104.8])



end





%g2=mprintf(Y,'  %3.2g')


%%
%     
%     fname={ 'wavefiles/CoolEditPro/lampe_AUS_w.wav',...
%         'wavefiles/CoolEditPro/lampe_AN_w.wav'};
%     clear yin yinc A
%     
% for k=1:length(fname) 
%     f=fopen(fname{k},'r+');% wave als raw file öffnen
%     fseek(f,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
%     fwrite(f,[3 0]);       % "compression code" mit 0x03 überschreiben
%     fclose(f);             
%     [yinc{k} FsInc(k)]=wavread(fname{k});
%     
% %    yinc{k}(:,2)=[];       % clear left channel
% end
% 
% FsIn = FsIn(1);
% 
% %%
% mpl=audioplayer(yinc{1},FsIn);   % erzeuge audioplayer object mpl
% play(mpl)                     % play wave stored in y from beginning to end
% %%
% mpl=audioplayer(yinc{:,2},FsIn);   % erzeuge audioplayer object mpl
% play(mpl)                     % play wave stored in y from beginning to end
% %%
% lessSam = min(cell2mat(cellfun(@length, yinc, 'UniformOutput',false)));
% for k=1:length(yinc) 
%     yincc(:,k) = yinc{k}(1:lessSam,1);
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %delete(findall(0,'type','line'));
% 
% SEL = 1;
% yin = yincc(:,SEL);
% FsIn = FsInc(SEL);
% 
% %yin=yin(0.5*FsIn:end,1);    % clear left channel, remove 0.5 sec quit time 
% %yin(20*FsIn:end)=[];        % cut wave vector to 20sec playback
% 
% % % weißes rauschen erzeugen, addieren
% % yinN=awgn(yin,5,'measured');
% % % hinteren Teil mit unverrauschtem Signal überschreiben
% % yinN(round(end/2:end))=yin(round(end/2:end)); 
% 
% yinN=yin;
% l10=round(length(yin)/6);
% 
% nsam=2.5*FsIn;    % nsam entspricht n sek.
% SNRmax=10;
% testVec=zeros(length(yin),1);
% 
% % for k=1:5
% %     rangeM=[l10*k-nsam/2:l10*k+nsam/2];
% %     yinN(rangeM)=awgn(yin(rangeM),SNRmax-k,'measured');
% %     testVec(rangeM)=wgn(length(rangeM),1,k);
% % end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%% Figure 1 %%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % f1=figure(1);
% % tt=[0:1:length(yin)-1]*1/FsIn;
% % plot(tt,testVec);
% % title('Rauschsignal, welches der Jackson wave aufaddiert wird')
% % grid on;
% 
% mpl=audioplayer(yin,FsIn);   % erzeuge audioplayer object mpl
% play(mpl)                     % play wave stored in y from beginning to end
% 
% 
% MI=[];      % min sum speicher
% format shortg
% nEl = 5;
% last = 1;
% for k=1:length(yincc(:,1))/5
%     A=[];
%     A(1:nEl,1:2) = [yincc(last:last+nEl-1,1), yincc(last:last+nEl-1,1)];
%     A(1:nEl,3:nEl) = [repmat(max(A(:)), nEl, 3)];
%     [MI(k),~,~,yy] = habr(A);
%     last = last+nEl-1;
% end
% 
% hold all;
% plot(-MI)
% hold off;
% return 
% 
% 
% %%
% fprintf('%s\n\tungarische Methode\n%s\n',ds,ds)
% 
% A=[ [1 1 1 2];...
%     [3 2 4 1];...
%     [4 4 2 4];
%     [2 3 3 3]];
% 
% AA=[   [10 19 8 15];...
%        [10 18 7 17];...
%        [13 16 9 14];...
%        [12 19 8 18];...
%        [14 17 10 19]];
% 
%    AA(:,end+1)=max(AA(:));
% 
% habr(A)
% 
% A=randg(4,4);
% format shortg
% disp(A)
% a1 = A;
% 
% % Mittelwerte pro Zeile ermitteln
% % A(:,end+1)=[mean(A(1,1:4));...
% %             mean(A(2,1:4));...
% %             mean(A(3,1:4));...
% %             mean(A(4,1:4))];
% %mean(A,2);
% 
% % Mittelwerte pro Spalte ermitteln
% %A(end+1,end)=mean(A(1:4,end));
% % A(end+1,1:end)=[mean(A(1:4,1)),...
% %                 mean(A(1:4,2)),...
% %                 mean(A(1:4,3)),...
% %                 mean(A(1:4,4))];
% %mean(A,1)
% 
% A(end+1,1:end)=mean(A,1);
% A(1:end,end+1)=mean(A,2);
% 
% disp(A)
% 
% % for z=1:4
% %     for s=1:4
% %         Y2(z,s)=A(z,s)-A(z,end)-A(end,s)+mean(A(:));
% %     end
% % end
% 
% Y=A-repmat(mean(A,2),1,5)-repmat(mean(A,1),5,1)+mean(A(:));
% disp(Y)
% [C,id]=min(Y)
% sum(C)



