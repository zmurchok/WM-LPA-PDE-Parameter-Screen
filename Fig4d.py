import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib as mpl
import numpy as np
import seaborn as sns
from mpl_toolkits.axes_grid1 import ImageGrid

sns.set(style="white")

from pylab import rcParams
from matplotlib import rc

rc('font',**{'family':'serif','serif':['Times']})

#%%
cmap = [(0.2980392156862745, 0.4470588235294118, 0.6901960784313725),(0.8666666666666667, 0.5176470588235295, 0.3215686274509804,),(0.3333333333333333, 0.6588235294117647, 0.40784313725490196)]

#%%
# https://matplotlib.org/3.1.0/gallery/lines_bars_and_markers/barchart.html#sphx-glr-gallery-lines-bars-and-markers-barchart-py

activeRac1D = (0.7424,0.6906,0.6996)
activeRac2D = (0.7415728625647552,0.7114243848272865,0.7153789164010497)
activeRho1D = (0.7035,0.7072,0.7454)
activeRho2D = (0.7206731070871909,0.7168211531628713,0.7444201599778206)

maxminRac1D = (0.5158,2.0596,1.7240)
maxminRac2D = (0.42822761550184674,1.9888636856289517,1.6062536478218994)
maxminRho1D = (1.7017,2.0492,0.4956)
maxminRho2D = (1.5523195099403309,1.9728758683451602,0.44185477848968135)

ind = np.arange(len(activeRac1D))
width = 0.4

fig, ax1 = plt.subplots(figsize=(2.5,2.5))
gR2d = ax1.bar(ind-width/2,maxminRac2D,width,label="Rac",color=cmap,edgecolor=cmap)
gp2d = ax1.bar(ind+width/2,maxminRho2D,width,label="Rho",color='w',edgecolor=cmap,hatch='////')
ax1.spines["left"].set_linewidth(1.5)
ax1.spines["top"].set_linewidth(1.5)
ax1.spines["right"].set_linewidth(1.5)
ax1.spines["bottom"].set_linewidth(1.5)
ax1.set_ylabel('max - min')
ax1.set_yticks((0,0.5,1,1.5,2))
ax1.grid()

ax1.legend(loc='center right',fontsize=8)
leg = ax1.get_legend()
leg.legendHandles[0].set_edgecolor('k')
leg.legendHandles[0].set_color('k')
leg.legendHandles[1].set_edgecolor('k')

ax1.set_xlabel('Polarity type')

ax1.set_xticks(ind)
ax1.set_xticklabels(('(a)', '(b)', '(c)'))

plt.tight_layout()
fig.savefig('2d_data.tif',dpi=600)
plt.show()
