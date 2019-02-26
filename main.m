%main.m
%Run this to perform the entire parameter sweep.
tic;
%Flags: if running on ACCRE, set accre = 1 (to get the largest number of cores for parpool)
accre = 1;

%Generate Latin Hypercube Sample of Parameter Space
%num = 1000;
num = 10^6;
LatinHypercubeSample;

%Run the parameter screen
ParameterScreen;
toc;
