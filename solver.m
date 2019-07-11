function [rac,rho,raci,rhoi] = solver(X,u1init,u2init,v1init,v2init,pu1height,pu2height)
   a1 = X(1);
   a2 = a1;
   b1 = X(2);
   b2 = b1;
   c1 = X(3);
   c2 = c1;
   RT = X(4);
   pT = X(5);
   s1 = 0.5;
   s2 = s1;
   n = 3;
   D = 0.01;
   Di = 10;
   k = 1;

   m = 0;
   xnum = 400;
   tfinal = 1000;
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
   raci = v1(end,:);
   rhoi = v2(end,:);

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

    function [cpde,fpde,spde] = pdefunction(x,t,u,DuDx)
    cpde = [1;1;1;1]; %coeff of time derivatives
    fpde = [D*DuDx(1);Di*DuDx(2);D*DuDx(3);Di*DuDx(4)]; %flux terms
    spde = [u1fun(u(1),u(2),u(3),u(4));v1fun(u(1),u(2),u(3),u(4));u2fun(u(1),u(2),u(3),u(4));v2fun(u(1),u(2),u(3),u(4))]; %reaction terms
    end

  function u0 = icperturb(x)
    pwidth=0.1;
    u0 = [u1init+pu1height*(x<pwidth);v1init-(pu1height*pwidth);u2init+pu2height*(x<pwidth);v2init-(pu2height*pwidth)];
  end

  function [pl,ql,pr,qr] = bcfunction(xl,ul,xr,ur,t)
    % This gives Neumann boundary conditions
    pl = [0;0;0;0];
    ql = [1;1;1;1];
    pr = [0;0;0;0];
    qr = [1;1;1;1];
  end
end
