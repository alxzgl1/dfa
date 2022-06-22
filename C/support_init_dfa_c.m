%-------------------------------------------------------------------------------
% Function: init_dfa_c
%-------------------------------------------------------------------------------
function [pWLen, pWNum, dX, dP1, dP2] = support_init_dfa_c(tmin, tmax, fs, N)

% parameters
nMinWLen = tmin * fs; % in samples
nMaxWLen = tmax * fs; % in samples

%% old settings
% if bOLD == 1
%   nMinWLen = 10;      % in samples
%   nMaxWLen = 0.3 * N; % in samples
% end

% make windows
nWLen = nMinWLen;
nFraction = 1.1;
pWLen = zeros(N, 1);
pWNum = zeros(N, 1);
nCount = 1;
while 1
	pWLen(nCount) = round(nWLen);
  nWLen = nWLen * nFraction;
  p = N / nWLen; 
  p = floor(p);
  pWNum(nCount) = p;
  if p < 1
    break 
  end
  nCount = nCount + 1;
end

% delete zeros
pWLen = pWLen(:);
pWNum = pWNum(:);
pWLen(pWNum == 0) = [];
pWNum(pWNum == 0) = [];

% delete windows more than MAX
pWNum(pWLen > nMaxWLen) = [];
pWLen(pWLen > nMaxWLen) = [];

% precomputing
nWLenMax = pWLen(end);
L = length(pWLen);
dX = zeros(nWLenMax, L);
dP1 = zeros(nWLenMax, L);
dP2 = zeros(nWLenMax, L);
for nIndex = 1:L
  % get
  X = (0:(pWLen(nIndex) - 1))';
  M = [ones(length(X), 1), X];
  P = (M' * M) \ M'; 
  % set
  dX(1:pWLen(nIndex), nIndex) = X;
  dP1(1:pWLen(nIndex), nIndex) = P(1, :)';
  dP2(1:pWLen(nIndex), nIndex) = P(2, :)';
end

end % end

%-------------------------------------------------------------------------------