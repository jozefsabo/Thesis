function V = RudOsh(DU,epsilon)

% V = RudOsh(DU,epsilon)
% calculate fprime fce for Rudin-Osher minimization problem
%
V = max(min(sqrt(DU),1/epsilon),epsilon);
V = 1./V;
