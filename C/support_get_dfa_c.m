%-------------------------------------------------------------------------------
% Function: dfa_c
%-------------------------------------------------------------------------------
function [beta, rSquare, pXLog, pYLog, pULog] = support_get_dfa_c(data, fs, pWLen, pWNum, X, P1, P2)

% data as column vector
data = data(:);

% random walk
data = data - mean(data);
data = cumsum(data);

pX = pWLen;

%% call
nWMax = int32(pWLen(end));
nWN = int32(length(pWLen));
pWNum = int32(pWNum);
pWLen = int32(pWLen);

Y = zeros(nWMax, 1);
U = zeros(nWMax, 1);

pY = evaluate_dfa(data, X, P1, P2, Y, U, pWNum, pWLen, nWMax, nWN);

% transform
pY = pY(:);
pX = pX(:) * (1 / fs);

% log
pX(pY == 0) = [];
pY(pY == 0) = [];
pXLog = log10(pX);
pYLog = log10(pY);

% linear fitting
[pULog, beta, rSquare] = support_linear_fit_c(pXLog, pYLog);

end % end

%-------------------------------------------------------------------------------
