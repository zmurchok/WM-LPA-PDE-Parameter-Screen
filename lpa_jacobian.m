function J = lpa_jacobian(y,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
  u1g = y(1);
  u2g = y(2);
  u1l = y(3);
  u2l = y(4);

  J = reshape([-c1+((a1.*n.*u1g.^(n-1.0))./(u1g.^n+1.0)-a1.*n.*u1g.^n.*u1g.^(n-1.0).*1.0./(u1g.^n+1.0).^2).*(T1-u1g)-(a1.*u1g.^n)./(u1g.^n+1.0)-(b1.*switch1.^n)./(switch1.^n+u2g.^n)-1.0,-b2.*n.*switch2.^n.*u1g.^(n-1.0).*(T2-u2g).*1.0./(switch2.^n+u1g.^n).^2,-c1-(a1.*u1l.^n)./(u1l.^n+1.0)-(b1.*switch1.^n)./(switch1.^n+u2l.^n),0.0,-b1.*n.*switch1.^n.*u2g.^(n-1.0).*(T1-u1g).*1.0./(switch1.^n+u2g.^n).^2,-c2-k+((a2.*n.*u2g.^(n-1.0))./(u2g.^n+1.0)-a2.*n.*u2g.^n.*u2g.^(n-1.0).*1.0./(u2g.^n+1.0).^2).*(T2-u2g)-(a2.*u2g.^n)./(u2g.^n+1.0)-(b2.*switch2.^n)./(switch2.^n+u1g.^n),0.0,-c2-(a2.*u2l.^n)./(u2l.^n+1.0)-(b2.*switch2.^n)./(switch2.^n+u1l.^n),0.0,0.0,((a1.*n.*u1l.^(n-1.0))./(u1l.^n+1.0)-a1.*n.*u1l.^n.*u1l.^(n-1.0).*1.0./(u1l.^n+1.0).^2).*(T1-u1g)-1.0,-b2.*n.*switch2.^n.*u1l.^(n-1.0).*(T2-u2g).*1.0./(switch2.^n+u1l.^n).^2,0.0,0.0,-b1.*n.*switch1.^n.*u2l.^(n-1.0).*(T1-u1g).*1.0./(switch1.^n+u2l.^n).^2,-k+((a2.*n.*u2l.^(n-1.0))./(u2l.^n+1.0)-a2.*n.*u2l.^n.*u2l.^(n-1.0).*1.0./(u2l.^n+1.0).^2).*(T2-u2g)],[4,4]);
end

%
% %
% % to create this jacobian do the following
% %
% syms u1l u1g u2l u2g a1 b1 c1 a2 b2 c2 T1 T2 k n switch1 switch2
% %
% vars = [u1g,u2g,u1l,u2l]
% %
% funcs = [ (a1*u1g^n/(1+u1g^n)+b1*switch1^n/(switch1^n+u2g^n)+c1)*(T1-u1g)-u1g; (a2*u2g^n/(1+u2g^n)+b2*switch2^n/(switch2^n+u1g^n)+c2)*(T2-u2g)-k*u2g; (a1*u1l^n/(1+u1l^n)+b1*switch1^n/(switch1^n+u2l^n)+c1)*(T1-u1g)-u1l; (a2*u2l^n/(1+u2l^n)+b2*switch2^n/(switch2^n+u1l^n)+c2)*(T2-u2g)-k*u2l;]
% J = jacobian(funcs,vars)
% f = matlabFunction(J)
% funcs = [ (a1*u1g^n/(1+u1g^n)+b1*switch1^n/(switch1^n+u2g^n)+c1)*v1g-u1g; (a2*u2g^n/(1+u2g^n)+b2*switch2^n/(switch2^n+u1g^n)+c2)*v2g-k*u2g;
% -(a1*u1g^n/(1+u1g^n)+b1*switch1^n/(switch1^n+u2g^n)+c1)*v1g+u1g; -(a2*u2g^n/(1+u2g^n)+b2*switch2^n/(switch2^n+u1g^n)+c2)*v2g+k*u2g; (a1*u1l^n/(1+u1l^n)+b1*switch1^n/(switch1^n+u2l^n)+c1)*v1g-u1l; (a2*u2l^n/(1+u2l^n)+b2*switch2^n/(switch2^n+u1l^n)+c2)*v2g-k*u2l;]
