%-------------------------------------------------------------------------------
% Function: linear_fit
%-------------------------------------------------------------------------------
function [U, beta, rSquare] = support_linear_fit(X, Y, P)

% least-square estimate
if isempty(P)
  M = [ones(length(X), 1), X];
  P = (M' * M) \ M';
end
p = P * Y;
U = p(2) * X + p(1);
beta = p(2);
rSquare = 1 - sum((Y - U) .^ 2) / sum((Y - mean(Y)) .^ 2);

end % end

%-------------------------------------------------------------------------------