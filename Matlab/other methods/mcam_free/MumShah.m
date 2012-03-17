function V = MumShah(DU,beta)

% V = MumShah(DU,b)
% calculate fprime fce for Mumford-Shah minimization problem
%

  V = 1./(1+(pi/2/beta.*DU).^2);