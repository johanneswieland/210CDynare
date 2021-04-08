% Mod File that computes RBC model
% Comment as much as you want

%------------------------------------
% 1. Defining Variables
%------------------------------------

% endogneous variables (no shocks)
var y, n, k, c, a;  

% shocks
varexo e_a;

% parameters
parameters alpha, beta, gamma, delta, chi, phi, rho_a, sigma_a; 


%------------------------------------
% 2. Calibration
%------------------------------------

alpha   = 1/3;
beta    = 0.984;
gamma   = 1;
chi     = 3.48;
phi     = 1/4;
delta   = 0.025;
rho_a   = 0.979;
sigma_a = 0.0072;


%------------------------------------
% 3. Model
%------------------------------------

model;
    
    % Intratemporal FOC for labor

    (1-alpha) * exp(y) / exp(n) = chi * exp(n)^phi * exp(c)^gamma ;

    
    % Euler equation

    1 = beta * exp( c(+1) )^(-gamma) / exp(c)^(-gamma) *
            (    alpha * exp( y(+1) ) / exp(k) + (1-delta)  );


    % Resoruce constraint

    exp(y) = exp(c) + exp(k) - (1-delta)*exp( k(-1) );


    % Production function
    
    exp(y) = exp(a) * exp( k(-1) )^alpha * exp(n)^(1-alpha);

    
    % Productivity process
    
    exp(a) = exp( a(-1) )^(rho_a) * exp(e_a);

end;


%------------------------------------
% 4. Steady State
%------------------------------------

initval;

    %y = log(0.907658170398745); 
    %n = log(0.319336393586796); 
    %c = log(0.724338047313284); 
    %k = log(7.332804923418412); 
    %a = log(1);

    y = log(0.9); 
    n = log(0.3); 
    c = log(0.7); 
    k = log(7.3); 
    a = log(1);

end;

resid;

%------------------------------------
% 5. Shocks
%------------------------------------

shocks;

    var e_a = sigma_a^2;

end;


%------------------------------------
% 5. Computation
%------------------------------------

steady;

check;

stoch_simul(order=1, irf=40, hp_filter=1600);

