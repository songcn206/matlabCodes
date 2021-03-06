%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Postprocessing Lineplot- csv files from FEMM4.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%clear all;

mm=importdata('/media/storage/data_raid_back/mainster/DATAPOOL/TRANSFER/CODES/Femm_magnetics/outMath.txt', '\t', 2);


if exist('outMathArray.mat', 'file')
    load('outMathArray.mat');
    
    if ~isequal(arr{end},mm)
        clear in;
        in1= input('n*I=','s');
        in2= input('Coils=','s');
        arr{length(arr)+1}=mm;
        arr{length(arr)}.textdata{2,1}=[arr{length(arr)}.textdata{2,1} ' n*I=' in1 ' Coils=' in2]
%        [arr{1}.textdata{2,1} str]
        sprintf('outMathArray.mat refreshed!')
    else
        sprintf('Old contents, not refreshed!')
    end
else
    sprintf('outMathArray.mat not found')
    in1= input('n*I=','s');
    in2= input('Coils=','s');
    arr{1}=mm;
    arr{length(arr)}.textdata{2,1}=[arr{length(arr)}.textdata{2,1} ' n*I=' in1 ' Coils=' in2]
end

save('outMathArray.mat','arr');

f1=figure(1);
hold all;
legStr='';
for n=1:length(arr)
    plot(arr{n}.data(:,1),arr{n}.data(:,2));grid on;
    str=strsplit(arr{n}.textdata{2,1},':');
    str=str{1,2};
    legStr{n}=str;
%    set(gca,'XTick',0:1:30);
end

legend(legStr);
hold off;    
    
    
    
    
    
    
    