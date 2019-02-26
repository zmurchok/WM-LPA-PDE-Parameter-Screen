%plots the stability of the coexistence HSS for the tristable parameter sets
load('data_counted.mat')
% seaborncolors;

printfigs = 1;

%loop over all tristable parameters and classify the coexistence HSS based on LPA stability and perturbation response
%make lists of indices. this is slow because I'm appending things onto lists. oh well.
trisCoexistUnstable = [];
smallPerturb = [];
bigPerturb = [];
noPerturb = [];

for i = 1:length(tris)
  if stability{tris(i)}(2) == 1
    %LPA stable
    if ismember(-1,perturbation_middle{tris(i)}(2:end-1,2:end-1))
      %small perturbation works
      smallPerturb = [smallPerturb; tris(i)];
    elseif ismember(-1,perturbation_middle{tris(i)})
      %big perturbation works
      bigPerturb = [bigPerturb; tris(i)];
    elseif not(ismember(-1,perturbation_middle{tris(i)}))
      %no perturbation worked
      noPerturb = [noPerturb; tris(i)];
    end
  elseif stability{tris(i)}(2) == -1
    %LPA unstable
    trisCoexistUnstable = [trisCoexistUnstable; tris(i)];
  end
end




nump = size(X,2);
totalgraphs = nchoosek(nump,2);
pars = {'a','b','c','R_T','\rho_T'};

black = [0,0,0]/255;
red = [255,0,0]/255;
gold = [250,241,142]/255;

width=2.5;
height=2.5;
x0 = 5;
y0 = 5;
fontsize = 12;
choices = nchoosek([1 2 3 4 5],3);
limits = [0,5;0,5;0,0.25;0,5;0,5];
NUM = length(choices);

close all
for i = 1:NUM
  figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
  set(gca,'Box','on')
  hold on
  s = scatter3(X(trisCoexistUnstable,choices(i,1)),X(trisCoexistUnstable,choices(i,2)),X(trisCoexistUnstable,choices(i,3)),8,red,'filled');
  set(gca,'LineWidth',1.5)
  % s.MarkerFaceAlpha = 1;
  % s = scatter3(X(trisNonPolar,choices(i,1)),X(trisNonPolar,choices(i,2)),X(trisNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(smallPerturb,choices(i,1)),X(smallPerturb,choices(i,2)),X(smallPerturb,choices(i,3)),8,gold,'filled');
  % s.MarkerFaceAlpha = 0.25;
  % s = scatter3(X(bistNonPolar,choices(i,1)),X(bistNonPolar,choices(i,2)),X(bistNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(bigPerturb,choices(i,1)),X(bigPerturb,choices(i,2)),X(bigPerturb,choices(i,3)),8,black,'filled');
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
    print(i,['coexistenceHSS',num2str(i)],'-depsc','-painters')
    % print(i,['alltogetherPDE',num2str(i)],'-dpng')
  end
end
