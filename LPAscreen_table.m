% LPAscreen_table.m




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
