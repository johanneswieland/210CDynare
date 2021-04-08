clear all;
close all;
	
%-------------------------------------------------------
% 1. Baseline Calibration
%-------------------------------------------------------

alpha 	= 1/3;
beta 	= 0.984;
gamma	= 1;
chi		= 3.48;
phi 	= 1/4;
delta	= 0.025;
rho_a	= 0.979;
sigma_a	= 0.0072;

save paramfile alpha beta gamma chi phi delta rho_a sigma_a;

% sets we loop over
rho_a_set = [0.5,0.8,0.9,0.95,0.979];
phi_set = [0.125,0.25,0.5,1,2,4];

%-------------------------------------------------------
% 2. Looping over Dynare code: persistence of tech shock
%-------------------------------------------------------



for rho_a = rho_a_set

	save paramfile alpha beta gamma chi phi delta rho_a sigma_a;

	dynare RBCloop noclearall nolog nograph;

	% save your output here, e.g. impulse response functions
    figure(1)
    plot(0:1:length(y_e_a)-1,y_e_a*100,'Linewidth',3)
    hold on
    
end



%-------------------------------------------------------
% 3. Looping over Dynare code: persistence of tech shock
%-------------------------------------------------------


relstd = [];

for phi = phi_set

	save paramfile alpha beta gamma chi phi delta rho_a sigma_a;

	dynare RBCloop noclearall nolog nograph;

	% save your output here, e.g. impulse response functions
    figure(2)
    plot(0:1:length(y_e_a)-1,y_e_a*100,'Linewidth',3)
    hold on
    
    % find y-location and n-location
    loc.y = find(strcmp(M_.endo_names,'y'));
    loc.n = find(strcmp(M_.endo_names,'n'));
    
    % relative standard deviation
    relvar = oo_.var(loc.n,loc.n)/oo_.var(loc.y,loc.y);
    relstd = [relstd,sqrt(relvar)];
    
    
end

%-------------------------------------------------------
% 4. Finish figures
%-------------------------------------------------------

figure(1)
hold off
legend(strcat('\rho_a=',num2str(rho_a_set')))
ylabel('Output, % deviation')
xlabel('Quarter')

figure(2)
hold off
legend(strcat('\phi=',num2str(phi_set')))
ylabel('Output, % deviation')
xlabel('Quarter')

figure(3)
plot(phi_set,relstd,'Linewidth',3)
ylabel('Relative Standard Deviation')
xlabel('\phi')