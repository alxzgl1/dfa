%-------------------------------------------------------------------------------
% Function: support_get_dfa
%-------------------------------------------------------------------------------
function [beta, rSquare, pXLog, pYLog, pULog] = support_get_dfa(data, fs, pWLen, pWNum)

% data as column vector
data = data(:);

% random walk
data = data - mean(data);
data = cumsum(data);

% iterate window length and number
L = length(pWLen);
pY = zeros(L, 1);
pX = zeros(L, 1);
for nIndex = 1:L
  X = (0:(pWLen(nIndex) - 1))';
  % pre-compute LSE
  M = [ones(length(X), 1), X];
  P = (M' * M) \ M'; 
  % evaluate
  nWindows = pWNum(nIndex);
  pRMS = zeros(nWindows, 1);
  for nCount = 1:nWindows  
    nWindowIndex = pWLen(nIndex) * (nCount - 1) + 1;
    Y = data(nWindowIndex:(nWindowIndex + pWLen(nIndex) - 1));
    U = support_linear_fit(X, Y, P);
    pRMS(nCount) = sqrt(mean((Y - U) .^ 2));
  end 
  % weight by number of windows
  pY(nIndex) = mean(pRMS);
  pX(nIndex) = (1 / fs) * pWLen(nIndex);
end

% check
pX(pY == 0) = [];
pY(pY == 0) = [];
% norm
pY = pY / sum(pY);
% log
pXLog = log10(pX);
pYLog = log10(pY);

% linar fitting
P = [];
[pULog, beta, rSquare] = support_linear_fit(pXLog, pYLog, P);

end % end

%-------------------------------------------------------------------------------