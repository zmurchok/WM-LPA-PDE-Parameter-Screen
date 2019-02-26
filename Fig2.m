% co(1,:) = [27,158,119]/255;
% co(2,:) = [217,95,2]/255;
% co(3,:) = [117,112,179]/255;
% co(4,:) = [228,26,28]/255;
seaborncolors;

global cds sys

sys.gui.pausespecial=0;  %Pause at special points
sys.gui.pausenever=1;    %Pause never
sys.gui.pauseeachpoint=0; %Pause at each point

syshandle=@Fig2a_Functions;  %Specify system file

SubFunHandles=feval(syshandle);  %Get function handles from system file
RHShandle=SubFunHandles{2};      %Get function handle for ODE

a1 = 0;
a2=a1;
b1=1;
b2=b1;
switch1=0.5;
switch2=switch1;
n=3;
k=1;
T1=2;
T2=2;
c1=0;
c2=c1;


local = 1;
codim = 0;

xinit=[0,0,0,0]; %Set ODE initial condition

%Specify ODE function with ODE parameters set
RHS_no_param=@(t,x)RHShandle(t,x,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2);

%Set ODE integrator parameters.
options=odeset;
options=odeset(options,'RelTol',1e-5);
options=odeset(options,'maxstep',1e-1);

%Integrate until a steady state is found.
[tout xout]=ode45(RHS_no_param,[0,200],xinit,options);

%%
%% GLOBAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set initial condition as the endpoint of integration.  Use
%to bootstrap the continuation.
xinit=xout(size(xout,1),:);

pvec=[a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2]';      % Initialize parameter vector

ap=11;

