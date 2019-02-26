%visualizes coexistence of states data from LPA screen
close all;
seaborncolors;

load('data_counted.mat')

fig = 0; %make triangle of scatter plots
figs = 0; %make many individual scatter plots 1
printfigs = 1; %save figures, set this to 1
indivi = 0;

nump = size(X,2);
totalgraphs = nchoosek(nump,2);
pars = {'a','b','c','R_T','\rho_T'};

nonPolarColor = [160,150,47]/255;
trisPolarColor = [255,0,0]/255;
bistPolarColor = [250,241,142]/255;
monoPolarColor = [150,150,150]/255;

% if fig == 1
% type = {'trisPolar','bistPolar','monoPolar'};
% typeNonPolar = {'trisNonPolar','bistNonPolar','monoNonPolar'};
%
% for k = 1:3
% figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
%   for i=1:nump
%     for j=1:nump
%       if i<j
%         subplot(nump-1,nump-1,i+(j-2)*(nump-1)) %i don't know why this is correct but it works
%         set(gca,'Box','on')
%         hold on
%         scatter(X(eval(type{k}),i),X(eval(type{k}),j),8,co(1,:),'filled');
%         scatter(X(eval(typeNonPolar{k}),i),X(eval(typeNonPolar{k}),j),4,nonPolarColor,'filled');
%         axis square
%         xticks([])
%         yticks([])
%         xlim([0 5])
%         ylim([0 5])
%         if i == 3
%           xlim([0 0.25])
%         end
%         if j == 3
%           ylim([0 0.25])
%         end
%         if j == nump
%           xlabel(strcat('{$',pars{i},'$}'),'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
%           xticks([0 5])
%           if i == 3
%             xticks([0 0.1 0.2])
%           end
%         end
%         if i == 1
%           ylabel(strcat('{$',pars{j},'$}'),'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
%           yticks([0 5])
%           if j == 3
%             yticks([0 0.1 0.2])
%           end
%         end
%         set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
%       end
%     end
%   end
% end
% end

width=2.5;
height=2.5;
x0 = 5;
y0 = 5;
fontsize = 12;
% f3 = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
choices = nchoosek([1 2 3 4 5],3);
limits = [0,5;0,5;0,0.25;0,5;0,5];
NUM = length(choices);



monoToPlot = union(monoPolar,monoUnstable);
bistToPlot = union(union(intersect(bistStable,bistPolar),bistMixed),bistUnstable);
trisToPlot = union(union(union(intersect(trisPolar,trisAllStable),trisAllUnstable),tris1Stable),tris2Stable);

monoPolar = monoToPlot;
bistPolar = bistToPlot;
trisPolar = trisToPlot;

close all
for i = 1:NUM
  figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
  set(gca,'Box','on')
  set(gca,'LineWidth',1.5)
  hold on
  s = scatter3(X(trisPolar(1:7500),choices(i,1)),X(trisPolar(1:7500),choices(i,2)),X(trisPolar(1:7500),choices(i,3)),8,trisPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  % s = scatter3(X(trisNonPolar,choices(i,1)),X(trisNonPolar,choices(i,2)),X(trisNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(bistPolar(1:7500),choices(i,1)),X(bistPolar(1:7500),choices(i,2)),X(bistPolar(1:7500),choices(i,3)),8,bistPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  % s = scatter3(X(bistNonPolar,choices(i,1)),X(bistNonPolar,choices(i,2)),X(bistNonPolar,choices(i,3)),2,nonPolarColor,'filled');
  % s.MarkerFaceAlpha = 1;
  s = scatter3(X(monoPolar(1:7500),choices(i,1)),X(monoPolar(1:7500),choices(i,2)),X(monoPolar(1:7500),choices(i,3)),8,monoPolarColor,'filled');
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
    print(i,['alltogether',num2str(i)],'-depsc','-painters')
    % print(i,['alltogether',num2str(i)],'-dpng')
  end
end
