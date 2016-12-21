function pzg_menu( menu_h, Domain )
% Creates pzgui standard menus in the specified figure.
% Requires a menu "stub", and the domain.

% The following copyrighted m-files comprise the PZGUI tool:
%    ** The contents of these files may not be included **
%    **  in any other program without explicit written  **
%    **    consent from the author, Mark A. Hopkins     **
%     bodepl.m        pzg_bodex.m     pzg_islink.m     pzg_seltxt.m
%     contents.m      pzg_box.m       pzg_islogx.m     pzg_tools.m
%     contourpl.m     pzg_c2d.m       pzg_isunwrp.m    pzg_tpwr.m
%     dpzgui.m        pzg_cntr.m      pzg_lims.m       pzg_txan.m
%     dupdatep.m      pzg_cphndl.m    pzg_menu.m       pzg_unre.m
%     figopts.m       pzg_d2c.m       pzg_moda.m       pzg_unwrap.m
%     fr_disp.m       pzg_disab.m     pzg_onoff.m      pzg_updtfilt.m
%     freqserv.m      pzg_efmt.m      pzg_pfesim.m     pzg_xtrfrq.m
%     gainfilt.m      pzg_err.m       pzg_prvw.m       pzgcalbk.m
%     helpserv.m      pzg_errvis.m    pzg_ptr.m        pzgui.m
%     ldlgfilt.m      pzg_fndo.m      pzg_recovr.m     pzmvserv.m
%     nicholpl.m      pzg_gle.m       pzg_reptxt.m     resppl.m
%     nyqistpl.m      pzg_grid.m      pzg_res.m        rlocuspl.m
%     pidfilt.m       pzg_inzpk.m     pzg_rsppfe.m     sensplot.m
%     pz_move.m       pzg_isdby.m     pzg_rss.m        updatepl.m
%     pzg_bkup.m      pzg_ishzx.m     pzg_scifmt.m     updtpzln.m
%                                     pzg_sclpt.m      zmimntcpt.m
% (c) 1996 - 2014
%    by Professor Mark A. Hopkins, Ph.D.
%       Electrical and Microelectronic Engineering
%       Rochester Institute of Technology
%       Rochester NY, USA 14623        Email:  mark.hopkins@rit.edu
%
% SHAREWARE INFORMATION:
%               FREE, IF USED ONLY FOR EDUCATIONAL PURPOSES.
%   Otherwise:
%    (corporations, companies, and other for-profit users) 
%    Individual licenses -- US$200 per computer
%    Site license -- US$2000 per industrial site, any number of users
%    Make check payable to "Mark A. Hopkins", and remit to address above
% ----------------------------------------------------------------------
global PZG
if isempty(PZG) && ~pzg_recovr 
  return
end

% Check validity of input arguments.
if nargin < 2
  errdlg_h = ...
    errordlg({'Insufficient input arguments.'; ...
              ' ';'    Click "OK" to continue.'}, ...
             [mfilename ': Input Arg Error'],'modal');
  uiwait(errdlg_h)
  return
elseif isempty(menu_h) || ~ishandle(menu_h) ...
      || ~strcmpi('uimenu',get(menu_h,'type'))
  errdlg_h = ...
    errordlg({'First input arg is not UIMENU.'; ...
              ' ';'    Click "OK" to continue.'}, ...
             [mfilename ': Input Arg Error'],'modal');
  uiwait(errdlg_h)
  return
elseif ~ischar(Domain) || ( numel(Domain) ~= 1 ) ...
      ||( ~isequal(Domain,'s') && ~isequal(Domain,'z') )
  errdlg_h = ...
    errordlg({'Second input arg must be ''s'' or ''z''.'; ...
              ' ';'    Click "OK" to continue.'}, ...
             [mfilename ': Input Arg Error'],'modal');
  uiwait(errdlg_h)
  return
end

fig_h = get( menu_h,'parent');
set( fig_h,'menubar','none');
set( menu_h,'label','File','tag','pzgui_file_menu');

if isappdata(fig_h,'hndl')
  hndl = getappdata(fig_h,'hndl');
else
  hndl = [];
end
hndl.file_menu = menu_h;

mdl_menu_h = findobj( fig_h,'tag','pzgui_model_menu');
if isempty(mdl_menu_h)
  mdl_menu_h = ...
    uimenu('parent', fig_h, ...
           'label', 'Model', ...
           'tag','pzgui_model_menu');
