idx = [];
for i = 1:length(perturbation_bottom)
  if ismember(2,perturbation_bottom{i})
    idx = [idx; i];
  end
end
idx

idx = [];
for i = 1:length(perturbation_middle)
  if ismember(2,perturbation_middle{i})
    idx = [idx; i];
  end
end
idx

idx = [];
for i = 1:length(perturbation_top)
  if ismember(2,perturbation_top{i})
    idx = [idx; i];
  end
end
idx