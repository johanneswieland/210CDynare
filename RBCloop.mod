% Mod File that computes RBC model

%-------------------------------------------------------
% 1. Defining variables
%-------------------------------------------------------

var y, n, c, k, i, a; 
 
varexo e_a;

parameters alpha, beta, gamma, phi, chi, delta, rho_a, sigma_a;


%-------------------------------------------------------
% 2. Calibration
%-------------------------------------------------------

load paramfile;

set_param_value('alpha',alpha);
set_param_value('beta',beta);
set_param_value('gamma',gamma);
set_param_value('delta',delta);
set_param_value('chi',chi);
set_param_value('phi',phi);
set_param_value('rho_a',rho_a);
set_param_value('sigma_a',sigma_a);


%-------------------------------------------------------
% 3. Model
%-------------------------------------------------------
model;
    
    % (1) FOC for labor supply and labor demand
    (1-alpha) * exp(y) / exp(n) = chi * exp(n)^phi * exp(c)^gamma;
    
    % (2) Euler equation
    exp(c)^(-gamma) = beta * exp(c(+1))^(-gamma) *(  alpha * exp(y(+1)) / exp(k) + (1-delta)  );
    
    % (3) Resource constraint
    exp(y) = exp(c) + exp(i);

    % (4) capital accumulation
    exp(k) = exp(i) + (1-delta)*exp(k(-1));
    
    % (5) Production function
    exp(y) = exp(a) * exp(k(-1))^alpha * exp(n)^(1-alpha);
    
    % (6) TFP process
    a = rho_a * a(-1) + e_a;

end;



%-------------------------------------------------------
% 5. Shocks
%-------------------------------------------------------

shocks;

    var e_a	= sigma_a^2;

end;

%-------------------------------------------------------
% 6. Computation
%-------------------------------------------------------

steady;

check;

stoch_simul(order=1, irf=40, hp_filter=1600);



