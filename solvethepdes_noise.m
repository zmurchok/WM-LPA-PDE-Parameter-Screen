function [rac,rho] = solvethepdes(Du,i,X,ids,equilibria,m)
  a1=X(ids(i),1);
  a2=a1;
  b1=X(ids(i),2);
  b2=b1;
  c1=X(ids(i),3);
  c2=c1;
  s1=0.5;
  s2=s1;
  n=3;
  k=1;
  T1=X(ids(i),4);
  T2=X(ids(i),5);

  u1init = equilibria{ids(i)}(m,1);
  u2init = equilibria{ids(i)}(m,2);
  v1init = T1 - u1init;
  v2init = T2 - u2init;

  Du1 = Du;
  Dv1 = 10;
  Du2 = Du1;
  Dv2 = Dv1;

  symmetryparam = 0;

  xnum = 200;
  tfinal = 400;
  tnum = tfinal;
  x = linspace(0,1,xnum+1);
  t = linspace(0,tfinal,tnum+1);

  sol_pdepe = pdepe(symmetryparam,@pdefunction,@icnoise,@bcfunction,x,t);
  u1 = sol_pdepe(:,:,1);
  v1 = sol_pdepe(:,:,2);
  u2 = sol_pdepe(:,:,3);
  v2 = sol_pdepe(:,:,4);

  rac = u1(end,:);
  rho = u2(end,:);
  % figure
  % % plot(x,rac,x,rho)
  % mesh(x,t,u1)

  function y = u1fun(u1,v1,u2,v2)
    y = (a1*u1.^n./(1+u1.^n)+b1*s1^n./(s1^n+u2.^n)+c1).*v1-u1;
  end
  function y = v1fun(u1,v1,u2,v2)
    y = -u1fun(u1,v1,u2,v2);
  end
  function y = u2fun(u1,v1,u2,v2)
    y = (a2*u2.^n./(1+u2.^n)+b2*s2^n./(s2^n+u1.^n)+c2).*v2-k*u2;
  end
  function y = v2fun(u1,v1,u2,v2)
    y = -u2fun(u1,v1,u2,v2);
  end

  %set up the PDES
  function [cpde,fpde,spde] = pdefunction(x,t,u,DuDx)
    cpde = [1;1;1;1]; %coeff of time derivatives
    fpde = [Du1*DuDx(1);Dv1*DuDx(2);Du2*DuDx(3);Dv2*DuDx(4)]; %flux terms
    spde = [u1fun(u(1),u(2),u(3),u(4));v1fun(u(1),u(2),u(3),u(4));u2fun(u(1),u(2),u(3),u(4));v2fun(u(1),u(2),u(3),u(4))]; %reaction terms
  end

  function u0 = icnoise(x)
    % pwidth=0.1;
    % u0 = [u1init+pu1height*(x<pwidth);v1init-(pu1height*pwidth);u2init+pu2height*(x<pwidth);v2init-(pu2height*pwidth)];
    % u0 = [T1*(x<0.5);T1/2;T2*(x>0.5);T2/2];
    amp = 0.1;
    noise1 = amp*(2*rand(1)-1);
    noise2 = amp*(2*rand(1)-1);
    u0 = [u1init+noise1;v1init-noise1;u2init+noise2;v2init-noise2];
  end

  function [pl,ql,pr,qr] = bcfunction(xl,ul,xr,ur,t)
    % This gives Neumann boundary conditions
    pl = [0;0;0;0];
    ql = [1;1;1;1];
    pr = [0;0;0;0];
    qr = [1;1;1;1];
  end
end
