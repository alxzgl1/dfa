%-------------------------------------------------------------------------------
% Function
% This script does the following steps:
%  1. Generates random data (example) | Please init X (and fs) using your own data (if necessary)  
%  2. Performs DFA
%  3. Estimates the scaling exponent of LRTC (parameter beta)
% 
% Fitting range is very important, please make sure that the DFA plot is linear within 
% the fitting range.
%-------------------------------------------------------------------------------
function dfa_example_MATLAB()

clc;

% generate data
N = 1000000; % number of samples
fs = 200; % sampling rate (Hz)
X = randn(1, N); % random data, beta should be around 0.5

% DFA fitting range
DFA_t_min = 5; % seconds, min fitting
DFA_t_max = (N / fs) / 5; % seconds, max fitting

% get dfa
[pWLen, pWNum] = support_init_dfa(DFA_t_min, DFA_t_max, fs, N);
[beta, rSquare, pXLog, pYLog, pULog] = support_get_dfa(X, fs, pWLen, pWNum);

% plot
subplot(1, 2, 1); plot(X); title('time serie', 'FontWeight', 'normal', 'FontSize', 10);
subplot(1, 2, 2); plot(pXLog, pYLog, 'o'); hold on; plot(pXLog, pULog, 'LineWidth', 2);
xlabel('fitting range (log seconds)');
title(sprintf('DFA exponent = %1.4f', beta), 'FontWeight', 'normal', 'FontSize', 10);

end % end

%-------------------------------------------------------------------------------
