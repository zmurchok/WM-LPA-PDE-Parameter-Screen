x = load('PDEscreen1.mat')

filenames = {'PDEscreen2.mat','PDEscreen3.mat','PDEscreen4.mat','PDEscreen5.mat','PDEscreen6.mat','PDEscreen7.mat','PDEscreen8.mat','PDEscreen9.mat','PDEscreen10.mat','PDEscreen11.mat','PDEscreen12.mat','PDEscreen13.mat','PDEscreen14.mat','PDEscreen15.mat','PDEscreen16.mat','PDEscreen17.mat','PDEscreen18.mat','PDEscreen19.mat','PDEscreen20.mat'}

for i = 1:19
  y =  load(filenames{i})

  x.y_noise = [x.y_noise,y.y_noise];
  x.y_polar = [x.y_polar,y.y_polar];
end

save('data_PDEscreen','-struct','x');