end
hndl.mdl_menu = mdl_menu_h;
tool_menu_h = findobj( fig_h,'tag','pzgui_tool_menu');
if isempty(tool_menu_h)
  tool_menu_h = ...
    uimenu('parent', fig_h, ...
           'label', 'Tools', ...
           'tag','pzgui_tool_menu');
end
hndl.tool_menu = tool_menu_h;
help_menu_h = findobj( fig_h,'tag','pzgui_help_menu');
if isempty(help_menu_h)
  help_menu_h = ...
    uimenu('parent', fig_h, ...
           'label', 'Help', ...
           'tag','pzgui_help_menu');
end
hndl.help_menu = help_menu_h;

uimenu('parent', menu_h, ...
 'label','Figure background:  WHITE', ...
 'tag','pzgui options menu bg white', ...
 'callback', 'figopts(''all_plots'',''w'');');
uimenu('parent', menu_h, ...
 'label','Figure background:  BLACK', ...
 'tag','pzgui options menu bg black', ...
 'callback','figopts(''all_plots'',''k'');');
uimenu('parent', menu_h, ...
 'label','Hide Controls (this figure)', ...
 'separator','on', ...
 'tag','pzgui hide controls', ...
 'callback', ...
  ['if isempty(findobj(gcbf,''type'',''uicontrol'',' ...'
               '''visible'',''on'')),' ...
      'return,' ...
   'end,' ...
   'set(findobj(gcbf,''type'',''uicontrol''),' ...
         '''visible'',''off'');' ...
   'temp_ax13=findobj(gcbf,''type'',''axes'');' ...
   'for temp_axk=1:numel(temp_ax13),' ...
     'if isempty(strfind(get(temp_ax13(temp_axk),''tag''),''legend'')),' ...
       'setappdata(temp_ax13(temp_axk),''initpos'',' ...
          'get(temp_ax13(temp_axk),''position''));' ...
       'set(temp_ax13(temp_axk),''position'',[0.13 0.14 0.80 0.78]);' ...
     'end,' ...
   'end,' ...
   'clear temp_axk temp_ax13']);

