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

alpha 	= 1/3;
beta 	= 0.984;
gamma	= 1;
chi		= 3.48;
phi 	= 1/4;
delta	= 0.025;
rho_a	= 0.979;
sigma_a	= 0.0072;


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
% 4. Steady State
%-------------------------------------------------------

initval;

    y	= log(0.907658170398745);
    n	= log(0.319336393586796);
    c	= log(0.724338047313284);
    k	= log(7.332804923418412);
    i   = log(0.183320123085460);
    a	= log(1);

end;

resid;


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


