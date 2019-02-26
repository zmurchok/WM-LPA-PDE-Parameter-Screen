syshandle=@Fig2a_Functions;  %Specify system file

SubFunHandles=feval(syshandle);  %Get function handles from system file
RHShandle=SubFunHandles{2};      %Get function handle for ODE

a1 = 1.8;
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
c2=c1;

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
opt=contset(opt,'MaxNumPoints',3000); %Set numeber of continuation steps
opt=contset(opt,'MaxStepsize',.1);  %Set max step size
opt=contset(opt,'Singularities',1);  %Monitor singularities
opt=contset(opt,'Eigenvalues',1);    %Output eigenvalues
opt=contset(opt,'InitStepsize',0.1); %Set Initial stepsize

[x1,v1,s1,h1,f1]=cont(@equilibrium,x0,v0,opt);

opt=contset(opt,'backward',1);
[x1b,v1b,s1b,h1b,f1b]=cont(@equilibrium,x0,v0,opt);



%%%% LOCAL BRANCHES


xBP=x1(1:4,s1(8).index);       %Extract branch point
pvec(ap)=x1(5,s1(8).index);  %Extract branch point
[x0,vO]=init_BP_EP(syshandle, xBP, pvec, s1(8), 0.01);
opt=contset(opt,'backward',1);
[x3b,v3b,s3b,h3b,f3b]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.
opt = contset(opt,'backward',0);
[x3,v3,s3,h3,f3]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.

xBP=x1b(1:4,s1b(7).index);       %Extract branch point
pvec(ap)=x1b(5,s1b(7).index);  %Extract branch point
[x0,vO]=init_BP_EP(syshandle, xBP, pvec, s1b(7), 0.01);
opt = contset(opt,'backward',1);
[x4b,v4b,s4b,h4b,f4b]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.
opt = contset(opt,'backward',0);
[x4,v4,s4,h4,f4]=cont(@equilibrium,x0,v0,opt); %Switch branches and continue.

aps = [11,12];
% opt=contset(opt,'MaxNumPoints',1000);

disp('first limit point')
xtmp = x1(1:end-1,s1(3).index);
pvec(ap) = x1(end,s1(3).index);
[x0,v0] = init_LP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',0);
[x5,v5,s5,h5,f5] = cont(@limitpoint,x0,v0,opt);
disp('first limit point backward')
opt = contset(opt,'backward',1);
[x5b,v5b,s5b,h5b,f5b] = cont(@limitpoint,x0,v0,opt);

disp('branch point')
xtmp = x1(1:end-1,s1(8).index);
pvec(ap) = x1(end,s1(8).index);
[x0,v0] = init_BP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',0);
[x6,v6,s6,h6,f6] = cont(@limitpoint,x0,v0,opt);
disp('branch point backward')
opt = contset(opt,'backward',1);
[x6b,v6b,s6b,h6b,f6b] = cont(@limitpoint,x0,v0,opt);

disp('second limit point')
xtmp = x1b(1:end-1,s1b(3).index);
pvec(ap) = x1b(end,s1b(3).index);
[x0,v0] = init_LP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',0);
[x7,v7,s7,h7,f7] = cont(@limitpoint,x0,v0,opt);
disp('second limit point backward')
opt = contset(opt,'backward',1);
[x7b,v7b,s7b,h7b,f7b] = cont(@limitpoint,x0,v0,opt);

disp('other branch point backward')
xtmp = x1b(1:end-1,s1b(7).index);
pvec(ap) = x1b(end,s1b(7).index);
[x0,v0] = init_BP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',1);
[x8b,v8b,s8b,h8b,f8b] = cont(@limitpoint,x0,v0,opt);
disp('other branch point ')
opt = contset(opt,'backward',0);
[x8,v8,s8,h8,f8] = cont(@limitpoint,x0,v0,opt);

disp('polarity limit point')
xtmp = x3(1:end-1,s3(7).index);
pvec(ap) = x3(end,s3(7).index);
[x0,v0] = init_LP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',0);
[x9,v9,s9,h9,f9] = cont(@limitpoint,x0,v0,opt);
disp('first limit point backward')
opt = contset(opt,'backward',1);
[x9b,v9b,s9b,h9b,f9b] = cont(@limitpoint,x0,v0,opt);
xtmp = x3(1:end-1,s3(10).index);
pvec(ap) = x3(end,s3(10).index);
[x0,v0] = init_LP_LP(syshandle,xtmp,pvec,aps);
opt = contset(opt,'backward',0);
[x10,v10,s10,h10,f10] = cont(@limitpoint,x0,v0,opt);
disp('first limit point backward')
opt = contset(opt,'backward',1);
[x10b,v10b,s10b,h10b,f10b] = cont(@limitpoint,x0,v0,opt);

% figure
% hold on
% axis square
% xlim([0 5])
% ylim([0 5])
% grid
% cpl(x5,v5,s5,[5 6])
% cpl(x5b,v5b,s5b,[5 6])
% cpl(x6,v6,s6,[5 6])
% cpl(x6b,v6b,s6b,[5 6])
% cpl(x7,v7,s7,[5 6])
% cpl(x7b,v7b,s7b,[5 6])
% cpl(x8,v8,s8,[5 6])
% cpl(x8b,v8b,s8b,[5 6])
% cpl(x9,v9,s9,[5 6])
% cpl(x9b,v9b,s9b,[5 6])
% cpl(x10,v10,s10,[5 6])
% cpl(x10b,v10b,s10b,[5 6])
% % end

Fig6c = subplot(2,2,3);
Fig6cTitle = title(Fig6c,{'(c)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(Fig6c,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
grid
Fig6c.XLim = [0 5];
Fig6c.YLim = [0 5];
Fig6c.Box = 'on';
xlabel(Fig6c,{'$R_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
ylabel(Fig6c,{'$\rho_T$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')

hold on

linecolor(5) = {co(1,:)};
linecolor(6) = {'k'};
linecolor(7) = {co(1,:)};
linecolor(8) = {'k'};
linecolor(9) = {co(4,:)};


linestyle(5) = {'-'};
linestyle(6) = {'--'};
linestyle(7) = {'-'};
linestyle(8) = {'--'};
linestyle(9) = {'-'};


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
