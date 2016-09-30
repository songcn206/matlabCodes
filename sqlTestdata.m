function sqlTestdata (NNN)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erzeugen von testdaten SQL database - worktime - 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clearvars('-except',INITIALVARS{:})

NN=NNN;
halbe = round(rand(1,NN))*0.5;
dat={zeros(NN,1)};
lead = 'INSERT INTO "worktime" (dat, workerID, prjID, hours) VALUES (';

%% src and target 
% TEMPLATE='/home/mainster/mysql/delBassoInitialDb_sheme_template.sql';
%TEMPLATE='/var/lib/mysql/delBassoInitialDb_sheme_template.sql';
% TEMPLATE='~/CODES_local/qt_creator/WorktimeManager/sqlite/delBassoInitialDb_sheme_template.sql';
TEMPLATE='~/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/sqlite/delBassoInitialDb_sheme_template.sql';
% SQL_PATH = '~/CODES_local/qt_creator/WorktimeManager/sqlite';
SQL_PATH = '~/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/sqlite';

[PAT, NAME, EXT]= fileparts (TEMPLATE);
NAMER = [NAME strrep(strrep(char(timeDate), ' ','_'),':','')];

TARG=[fullfile(PAT, NAMER), EXT];
copyfile(TEMPLATE, TARG);
%%

fd = fopen(TARG,'at+');
day  = [1 30];
month= [1 12];
year = [2006 2016];
worker = [1 13];
prj = [1 7];
hrs = [0 10];

r = @(x) randi(x);
%%
for k=1:NN
%   dat{k,1} = sprintf('%s%3i, ''2015-%02i-%02i'', %2g, %2g, %3g);',...
%   dat{k,1} = sprintf('%s%3i, ''%02i/%02i/16'', %2g, %2g, %3g);',...
   dat{k,1} = sprintf('%s%3i, ''%4i-%02i-%02i'', %2g, %2g, %3g);',...
   lead, k, r(year), r(month), r(day),... 
   r(worker),r(prj),r(hrs)+halbe(k));
   fprintf(fd, '%s\n', dat{k,1});
end

fclose(fd);
type(TARG)
%%

cmd1 = ['[ -e $SQL/delbassoSQL.db ] && mv $SQL/delbassoSQL.db $SQL/olddb/delbassoSQL_$(dateForFile).db;',...
   'sqlite3 $SQL/delbassoSQL.db < ', TARG];
cmd = ['[ -e ' SQL_PATH '/delbassoSQL.db ] && mv ' SQL_PATH '/delbassoSQL.db ' SQL_PATH '/olddb/delbassoSQL_$(dateForFile).db;',...
   'sqlite3 ' SQL_PATH '/delbassoSQL.db < ', TARG];
[stat, cmdout]=system(cmd)
%%
disp (stat)
disp (cmdout)
disp (TARG)

if stat > 0
   system(['subl ' TARG]);
end
