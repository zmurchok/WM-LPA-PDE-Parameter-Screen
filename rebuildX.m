x = load('main1.mat');
%fix up length of these cell arrays...
if size(x.perturbation_bottom,2) < 50000
  for i = 50000-(50000-size(x.perturbation_bottom,2))+1:50000
    x.perturbation_bottom{i} = [];
  end
end
if size(x.perturbation_middle,2) < 50000
  for i = 50000-(50000-size(x.perturbation_middle,2))+1:50000
    x.perturbation_middle{i} = [];
  end
end
if size(x.perturbation_top,2) < 50000
  for i = 50000-(50000-size(x.perturbation_top,2))+1:50000
    x.perturbation_top{i} = [];
  end
end


filenames = {'main2.mat','main3.mat','main4.mat','main5.mat','main6.mat','main7.mat','main8.mat','main9.mat','main10.mat','main11.mat','main12.mat','main13.mat','main14.mat','main15.mat','main16.mat','main17.mat','main18.mat','main19.mat','main20.mat'};
for i=1:19
  y = load(filenames{i})

  x.X = [x.X;y.X];
  x.len = [x.len;y.len];
  x.equilibria = [x.equilibria,y.equilibria];
  x.LPAPolarizable = [x.LPAPolarizable,y.LPAPolarizable];
  x.stability = [x.stability,y.stability];

  %fix up length of these cell arrays if necessary
  if size(y.perturbation_bottom,2) < 50000
    for i = 50000-(50000-size(y.perturbation_bottom,2))+1:50000
      y.perturbation_bottom{i} = [];
    end
  end
  if size(y.perturbation_middle,2) < 50000
    for i = 50000-(50000-size(y.perturbation_middle,2))+1:50000
      y.perturbation_middle{i} = [];
    end
  end
  if size(y.perturbation_top,2) < 50000
    for i = 50000-(50000-size(y.perturbation_top,2))+1:50000
      y.perturbation_top{i} = [];
    end
  end

  x.perturbation_bottom = [x.perturbation_bottom, y.perturbation_bottom];
  x.perturbation_middle = [x.perturbation_middle, y.perturbation_middle];
  x.perturbation_top = [x.perturbation_top, y.perturbation_top];
end

save('data','-struct','x');