uimenu('parent', menu_h, ...
 'label','Show Controls (this figure)', ...
 'tag','pzgui show controls', ...
 'callback', ...
    ['if isempty(findobj(gcbf,''type'',''uicontrol'',' ...'
                 '''visible'',''on'')),' ...
       'temp_ax13=findobj(gcbf,''type'',''axes'');' ...
       'for temp_axk=1:numel(temp_ax13),' ...
         'if isempty(strfind(get(temp_ax13(temp_axk),''tag''),''legend'')),' ...
           'set(temp_ax13(temp_axk),''position'',' ...
                'getappdata(temp_ax13(temp_axk),''initpos''));' ...
         'end,' ...
       'end,' ...
     'end,' ...
     'set(findobj(gcbf,''type'',''uicontrol''),''visible'',''on'');' ...
     'if~isempty(strfind(get(gcbf,''name''),''Nichols'')),' ...
       'temp_cb_h=findobj(gcbf,''tag'',''Nichols hilite cursor checkbox'');' ...
       'temp_gd_h=findobj(gcbf,''tag'',''CL mag phase grid checkbox'');' ...
       'if~get(temp_gd_h,''value''),' ...
         'set(temp_cb_h,''value'',0,''visible'',''off'');' ...
       'end,' ...
     'end,' ...
     'if~isempty(strfind(get(gcbf,''name''),' ...
                 '''Continuous-Time Nyquist Contour'')),' ...
       'if PZG(1).stop_movie,' ...
         'set(findobj(gcbf,''tag'',''nyq stop movie pushbutton''),' ...
              '''visible'',''off'');' ...
       'end,' ...
     'elseif~isempty(strfind(get(gcbf,''name''),' ...
                 '''Discrete-Time Nyquist Contour'')),' ...
       'if PZG(2).stop_movie,' ...
         'set(findobj(gcbf,''tag'',''nyq stop movie pushbutton''),' ...
              '''visible'',''off'');' ...
       'end,' ...
     'end,' ...
     'if~isempty(strfind(get(gcbf,''name''),''Time Response'')),' ...
       'temp_step_h=findobj(gcbf,''tag'',''visible for step only'');' ...
       'temp_sine_h=findobj(gcbf,''tag'',''visible for sinusoid only'');' ...
       'temp_peri_h=findobj(gcbf,''tag'',''visible for periodic only'');' ...
       'temp_input_h=findobj(gcbf,''tag'',''input-type popupmenu'');' ...
       'temp_show_e_h=findobj(gcbf,''tag'',''show_io_difference'');' ...
       'temp_input=get(temp_input_h,''value'');' ...
       'if temp_input==2,' ...
         'set(temp_step_h,''visible'',''on'');' ...
       'else,' ...
         'set(temp_step_h,''visible'',''off'');' ...
       'end,' ...
       'if temp_input==5,' ...
         'set(temp_sine_h,''visible'',''on'');' ...
       'else,' ...
         'set(temp_sine_h,''visible'',''off'');' ...
       'end,' ...
       'if temp_input==1,' ...
         'set(temp_show_e_h,''visible'',''off'');' ...
       'end,' ...
       'if temp_input>4,' ...
         'set(temp_peri_h,''visible'',''on'');' ...
       'else,' ...
         'set(temp_peri_h,''visible'',''off'');' ...
       'end,' ...
     'end,' ...
     'clear temp_cb_h temp_gd_h temp_peri_h temp_ax13 temp_axk,' ...
     'clear temp_step_h temp_sine_h temp_input_h temp_input temp_show_e_h']);

uimenu('parent', menu_h, ...
       'label','Close all PZGUI plots', ...
       'separator','on', ...
       'foregroundcolor',[0.7 0 0], ...
       'tag','Close all auxiliary PZGUI plots', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'temp_fig_h=findobj(allchild(0),''tag'',''PZGUI plot'');' ...
            'delete(temp_fig_h);' ...
          'catch,pzg_err(''"Close aux plots" menu selection'');end,' ...
          'pzg_onoff(1);' ...
          'clear temp_fig_h']);
        
uimenu('parent', menu_h, ...
       'label','Clear "Undo" & "Redo" history', ...
       'separator','on', ...
       'foregroundcolor',[0.7 0 0.7], ...
       'tag','Clear "Undo" & "Redo" history', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'temp_clrans=questdlg(' ...
             '''Clear the "Undo" and "Redo" history?'',' ...
             '''Verify Clear History'',' ...
             '''Yes, Clear History'',''No, Cancel'',''No, Cancel'');' ...
          'if~strcmp(temp_clrans,''Yes, Clear History''),' ...
            'return,' ...
          'end,' ...
          'if ~isempty(strfind(get(gcbf,''name''),''iscrete'')),' ...
            'PZG(2).undo_info={};' ...
            'PZG(2).redo_info={};' ...
          'else,' ...
            'PZG(1).undo_info={};' ...
            'PZG(1).redo_info={};' ...
          'end,' ...
          'pzg_unre;' ...
          'clear temp_clrans']);

uimenu('parent', menu_h, ...
   'label','Export Setup ...', ...
   'separator','on', ...
   'foregroundcolor',[0 0 1], ...
   'tag','Export Setup', ...
   'callback','exportsetupdlg(gcbf)');
uimenu('parent', menu_h, ...
   'label','Print Preview ...', ...
   'separator','on', ...
   'foregroundcolor',[0 0 1], ...
   'tag','Print Preview', ...
   'callback', ...
     ['global PZG pzg_def_bg_color;' ...
      'pzg_def_bg_color=''w'';' ...
      'if~strcmpi(PZG(1).DefaultBackgroundColor,''w''),' ...
        'pzg_def_bg_color=''k'';' ...
        'figopts(''all_plots'',''w'');' ...
      'end,' ...
      'printpreview(gcbf);' ...
      'global pzg_def_bg_color,' ...
      'if~strcmp(pzg_def_bg_color,''w''),' ...
        'figopts(''all_plots'',''k'');' ...
      'end,' ...
      'clear global pzg_def_bg_color']);
uimenu('parent', menu_h, ...
   'label','Print ...', ...
   'foregroundcolor',[0 0 1], ...
   'tag','Print dialog', ...
   'callback', ...
     ['global PZG pzg_def_bg_color;' ...
      'pzg_def_bg_color=''w'';' ...
      'if~strcmpi(PZG(1).DefaultBackgroundColor,''w''),' ...
        'pzg_def_bg_color=''k'';' ...
        'figopts(''all_plots'',''w'');' ...
      'end,' ...
      'printdlg(gcbf);' ...
      'global pzg_def_bg_color,' ...
      'if~strcmp(pzg_def_bg_color,''w''),' ...
        'figopts(''all_plots'',''k'');' ...
      'end,' ...
      'clear global pzg_def_bg_color']);

    
    
wrkvar_menu_h = ...
  uimenu('parent', mdl_menu_h, ...
         'label','Export model to a workspace variable', ...
         'tag','export model to a workspace variable');
