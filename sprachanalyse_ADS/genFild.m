function y = genFild(x)
%GENFILD Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the Signal Processing Toolbox 6.19.
% Generated on: 12-Nov-2014 14:08:48

%#codegen

% To generate C/C++ code from this function use the codegen command. Type
% 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    % % FIR least-squares Lowpass filter designed using the FIRLS function.
    %
    % % All frequency values are in Hz.
    % Fs = 16000;  % Sampling Frequency
    %
    % N     = 4;     % Order
    % Fpass = 3000;  % Passband Frequency
    % Fstop = 5000;  % Stopband Frequency
    % Wpass = 10;    % Passband Weight
    % Wstop = 5;     % Stopband Weight
    %
    % % Calculate the coefficients using the FIRLS function.
    % b  = firls(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop]);
    
    Hd = dsp.FIRFilter( ...
        'Numerator', [-0.0339525975145589 0.30157276768957 0.52938046739981 ...
        0.30157276768957 -0.0339525975145589]);
end

y = step(Hd,x);


% [EOF]
