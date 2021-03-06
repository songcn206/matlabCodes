% Import galvo Sensor data from PCSU1000 export file
%

delete(findall(0,'type','line'));

clear A;

filename = '/media/global_exchange/galvoP1.txt';
delimiterIn = '\t';
headerlinesIn = 9;
A = importdata(filename,delimiterIn,headerlinesIn);

inc=strfind(A.textdata(:,1),'TIME STEP');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))+1;            % take all children handles of all axes handle into structure
[sampDiv]=strsplit(A.textdata{ind,1},'=');

if find(strfind(sampDiv{1,2},'ms'))
    tmp=strsplit(sampDiv{1,2},'ms');
    samp_tdiv(1)=str2double(tmp{1,1})*1e-3;
elseif find(strfind(sampDiv{1,2},'us'))
    tmp=strsplit(sampDiv{1,2},'us');
    samp_tdiv(1)=str2double(tmp{1,1})*1e-6;
else
    sprintf('kein ms oder us gefunden');
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% header zeilen bleiben gleich --> direkte indexierung

A.channels(1,[2 3])=A.colheaders(1,[2 3]);

samp_tdiv(2)=str2double(sampDiv{1,1});
A.dataSkal(:,1)=A.data(:,1)*samp_tdiv(1)/samp_tdiv(2);

off=strsplit(A.textdata{8,1});

A.offsets(2:3)=str2double(off(2:3));

inc{1,1}=strfind(A.textdata(:,1),'CH1:');        % indexiere Childes vom type 'axes'
inc{1,2}=strfind(A.textdata(:,1),'CH2:');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))+1;            % take all children handles of all axes handle into structure
veqsts{1,1}=strsplit(A.textdata{6,1},{'CH1:','=','V'});
veqsts{1,2}=strsplit(A.textdata{7,1},{'CH2:','=','V'});

A.samp_vdiv([1 2],[2 3])=str2double([veqsts{1,1}(2:3);veqsts{1,2}(2:3)] );
A.vDiv(1,1)=A.samp_vdiv(1,3)/A.samp_vdiv(1,2);
A.vDiv(1,2)=A.samp_vdiv(2,3)/A.samp_vdiv(2,2);

A.dataSkal(:,2)=A.data(:,2)*A.vDiv(1);
A.dataSkal(:,3)=A.data(:,3)*A.vDiv(2);

f1=figure(1);
SUB=110;

hold on;
plot(A.data(:,1),A.dataSkal(:,2));
hold off;
grid on;

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');