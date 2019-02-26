%visualizes coexistence of states data from LPA screen
close all;
seaborncolors;

% load('data_PDE_screen_counted.mat')

fig = 0; %make triangle of scatter plots
figs = 1; %make many individual scatter plots 1
printfigs = 1; %save figures, set this to 1
indivi = 0;

nump = size(X,2);
totalgraphs = nchoosek(nump,2);
pars = {'a','b','c','R_T','\rho_T'};

nonPolarColor = [160,150,47]/255;
trisPDEPolarColor = [255,0,0]/255;
bistPDEPolarColor = [250,241,142]/255;
monoPDEPolarColor = [150,150,150]/255;



width=2.5;
height=2.5;
x0 = 5;
y0 = 5;
fontsize = 12;
choices = nchoosek([1 2 3 4 5],3);
limits = [0,5;0,5;0,0.25;0,5;0,5];
NUM = length(choices);

A1 = union(intersect(monoPDEPolar,monoPDENoiseNonPolar),intersect(monoPDEPolar,monoPDENoisePolar));
B1 = union(intersect(bistPDEPolar,bistPDENoiseNonPolar),intersect(bistPDEPolar,union(bistPDEOneNoisePolar,bistPDEBothNoisePolar)));
C1 = union(intersect(trisPDEPolar,trisPDENoNoisePolar),intersect(trisPDEPolar,union(union(trisPDEOneNoisePolar,trisPDETwoNoisePolar),trisPDEAllNoisePolar)));

trisPDEPolarPlot = C1;%trisPDEPolar(1:7500);
bistPDEPolarPlot = B1(1:7500);
monoPDEPolarPlot = A1(1:7500);

close all
for i = 1:NUM
  figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
  set(gca,'Box','on')
  hold on
  s = scatter3(X(trisPDEPolarPlot,choices(i,1)),X(trisPDEPolarPlot,choices(i,2)),X(trisPDEPolarPlot,choices(i,3)),8,trisPDEPolarColor,'filled');
  set(gca,'LineWidth',1.5)
  % s.MarkerFaceAlpha = 1;
  % s = scatter3(X(trisNonPolar,choices(i,1)),X(trisNonPolar,choices(i,2)),X(trisNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(bistPDEPolarPlot,choices(i,1)),X(bistPDEPolarPlot,choices(i,2)),X(bistPDEPolarPlot,choices(i,3)),8,bistPDEPolarColor,'filled');
  % s.MarkerFaceAlpha = 0.25;
  % s = scatter3(X(bistNonPolar,choices(i,1)),X(bistNonPolar,choices(i,2)),X(bistNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(monoPDEPolarPlot,choices(i,1)),X(monoPDEPolarPlot,choices(i,2)),X(monoPDEPolarPlot,choices(i,3)),8,monoPDEPolarColor,'filled');
  % s.MarkerFaceAlpha = 0.1;
  % s = scatter3(X(monoNonPolar,choices(i,1)),X(monoNonPolar,choices(i,2)),X(monoNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  axis square
  grid
  view(3)
  xlim(limits(choices(i,1),:))
  ylim(limits(choices(i,2),:))
  zlim(limits(choices(i,3),:))
  xlabel(strcat('{$',pars{choices(i,1)},'$}'),'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

  ylabel(strcat('{$',pars{choices(i,2)},'$}'),'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

  zlabel(strcat('{$',pars{choices(i,3)},'$}'),'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

  set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
  if printfigs == 1
    print(i,['alltogetherPDE',num2str(i)],'-depsc','-painters')
    % print(i,['alltogetherPDE',num2str(i)],'-dpng')
  end
end
