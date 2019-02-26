% load('data_PDE_screen_counted.mat')
% trouble = intersect(trisPolar,trisPDENonPolar);
% length(trouble)
indices = randi(length(trouble),5,1)
indices = [1228;3505;6882;12049;12142;12275];
trouble(indices)
xnum = 1000;
tfinal = 4000;
tnum = tfinal/10;
x = linspace(0,1,xnum+1);
t = linspace(0,tfinal,tnum+1);

DiffCoef = 0.0001;

for i = 1:length(indices)
    [rac,rho] = solvethepdes_time(DiffCoef,i,X,trouble(indices),equilibria);
    subplot(2,3,i)
    hold on
    % mesh(x,t,rac);
    % view(3)
    plot(x,rac(end,:),'b','LineWidth',4)
    plot(x,rho(end,:),'g','LineWidth',4)
    plot(x,rac(1,:),'b--','LineWidth',2)
    plot(x,rho(1,:),'g--','LineWidth',2)
    grid
end

figure
for i = 1:length(indices)
    [rac,rho] = solvethepdes_time2(DiffCoef,i,X,trouble(indices),equilibria);
    subplot(2,3,i)
    hold on
    % mesh(x,t,rac);
    % view(3)
    plot(x,rac(end,:),'b','LineWidth',4)
    plot(x,rho(end,:),'g','LineWidth',4)
    plot(x,rac(1,:),'b--','LineWidth',2)
    plot(x,rho(1,:),'g--','LineWidth',2)
    grid
end
