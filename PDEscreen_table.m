%counting for table


%LPA TABLE:


%mono
length(mono)
length(monoPolar)
length(monoUnstable)
length(intersect(monoNonPolar,monoStable))

%bist
length(bist)
length(intersect(bistPolar,bistStable))
length(union(bistUnstable,bistMixed))
length(intersect(bistNonPolar,bistStable))

%tris
length(tris)
length(intersect(trisAllStable,trisPolar))
length(union(union(trisAllUnstable,tris1Stable),tris2Stable))
length(intersect(trisNonPolar,trisAllStable))









%%%%%%
%%PDE TABLE
%
% length(trisPDEPolar)
length(intersect(trisPDEPolar,trisPDENoNoisePolar))
length(intersect(trisPDEPolar,union(union(trisPDEOneNoisePolar,trisPDETwoNoisePolar),trisPDEAllNoisePolar)))
length(trisPDENonPolar)

% length(bistPDEPolar)
length(intersect(bistPDEPolar,bistPDENoiseNonPolar))
length(intersect(bistPDEPolar,union(bistPDEOneNoisePolar,bistPDEBothNoisePolar)))
length(bistPDENonPolar)

% length(monoPDEPolar)
length(intersect(monoPDEPolar,monoPDENoiseNonPolar))
length(intersect(monoPDEPolar,monoPDENoisePolar))
length(monoPDENonPolar)


%TOTAL COUNTS

%ALL LPA POLAR:
A = union(monoPolar,monoUnstable);
B = union(intersect(bistPolar,bistStable),union(bistUnstable,bistMixed));
C = union(intersect(trisAllStable,trisPolar),union(union(trisAllUnstable,tris1Stable),tris2Stable));
ALLLPAPOLAR = union(union(A,B),C);

%ALL PDE POLAR
A1 = union(intersect(monoPDEPolar,monoPDENoiseNonPolar),intersect(monoPDEPolar,monoPDENoisePolar));
B1 = union(intersect(bistPDEPolar,bistPDENoiseNonPolar),intersect(bistPDEPolar,union(bistPDEOneNoisePolar,bistPDEBothNoisePolar)));
C1 = union(intersect(trisPDEPolar,trisPDENoNoisePolar),intersect(trisPDEPolar,union(union(trisPDEOneNoisePolar,trisPDETwoNoisePolar),trisPDEAllNoisePolar)));
ALLPDEPOLAR = union(union(A1,B1),C1);

indices = 1:10^6;
NOTLPAPOLAR = setdiff(indices,ALLLPAPOLAR);
NOTPDEPOLAR = setdiff(indices,ALLPDEPOLAR);

LPA_not_PDE = length(intersect(ALLLPAPOLAR,NOTPDEPOLAR))/length(indices)
PDE_not_LPA = length(intersect(NOTLPAPOLAR,ALLPDEPOLAR))/length(indices)
