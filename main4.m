%main.m
%Run this to perform the entire parameter sweep.
tic;
%Flags: if running on ACCRE, set accre = 1 (to get the largest number of cores for parpool)
accre = 1;

%Generate Latin Hypercube Sample of Parameter Space
% num = 1000;
% num = 10^6;
% LatinHypercubeSample;
load('X4.mat')
X = current;
num = size(X,1)

%set other model parameters
switch1 = 0.5;
switch2 = 0.5;
k = 1;
n = 3;


%Run the parameter screen
ParameterScreen;

save('main4.mat')

toc;