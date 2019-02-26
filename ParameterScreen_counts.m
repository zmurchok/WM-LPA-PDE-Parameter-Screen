%data processing
%this is slow becuase I was lazy and added indices to the end of the array

load('data.mat')
mono = find(len==1);
bist = find(len==2);
tris = find(len==3);

Totals = [length(mono);length(bist);length(tris)];


trisPolarCount = 0;
trisLPAallStable = 0;
trisLPAallUnstable = 0;
trisLPA2stable = 0;
trisLPA2unstable = 0;

trisPolar = [];
trisNonPolar = [];
trisAllStable = [];
tris2Stable = [];
tris1Stable = [];
trisAllUnstable = [];

for i = 1:length(tris)
  if ismember(1,LPAPolarizable{tris(i)})
    trisPolarCount = trisPolarCount + 1;
    trisPolar = [trisPolar; tris(i)];
  else
    trisNonPolar = [trisNonPolar; tris(i)];
  end
  if stability{tris(i)}(1) == 1 && stability{tris(i)}(2) == 1 && stability{tris(i)}(3) == 1
    trisLPAallStable = trisLPAallStable + 1;
    trisAllStable = [trisAllStable; tris(i)];
  elseif stability{tris(i)}(1) == -1 && stability{tris(i)}(2) == -1 && stability{tris(i)}(3) == -1
    trisLPAallUnstable = trisLPAallUnstable + 1;
    trisAllUnstable = [trisAllUnstable; tris(i)];
  elseif stability{tris(i)}(1) == 1 && stability{tris(i)}(2) == 1 && stability{tris(i)}(3) == -1
    trisLPA2stable = trisLPA2stable + 1;
    tris2Stable = [tris2Stable; tris(i)];
  elseif stability{tris(i)}(1) == 1 && stability{tris(i)}(2) == -1 && stability{tris(i)}(3) == 1
    trisLPA2stable = trisLPA2stable + 1;
    tris2Stable = [tris2Stable; tris(i)];
  elseif stability{tris(i)}(1) == -1 && stability{tris(i)}(2) == 1 && stability{tris(i)}(3) == 1
    trisLPA2stable = trisLPA2stable + 1;
    tris2Stable = [tris2Stable; tris(i)];
  elseif stability{tris(i)}(1) == -1 && stability{tris(i)}(2) == -1 && stability{tris(i)}(3) == 1
    trisLPA2unstable = trisLPA2unstable + 1;
    tris1Stable = [tris1Stable; tris(i)];
  elseif stability{tris(i)}(1) == -1 && stability{tris(i)}(2) == 1 && stability{tris(i)}(3) == -1
    trisLPA2unstable = trisLPA2unstable + 1;
    tris1Stable = [tris1Stable; tris(i)];
  elseif stability{tris(i)}(1) == 1 && stability{tris(i)}(2) == -1 && stability{tris(i)}(3) == -1
    trisLPA2unstable = trisLPA2unstable + 1;
    tris1Stable = [tris1Stable; tris(i)];
  end
end

bistPolarCount = 0;
bistLPAallStable = 0;
bistLPAallUnstable = 0;
bistLPAmixed = 0;

bistPolar = [];
bistNonPolar = [];
bistStable = [];
bistMixed = [];
bistUnstable = [];

for i = 1:length(bist)
  if ismember(1,LPAPolarizable{bist(i)})
    bistPolarCount = bistPolarCount + 1;
    bistPolar = [bistPolar; bist(i)];
  else
    bistNonPolar = [bistNonPolar; bist(i)];
  end
  if stability{bist(i)}(1) == 1 && stability{bist(i)}(2) == 1
    bistLPAallStable = bistLPAallStable + 1;
    bistStable = [bistStable; bist(i)];
  elseif stability{bist(i)}(1) == -1 && stability{bist(i)}(2) == -1
    bistLPAallUnstable = bistLPAallUnstable + 1;
    bistUnstable = [bistUnstable; bist(i)];
  else
    bistLPAmixed = bistLPAmixed + 1;
    bistMixed = [bistMixed; bist(i)];
  end
end

monoPolarCount = 0;
monoLPAStable = 0;
monoPolar = [];
monoNonPolar = [];
monoStable = [];
monoUnstable = [];

for i = 1:length(mono)
  if ismember(1,LPAPolarizable{mono(i)})
    monoPolarCount = monoPolarCount + 1;
    monoPolar = [monoPolar; mono(i)];
  else
    monoNonPolar = [monoNonPolar; mono(i)];
  end
  if stability{mono(i)} == 1
    monoLPAStable = monoLPAStable + 1;
    monoStable = [monoStable; mono(i)];
  else
    monoUnstable = [monoUnstable; mono(i)];
  end
end

% monoLPAStable
monoLPAUnstable = length(mono) - monoLPAStable;
%
% bistLPAallStable
% bistLPAallUnstable
% bistLPAmixed
%
% trisLPAallStable
% trisLPAallUnstable
% trisLPA2stable
% trisLPA2unstable

Polar = [monoPolarCount;bistPolarCount;trisPolarCount];
nonPolar = Totals - Polar;

Data = [Totals,Polar,nonPolar,[monoLPAStable,monoLPAUnstable,NaN,NaN;bistLPAallStable,bistLPAmixed,bistLPAallUnstable,NaN;trisLPAallStable,trisLPA2stable,trisLPA2unstable,trisLPAallUnstable]];
Data

save('data_counted')
