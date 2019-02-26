function y = PDEscreen(arraynum)
  load('data_counted.mat')
  Du = 0.01;
  rac = zeros(1,201);
  rho = zeros(1,201);

  range = (1+50000*(arraynum-1)):(50000*arraynum);
  range(1)
  range(end)
  len_tmp = len(range);
  X_tmp = X(range,:);
  equilibria_tmp = equilibria(range);
  ids = 1:length(range);

  parfor i = 1:length(range)
    M = len_tmp(i);%num of HSS
    y_tmp1 = zeros(M,1);
    y_tmp2 = 0;
    for m = 1:M %loop thru HSSs
      [rac,rho] = solvethepdes_noise(Du,i,X_tmp,ids,equilibria_tmp,m);
      y_tmp1(m) = is_polarized(rac,rho);
    end
    [rac,rho] = solvethepdes(Du,i,X_tmp,ids,equilibria_tmp);
    y_tmp2 = is_polarized(rac,rho);
    y_noise{i} = y_tmp1;
    y_polar{i} = y_tmp2;
  end

  save(['PDEscreen',num2str(arraynum)])
end
