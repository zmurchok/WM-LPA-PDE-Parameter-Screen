function dydt = global_odes(t,y,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2)
  u1g = y(1);
  u2g = y(2);

  dydt = [(a1*u1g^n/(1+u1g^n)+b1*switch1^n/(switch1^n+u2g^n)+c1)*(T1-u1g)-u1g;(a2*u2g^n/(1+u2g^n)+b2*switch2^n/(switch2^n+u1g^n)+c2)*(T2-u2g)-k*u2g;];
end
