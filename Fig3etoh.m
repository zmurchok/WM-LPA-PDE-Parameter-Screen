seaborncolors;
load('testrun_million.mat')
% EXTRACT INDEXES
id1 = find(len==1); %monostable param sets
id2 = find(len==2); %bistable param sets
id3 = find(len==3); %trisablte param sets
id4 = find(len>=4); %more than 4 steady-states or ERRORS in finding unique equilibiria

stableids_top = intersect(find(stability_top==1),id3);
stableids_middle = intersect(find(stability_middle==1),id3);
stableids_bottom = intersect(find(stability_bottom==1),id3);
unstableids_top = intersect(find(stability_top==-1),id3);
unstableids_middle = intersect(find(stability_middle==-1),id3);
unstableids_bottom = intersect(find(stability_bottom==-1),id3);

all_unstable = intersect(intersect(unstableids_top,unstableids_bottom),unstableids_middle);
all_stable = intersect(intersect(stableids_top,stableids_bottom),stableids_middle);

screen = 0;
if screen == 1
width=5.2;
height=2;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Du = 0.01;
counter = 1;
xnum = 200;
x = linspace(0,1,xnum+1);
idx = randi(length(all_unstable),1,30);
ids = all_unstable(idx);
for j=1:length(ids)
  %solve for top branch
  u1init = equilibria{ids(j)}(3,1);
  u2init = equilibria{ids(j)}(3,2);
  pu1height = 0;
  pu2height = 1;
  [rac_top,rho_top,raci_top,rhoi_top] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  %solve for middle branch
  u1init = equilibria{ids(j)}(2,1);
  u2init = equilibria{ids(j)}(2,2);
  [rac_middle,rho_middle,raci_middle,rhoi_middle] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  pu1height = 0.5;
  pu2height = 0.5;
  %solve for bottom branch
  u1init = equilibria{ids(j)}(1,1);
  u2init = equilibria{ids(j)}(1,2);
  pu1height = 1;
  pu2height = 0;
  [rac_bottom,rho_bottom,raci_bottom,rhoi_bottom] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  subplot(3,10,counter)
  hold on
  plot(x,rac_top,'-','LineWidth',4,'Color',co(1,:))
  plot(x,rho_top,'-','LineWidth',2,'Color',co(1,:))
  plot(x,rac_middle,'--','LineWidth',4,'Color',co(2,:))
  plot(x,rho_middle,'--','LineWidth',2,'Color',co(2,:))
  plot(x,rac_bottom,'-.','LineWidth',4,'Color',co(3,:))
  plot(x,rho_bottom,'-.','LineWidth',2,'Color',co(3,:))
  grid
  counter = counter + 1;
end

width=7.5;
height=2;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Du = 0.01;
counter = 1;
xnum = 200;
x = linspace(0,1,xnum+1);
titlestr = {'(d)','(e)','(f)'};
ids = all_unstable([53,54,195]);
for j=1:length(ids)
  %solve for top branch
  u1init = equilibria{ids(j)}(3,1);
  u2init = equilibria{ids(j)}(3,2);
  pu1height = 0;
  pu2height = 1;
  [rac_top,rho_top,raci_top,rhoi_top] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  %solve for middle branch
  u1init = equilibria{ids(j)}(2,1);
  u2init = equilibria{ids(j)}(2,2);
  [rac_middle,rho_middle,raci_middle,rhoi_middle] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  pu1height = 1;
  pu2height = 0;
  %solve for bottom branch
  u1init = equilibria{ids(j)}(1,1);
  u2init = equilibria{ids(j)}(1,2);
  pu1height = 1;
  pu2height = 0;
  [rac_bottom,rho_bottom,raci_bottom,rhoi_bottom] = solvethepdes_for_figs(Du,j,X,ids,u1init,u2init,pu1height,pu2height);
  subplot(1,3,j)
  hold on
  % Fig5c = subplot(1,3,3);
  ax = gca;
  ax.Box = 'on';
  xlabel({'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
  title(strcat('{',titlestr{j},'}'),'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
  set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
  % Fig5c.YLim = [0 3.5];
  plot(x,rac_top,'-','LineWidth',4,'Color',co(1,:))
  plot(x,rho_top,'-','LineWidth',2,'Color',co(1,:))
  plot(x,rac_middle,'--','LineWidth',4,'Color',co(2,:))
  plot(x,rho_middle,'--','LineWidth',2,'Color',co(2,:))
  plot(x,rac_bottom,'-.','LineWidth',4,'Color',co(3,:))
  plot(x,rho_bottom,'-.','LineWidth',2,'Color',co(3,:))
  grid
  counter = counter + 1;
end

end

width=7.5;
height=2;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Du = 0.01;
counter = 1;
xnum = 200;
x = linspace(0,1,xnum+1);
titlestr = {'(d)','(e)','(f)'};
ids = all_unstable(195);
%solve for top branch
u1init = equilibria{ids}(3,1);
u2init = equilibria{ids}(3,2);
pu1height = 0;
pu2height = 1;
[rac_top,rho_top,raci_top,rhoi_top] = solvethepdes_for_figs(Du,1,X,ids,u1init,u2init,pu1height,pu2height);
%solve for middle branch
u1init = equilibria{ids}(2,1);
u2init = equilibria{ids}(2,2);
[rac_middle,rho_middle,raci_middle,rhoi_middle] = solvethepdes_for_figs(Du,1,X,ids,u1init,u2init,pu1height,pu2height);
pu1height = 1;
pu2height = 0;
%solve for bottom branch
u1init = equilibria{ids}(1,1);
u2init = equilibria{ids}(1,2);
pu1height = 0;
pu2height = 1;
[rac_bottom,rho_bottom,raci_bottom,rhoi_bottom] = solvethepdes_for_figs(Du,1,X,ids,u1init,u2init,pu1height,pu2height);

subplot(1,4,2)
hold on
ax = gca;
ax.Box = 'on';
xlabel({'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title('(f) Rac IC','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
% Fig5c.YLim = [0 3.5];
plot(x,rac_top,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho_top,'--','LineWidth',2,'Color',co(3,:))
grid

subplot(1,4,3)
hold on
ax = gca;
ax.Box = 'on';
xlabel({'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title('(g) Coexist. IC','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac_middle,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho_middle,'--','LineWidth',2,'Color',co(3,:))
grid

subplot(1,4,4)
hold on
ax = gca;
ax.Box = 'on';
xlabel({'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title('(h) Rho IC','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
plot(x,rac_bottom,'-','LineWidth',4,'Color',co(1,:))
plot(x,rho_bottom,'--','LineWidth',2,'Color',co(3,:))
ylim([0 2])
grid

subplot(1,4,1)
hold on
ax = gca;
ax.Box = 'on';
xlabel({'$R$ IC'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
ylabel({'$\rho$ IC'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
set(ax,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
title('(e)  HSS','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
scatter(equilibria{ids}(1,1),equilibria{ids}(1,2),50,co(3,:),'+','LineWidth',3)
scatter(equilibria{ids}(2,1),equilibria{ids}(2,2),50,co(2,:),'x','LineWidth',3)
scatter(equilibria{ids}(3,1),equilibria{ids}(3,2),50,co(1,:),'o','MarkerFaceColor',co(1,:),'LineWidth',1.5)
xlim([0 1])
ylim([0 1])
grid




print(1,'Fig4row2','-depsc','-painters')
