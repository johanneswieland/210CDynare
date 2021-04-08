function [ys,params,check] = RBCloop_steadystate(ys,exo,M_,options_)
	
% read out parameters to access them with their name
% same order as parameter declaration	
alpha = M_.params(1);
beta = M_.params(2);
gamma = M_.params(3);
chi = M_.params(4);
phi = M_.params(5);
delta = M_.params(6);
rho_a = M_.params(7);
sigma_a = M_.params(8);

% initialize indicator
check = 0;

%% Enter model equations here

% ky ratio
ky	= alpha*beta / (1 - beta*(1-delta));

% cy ratio
cy  = 1 - delta*ky;

% yn ratio
yn  = ky^(alpha/(1-alpha));

% output
y   = ( (1-alpha)/chi * yn^(1+phi) / cy^gamma )^(1/(gamma+phi));

% remaining variables
c	= cy * y;
k	= ky * y;
n	= 1/yn * y;
i   = delta * k;
a   = 1;

% dynare is looking for variables in logs
y   = log(y);
c   = log(c);
k   = log(k);
n   = log(n);
i   = log(i);
a   = log(a);

%% end own model equations
NumberOfParameters = M_.param_nbr;
params=NaN(NumberOfParameters,1);
for iter = 1:length(M_.params) %update parameters set in the file
  eval([ 'params(' num2str(iter) ') = ' M_.param_names{iter} ';' ])
end

NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval(['ys(' int2str(ii) ') = ' varname ';']);
end


end
