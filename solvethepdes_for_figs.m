function [rac,rho,raci,rhoi] = solvethepdes(Du,i,X,ids,u1init,u2init,pu1height,pu2height)
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

  %middle branch as equilibria
  % u1init = equilibria{ids(i)}(2,1);
  % u2init = equilibria{ids(i)}(2,2);
  v1init = T1 - u1init;
  v2init = T2 - u2init;

  %need to get a perturbation that works (for the stable ids)
  % if stablecase == 1
  %   [Lia,Locb] = ismember(-1,perturbation{ids(i)}(2:end-1,2:end-1));
  %
  % else
    %linearly unstable regime, and so some small perturbation should work for polarity (in the limit of Du/Dv1 << 1)
  % pu1height = 0.5;
  % pu2height = 0.5;
  % end

  Du1 = Du;
  Dv1 = 10;
  Du2 = Du1;
  Dv2 = Dv1;

  m = 0;

  xnum = 200;
  tfinal = 800;
  tnum = tfinal;
  x = linspace(0,1,xnum+1);
  t = linspace(0,tfinal,tnum+1);

  sol_pdepe = pdepe(m,@pdefunction,@icperturb,@bcfunction,x,t);
  u1 = sol_pdepe(:,:,1);
  v1 = sol_pdepe(:,:,2);
  u2 = sol_pdepe(:,:,3);
  v2 = sol_pdepe(:,:,4);

  rac = u1(end,:);
  rho = u2(end,:);
  raci= v1(end,:);
  rhoi = v2(end,:);
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

  function u0 = icperturb(x)
    pwidth=0.1;
    u0 = [u1init+pu1height*(x<pwidth);v2init-(pu1height*pwidth);u2init+pu2height*(x<pwidth);v2init-(pu2height*pwidth)];
  end

  function [pl,ql,pr,qr] = bcfunction(xl,ul,xr,ur,t)
    % This gives Neumann boundary conditions
    pl = [0;0;0;0];
    ql = [1;1;1;1];
    pr = [0;0;0;0];
    qr = [1;1;1;1];
  end
end
