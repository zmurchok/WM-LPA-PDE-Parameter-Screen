seaborncolors;


global cds sys

sys.gui.pausespecial=0;  %Pause at special points
sys.gui.pausenever=1;    %Pause never
sys.gui.pauseeachpoint=0; %Pause at each point

width=5;
height=5;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Fig6a_driver
Fig6b_driver
Fig6c_new
Fig6d_PDE_driver


print(1,'Fig6','-depsc','-painters')
