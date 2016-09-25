function MultiAudioRec (varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufnehmen von Sprachkommandos                                       @@@MDB
%
%% MultiAudioRec (SAVEPATH, PREFIX, POSTFIX)
%
% defaults
try 
    
ds = evalin('base','ds');
ol = evalin('base','ol');
evalin('base','global SAVEPATH');
global SAVEPATH

fprintf('%s\n%s\n{''haus'',''maus'',''raus'',''vogel'',''eins''})\n%s\n%s\n',ds,ds,ds,ds)

if nargin > 0
   if ~isnumeric(varargin{1})
      warning('Dont know what to do with this parameter??! Need numeric one')
   end
   TEST = varargin{1};
end

lastSetup1 = fullfile(ol.projectsPath,'wavefiles','MultiAudioRec_lastused.mat');
lastSetup2 = fullfile(ol.projectsPath,'MultiAudioRec_lastused.mat');

lastSetup=[];
if exist(lastSetup1, 'file')  
    used = questdlg('use MultiAudioRec_lastused?', 'Restore config?', 'Yes','No', 'Yes')
    if strcmp(used,'No')
        movefile(lastSetup1, [lastSetup1 '_' timeDate(4,'_')]);
        lastSetup=[];
    end
    lastSetup=lastSetup1;
else
    if exist(lastSetup2, 'file')
        used = questdlg('use MultiAudioRec_lastused?', 'Restore config?', 'Yes','No', 'Yes')
        if strcmp(used,'No')
            movefile(lastSetup2, [lastSetup2 '_' timeDate(4,'_')]);
            lastSetup=[];
        end
        lastSetup=lastSetup2;
    end
end

if isempty(lastSetup) %&& ~exist('MultiAudioRec_lastused.mat', 'file')
    N_RECORD_LOOPS = 3;
%    SAVEPATH_DEF = '/home/mainster/CODES_local/matlab_workspace/wavefiles/';
    SAVEPATH_DEF = '/media/global_exchange/wav_21-02/';

PREFIX_DEF = 'waveout_';
    SUBFOLDER_DEF = 'timeDate(3,''_'')';
    FS_DEF = 16000;
    NCHAN = 2;
    RESOL = 16;
    LENGTH_SEC = 1;
    LENGTH_SAM = LENGTH_SEC*FS_DEF;
    AUTO_LOOP = 1;
else
    load(lastSetup);
end


%     if nargin >= 1   % no parameter passed
%         if ischar(varargin{1})
%             SAVEPATH = varargin{1};
%         else
%             SAVEPATH = SAVEPATH_DEF;
%         end            
%     else
%         SAVEPATH = SAVEPATH_DEF;
%     end
    
    prompt = {  'How many record loops:',...
                'Enter record length [sec]',...
                'Enter record length [N samples]',...
                'Enter resolution [Bit]',...
                'Enter Channels [1:Mono 2:Stereo]',...
                'Enter Sample rate:',...
                'Enter prefix (opt):',...
                'Enter subfolder :',...
                'Enter loop mode [0: manuell 1:auto]'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {N_RECORD_LOOPS, LENGTH_SEC, LENGTH_SAM, num2str(RESOL),...
           NCHAN, num2str(FS_DEF), PREFIX_DEF, SUBFOLDER_DEF, AUTO_LOOP}
   for n=1:length(def)
       if isnumeric(def{n})
           def{n}=num2str(def{n});
       end
   end
       
    ret = inputdlg(prompt,dlg_title,num_lines,def);
    retn = cellfun(@str2num, ret, 'UniformOutput', false);
    
    dirnow = pwd;
    cd(SAVEPATH_DEF);
    [PREFIX_DEF, SAVEPATH] = uiputfile({'*.wav','All Audio Files';...
          '*.*','All Files' },'Save wave record as',...
          [PREFIX_DEF]) % eval(SUBFOLDER_DEF), '.wav'
%          [SAVEPATH, PREFIX_DEF,timeDate('_'),'.wav'])
    if ~PREFIX_DEF
        returnToPwd();
        return 
    else
        tmp = strsplit(PREFIX_DEF,'.');
        PREFIX_DEF = tmp{1}
        EXT = tmp{2};
    end
   
    
    N_RECORD_LOOPS = retn{1};
    SUBFOLDER_DEF = ret{8};
    FS_DEF = retn{6};
    NCHAN = retn{5};
    RESOL = retn{4};
    if retn{2} ~= LENGTH_SEC
        LENGTH_SEC = retn{2};
        LENGTH_SAM = LENGTH_SEC*FS_DEF;
    else
        if retn{3} ~= LENGTH_SAM
            LENGTH_SAM = retn{3};
            LENGTH_SEC = LENGTH_SAM/FS_DEF;
        end            
    end
    AUTO_LOOP = str2num(ret{9});
    
    save('MultiAudioRec_lastused.mat','N_RECORD_LOOPS','SAVEPATH_DEF',...
         'SUBFOLDER_DEF','PREFIX_DEF','FS_DEF','NCHAN','RESOL','LENGTH_SEC',...
         'LENGTH_SAM','AUTO_LOOP');

    if AUTO_LOOP
        opt.Default = 'Yes';
        opt.Interpreter = 'none';
        choice = questdlg('Aufnahme starten','Rec',...
            'Yes','No',opt)

        if strcmp(choice, 'No')
            returnToPwd();
            return 
        end
    end
    
     cd(dirnow);
    
      f44 = figure(44); clf;
      SUB = 120;
      su(1)=subplot(SUB+1); hold all;
      su(2)=subplot(SUB+2); hold all;
      
      datedir = eval(SUBFOLDER_DEF);
      
    for k=1:N_RECORD_LOOPS
        
        if ~AUTO_LOOP
            opt.Default = 'Yes';
            opt.Interpreter = 'none';
            choice = questdlg('Aufnahme starten','Rec',...
                'Yes','No',opt)
            
            if strcmp(choice, 'No')
                break;
            end
        else
            for N=0:2
                fprintf('record #%i in %isec\n',k,3-N)
                delayWait(1);  
            end
        end
        
        recObj = audiorecorder(FS_DEF, RESOL, NCHAN);
        disp('Start speaking.')
        recordblocking(recObj, LENGTH_SEC);
        disp('End of Recording.');

%         if exists('TEST','var')
%            if TEST == k
%               figure; hold all;
%               for h=1:TEST
%                  plot()
        
        % Play back the recording.
%         play(recObj);

        % Store data in double-precision array.
        myRecording = getaudiodata(recObj);
    

        order = 12;
         nfft = 512;
         Fs = FS_DEF;

        subplot(su(1)); hold all;
        py(:,k) = pyulear(myRecording(:,1)',order,nfft,Fs);
        plA(:,k)=plot(su(1),10*log10(py(:,k)));        
        drawnow;

        pl(:,k)=plot(su(2),myRecording); 
        drawnow;
        
        
        SAVEAT{k} = [SAVEPATH, fullfile(datedir, [PREFIX_DEF num2str(k), '.wav'])];
    	if ~exist(fullfile(SAVEPATH, datedir))
                mkdir(fullfile(SAVEPATH, datedir));
        end
        audiowrite(SAVEAT{k}, myRecording, FS_DEF);
    end
    
    try
       for N=1:N_RECORD_LOOPS
           evalin('base',sprintf('Y=audioread(''%s'');',SAVEAT{N}));
           evalin('base',sprintf('mp{%i} = audioplayer(Y,%i);',N,FS_DEF));
       end
    catch err
       fprintf('%s\n%s\n%s\n', ds, err.identifier, ds)
    end
%     
%     datefolder = [SAVEPATH, timeDate('_')];
%     mkdir(datefolder);
%     
%     for k=1:N_RECORD_LOOPS
%         movefile(SAVEAT{k}, datefolder);
%     end
%     DIR_CMD = sprintf('dir %s',datefolder);
%     disp(DIR_CMD);
%     evalin('base',DIR_CMD);
    disp(' ');
	disp(['Run   play(mp(1))   for playback'])
    disp('maybe run:')
    disp('renameWaveFiles(SAVEPATH, {''haus'',''maus'',''raus'',''vogel'',''eins''});')
%     evalin('base','SAVEPATH',SAVEPATH);
    addpath(fullfile(SAVEPATH, datedir));
    SAVEPATH = fullfile(SAVEPATH, datedir);
    
catch err
    cd('/home/mainster/CODES_local/matlab_workspace/');
end
    
end

function returnToPwd()
    cd(dirnow);
end