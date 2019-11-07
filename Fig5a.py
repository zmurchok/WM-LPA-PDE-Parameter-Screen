from __future__ import print_function
from fenics import *
from mshr import *
import time
import csv
import numpy as np
import matplotlib.tri as tri
import matplotlib.pyplot as plt
import time

start = time.time()

set_log_active(False)

def mesh2triang(mesh):
    xy = mesh.coordinates()
    return tri.Triangulation(xy[:, 0], xy[:, 1], mesh.cells())

p = 1 #order of interpolation

domain = Circle(Point(0, 0), np.sqrt(1/np.pi))
mesh = generate_mesh(domain, 40)
# parameters["form_compiler"]["quadrature_degree"] = 2*p+1
plot(mesh)
plt.savefig('mesh.eps')
V = FunctionSpace(mesh,'P', p)

# Neumann boundary is default
#def boundary(x, on_boundary):
#    return on_boundary

theta = 0.5 # 1: bw euler, 0: fw euler, 0.5: C-N

t0 = 0. # initial time
T = 50 #15. # T = 30. # final time
t = t0   #current time
dt = 1e-3 # time step
nt = int(T/dt) # number of time steps
drawPerIter = 50

a = 3.8941
b = 0.4476
c = 0.0223
RT = 1.8466
pT = 1.8678

Du = 0.01
Dv = 10.
s = 0.5
n = 3

u1height = -0.0082
u1eq = 1.4230
# v1eq = RT-u1eq-u1height*0.1*0.1
v1eq = RT-u1eq-u1height*0.25

u2height = 4.4212
u2eq = 0.0764
# v2eq = pT-u2eq-u2height*0.1*0.1
v2eq = pT-u2eq-u2height*0.25


# u1_old = Expression('x[1] < 0.45 && x[1] > 0.35 && x[0] < 0.05 && x[0] > -0.05 ? u1height : u1eq', degree=p,u1height=u1height+u1eq,u1eq=u1eq)
u1_old = Expression('x[1] > x[0] && x[1] > -x[0] && x[0]*x[0] + x[1]*x[1] < 0.5641 ? u1height : u1eq', degree=p,u1height=u1height+u1eq,u1eq=u1eq)

u1_old = interpolate(u1_old, V)
v1_old = Expression('v1eq',degree=p, v1eq=v1eq)
v1_old = interpolate(v1_old, V)

# u2_old = Expression('x[1] < 0.45 && x[1] > 0.35 && x[0] < 0.05 && x[0] > -0.05 ? u2height : u2eq', degree=p,u2height=u2height+u2eq,u2eq=u2eq)
u2_old = Expression('x[1] > x[0] && x[1] > -x[0] && x[0]*x[0] + x[1]*x[1] < 0.5641 ? u2height : u2eq', degree=p,u2height=u2height+u2eq,u2eq=u2eq)

u2_old = interpolate(u2_old, V)
v2_old = Expression('v2eq',degree=p, v2eq=v2eq)
v2_old = interpolate(v2_old, V)

u1 = TrialFunction(V)
v1 = TrialFunction(V)
u2 = TrialFunction(V)
v2 = TrialFunction(V)

z = TestFunction(V)

Bu1 = (u1*z + theta*dt*Du*dot(grad(u1), grad(z)))*dx
Bv1 = (v1*z + theta*dt*Dv*dot(grad(v1), grad(z)))*dx
Bu2 = (u2*z + theta*dt*Du*dot(grad(u2), grad(z)))*dx
Bv2 = (v2*z + theta*dt*Dv*dot(grad(v2), grad(z)))*dx

u1 = Function(V, name='u1')
u1.assign(u1_old)
v1 = Function(V, name='v1')
v1.assign(v1_old)
u2 = Function(V, name='u2')
u2.assign(u2_old)
v2 = Function(V, name='v2')
v2.assign(v2_old)

u1total=assemble(u1*dx)
# print(u1total)
v1total=assemble(v1*dx)
# print(v1total)
totalRac=u1total+v1total
# print(totalRac)