[x0,v0]=init_EP_EP(syshandle, xinit', pvec, ap); %Initialize equilibrium


opt=contset;
opt=contset(opt,'MaxNumPoints',1500); %Set numeber of continuation steps
opt=contset(opt,'MaxStepsize',.01);  %Set max step size
opt=contset(opt,'Singularities',1);  %Monitor singularities
opt=contset(opt,'Eigenvalues',1);    %Output eigenvalues
opt=contset(opt,'InitStepsize',0.01); %Set Initial stepsize

[x1,v1,s1,h1,f1]=cont(@equilibrium,x0,v0,opt);

opt=contset(opt,'backward',1);
[x1b,v1b,s1b,h1b,f1b]=cont(@equilibrium,x0,v0,opt);


if local == 1
%%%% LOCAL BRANCHES

ind = 4;
xBP=x1(1:4,s1(ind).index);       %Extract branch point
pvec(ap)=x1(5,s1(ind).index);  %Extract branch point
[x0,v0]=init_BP_EP(syshandle, xBP, pvec, s1(ind), 0.05);
opt=contset(opt,'backward',1);
[x3b,v3b,s3b,h3b,f3b]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.
opt = contset(opt,'backward',0);
[x3,v3,s3,h3,f3]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.

ind = 4;
xBP=x1b(1:4,s1b(ind).index);       %Extract branch point
pvec(ap)=x1b(5,s1b(ind).index);  %Extract branch point
[x0,v0]=init_BP_EP(syshandle, xBP, pvec, s1b(ind), 0.05);
opt = contset(opt,'backward',1);
[x4b,v4b,s4b,h4b,f4b]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.
opt = contset(opt,'backward',0);
[x4,v4,s4,h4,f4]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.

%x4 and x3 are the sam
end
% CODIM 1 plots


width=5.2;
height=2;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Fig2a = subplot(1,2,1);
xlabel(Fig2a,{'$R_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
ylabel(Fig2a,{'$R^\ell$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
Fig2aTitle = title(Fig2a,{'(a)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(Fig2a,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
grid
Fig2a.XLim = [0 4];
Fig2a.YLim = [0 2.5];
Fig2a.Box = 'on';
% colordef(gcf,'black')
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GLOBAL curves
curves = {'1','1b'};

for i = 1:length(curves)
  xeqcurve=eval(['x' curves{i}]);
  minevaleq=eval(['f' curves{i} '(4,:)']); %This is the last eigenvalue.  That is the one that determines stability

  L=length(xeqcurve(1,:));

  curveind=1;
  lengthind=0;
  maxlengthind=0;
  evalstart=floor(heaviside(minevaleq(1)));
  datamateq=zeros(4,L);

  for i=1:L
    evalind=floor(heaviside(minevaleq(i)));
    if evalstart~=evalind
        curveind=curveind+1;
        i;
        evalstart=evalind;
        maxlengthind=max(lengthind,maxlengthind);
        lengthind=0;
    end
    datamateq(1,i)=xeqcurve(5,i); % This is the parameter that is varied.
    datamateq(2,i)=xeqcurve(1,i); % This is the dependent axis of the bifurcation plot.  The one you wish to plot
    datamateq(3,i)=evalind;
    datamateq(4,i)=curveind;

    lengthind=lengthind+1;
  end

  maxlengthind=max(maxlengthind,lengthind);

  curveindeq=curveind;

  for i=1:curveindeq
    index=find(datamateq(4,:)==i);
    eval(['curve' num2str(i) 'eq' '=datamateq(1:3,index);']);
  end

  for i=1:curveindeq
    stability=eval(['curve' num2str(i) 'eq(3,1)']);
    if stability==0
        plotsty='-';
    else
        plotsty=':';
    end

    plotcolor='k';

    plotstr=strcat(plotcolor,plotsty);

    plot(eval(['curve' num2str(i) 'eq(1,:)']),eval(['curve' num2str(i) 'eq(2,:)']),plotstr,'Linewidth',3)
    hold on
  end
end

if local == 1
%%%LOCAL
curves = {'3','3b'};

for i = 1:length(curves)
  xeqcurve=eval(['x' curves{i}]);
  minevaleq=eval(['f' curves{i} '(4,:)']); %This is the last eigenvalue.  That is the one that determines stability

  L=length(xeqcurve(1,:));

  curveind=1;
  lengthind=0;
  maxlengthind=0;
  evalstart=floor(heaviside(minevaleq(1)));
  datamateq=zeros(4,L);

  for i=1:L
    evalind=floor(heaviside(minevaleq(i)));
    if evalstart~=evalind
        curveind=curveind+1;
        i;
        evalstart=evalind;
        maxlengthind=max(lengthind,maxlengthind);
        lengthind=0;
    end
    datamateq(1,i)=xeqcurve(5,i); % This is the parameter that is varied.
    datamateq(2,i)=xeqcurve(1,i); % This is the dependent axis of the bifurcation plot.  The one you wish to plot
    datamateq(3,i)=evalind;
    datamateq(4,i)=curveind;

    lengthind=lengthind+1;
  end

  maxlengthind=max(maxlengthind,lengthind);

  curveindeq=curveind;

  for i=1:curveindeq
    index=find(datamateq(4,:)==i);
    eval(['curve' num2str(i) 'eq' '=datamateq(1:3,index);']);
  end

  for i=1:curveindeq
    stability=eval(['curve' num2str(i) 'eq(3,1)']);
    if stability==0
        plotsty='-';
    else
        plotsty=':';
    end

    mycolor = co(4,:);
    plotstr=plotsty;

    plot(eval(['curve' num2str(i) 'eq(1,:)']),eval(['curve' num2str(i) 'eq(2,:)']),plotstr,'Color',mycolor,'Linewidth',2)
    hold on
  end
end

end


global cds sys

sys.gui.pausespecial=0;  %Pause at special points
sys.gui.pausenever=1;    %Pause never
sys.gui.pauseeachpoint=0; %Pause at each point

syshandle=@Fig2b_Functions;  %Specify system file

SubFunHandles=feval(syshandle);  %Get function handles from system file
RHShandle=SubFunHandles{2};      %Get function handle for ODE


local = 0;
codim = 0;

a1=1.8;
a2=a1;
b1=4;
b2=b1;
switch1=0.5;
switch2=switch1;
n=3;
k=1;
T1=2;
T2=2;
c1=0;
c2=0;


xinit=[0,0]; %Set ODE initial condition

%Specify ODE function with ODE parameters set
RHS_no_param=@(t,x)RHShandle(t,x,a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2);

%Set ODE integrator parameters.
options=odeset;
options=odeset(options,'RelTol',1e-5);
options=odeset(options,'maxstep',1e-1);

%Integrate until a steady state is found.
[tout xout]=ode45(RHS_no_param,[0,200],xinit,options);

%%
%% GLOBAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set initial condition as the endpoint of integration.  Use
%to bootstrap the continuation.
xinit=xout(size(xout,1),:);

pvec=[a1,a2,b1,b2,c1,c2,switch1,switch2,k,n,T1,T2]';      % Initialize parameter vector

ap=11;

[x0,v0]=init_EP_EP(syshandle, xinit', pvec, ap); %Initialize equilibrium


opt=contset;
opt=contset(opt,'MaxNumPoints',1500); %Set numeber of continuation steps
opt=contset(opt,'MaxStepsize',.01);  %Set max step size
opt=contset(opt,'Singularities',1);  %Monitor singularities
opt=contset(opt,'Eigenvalues',1);    %Output eigenvalues
opt=contset(opt,'InitStepsize',0.01); %Set Initial stepsize

[x1,v1,s1,h1,f1]=cont(@equilibrium,x0,v0,opt);

opt=contset(opt,'backward',1);
[x1b,v1b,s1b,h1b,f1b]=cont(@equilibrium,x0,v0,opt);


Fig2b = subplot(1,2,2);
xlabel(Fig2b,{'$R_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

Fig2bTitle = title(Fig2b,{'(b)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(Fig2b,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')

yyaxis left
grid
Fig2b.XLim = [0 4];
Fig2b.YLim = [0 3.5];
Fig2b.Box = 'on';
ylabel({'$R$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

ax = gca;
ax.YAxis(1).Color = [0 0 0];

% hold on

curves = {'1','1b'};

for i = 1:length(curves)
  xeqcurve=eval(['x' curves{i}]);
  minevaleq=eval(['f' curves{i} '(2,:)']); %This is the last eigenvalue.  That is the one that determines stability

  L=length(xeqcurve(1,:));

  curveind=1;
  lengthind=0;
  maxlengthind=0;
  evalstart=floor(heaviside(minevaleq(1)));
  datamateq=zeros(4,L);

  for i=1:L
    evalind=floor(heaviside(minevaleq(i)));
    if evalstart~=evalind
        curveind=curveind+1;
        i;
        evalstart=evalind;
        maxlengthind=max(lengthind,maxlengthind);
        lengthind=0;
    end
    datamateq(1,i)=xeqcurve(3,i); % This is the parameter that is varied.
    datamateq(2,i)=xeqcurve(1,i); % This is the dependent axis of the bifurcation plot.  The one you wish to plot
    datamateq(3,i)=evalind;
    datamateq(4,i)=curveind;

    lengthind=lengthind+1;
  end

  maxlengthind=max(maxlengthind,lengthind);

  curveindeq=curveind;

  for i=1:curveindeq
    index=find(datamateq(4,:)==i);
    eval(['curve' num2str(i) 'eq' '=datamateq(1:3,index);']);
  end

  for i=1:curveindeq
    stability=eval(['curve' num2str(i) 'eq(3,1)']);
    if stability==0
        plotsty='-';
    else
        plotsty=':';
    end

    plotcolor='k';

    plotstr=strcat(plotcolor,plotsty);

    plot(eval(['curve' num2str(i) 'eq(1,:)']),eval(['curve' num2str(i) 'eq(2,:)']),plotstr,'Linewidth',3)
    hold on
  end
end

yyaxis right
ylabel({'$\rho$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
ax.YAxis(2).Color = co(8,:)
curves = {'1','1b'};

for i = 1:length(curves)
  xeqcurve=eval(['x' curves{i}]);
  minevaleq=eval(['f' curves{i} '(2,:)']); %This is the last eigenvalue.  That is the one that determines stability

  L=length(xeqcurve(1,:));

  curveind=1;
  lengthind=0;
  maxlengthind=0;
  evalstart=floor(heaviside(minevaleq(1)));
  datamateq=zeros(4,L);

  for i=1:L
    evalind=floor(heaviside(minevaleq(i)));
    if evalstart~=evalind
        curveind=curveind+1;
        i;
        evalstart=evalind;
        maxlengthind=max(lengthind,maxlengthind);
        lengthind=0;
    end
    datamateq(1,i)=xeqcurve(3,i); % This is the parameter that is varied.
    datamateq(2,i)=xeqcurve(2,i); % This is the dependent axis of the bifurcation plot.  The one you wish to plot
    datamateq(3,i)=evalind;
    datamateq(4,i)=curveind;

    lengthind=lengthind+1;
  end

  maxlengthind=max(maxlengthind,lengthind);

  curveindeq=curveind;

  for i=1:curveindeq
    index=find(datamateq(4,:)==i);
    eval(['curve' num2str(i) 'eq' '=datamateq(1:3,index);']);
  end

  for i=1:curveindeq
    stability=eval(['curve' num2str(i) 'eq(3,1)']);
    if stability==0
        plotsty='-';
    else
        plotsty=':';
    end

    % plotcolor='k';

    plotstr=strcat(plotsty);

    plot(eval(['curve' num2str(i) 'eq(1,:)']),eval(['curve' num2str(i) 'eq(2,:)']),plotstr,'Linewidth',3,'Color',co(8,:))
    hold on
  end
end

yyaxis left
ylabel({'$R$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

print(1,'Fig2','-depsc','-painters')
