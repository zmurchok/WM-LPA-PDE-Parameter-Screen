function [len,steadystates] = FindSteadyStates(a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
  %A function to return the number (len) and equilibria (steadystates) for each parameter set, i.e., Well-mixed analysis

  % Build a Latin Hypercube Sample for Initial Conditions Array
  num = 50;
  X0 = lhsdesign(num,2);
  X0 = [T1*X0(:,1), T2*X0(:,2)];

  %loop over all initial conditions and integrate
  opts = odeset('RelTol',1e-12,'AbsTol',1e-12);
  tspan = [0 100];
  sol = zeros(size(X0)); %preallocate storage vector for speed

  for i=1:num
    %integrate
    [t,y] = ode45(@(t,y) global_odes(t,y,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2),tspan,[X0(i,1), X0(i,2)],opts);
    %bootstrap: repeat integration 3 times using the steady-state as the initial condition (hopefully to improve accuracy of steady-state calcualtion)
    for j=1:3
      [t,y] = ode45(@(t,y) global_odes(t,y,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2),tspan,[y(end,1), y(end,2)],opts);
    end
    sol(i,:) = [y(end,1), y(end,2)];
  end

  %find unique solutions within a tolerance:
  tol = 1e-6;
  [C,ic,ia] = uniquetol(sol(:,1),tol);
  % get corresponding steady states:
  steadystates = [C, sol(ic,2)];

  %for each parameter set, return number of steady states:
  len = size(steadystates,1);
end
