load('X.mat')

for i = 1:20
  current = X((1+50000*(i-1)):(50000*i),:);
  filename = strcat('X',num2str(i),'.mat');
  save(filename,'current')
end
