seaborncolors;
load('testrun_million.mat')

ids = 522664;
X(ids,:)
averages = [];
maxes = [];
mins = [];

width=6.5;
height=4.5;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');

xnum = 400;
x = linspace(0,1,xnum+1);

i = 1;
j = 3;
ii = 5;
jj = 1;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,1)
hold on
ax = gca;
ax.Box = 'on';
ylabel({'Activity'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title({'(a) Rac-dominated'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
legend({'$R$','$\rho$'},'Interpreter','latex','FontSize',fontsize,'FontName','Times','Location','east')
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];


grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])

j = 2;
ii = 5;
jj = 1;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,2)
hold on
ax = gca;
ax.Box = 'on';
% xlabel({'Space'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title({'(b) Coexistence'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];

j = 1;
ii = 1;
jj = 1;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,3)
hold on
ax = gca;
ax.Box = 'on';
title({'(c) Rho-dominated'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];

j = 3;
ii = 2;
jj = 2;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,4)
hold on
ax = gca;
ax.Box = 'on';
ylabel({'Activity'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title({'(d) Rac-dominated','polarity'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];

j = 1;
ii = 5;
jj = 1;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,5)
hold on
ax = gca;
ax.Box = 'on';
xlabel({'Space'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title({'(e) Balanced','polarity'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];

j = 1;
ii = 2;
jj = 2;
u1init = equilibria{ids(i)}(j,1);
u2init = equilibria{ids(i)}(j,2);
v1init = X(ids(i),4) - u1init;
v2init = X(ids(i),5) - u2init;
gr1min = -u1init;
gr2min = -u2init;
gr1max = v1init/0.1;
gr2max = v2init/0.1;
gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
gr2 = linspace(gr2min,gr2max,5);
[rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
subplot(2,3,6)
hold on
ax = gca;
ax.Box = 'on';
% xlabel({'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title({'(f) Rho-dominated','polarity'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho,'-','LineWidth',2,'Color',co(3,:))
grid
set(gca,'LineWidth',1.5)
ylim([0 2.5])
averages = [averages; mean(rac),mean(rho)];
maxes = [maxes; max(rac),max(rho)];
mins = [mins; min(rac),min(rho)];

RT = X(ids(i),4);
pT = X(ids(i),5);
averages = [averages(:,1)/RT,averages(:,2)/pT]
maxes = [maxes(:,1),maxes(:,2)]
mins = [mins(:,1),mins(:,2)]


print(1,'Fig3_new','-depsc','-painters')