uimenu('parent', wrkvar_menu_h, ...
       'label','as a Zero/Pole/Gain (zpk) variable', ...
       'tag','export model to zero/pole/gain (zpk) object', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''export model to zero/pole/gain (zpk) object'');' ...
          'catch,' ...
            'pzg_err(''"Export model to zpk object" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);
uimenu('parent', wrkvar_menu_h, ...
       'label','as a State-Space (ss) variable, "modal-canonic" form', ...
       'tag','export model to state-space (ss) object', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''export model as a state-space (ss) variable'');' ...
          'catch,' ...
            'pzg_err(''"Export model to ss object" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);
if strcmpi( Domain,'s')
  uimenu('parent', wrkvar_menu_h, ...
         'label','as a State-Space (ss) variable, "zeta/Wn" form', ...
         'tag','export model to state-space (ss) object', ...
         'callback', ...
           ['if pzg_disab,return,end,' ...
            'try,' ...
              'pzg_onoff(0);' ...
              'pzgui(''export model as a state-space (ss) zeta/wn form'');' ...
            'catch,' ...
              'pzg_err(''"Export model to ss object" menu selection'');' ...
            'end,' ...
            'pzg_onoff(1);']);
end
uimenu('parent', wrkvar_menu_h, ...
       'label','as a Partial Fraction Expansion, to a (struct) variable', ...
       'tag','Partial-fraction expansion to workspace', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''partial-fraction expansion to workspace'');' ...
          'catch,' ...
            'pzg_err(''"Partial-fraction expansion" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);
uimenu('parent', wrkvar_menu_h, ...
       'label','as a Transfer-Function (tf) variable <unfactored form>', ...
       'tag','export model to transfer-function (tf) object', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''export model to transfer-function (tf) object'');' ...
          'catch,' ...
            'pzg_err(''"Export model to tf object" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);
uimenu('parent', wrkvar_menu_h, ...
       'label','Export its FRF as a frequency-response (frd) variable', ...
       'foregroundcolor',[0.7 0 0.7], ...
       'separator','on', ...
       'tag','export model FRF to frequency-response (frd) object', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''frequency-response frd to workspace'');' ...
          'catch,' ...
            'pzg_err(''"Frequency-response FRD" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);
uimenu('parent', mdl_menu_h, ...
       'label','Save model to a File', ...
       'foregroundcolor',[0 0 1], ...
       'tag','Save model to file', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'pzg_onoff(0);' ...
          'try,' ...
            'pzgui(''save model to file'');' ...
          'catch,' ...
            'pzg_err(''"Save model to file" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);']);

