clear all
load('data_PDEscreen.mat')
%PDE screen processing
%this is slow becuase I was lazy and added indices to the end of the array
trisPDEPolarCount = 0;
trisPDEPolar = [];
trisPDENonPolarCount = 0;
trisPDENonPolar = [];

trisPDEAllNoisePolar = [];
trisPDETwoNoisePolar = [];
trisPDEOneNoisePolar = [];
trisPDENoNoisePolar = [];
trisPDEAllNoisePolarCount = 0;
trisPDETwoNoisePolarCount = 0;
trisPDEOneNoisePolarCount = 0;
trisPDENoNoisePolarCount = 0;
for i = 1:length(tris)
  if y_noise{tris(i)}(1) == 1 && y_noise{tris(i)}(2) == 1 && y_noise{tris(i)}(3) == 1
    %all noise POLAR
    trisPDEAllNoisePolarCount = trisPDEAllNoisePolarCount + 1;
    trisPDEAllNoisePolar = [trisPDEAllNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 1 && y_noise{tris(i)}(2) == 0 && y_noise{tris(i)}(3) == 0
    %one noise POLAR
    trisPDEOneNoisePolarCount = trisPDEOneNoisePolarCount + 1;
    trisPDEOneNoisePolar = [trisPDEOneNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 0 && y_noise{tris(i)}(2) == 1 && y_noise{tris(i)}(3) == 0
    %one noise POLAR
    trisPDEOneNoisePolarCount = trisPDEOneNoisePolarCount + 1;
    trisPDEOneNoisePolar = [trisPDEOneNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 0 && y_noise{tris(i)}(2) == 0 && y_noise{tris(i)}(3) == 1
    %one noise POLAR
    trisPDEOneNoisePolarCount = trisPDEOneNoisePolarCount + 1;
    trisPDEOneNoisePolar = [trisPDEOneNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 0 && y_noise{tris(i)}(2) == 1 && y_noise{tris(i)}(3) == 1
    %two noise POLAR
    trisPDETwoNoisePolarCount = trisPDETwoNoisePolarCount + 1;
    trisPDETwoNoisePolar = [trisPDETwoNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 1 && y_noise{tris(i)}(2) == 0 && y_noise{tris(i)}(3) == 1
    %two noise POLAR
    trisPDETwoNoisePolarCount = trisPDETwoNoisePolarCount + 1;
    trisPDETwoNoisePolar = [trisPDETwoNoisePolar; tris(i)];
  elseif y_noise{tris(i)}(1) == 1 && y_noise{tris(i)}(2) == 1 && y_noise{tris(i)}(3) == 0
    %two noise POLAR
    trisPDETwoNoisePolarCount = trisPDETwoNoisePolarCount + 1;
    trisPDETwoNoisePolar = [trisPDETwoNoisePolar; tris(i)];
  else
    %three noise stable (no polar from noise)
    trisPDENoNoisePolarCount = trisPDENoNoisePolarCount + 1;
    trisPDENoNoisePolar = [trisPDENoNoisePolar; tris(i)];
  end
  %%
  if ismember(1,y_polar{tris(i)})
    trisPDEPolarCount = trisPDEPolarCount + 1;
    trisPDEPolar = [trisPDEPolar; tris(i)];
  else
    trisPDENonPolarCount = trisPDENonPolarCount + 1;
    trisPDENonPolar = [trisPDENonPolar; tris(i)];
  end
end

bistPDEBothNoisePolarCount = 0;
bistPDEBothNoisePolar = [];
bistPDEOneNoisePolarCount = 0;
bistPDEOneNoisePolar = [];
bistPDENoiseNonPolarCount = 0;
bistPDENoiseNonPolar = [];
%%
bistPDEPolarCount = 0;
bistPDEPolar = [];
bistPDENonPolarCount = 0;
bistPDENonPolar = [];

for i = 1:length(bist)
  if y_noise{bist(i)}(1) == 1 && y_noise{bist(i)}(2) == 1
    %both HSS noise polar
    bistPDEBothNoisePolarCount = bistPDEBothNoisePolarCount + 1;
    bistPDEBothNoisePolar = [bistPDEBothNoisePolar; bist(i)];
  elseif y_noise{bist(i)}(1) == 0 && y_noise{bist(i)}(2) == 1
    %one HSS noise polar
    bistPDEOneNoisePolarCount = bistPDEOneNoisePolarCount + 1;
    bistPDEOneNoisePolar = [bistPDEOneNoisePolar; bist(i)];
  elseif y_noise{bist(i)}(1) == 1 && y_noise{bist(i)}(2) == 0
    %one HSS noise polar
    bistPDEOneNoisePolarCount = bistPDEOneNoisePolarCount + 1;
    bistPDEOneNoisePolar = [bistPDEOneNoisePolar; bist(i)];
  else
    %zero HSS noise polar (i.e. both HSS are noise stable)
    bistPDENoiseNonPolarCount = bistPDENoiseNonPolarCount + 1;
    bistPDENoiseNonPolar = [bistPDENoiseNonPolar; bist(i)];
  end
  %%
  if ismember(1,y_polar{bist(i)})
    bistPDEPolarCount = bistPDEPolarCount + 1;
    bistPDEPolar = [bistPDEPolar; bist(i)];
  else
    bistPDENonPolarCount = bistPDENonPolarCount + 1;
    bistPDENonPolar = [bistPDENonPolar; bist(i)];
  end
end

monoPDENoisePolarCount = 0;
monoPDENoiseNonPolarCount = 0;
monoPDENoisePolar = [];
monoPDENoiseNonPolar = [];
monoPDEPolarCount = 0;
monoPDENonPolarCount = 0;
monoPDEPolar = [];
monoPDENonPolar = [];

for i = 1:length(mono)
  if ismember(1,y_noise{mono(i)})
    monoPDENoisePolarCount = monoPDENoisePolarCount + 1;
    monoPDENoisePolar = [monoPDENoisePolar; mono(i)];
  else
    monoPDENoiseNonPolarCount = monoPDENoiseNonPolarCount + 1;
    monoPDENoiseNonPolar = [monoPDENoiseNonPolar; mono(i)];
  end
  if ismember(1,y_polar{mono(i)})
    monoPDEPolarCount = monoPDEPolarCount + 1;
    monoPDEPolar = [monoPDEPolar; mono(i)];
  else
    monoPDENonPolarCount = monoPDENonPolarCount + 1;
    monoPDENonPolar = [monoPDENonPolar; mono(i)];
  end
end



save('data_PDE_screen_counted')
