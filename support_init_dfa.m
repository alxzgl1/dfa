%-------------------------------------------------------------------------------
% Function: init_dfa
%-------------------------------------------------------------------------------
function [pWLen, pWNum] = support_init_dfa(tmin, tmax, fs, N)

% parameters
nMinWLen = tmin * fs; % in samples
nMaxWLen = tmax * fs; % in samples

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

end % end

%-------------------------------------------------------------------------------