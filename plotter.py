import matplotlib.pyplot as plt
from matplotlib import cm
import numpy as np
from mpl_toolkits.axes_grid1 import ImageGrid
import matplotlib.tri as tri



plt.rc("text", usetex=False)
plt.rc("font", family="sans-serif", size=10)

def myplot(u,v,triangs,t):
    fig = plt.figure("fig1",figsize=(6.4,3.6))
    grid = ImageGrid(fig, 111,          # as in plt.subplot(111)
                     nrows_ncols=(1,2),
                     axes_pad=0.1,
                     share_all=True,
                     cbar_location="right",
                     cbar_mode="single",
                     cbar_size="7%",
                     cbar_pad=0.1,)
    ax1 = grid[0]
    p1 = ax1.tripcolor(triangs, u[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax1.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax1.set_xlabel(r'$x$')
    # ax1.set_ylabel(r'$y$')
    ax1.spines["left"].set_linewidth(1.5)
    ax1.spines["top"].set_linewidth(1.5)
    ax1.spines["right"].set_linewidth(1.5)
    ax1.spines["bottom"].set_linewidth(1.5)
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax1.set_title(r'$R$')
    ax1.set_facecolor((0.7,0.7,0.7))

    ax2 = grid[1]
    p2 = ax2.tripcolor(triangs, v[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax2.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax2.set_xlabel(r'$x$')
    # ax2.set_ylabel(r'$y$')
    ax2.spines["left"].set_linewidth(1.5)
    ax2.spines["top"].set_linewidth(1.5)
    ax2.spines["right"].set_linewidth(1.5)
    ax2.spines["bottom"].set_linewidth(1.5)
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax2.set_title(r'$\rho$')
    ax2.set_facecolor((0.7,0.7,0.7))

    #colorbar
    cbar = fig.colorbar(p1,cax=ax1.cax)
    cbar.outline.set_linewidth(1.5)
    cbar.ax.tick_params(width=1.5)

    #save
    filename = 'img%04d.png' % t
    fig.savefig(filename,dpi=300)
    plt.close(fig)

def mytif(u,v,triangs,t):
    fig = plt.figure("fig1",figsize=(6.4,3.6))
    grid = ImageGrid(fig, 111,          # as in plt.subplot(111)
                     nrows_ncols=(1,2),
                     axes_pad=0.1,
                     share_all=True,
                     cbar_location="right",
                     cbar_mode="single",
                     cbar_size="7%",
                     cbar_pad=0.1,)
    ax1 = grid[0]
    p1 = ax1.tripcolor(triangs, u[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax1.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax1.set_xlabel(r'$x$')
    # ax1.set_ylabel(r'$y$')
    ax1.spines["left"].set_linewidth(1.5)
    ax1.spines["top"].set_linewidth(1.5)
    ax1.spines["right"].set_linewidth(1.5)
    ax1.spines["bottom"].set_linewidth(1.5)
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax1.set_title(r'$R$')
    ax1.set_facecolor((0.7,0.7,0.7))

    ax2 = grid[1]
    p2 = ax2.tripcolor(triangs, v[:,t], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax2.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax2.set_xlabel(r'$x$')
    # ax2.set_ylabel(r'$y$')
    ax2.spines["left"].set_linewidth(1.5)
    ax2.spines["top"].set_linewidth(1.5)
    ax2.spines["right"].set_linewidth(1.5)
    ax2.spines["bottom"].set_linewidth(1.5)
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax2.set_title(r'$\rho$')
    ax2.set_facecolor((0.7,0.7,0.7))

    #colorbar
    cbar = fig.colorbar(p1,cax=ax1.cax)
    cbar.outline.set_linewidth(1.5)
    cbar.ax.tick_params(width=1.5)

    #save
    filename = 'img%04d.tif' % t
    fig.savefig(filename,dpi=300)
    plt.close(fig)


Rac = np.load('u1.npy')
Rho = np.load('u2.npy')
x = np.load('x.npy')
y = np.load('y.npy')
triangles = np.load('triangles.npy')
triangs = tri.Triangulation(x,y,triangles)

np.shape(Rac)

# myplot(Rac,Rho,triangs,1500-1)

# for i in range(0,len(Rac[0,:]),10):
#     myplot(Rac,Rho,triangs,i)


movie = 1
if movie == 1:
    import matplotlib.animation as animation
    fig = plt.figure("fig1",figsize=(6.4,3.6))
    grid = ImageGrid(fig, 111,          # as in plt.subplot(111)
                     nrows_ncols=(1,2),
                     axes_pad=0.1,
                     share_all=True,
                     cbar_location="right",
                     cbar_mode="single",
                     cbar_size="7%",
                     cbar_pad=0.1,)
    ax1 = grid[0]
    p1 = ax1.tripcolor(triangs, Rac[:,0], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax1.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax1.set_xlabel(r'$x$')
    # ax1.set_ylabel(r'$y$')
    ax1.spines["left"].set_linewidth(1.5)
    ax1.spines["top"].set_linewidth(1.5)
    ax1.spines["right"].set_linewidth(1.5)
    ax1.spines["bottom"].set_linewidth(1.5)
    ax1.set_title(r'$R$')
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax1.set_facecolor((0.7,0.7,0.7))

    ax2 = grid[1]
    p2 = ax2.tripcolor(triangs, Rho[:,0], shading='gouraud', cmap=cm.hot, vmin=0, vmax=2.5)
    # ax2.tick_params(axis="both", direction="in", which="both", right=True, top=True, labelsize=10 , width=1.5)
    # ax2.set_xlabel(r'$x$')
    # ax2.set_ylabel(r'$y$')
    ax2.spines["left"].set_linewidth(1.5)
    ax2.spines["top"].set_linewidth(1.5)
    ax2.spines["right"].set_linewidth(1.5)
    ax2.spines["bottom"].set_linewidth(1.5)
    ax2.set_title(r'$\rho$')
    ax1.get_xaxis().set_ticks([])
    ax1.get_yaxis().set_ticks([])
    ax2.set_facecolor((0.7,0.7,0.7))

    #colorbar
    cbar = fig.colorbar(p1,cax=ax1.cax)
    cbar.outline.set_linewidth(1.5)
    cbar.ax.tick_params(width=1.5)

    def animate(i):
        p1.set_array(Rac[:,i])
        p2.set_array(Rho[:,i])
        return p1, p2

    ani = animation.FuncAnimation(fig,animate,frames=range(0,len(Rac[0,:]),50)) #len(Rac[0,:])
    ani.save('Movie.mp4',fps=30,dpi=300)
