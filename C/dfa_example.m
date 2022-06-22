%-------------------------------------------------------------------------------
% Function
%-------------------------------------------------------------------------------
function dfa_example()

clc;

% generate data
N = 1000000;
fs = 200;
data = randn(1, N);
% load('data\\data.mat');

fl = 8.0;  % narrowband filter (low frequency)
fh = 12.0; % narrowband filter (high frequency)

% parameters
nChannels = size(data, 1);
N = size(data, 2);

% DFA parameters
DFA_t_min = 5; % seconds, min fitting
DFA_t_max = (N / fs) / 5; % seconds, max fitting

% filtering
[b, a] = butter(4, [fl, fh] / fs, 'bandpass');
data = filtfilt(b, a, data')';
X = abs(hilbert(data(1, :)));

% get dfa
[pWLen, pWNum, dX, dP1, dP2] = support_init_dfa_c(DFA_t_min, DFA_t_max, fs, N);
[beta, rSquare, pXLog, pYLog, pULog] = support_get_dfa_c(X, fs, pWLen, pWNum, dX, dP1, dP2);

% plot
subplot(1, 2, 1); plot(X); title('time serie', 'FontWeight', 'normal', 'FontSize', 10);
subplot(1, 2, 2); plot(pXLog, pYLog, 'o'); hold on; plot(pXLog, pULog, 'LineWidth', 2);
xlabel('fitting range (log seconds)');
title(sprintf('DFA exponent = %1.4f', beta), 'FontWeight', 'normal', 'FontSize', 10);

end % end

%-------------------------------------------------------------------------------
