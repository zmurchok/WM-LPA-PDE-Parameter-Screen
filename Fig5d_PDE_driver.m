load('data_PDE_screen_counted.mat')

% trisCoexistUnstable = [];
% smallPerturb = [];
% bigPerturb = [];
% noPerturb = [];

% for i = 1:length(tris)
%   if stability{tris(i)}(2) == 1
%     %LPA stable
%     if ismember(-1,perturbation_middle{tris(i)}(2:end-1,2:end-1))
%       %small perturbation works
%       smallPerturb = [smallPerturb; tris(i)];
%     elseif ismember(-1,perturbation_middle{tris(i)})
%       %big perturbation works
%       bigPerturb = [bigPerturb; tris(i)];
%     elseif not(ismember(-1,perturbation_middle{tris(i)}))
%       %no perturbation worked
%       noPerturb = [noPerturb; tris(i)];
%     end
%   elseif stability{tris(i)}(2) == -1
%     %LPA unstable
%     trisCoexistUnstable = [trisCoexistUnstable; tris(i)];
%   end
% end

black = [0,0,0]/255;
red = [255,0,0]/255;
gold = [250,241,142]/255;
nonPolarColor = [160,150,47]/255;
trisPolarColor = [255,0,0]/255;
bistPolarColor = [250,241,142]/255;
monoPolarColor = [150,150,150]/255;

A1 = union(intersect(monoPDEPolar,monoPDENoiseNonPolar),intersect(monoPDEPolar,monoPDENoisePolar));
B1 = union(intersect(bistPDEPolar,bistPDENoiseNonPolar),intersect(bistPDEPolar,union(bistPDEOneNoisePolar,bistPDEBothNoisePolar)));
C1 = union(intersect(trisPDEPolar,trisPDENoNoisePolar),intersect(trisPDEPolar,union(union(trisPDEOneNoisePolar,trisPDETwoNoisePolar),trisPDEAllNoisePolar)));

monoPolar = A1;
bistPolar = B1;
trisPolar = C1;

a_min = 1.3;
a_max = 2.3;
b_min = 3.5;
b_max = 4.5;
c_max = 0.025;


monoPolar_c = find(X(monoPolar,3)<c_max);
bistPolar_c = find(X(bistPolar,3)<c_max);
trisPolar_c = find(X(trisPolar,3)<c_max);
monoPolar_a = find(a_min<X(monoPolar,1) & X(monoPolar,1)<a_max);
bistPolar_a = find(a_min<X(bistPolar,1) & X(bistPolar,1)<a_max);
trisPolar_a = find(a_min<X(trisPolar,1) & X(trisPolar,1)<a_max);
monoPolar_b = find(b_min<X(monoPolar,2) & X(monoPolar,1)<b_max);
bistPolar_b = find(b_min<X(bistPolar,2) & X(bistPolar,1)<b_max);
trisPolar_b = find(b_min<X(trisPolar,2) & X(trisPolar,1)<b_max);

monoplotindx = intersect(intersect(monoPolar_c,monoPolar_a),monoPolar_b);
bistplotindx = intersect(intersect(bistPolar_c,bistPolar_a),bistPolar_b);
trisplotindx = intersect(intersect(trisPolar_c,trisPolar_a),trisPolar_b);


%
% width=2.5;
% height=2.5;
% x0 = 5;
% y0 = 5;
% fontsize = 12;
%
% f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Fig6d = subplot(2,2,4);
Fig6dTitle = title(Fig6d,{'(d)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(Fig6d,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
grid
Fig6d.XLim = [0 5];
Fig6d.YLim = [0 5];
Fig6d.Box = 'on';
xlabel(Fig6d,{'$R_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
ylabel(Fig6d,{'$\rho_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
hold on
i = 4; j = 5;
% a2=scatter(X(mono,i),X(bigPerturb,j),8,black,'filled');
% a3=scatter(X(smallPerturb,i),X(smallPerturb,j),4,gold,'filled');4
% a1=scatter(X(trisCoexistUnstable,i),X(trisCoexistUnstable,j),8,red,'filled');
% a2=scatter(X(monoPolar,i),X(monoPolar,j),2,monoPolarColor,'filled');
% a3=scatter(X(bistPolar,i),X(bistPolar,j),2,bistPolarColor,'filled');
% a1=scatter(X(trisPolar,i),X(trisPolar,j),2,trisPolarColor,'filled');
a2=scatter(X(monoPolar(monoplotindx),i),X(monoPolar(monoplotindx),j),8,monoPolarColor,'filled');
a3=scatter(X(bistPolar(bistplotindx),i),X(bistPolar(bistplotindx),j),8,bistPolarColor,'filled');
a1=scatter(X(trisPolar(trisplotindx),i),X(trisPolar(trisplotindx),j),8,trisPolarColor,'filled');

% NonPolar = union(union(trisNonPolar,bistNonPolar),monoNonPolar);
% scatter(X(NonPolar,i),X(NonPolar,j),8,black,'filled');
% i = 4;
% scatter(X(monoUnstable,i),X(monoUnstable,j),8,black,'filled')

for i=5:9
  xeqcurve = eval(['x' num2str(i)]);
  plot(xeqcurve(end-1,:),xeqcurve(end,:),'LineStyle',linestyle{i},'Color',linecolor{i},'LineWidth',2)
  xeqcurve = eval(['x' num2str(i) 'b']);
  plot(xeqcurve(end-1,:),xeqcurve(end,:),'LineStyle',linestyle{i},'Color',linecolor{i},'LineWidth',2)
end
yticks([0 1 2 3 4 5])
xticks([0 1 2 3 4 5])
axis square
set(gca,'LineWidth',1.5)
