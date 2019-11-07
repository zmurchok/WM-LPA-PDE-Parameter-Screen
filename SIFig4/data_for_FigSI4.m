load('million_parameter_data.mat')

seaborncolors;

% EXTRACT INDEXES
id1 = find(len==1); %monostable param sets
id2 = find(len==2); %bistable param sets
id3 = find(len==3); %trisablte param sets
id4 = find(len>=4); %more than 4 steady-states or ERRORS in finding unique equilibiria

stableids_top = intersect(find(stability_top==1),id3);
stableids_middle = intersect(find(stability_middle==1),id3);
stableids_bottom = intersect(find(stability_bottom==1),id3);
unstableids_top = intersect(find(stability_top==-1),id3);
unstableids_middle = intersect(find(stability_middle==-1),id3);
unstableids_bottom = intersect(find(stability_bottom==-1),id3);

all_unstable = intersect(intersect(unstableids_top,unstableids_bottom),unstableids_middle);
all_stable = intersect(intersect(stableids_top,stableids_bottom),stableids_middle);

ids = stableids_top;
for i=1:length(ids)
  storage13(i,:) = [X(ids(i),:),1,3];
end
ids = stableids_middle;
for i=1:length(ids)
  storage12(i,:) = [X(ids(i),:),1,2];
end
ids = stableids_bottom;
for i=1:length(ids)
  storage11(i,:) = [X(ids(i),:),1,1];
end
ids = unstableids_top;
for i=1:length(ids)
  storagem13(i,:) = [X(ids(i),:),-1,3];
end
ids = unstableids_middle;
for i=1:length(ids)
  storagem12(i,:) = [X(ids(i),:),-1,2];
end
ids = unstableids_bottom;
for i=1:length(ids)
  storagem11(i,:) = [X(ids(i),:),-1,1];
end
storage = [storage13;storage12;storage11;storagem13;storagem12;storagem11];

save('forpython.mat',storage)
