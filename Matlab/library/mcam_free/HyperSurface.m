function V = HyperSurface(DU,epsilon)

% V = HyperSurface(DU,epsilon)
% calculate fprime = phi'(s)/s fce for $phi$ = hypersurface minimal function
%
V = 1./sqrt(DU+epsilon);
