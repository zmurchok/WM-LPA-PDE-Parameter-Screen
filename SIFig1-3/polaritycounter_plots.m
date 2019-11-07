tic;
% load('trisstable_states_counted.mat');
% S = load('data_PDE_screen_counted.mat','len','X','equilibria');


seaborncolors;
S = load('data_PDE_screen_counted.mat','len','X','trisAllStable','equilibria');
len = S.len;
X = S.X;
% ids = S.trisAllStable;
equilibria = S.equilibria;


xnum = 800;
% tfinal = 800;
% tnum = tfinal;
x = linspace(0,1,xnum+1);
% t = linspace(0,tfinal,tnum+1);

%-----------for each parameter set
ids = 522664;%191569%ids(s6(s6_3p));%41297;%ids(198);
numstates = zeros(size(ids));
whichstates = [];
states = [];
whichpolar = [];
l1 = 5;
l2 = l1;


width=5.5;
height=4.25;
x0 = 5;
y0 = 5;
fontsize = 12;



for i=1:length(ids)
  barcode_endpoints = [];
  barcode_maxmin = [];
  for j=1:len(ids(i))
    u1init = equilibria{ids(i)}(j,1);
    u2init = equilibria{ids(i)}(j,2);
    v1init = X(ids(i),4) - u1init;
    v2init = X(ids(i),5) - u2init;
    gr1min = -u1init;
    gr2min = -u2init;
    gr1max = v1init/0.1;
    gr2max = v2init/0.1;
    gr1 = linspace(gr1min,gr1max,l1);%grmin:1:gr1max;
    gr2 = linspace(gr2min,gr2max,l2);

    % storage_endpoints{j} = zeros(l1*l2,4);
    % storage_maxmin{j} = zeros(l1*l2,4);
    maxrac = max(max(gr1))
    minrac = min(min(gr1))
    maxrho = max(max(gr2))
    minrho = min(min(gr2))
    ymax = max(maxrac,maxrho)
    ymin = min(minrac,minrho)

    tmpstorage = zeros(l1*l2,4);
    figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
    for ii=1:l1
      for jj=1:l2
        [rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
        % storage_endpoints{j}((ii-1)*l2+jj,:) = [rac(1),rac(end),rho(1),rho(end)];
        % storage_maxmin{j}((ii-1)*l2+jj,:) = [max(rac),min(rac),max(rho),min(rho)];
        tmpstorage((ii-1)*l2+jj,:) = [max(rac(end,:)),min(rac(end,:)),max(rho(end,:)),min(rho(end,:))];
        fig = subplot(l1,l2,(ii-1)*l2+jj);
        hold on
        % ylim([0 2.5])
        % grid
        fig.Box = 'on';
        set(fig,'FontSize',8)

        plot(x,rac(1,:),'--','LineWidth',2,'Color',co(1,:))
        plot(x,rho(1,:),'--','LineWidth',1,'Color',co(3,:))
        % plot(x,rac(end,:),'-','LineWidth',4,'Color',co(1,:))
        % plot(x,rho(end,:),'-','LineWidth',2,'Color',co(3,:))
        % title([num2str((ii-1)*l2+jj),'-',num2str(gr1(ii)),'-',num2str(gr2(jj))])
      end
    end
    print(1,[num2str(ids(i)),'_',num2str(j),'_ICs'],'-depsc')
    close 1
    % barcode_endpoints = [barcode_endpoints; storage_endpoints{j}];
    barcode_maxmin = [barcode_maxmin; tmpstorage];
  end
  %determine number of unique polarities
  tol = 1e-1;
  % [C_endpoints,ia_endpoints,ic_endpoints] = uniquetol(barcode_endpoints,tol,'ByRows',true);
  [C_maxmin,ia_maxmin,ic_maxmin] = uniquetol(barcode_maxmin,tol,'ByRows',true);
  %count polarities and store data
  numstates(i) = length(ia_maxmin);
  whichstates{i} = ia_maxmin;
  states{i} = C_maxmin;
  polarstates = zeros(numstates(i),1);
  for k=1:numstates(i)
     polarstates(k) = is_polarized(states{i}(k,1:2),states{i}(k,3:4));
  end
  whichpolar{i} = polarstates;

  %make plot, save plot
  figure
  for k=1:numstates(i)
    k
    [j,ii,jj] = getindex(whichstates{i}(k),l1,l2,len(ids(i)))
    u1init = equilibria{ids(i)}(j,1)
    u2init = equilibria{ids(i)}(j,2)
    v1init = X(ids(i),4) - u1init;
    v2init = X(ids(i),5) - u2init;
    gr1min = -u1init;
    gr2min = -u2init;
    gr1max = v1init/0.1;
    gr2max = v2init/0.1;
    gr1 = linspace(gr1min,gr1max,5);%grmin:1:gr1max;
    gr2 = linspace(gr2min,gr2max,5);
    [rac,rho,raci,rhoi] = solver(X(ids(i),:),u1init,u2init,v1init,v2init,gr1(ii),gr2(jj));
    gr1(ii),gr2(jj)
    subplot(1,numstates(i),k)
    hold on
    plot(x,rac(end,:),'-','LineWidth',4,'Color',co(1,:))
    plot(x,rho(end,:),'-','LineWidth',2,'Color',co(3,:))
  end
  print(1,num2str(ids(i)),'-depsc')
  close 1
end


toc
