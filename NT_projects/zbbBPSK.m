% Get complex Baseband in time domain
%
% t: time- vector
% Ts: Symbol- Time in[s] --> 1/Ts = Baudrate
% dk: mapped symbol vector 
% Ampl: Baseband Amplitude
%
function [res] = zbbBPSK(t,Ts,dk,Ampl,shape,rolloff)
rect=@(t) (0.5*sign(t)+0.5);

% Baseband- Pulse: For M-PSK g(t)=cos(2*pi/(2*Ts))*(sigma(t+Ts)-sigma(t-Ts))
    if shape=='rect'
        g=@(t) (rect(t)-rect(t-1));
    elseif shape=='rcos'
        g=@(t) RaisedCosShaper(t,Ts,rolloff,'time');
    else
        errordlg('Unknown shape format')
        g=@(t) -1;
    end
% Summing complex I-Q pointer
 res=0;

    for k=0:size(dk,2)-1
        res=res + dk(k+1)*g(t-k*Ts);
    end;
    res=Ampl*res;
    
%     if real(res)==0
%         warndlg('No Real signal part')
%     elseif imag(res)==0
%         warndlg('No Imaginary signal part')
%     end
end