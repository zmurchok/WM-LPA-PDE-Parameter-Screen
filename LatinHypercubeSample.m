%generates a Latin Hypercube Sample (LHS) of num samples with parameters a,b,c,T1,T2 in the range [0,pmax] where pmax is the max value of the parameter range

X = lhsdesign(num,5);
%a b c t1 t2 <--- active params
%X has num rows and 5 columns with each entry between 0 and 1.
%We still need to scale the entries to get a sample of in the desired intervals

%range for each param is 0 to parammax
amax = 5;
bmax = 5;
cmax = 0.25;
T1max = 5;
T2max = 5;

A = diag([amax,bmax,cmax,T1max,T2max]); %build diagonal matrix to ste
X = X*A; %scale each column of lhsdesign matrix X by parammax



%save('X.mat',X) %uncomment this to save LHS