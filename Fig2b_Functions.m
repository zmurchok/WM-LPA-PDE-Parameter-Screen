function out = Fig2b_Functions
out{1} = @init;
out{2} = @fun_eval;
out{3} = [];
out{4} = [];
out{5} = [];
out{6} = [];
out{7} = [];
out{8} = [];
out{9} = [];

% --------------------------------------------------------------------------
function dydt = fun_eval(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
dydt=[(a1*kmrgd(1)^n/(1+kmrgd(1)^n)+b1*switch1^n/(switch1^n+kmrgd(2)^n)+c1)*(T1-kmrgd(1))-kmrgd(1); (a1*kmrgd(2)^n/(1+kmrgd(2)^n)+b1*switch2^n/(switch1^n+kmrgd(1)^n)+c1)*(T2-kmrgd(2))-k*kmrgd(2);];

% --------------------------------------------------------------------------
function [tspan,y0,options] = init
handles = feval(PosFeedMutInhib);
y0=[0];
options = odeset('Jacobian',[],'JacobianP',[],'Hessians',[],'HessiansP',[]);
tspan = [0 10];

% --------------------------------------------------------------------------
function jac = jacobian(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
% --------------------------------------------------------------------------
function jacp = jacobianp(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
% --------------------------------------------------------------------------
function hess = hessians(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
% --------------------------------------------------------------------------
function hessp = hessiansp(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
%---------------------------------------------------------------------------
function tens3  = der3(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
%---------------------------------------------------------------------------
function tens4  = der4(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
%---------------------------------------------------------------------------
function tens5  = der5(t,kmrgd,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
