%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Gute settling time auch mit +-25V sättigung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));
SIMFILES={  'Galvo_sys_v11'};
%             'GalvoModel_v31'
%             'GalvoModel_v31_CC',...
%             'GalvoModel_v31_no_CC',...
%             'GalvoModel_v31_19082014',...
paramCtrl=loadCtrlParam([]);
SimEnd = 30e-3;   
%open(SIMFILES{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind=NaN;
ch = allchild(0);
names = get(ch,'Name');
if iscell(names)
    ind=find(~cellfun(@isempty, strfind(lower(names), 'scope')));
else
    ind=find(strfind(lower(names), 'scope'));
end
if ~isnan(ind)
    close(ch(ind));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen aus Blockdiagramm ableiten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S = linmod(SIMFILES{1});
S.filename = SIMFILES{1};
u_ = strrep(S.InputName, [S.filename '/'], '');
y_ = strrep(S.OutputName, [S.filename '/'], '');
S.InputName = u_;
S.OutputName = y_;

simoa = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 
[num, den] = ss2tf(S.a, S.b, S.c, S.d);

NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
simob = tf(NUM, den, 'u', u_, 'y', y_); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=120;
Tfin = 2e-3;

subplot(SUB+1);
step(simoa, Tfin)



return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigener Zustandsraum der Strecke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=[ -(CR + SHR)/CL, -BEM/RIN,   0;
    TRC/CL,         -FR/RIN,    -KTR;
    0               1/RIN,      0 ];
b=[1; 0; 0];
c=[0, 0, 1];
d=0;

[num, den] = ss2tf(a, b, c, d);
%SIMO3 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 
SIMO3 = tf(num, den, 'u', u_, 'y', y_(1)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return



[num, den] = ss2tf(GvS.a, GvS.b, GvS.c, GvS.d);
SIMO1 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 

%[num, den] = linmod('GalvoModel_v31');

f15=figure(15);
SUB=130;
subplot(SUB+1);
step(SIMO1)

subplot(SUB+2);
step(SIMO2);

subplot(SUB+3);
step(SIMO3);

return

% sampleTime = 1;                             % Symbolzeit
% simin.time = [0:sampleTime:simulationTime]; % Zeitvektor

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
open_bd = find_system('type', 'block_diagram');
ind = find(strcmp(open_bd, 'simulink'));
if ind > 0
    open_bd(ind)=[];
end 

ret=[];
for k=1:length(SIMFILES)
%     ind(k)=~isempty(strfind(open_bd, SIMFILES{k}))
% 
%     if isempty(ind)
%         disp('blockdiagram not found')
%     else

    if isempty(ret)         
        ret = questdlg( 'Close blockdiagrams?', ...
                        'Simulink workaround', ...
                        'Yes', 'No', 'No');
    end
        if strcmp(ret, 'Yes') 
%            save_system(open_bd(ind));
            close_system(open_bd);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param=loadGalvoParam([]);
paramCtrl=loadCtrlParam([]);

CurrentController=Simulink.Variant ('Variant_CC == 1');
NO_CurrentController=Simulink.Variant ('Variant_CC == 0');
Variant_CC=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen aus Blockdiagramm ableiten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gv = linmod('GalvoModel_v31_19082014');
Gv.filename = 'GalvoModel_v31_19082014';
u_ = strrep(Gv.InputName, [Gv.filename '/'], '');
y_ = strrep(Gv.OutputName, [Gv.filename '/'], '');
Gv.InputName = u_;
Gv.OutputName = y_;

G=ss(Gv.a,Gv.b, Gv.c, Gv.d);



return;


vKp_cc = [0.06 0.1 0.5];

legstr=[];
for k=1:3
%    Kp_cc = Kp_cc + 3.33*(k-1)
    paramCtrl.Kp_cc = sprintf('%f',vKp_cc(k));
    legstr = [legstr sprintf('Kp_cc = %s:',paramCtrl.Kp_cc)];

    [num, den] = linmod(SIMFILES{2});   % v31 inkl. cc mit untersch.
    Gv31cc(k,:) = tf(num,den);          % stromverstärkungen
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen aus Blockdiagramm ableiten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GvS = linmod('GalvoModel_v31');
GvS = linmod('GalvoModel_v31');
GvS.filename = 'GalvoModel_v31';
u_ = strrep(GvS.InputName, [GvS.filename '/'], '');
y_ = strrep(GvS.OutputName, [GvS.filename '/'], '');
GvS.InputName = u_;
GvS.OutputName = y_;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO- tf aus linmod-struct (Zustandsraum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[num, den] = ss2tf(GvS.a, GvS.b, GvS.c, GvS.d);
SIMO1 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 

[num, den] = linmod('GalvoModel_v31');
SIMO2 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigener Zustandsraum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=[ -(CR + SHR)/CL, -BEM/RIN,   0;
    TRC/CL,         -FR/RIN,    -KTR;
    0               1/RIN,      0 ];
b=[1; 0; 0];
c=[0, 0, 1];
d=0;

[num, den] = ss2tf(a, b, c, d);
%SIMO3 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 
SIMO3 = tf(num, den, 'u', u_, 'y', y_(1)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f15=figure(15);
SUB=130;
subplot(SUB+1);
step(SIMO1)

subplot(SUB+2);
step(SIMO2);

subplot(SUB+3);
step(SIMO3);

%cellfun(@open, SIMFILES)

return 


f1=figure(1);
hold all;
step(Gv31cc(1,:))
step(Gv31cc(2,:))
step(Gv31cc(3,:))
hold off;
legend(strsplit(legstr,':'))


return

open(SIMFILES{1})

t2=linmod(SIMFILE);
t2.filename=SIMFILE;
t2.InputName=strrep(t2.InputName, t2.filename, '');
%[num2, den2] = linmod('GalvoModel_v3_discret_simo');
[num den]=ss2tf(t2.a,t2.b,t2.c,t2.d, 1);
sys2(:,2)=fieldnames(t2);
sys2(1,1)={t2};
sys2(:,3)=struct2cell(t2);

if size(num,1) == 1
    Gv=tf(num, den) %,...
end
if size(num,1) == 2
    Gv=tf({num(1,:); num(2,:)}, den) %,...
end
if size(num,1) == 2
    Gv=tf({num(1,:); num(2,:); num(3,:)}, den) %,...
end
%        'OutputName',strrep(sys2{1}.OutputName, t2.filename, '' ),...
%        'InputName',sys2{1}.InputName);
%[y1, tt]=step(Gv,linspace(0,10e-3,1000));
f2=figure(2);
step(Gv)
legend('Gv')



% 
% tt1(:,1)=tt;
% tt1(:,2)=tt;
% tt1(:,3)=tt;
% 
% hold on;
% subplot(311)
% plot(tt,y1(:,1))
% subplot(312)
% plot(tt,y1(:,2))
% subplot(313)
% plot(tt,y1(:,3))
% hold off
% ---------------------------------------------------------------
% ----- Estimate tf of current controller, simulated by LTSpice
% ---------------------------------------------------------------
%   tfCC=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
%                  'I(Shunt2)',[0 2e6],[3,2],0);


