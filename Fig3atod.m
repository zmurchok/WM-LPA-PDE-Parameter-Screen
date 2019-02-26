function Fig3atod()
	co = [0.2980392156862745, 0.4470588235294118, 0.6901960784313725, 0.8666666666666667, 0.5176470588235295, 0.3215686274509804, 0.3333333333333333, 0.6588235294117647, 0.40784313725490196, 0.7686274509803922, 0.3058823529411765, 0.3215686274509804, 0.5058823529411764, 0.4470588235294118, 0.7019607843137254, 0.5764705882352941, 0.47058823529411764, 0.3764705882352941, 0.8549019607843137, 0.5450980392156862, 0.7647058823529411, 0.5490196078431373, 0.5490196078431373, 0.5490196078431373, 0.8, 0.7254901960784313, 0.4549019607843137, 0.39215686274509803, 0.7098039215686275, 0.803921568627451];
	co = vec2mat(co,3);

	co2 = [0.09641540616370546, 0.17728671859553138, 0.28347363185399654,  0.6328422475018423, 0.4747981096220677, 0.29070209208025455, 0.7632674462838152, 0.850242277575182, 0.9515539762051686];
	co2 = vec2mat(co2,3);
	%
	co3 = [0.10361479515598847, 0.09497494261006116, 0.20622110711523312, 0.08259385956193721, 0.27284810506762325, 0.3077201223179875, 0.17004232121057958, 0.43679759647517286, 0.2237255555555555, 0.4587619752319175, 0.48057366087571074, 0.19972785287539777, 0.7576693751824222, 0.47696440257052414, 0.4377552097141371, 0.8299576787894204, 0.5632024035248271, 0.7762744444444444,0.763897854764939, 0.7572688769419182, 0.9494023023345208,0.8106543271652416, 0.9218447051984724, 0.9373759048616408];
	co3 = vec2mat(co3,3);


	% global a1 a2 b1 b2 c1 c2 k T1 T2 n Du1 Du2 Dv1 Dv2
	a1=0.4898;
  a2=a1;
  b1=1.2034;
  b2=b1;
  c1=0.0415;
  c2=c1;
  s1=0.5;
  s2=s1;
  n=3;
  k=1;
  T1=4.4206;
  T2=4.4372;
	% a1=1.8;
	% a2=a1;
	% b1=4;
	% b2=b1;
	% c1=0;
	% c2=c1;
	% s1=0.5;
	% s2=s1;
	% n=3;
	% k=1;
	% T1=2;
	% T2=2;

	Du1 = 0.01;
  Dv1 = 10;
  Du2 = Du1;
  Dv2 = Dv1;

	xnum = 1000;%ceil(1/sqrt(Du1)*10); %number of spatial steps
	necessary_width = sqrt(sqrt(Du1));
	tfinal = 200; %total time
	tnum = tfinal*10; %total number ot timestpes
	x = linspace(0,1,xnum+1);
	t = linspace(0,tfinal,tnum+1);

	m = 0;% Pdepe needs this

	%COEXISTENCE
	a = T1;
	b = T2;
	u1init = a;
	v1init = T1-a;
	u2init = b;
	v2init = T2-b;
  %solve the PDE
	sol_pdepe = pdepe(m,@pdefunction,@icfunction,@bcfunction,x,t);
  %get components of solution for plotting
	u1coexist = sol_pdepe(:,:,1);
  v1coexist = sol_pdepe(:,:,2);
	u2coexist = sol_pdepe(:,:,3);
	v2coexist = sol_pdepe(:,:,4);
	% global u1ss v1ss u2ss v2ss
	u1ss = u1coexist(end,1);
	v1ss = v1coexist(end,1);
	u2ss = u2coexist(end,1);
	v2ss = v2coexist(end,1);
	Jc = lpa_jacobian([u1ss,v1ss,u2ss,v2ss],a1,a2,b1,b2,c1,c2,s1,s2,k,n,T1,T2)
	eig(Jc)

	%RAC
	a = T1;
	b = 0;
	u1init = a;
	v1init = T1-a;
	u2init = b;
	v2init = T2-b;
  %solve the PDE
	sol_pdepe = pdepe(m,@pdefunction,@icfunction,@bcfunction,x,t);
  %get components of solution for plotting
	u1Rac = sol_pdepe(:,:,1);
  v1Rac = sol_pdepe(:,:,2);
	u2Rac = sol_pdepe(:,:,3);
	v2Rac = sol_pdepe(:,:,4);
	JR = lpa_jacobian([u1Rac(end,1),v1Rac(end,1),u2Rac(end,1),v2Rac(end,1)],a1,a2,b1,b2,c1,c2,s1,s2,k,n,T1,T2)
	eig(JR)

	%RAC
	a = 0;
	b = T2;
	u1init = a;
	v1init = T1-a;
	u2init = b;
	v2init = T2-b;
  %solve the PDE
	sol_pdepe = pdepe(m,@pdefunction,@icfunction,@bcfunction,x,t);
  %get components of solution for plotting
	u1Rho = sol_pdepe(:,:,1);
  v1Rho = sol_pdepe(:,:,2);
	u2Rho = sol_pdepe(:,:,3);
	v2Rho = sol_pdepe(:,:,4);
	JRho = lpa_jacobian([u1Rho(end,1),v1Rho(end,1),u2Rho(end,1),v2Rho(end,1)],a1,a2,b1,b2,c1,c2,s1,s2,k,n,T1,T2)
	eig(JRho)


	%Polarized
	% global pu1height pu2height
	pu1height = 10;
	pu2height = -1;
	%solve the PDE
	sol_pdepe = pdepe(m,@pdefunction,@icperturb,@bcfunction,x,t);
	%get components of solution for plotting
	u1Polar = sol_pdepe(:,:,1);
	v1Polar = sol_pdepe(:,:,2);
	u2Polar = sol_pdepe(:,:,3);
	v2Polar = sol_pdepe(:,:,4);
	% figure
	% subplot(2,2,1)
  % mesh(x,t,u1Polar)
  % subplot(2,2,2)
  % mesh(x,t,u2Polar)
  % subplot(2,2,3)
  % mesh(x,t,v1Polar)
  % subplot(2,2,4)
  % mesh(x,t,v2Polar)
	% title('pdepe run 1')
	% seaborncolors;
	% co(1,:) = [27,158,119]/255;
	% co(2,:) = [217,95,2]/255;
	% co(3,:) = [117,112,179]/255;
	width=7.5;
	height=2;
	x0 = 5;
	y0 = 5;
	fontsize = 12;
	f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
	Fig5a = subplot(1,4,1);
	xlabel(Fig5a,{'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	Fig5aTitle = title(Fig5a,{'(a)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
	set(Fig5a,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	grid
	Fig5a.Box = 'on';
	Fig5a.YLim = [0 4.5];
	hold on
	plot(x,u1Rac(end,:),'Color',co(1,:),'LineWidth',4)
	% plot(x,v1Rac(end,:),'--','Color',co(1,:),'LineWidth',4)
	plot(x,u2Rac(end,:),'--','Color',co(3,:),'LineWidth',2)
	% plot(x,v2Rac(end,:),'-.','Color',co(3,:),'LineWidth',2)
	legend({'$R$','$\rho$'},'Interpreter','latex','FontSize',8,'FontName','Times','Location','east')

	Fig5b = subplot(1,4,2);
	xlabel(Fig5b,{'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	Fig5bTitle = title(Fig5b,{'(b)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
	set(Fig5b,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	grid
	Fig5b.Box = 'on';
	Fig5b.YLim = [0 4.5];
	hold on
	plot(x,u1coexist(end,:),'Color',co(1,:),'LineWidth',4)
	% plot(x,v1coexist(end,:),'--','Color',co(1,:),'LineWidth',4)
	plot(x,u2coexist(end,:),'--','Color',co(3,:),'LineWidth',2)
	% plot(x,v2coexist(end,:),'-.','Color',co(3,:),'LineWidth',2)

	Fig5c = subplot(1,4,3);
	xlabel(Fig5c,{'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	Fig5cTitle = title(Fig5c,{'(c)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
	set(Fig5c,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	grid
	Fig5c.Box = 'on';
	Fig5c.YLim = [0 4.5];
	hold on
	plot(x,u1Polar(end,:),'Color',co(1,:),'LineWidth',4)
	% plot(x,v1Polar(end,:),'--','Color',co(1,:),'LineWidth',4)
	plot(x,u2Polar(end,:),'--','Color',co(3,:),'LineWidth',2)
	% plot(x,v2Polar(end,:),'-.','Color',co(3,:),'LineWidth',2)
	% legend({'$u_1$','$v_1$','$u_2$','$v_2$'},'Interpreter','latex','FontSize',8,'FontName','Times','Location','east')

	Fig5d = subplot(1,4,4);
	xlabel(Fig5d,{'$x$'},'FontUnits','points','Interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	Fig5cTitle = title(Fig5d,{'(d)'},'FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times');
	set(Fig5d,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fontsize,'FontName','Times')
	grid
	Fig5d.Box = 'on';
	Fig5d.YLim = [0 4.5];
	hold on
	plot(x,u1Rho(end,:),'Color',co(1,:),'LineWidth',4)
	% plot(x,v1Rho(end,:),'--','Color',co(1,:),'LineWidth',4)
	plot(x,u2Rho(end,:),'--','Color',co(3,:),'LineWidth',2)
	% plot(x,v2Rho(end,:),'-.','Color',co(3,:),'LineWidth',2)

	print(1,'Fig5','-depsc','-painters')

	function y = u1fun(u1,v1,u2,v2)
		y = (a1*u1.^n./(1+u1.^n)+b1*s1^n./(s1^n+u2.^n)+c1).*v1-u1;
	end
	function y = v1fun(u1,v1,u2,v2)
	  y = -u1fun(u1,v1,u2,v2);
	end
	function y = u2fun(u1,v1,u2,v2)
		y = (a2*u2.^n./(1+u2.^n)+b2*s2^n./(s2^n+u1.^n)+c2).*v2-k*u2;
	end
	function y = v2fun(u1,v1,u2,v2)
	  y = -u2fun(u1,v1,u2,v2);
	end

  %set up the PDES
	function [cpde,fpde,spde] = pdefunction(x,t,u,DuDx)
		cpde = [1;1;1;1]; %coeff of time derivatives
		fpde = [Du1*DuDx(1);Dv1*DuDx(2);Du2*DuDx(3);Dv2*DuDx(4)]; %flux terms
		spde = [u1fun(u(1),u(2),u(3),u(4));v1fun(u(1),u(2),u(3),u(4));u2fun(u(1),u(2),u(3),u(4));v2fun(u(1),u(2),u(3),u(4))]; %reaction terms
	end

	function u0 = icfunction(x)
		u0 = [u1init*ones(size(x));v1init*ones(size(x));u2init*ones(size(x));v2init*ones(size(x))];
	end

	function u0 = icperturb(x)
		pwidth=0.1;
		u0 = [u1ss+pu1height*(x<pwidth);v1ss-(pu1height*pwidth);u2ss+pu2height*(x<pwidth);v2ss-(pu2height*pwidth)];
	end

	function [pl,ql,pr,qr] = bcfunction(xl,ul,xr,ur,t)
    % This gives Neumann boundary conditions
		pl = [0;0;0;0];
		ql = [1;1;1;1];
    pr = [0;0;0;0];
		qr = [1;1;1;1];
  end
end
