import matplotlib.pyplot as plt
from matplotlib import cm
import numpy as np
from mpl_toolkits.axes_grid1 import ImageGrid
import matplotlib.tri as tri



plt.rc("text", usetex=False)
plt.rc("font", family="sans-serif", size=10)

def mytif(u,v,triangs,t):
    fig = plt.figure("fig1",figsize=(1.625,1.625))
    ax1 = plt.subplot(111)
    p1 = ax1.tripcolor(triangs, u[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # cbar = fig.colorbar(p1)
    # cbar.outline.set_linewidth(1.5)
    # cbar.ax.tick_params(width=1.5)
    # ax1.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax1.set_xlabel(r'$x$')
    # ax1.set_ylabel(r'$y$')
    ax1.spines["left"].set_linewidth(1.5)
    ax1.spines["top"].set_linewidth(1.5)
    ax1.spines["right"].set_linewidth(1.5)
    ax1.spines["bottom"].set_linewidth(1.5)
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    # ax1.set_title(r'$R$')
    ax1.set_facecolor((0.7,0.7,0.7))
    plt.tight_layout()
    filename = 'img%04d_R.tif' % t
    fig.savefig(filename,dpi=300)
    plt.close(fig)

    fig = plt.figure("fig1",figsize=(1.625,1.625))
    ax2 = plt.subplot(111)
    p2 = ax2.tripcolor(triangs, v[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax2.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax2.set_xlabel(r'$x$')
    # ax2.set_ylabel(r'$y$')
    ax2.spines["left"].set_linewidth(1.5)
    ax2.spines["top"].set_linewidth(1.5)
    ax2.spines["right"].set_linewidth(1.5)
    ax2.spines["bottom"].set_linewidth(1.5)
    ax2.get_xaxis().set_ticks([])
    ax2.get_yaxis().set_ticks([])
    # ax2.set_title(r'$\rho$')
    ax2.set_facecolor((0.7,0.7,0.7))
    plt.tight_layout()
    filename = 'img%04d_p.tif' % t
    fig.savefig(filename,dpi=300)
    plt.close(fig)

    #colorbar

Rac = np.load('u1.npy')
Rho = np.load('u2.npy')
x = np.load('x.npy')
y = np.load('y.npy')
triangles = np.load('triangles.npy')
triangs = tri.Triangulation(x,y,triangles)

print(np.max(Rac[:,-1]))
print(np.min(Rac[:,-1]))
print(np.max(Rac[:,-1])-np.min(Rac[:,-1]))
print(np.max(Rho[:,-1]))
print(np.min(Rho[:,-1]))
print(np.max(Rho[:,-1])-np.min(Rho[:,-1]))

mytif(Rac,Rho,triangs,0)

mytif(Rac,Rho,triangs,Rac.shape[1]-1)