u2total=assemble(u2*dx)
# print(u2total)
v2total=assemble(v2*dx)
# print(v2total)
totalRho=u2total+v2total
# print(totalRho)


# foldername = '3d_data'
# resultsu1 = File(foldername+'/CN_u1.pvd')
# resultsu1 << (u1, t)
# resultsv1 = File(foldername+'/CN_v1.pvd')
# resultsv1 << (v1, t)
# resultsu2 = File(foldername+'/CN_u2.pvd')
# resultsu2 << (u2, t)
# resultsv2 = File(foldername+'/CN_v2.pvd')
# resultsv2 << (v2, t)
csvfile = csv.writer(open('total.csv', 'w'))
RacProp = u1total/totalRac
RhoProp = u2total/totalRho
csvfile.writerow([t] + [RacProp] + [RhoProp] + [totalRac] + [totalRho])

numdof = np.shape(mesh.coordinates())[0]
u1_storage = np.empty([numdof,nt])
v1_storage = np.empty([numdof,nt])
u2_storage = np.empty([numdof,nt])
v2_storage = np.empty([numdof,nt])

for k in range(nt):
    t += dt
    print('Step = ', k+1, '/', nt , 'Time =', t, 'Total Rac = ', totalRac, 'Total Rho', totalRho)

    f = (a*u1_old**n/(1+u1_old**n)+b*s**n/(s**n+u2_old**n)+c)*v1_old - u1_old
    g = (a*u2_old**n/(1+u2_old**n)+b*s**n/(s**n+u1_old**n)+c)*v2_old - u2_old

    RHSu1 = (u1_old*z - (1.-theta)*Du*dt*dot(grad(u1_old),grad(z)) + dt*f*z)*dx
    RHSv1 = (v1_old*z - (1.-theta)*Dv*dt*dot(grad(v1_old),grad(z)) - dt*f*z)*dx
    RHSu2 = (u2_old*z - (1.-theta)*Du*dt*dot(grad(u2_old),grad(z)) + dt*g*z)*dx
    RHSv2 = (v2_old*z - (1.-theta)*Dv*dt*dot(grad(v2_old),grad(z)) - dt*g*z)*dx

    solve(Bu1 == RHSu1, u1)
    solve(Bv1 == RHSv1, v1)
    solve(Bu2 == RHSu2, u2)
    solve(Bv2 == RHSv2, v2)

    if (k+1) % drawPerIter == 0:
        # resultsu1 << (u1, t)
        # resultsv1 << (v1, t)
        # resultsu2 << (u2, t)
        # resultsv2 << (v2, t)
        u1total=assemble(u1*dx)
        v1total=assemble(v1*dx)
        totalRac=u1total+v1total
        u2total=assemble(u2*dx)
        v2total=assemble(v2*dx)
        totalRho=u2total+v2total
        RacProp = u1total/totalRac
        RhoProp = u2total/totalRho
        csvfile.writerow([t] + [RacProp] + [RhoProp] + [totalRac] + [totalRho])

    u1_storage[:,k] = u1.compute_vertex_values(mesh)
    v1_storage[:,k] = v1.compute_vertex_values(mesh)
    u2_storage[:,k] = u2.compute_vertex_values(mesh)
    v2_storage[:,k] = v2.compute_vertex_values(mesh)

    u1_old.assign(u1)
    v1_old.assign(v1)
    u2_old.assign(u2)
    v2_old.assign(v2)

#save data for plotting later
np.save('u1.npy',u1_storage)
np.save('v1.npy',v1_storage)
np.save('u2.npy',u2_storage)
np.save('v2.npy',v2_storage)

triangs = mesh2triang(mesh)
x = np.array(triangs.x)
y = np.array(triangs.y)
triangles = np.array(triangs.triangles)
np.save('x.npy',x)
np.save('y.npy',y)
np.save('triangles.npy',triangles)

end = time.time()
print(end-start)