uimenu('parent', mdl_menu_h, ...
       'label','Import model from a workspace variable', ...
       'separator','on', ...
       'tag','Import model from workspace', ...
       'callback', ...
         ['global PZG,' ...
          'if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'temp_pzg_h=[findobj(allchild(0),''name'',PZG(1).PZGUIname),' ...
                        'findobj(allchild(0),''name'',PZG(2).PZGUIname)];' ...
            'tempLMFWh=findobj(temp_pzg_h,''type'',''uicontrol'');' ...
            'set(tempLMFWh,''enable'',''off'');' ...
            'try,' ...
              'pzgui(''import model from workspace'');' ...
            'catch,' ...
              'pzg_err(''"Import model from workspace" menu selection'');' ...
            'end,' ...
            'drawnow,' ...
            'temp_pzg_h=[findobj(allchild(0),''name'',PZG(1).PZGUIname),' ...
                        'findobj(allchild(0),''name'',PZG(2).PZGUIname)];' ...
          'catch,' ...
            'pzg_err(''"Import model from workspace" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;' ...
          'clear temp_pzg_h tempLMFWh']);
uimenu('parent', mdl_menu_h, ...
       'label','Load model from a File', ...
       'foregroundcolor',[0 0 1], ...
       'tag','Load model from file', ...
       'callback', ...
         ['global PZG,' ...
          'if pzg_disab,return,end,' ...
          'if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'temp_pzg_h=[findobj(allchild(0),''name'',PZG(1).PZGUIname),' ...
                        'findobj(allchild(0),''name'',PZG(2).PZGUIname)];' ...
            'tempLMFWh=findobj(temp_pzg_h,''type'',''uicontrol'');' ...
            'set(tempLMFWh,''enable'',''off'');' ...
            'try,' ...
              'pzgui(''load model from file'');' ...
            'catch,' ...
              'pzg_err(''load model from file'');' ...
            'end,' ...
            'drawnow,' ...
            'temp_pzg_h=[findobj(allchild(0),''name'',PZG(1).PZGUIname),' ...
                        'findobj(allchild(0),''name'',PZG(2).PZGUIname)];' ...
          'catch,pzg_err(''"Load model from file" menu selection'');end,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;' ...
          'clear temp_pzg_h tempLMFWh']);

uimenu('parent', mdl_menu_h, ...
       'label','Generate a random flexible-structure-like model', ...
       'separator','on', ...
       'foregroundcolor',[0 0.5 0], ...
       'tag','Generate random flexible-structure', ...
       'callback', ...
         ['global PZG,' ...
          'if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''Generate random flexible-structure'');' ...
            'drawnow,' ...
          'catch,' ...
            'pzg_err(''"Generate random flex structure" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;']);
uimenu('parent', mdl_menu_h, ...
       'label','Clear the model (delete all zeros/poles, set gain = 1)', ...
       'separator','on', ...
       'foregroundcolor',[0.7 0 0], ...
       'tag','Delete all poles & zeros', ...
       'callback', ...
         ['global PZG,' ...
          'if pzg_disab,return,end,' ...
          'try,' ...
            'pzg_onoff(0);' ...
            'pzgui(''Delete all poles & zeros'');' ...
            'drawnow,' ...
          'catch,' ...
            'pzg_err(''"Delete all poles & zeros" menu selection'');' ...
          'end,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;']);

        
        
if strcmpi('s', Domain )
  uimenu('parent', tool_menu_h, ...
         'label','Pure Gain Design', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','pure-gain design tool', ...
         'callback','if pzg_disab,return,end,gainfilt(''s'');');

  uimenu('parent', tool_menu_h, ...
         'label','Lead and Lag Design', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','lead-lag design tool', ...
         'callback','if pzg_disab,return,end,ldlgfilt(''s'');');

  uimenu('parent', tool_menu_h, ...
         'label','PID Design', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','PID design tool', ...
         'callback','if pzg_disab,return,end,pidfilt(''s'');');
else
  uimenu('parent', tool_menu_h, ...
         'label','Pure Gain Design', ...
         'separator','on', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','pure-gain design tool', ...
         'callback','if pzg_disab,return,end,gainfilt(''z'');');

  uimenu('parent', tool_menu_h, ...
         'label','Lead and Lag Design', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','lead-lag design tool', ...
         'callback','if pzg_disab,return,end,ldlgfilt(''z'');');

  uimenu('parent', tool_menu_h, ...
         'label','PID Design', ...
         'foregroundcolor',[0.8 0 0], ...
         'tag','PID design tool', ...
         'callback','if pzg_disab,return,end,pidfilt(''z'');');
end

if PZG(1).pzg_show_frf_computation
  showdont_label = 'Don''t show FRF computation';
else
  showdont_label = 'Show FRF computation';
end
hndl.show_dontshow_frf_comp = ...
  uimenu('parent', tool_menu_h, ...
    'label', showdont_label, ...
    'separator','on', ...
    'foregroundcolor',[0 0.6 0.6], ...
    'tag','show/dont show FRF computation', ...
    'callback', ...
      ['if pzg_disab,return,end,' ...
       'pzgui(''show/dont show frf computation'');'] );

uimenu('parent', tool_menu_h, ...
   'label','Zoom', ...
   'foregroundcolor',[0 0 0], ...
   'separator','on', ...
   'tag','zoom tool', ...
   'callback', ...
     ['if pzg_disab,return,end,' ...
      'temp_mbh=findobj(allchild(0),''name'',''Zoom is Enabled'');' ...
        'if isempty(temp_mbh),' ...
        'temp_mbh=msgbox(' ...
          '{''All PZGUI plots are zoom-enabled from the start.'';' ...
          ''' '';' ...
          '''To ZOOM IN, click the left mouse button once,'';' ...
          ''' or hold down the left mouse button to drag a "zoom box".'';' ...
          ''' '';' ...
          '''To ZOOM OUT, click the right mouse button once.'';' ...
          ''' '';' ...
          '''Double-click either button to zoom all the way out.'';' ...
          ''' ''},' ...
          '''Zoom is Enabled'');' ...
        'temp_mbtxt=findobj(temp_mbh,''type'',''text'');' ...
        'set(temp_mbtxt,''fontsize'',12);' ...
        'temp_mbsz=get(temp_mbh,''position'');' ...
        'set(temp_mbh,''position'',' ...
           '[temp_mbsz(1:2)*0.8 temp_mbsz(3)*1.4 temp_mbsz(4)*1.2]);' ...
      'else,' ...
        'figure(temp_mbh);' ...
      'end,' ...
      'clear temp_mbh temp_mbsz temp_mbtxt']);

        
uimenu('parent', help_menu_h, ...
       'label','Pzgui User''s Manual (PDF)', ...
       'foregroundcolor',[0 0 1], ...
       'callback', ...
         'if pzg_disab,return,end,open(''PZGui_v8_Manual.pdf'');', ...
       'tag','open pzgui user manual');
uimenu('parent', help_menu_h, ...
       'label','"Help" checkbox in main GUI', ...
       'foregroundcolor',[1 0 0], ...
       'callback', ...
         ['temp_helph=pzg_fndo(1,(12:13),''pzg_help_checkbox'');' ...
          'set(temp_helph,' ...
            '''value'',1,' ...
            '''foregroundcolor'',''r'',' ...
            '''fontweight'',''bold'');' ...
          'helpserv(get(gcbf,''Name''));' ...
          'clear temp_helph'], ...
       'tag','help checkbox in main GUI');

     
