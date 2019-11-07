seaborncolors;


global cds sys

sys.gui.pausespecial=0;  %Pause at special points
sys.gui.pausenever=1;    %Pause never
sys.gui.pauseeachpoint=0; %Pause at each point

width=6.75;
height=2.25;
x0 = 5;
y0 = 5;
fontsize = 12;
f = figure('Units','inches','Position',[x0 y0 width height],'PaperPositionMode','auto');
Fig7a_driver
Fig7b_driver
Fig7c_driver



print(1,'Fig7','-depsc','-painters')
