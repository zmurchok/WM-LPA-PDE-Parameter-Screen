#distance to com plots
#first run dataprocessing.m
#then run this file

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import seaborn as sns
# %matplotlib inline
import scipy.io as sio

sns.set(style="white")


from pylab import rcParams
from matplotlib import rc

# rcParams.update({'figure.figsize': (6.5,3)})
storage = sio.loadmat('for_python_FigSI4.mat')
d = storage['storage']
df = pd.DataFrame(data=d,columns=['a','b','c','T_1','T_2','Stability','Branch'])

top = df[df['Branch']==3.0]
top = top.reset_index()
top.head()

middle = df[df['Branch']==2.0]
middle = middle.reset_index()
middle.head()

bottom = df[df['Branch']==1.0]
bottom = bottom.reset_index()
bottom.head()

topbar = top.mean()
middlebar = middle.mean()
bottombar = bottom.mean()
print(topbar,middlebar,bottombar)

top['Distance to COM'] = np.sqrt((top['a']-topbar['a'])**2 + (top['b']-topbar['b'])**2 \
                    + (top['c']-topbar['c'])**2 + (top['T_1']-topbar['T_2'])**2 \
                    + (top['T_2']-topbar['T_2'])**2)

middle['Distance to COM'] = np.sqrt((middle['a']-middlebar['a'])**2 + (middle['b']-middlebar['b'])**2 \
                    + (middle['c']-middlebar['c'])**2 + (middle['T_1']-middlebar['T_2'])**2 \
                    + (middle['T_2']-middlebar['T_2'])**2)

bottom['Distance to COM'] = np.sqrt((bottom['a']-bottombar['a'])**2 + (bottom['b']-bottombar['b'])**2 \
                    + (bottom['c']-bottombar['c'])**2 + (bottom['T_1']-bottombar['T_2'])**2 \
                    + (bottom['T_2']-bottombar['T_2'])**2)


frames = [top,middle,bottom]
dist_to_com = pd.concat(frames)
dist_to_com.loc[dist_to_com['Branch']==3.0, 'Branch'] = 'Rac Dominated'
dist_to_com.loc[dist_to_com['Branch']==2.0, 'Branch'] = 'Coexistence'
dist_to_com.loc[dist_to_com['Branch']==1.0, 'Branch'] = 'Rho Dominated'
dist_to_com.loc[dist_to_com['Stability']==-1, 'Stability'] = 'LPA Unstable'
dist_to_com.loc[dist_to_com['Stability']==1, 'Stability'] = 'LPA Stable'

g = sns.catplot(palette={"LPA Stable": [0.3,0.3,0.3], "LPA Unstable": [1,0,0]},x="Branch",y="Distance to COM",hue="Stability",kind="box",data=dist_to_com, height=3,aspect=1.3,legend=False)
plt.legend(loc='upper right')
plt.savefig('Distance to COM.eps')


n = 50000
inside = []
annulus = []
outside = []
for i in range(0,n):
    x = 1.25*(2*np.random.rand(1,5)-1)
    r = np.linalg.norm(x)
    if r <= 1:
        inside.append(x)
    elif r <= 1.25:
        annulus.append(x)
    else:
        outside.append(x)

inside = np.array(inside)
inside = inside[:,0,:]
insidedf = pd.DataFrame(data=inside,columns=['x1','x2','x3','x4','x5'])
insidedf['Location'] = 'Sphere'
insidedf.head()

annulus = np.array(annulus)
annulus = annulus[:,0,:]
annulusdf = pd.DataFrame(data=annulus,columns=['x1','x2','x3','x4','x5'])
annulusdf['Location'] = 'Annulus'
annulusdf.head()

frames = [insidedf,annulusdf]
spheredata = pd.concat(frames)

COM = spheredata.mean()
COM


spheredata['Distance to COM'] = np.sqrt((spheredata['x1']-COM['x1'])**2 + (spheredata['x2']-COM['x2'])**2 \
                    + (spheredata['x3']-COM['x3'])**2 + (spheredata['x4']-COM['x4'])**2 \
                    + (spheredata['x5']-COM['x5'])**2)
spheredata.head()


sns.catplot(palette={"Sphere": [0.3,0.3,0.3], "Annulus": [1,0,0]},x="Location",y="Distance to COM",kind="box",data=spheredata,height=3,aspect=0.7)
plt.savefig('Distance to COM Sphere.eps')


from mpl_toolkits.mplot3d import Axes3D
fig = plt.figure(figsize=(5,5))
ax = fig.add_subplot(111, projection='3d')
ax.scatter(insidedf['x1'],insidedf['x2'],insidedf['x3'],color=[0.3,0.3,0.3],marker="o")
ax.scatter(annulusdf['x1'],annulusdf['x2'],annulusdf['x3'],color=[1,0,0],marker="o",alpha=0.1)
ax.set_axis_off()
plt.tight_layout()
plt.savefig('sphere.tif',dpi=1200)