if strcmpi('s', Domain )
  ui_h = uimenu('parent', mdl_menu_h, ...
       'label','Purge C-T FRD model', ...
       'separator','on', ...
       'tag','Purge C-T FRD model', ...
       'callback', ...
         ['if pzg_disab,return,end,' ...
          'global PZG,' ...
          'if isempty(PZG(1).TFEFreqs),' ...
            'temp_mbh=' ...
              'msgbox({''No C-T FRD Model has been loaded.       .'';' ...
                      ''' '';''   Click "OK" to continue.''},' ...
                      '''pzgui Advisory'',''modal'');' ...
            'uiwait(temp_mbh),' ...
            'clear temp_mbh,' ...
            'return,' ...
          'end,' ...
          'pzg_onoff(0);' ...
          'try,' ...
            'PZG(1).TFEFreqs=[];' ...
            'PZG(1).TFEMag=[];' ...
            'PZG(1).TFEPhs=[];' ...
            'temp_ui_h=findobj(allchild(0),''tag'',''Purge C-T FRD model'');' ...
            'if ~isempty(temp_ui_h),' ...
              'set(temp_ui_h,''visible'',''off'');' ...
            'end,' ...
            'clear temp_ui_h,' ...
            'pzgui;updatepl;' ...
          'catch,' ...
            'pzg_err(''Purge C-T FRD menu item.'');' ...
          'end,' ...
          'drawnow,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;' ...
          'clear temp_ui_h,' ...
          ]);
else
  % Discrete-time
  ui_h = uimenu('parent', mdl_menu_h, ...
       'label','Purge D-T FRD model', ...
       'separator','on', ...
       'tag','Purge D-T FRD model', ...
       'callback', ...
         ['global PZG,' ...
          'if pzg_disab,return,end,' ...
          'if isempty(PZG(2).TFEFreqs),' ...
            'temp_mbh=' ...
              'msgbox({''No D-T FRD Model has been loaded.       .'';' ...
                      ''' '';''   Click "OK" to continue.''},' ...
                      '''dpzgui Advisory'',''modal'');' ...
            'uiwait(temp_mbh),' ...
            'clear temp_mbh,' ...
            'return,' ...
          'end,' ...
          'pzg_onoff(0);' ...
          'try,' ...
            'PZG(2).TFEFreqs=[];' ...
            'PZG(2).TFEMag=[];' ...
            'PZG(2).TFEPhs=[];' ...
            'temp_ui_h=findobj(allchild(0),''tag'',''Purge D-T FRD model'');' ...
            'if ~isempty(temp_ui_h),' ...
              'set(temp_ui_h,''visible'',''off'');' ...
            'end,' ...
            'clear temp_ui_h,' ...
            'dpzgui;dupdatep,' ...
          'catch,' ...
            'pzg_err(''Purge D-T FRD menu item.'');' ...
          'end,' ...
          'drawnow,' ...
          'pzg_onoff(1);' ...
          'pzg_unre;' ...
          'clear temp_ui_h temp_mbh']);
end
hndl.purgefrd_menu = ui_h;

if ( strcmpi('s',Domain) && isempty( PZG(1).TFEMag ) ) ...
  ||( strcmpi('z',Domain) && isempty( PZG(2).TFEMag ) )
  set( ui_h,'visible','off');
end

setappdata( fig_h,'hndl', hndl )

return