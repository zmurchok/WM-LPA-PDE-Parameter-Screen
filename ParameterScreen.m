%set up parpool
if accre == 1
  cores = str2num(getenv('SLURM_JOB_CPUS_PER_NODE'));
  parpool(cores)
end



%Preallocate some storage vectors
len = zeros(num,1); %the number of HSS for each parameter set
stability_top = zeros(num,1); %the LPA stability of the "top" branch, i.e. high R, low rho
stability_bottom = zeros(num,1); %LPA stability of the "bottom" branch, i.e. low R, high rho
stability_middle = zeros(num,1); %LPA stability of the "middle" branch, i.e. coexistence
%flags if LPA ODEs predict polarity from given branch
polar_top = zeros(num,1);
polar_bottom = zeros(num,1);
polar_middle = zeros(num,1);

%some random parameter sets used in testing:
% X = [1.8,4,1.9,2];
% X = [3.938496250194605   3.744354550360058   2.833989970009054   3.539567289563605];

%options for ode integration
tspan = [0 100];
opts = odeset('RelTol',1e-12,'AbsTol',1e-12);

%set up perturbations for initial conditions for LPA ODE screen:
% perturbs = [0.1,0.5,0.99,1,1.01,2,10];
perturbs = [0.1,0.5,2,10];
% perturbs = [0.5,0.99,1,1.01,2];
[u1_p, u2_p] = meshgrid(perturbs);
%here u1_p and u2_p describe the multiplicative perturbations applied to each HSS for the LPA ODE analysis

%parallelized loop to loop over each parameter set.
%for each parameter set:
% 1. find all the HSS
% 2. find the LPA stability of each HSS
% 3. if LPA stable, then use perturbed initial conditions to determine if the LPA ODEs predict polarization or not

parfor i=1:num
  %get steady states
  [numsteadystates,steadystates] = FindSteadyStates(X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));


  % if monostable
  if numsteadystates == 1
    middlebranch = steadystates(1,:);

    localmiddlebranch = [middlebranch(1), middlebranch(2), middlebranch(1), middlebranch(2)]; %[u1g u2g u1l u2l]

    J_LPA_middle = lpa_jacobian(localmiddlebranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));

    real_part_e_vals_middle = real(eig(J_LPA_middle));
    perturbationresponse_middle = zeros(size(u1_p));

    if sum((real_part_e_vals_middle>0))>0
      stability_middle(i) = -1; %unstable since there is at least one positive real part
    else
      stability_middle(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localmiddlebranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - middlebranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_middle(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            perturbationresponse_middle(ii,jj) = -1;
          end
        end
      end
    end

    perturbation_middle{i} = perturbationresponse_middle;

    polar_middle(i) = ismember(-1,perturbationresponse_middle);

    JLPA_middle{i} = J_LPA_middle;
  end

  if numsteadystates == 2
    bottombranch = steadystates(1,:);
    topbranch = steadystates(2,:);
    %prep steady-state for LPA integration/Jacobian
    localbottombranch = [bottombranch(1), bottombranch(2), bottombranch(1), bottombranch(2)];
    localtopbranch = [topbranch(1), topbranch(2), topbranch(1), topbranch(2)];
    J_LPA_bottom = lpa_jacobian(localbottombranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));
    J_LPA_top = lpa_jacobian(localtopbranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));

    real_part_e_vals_top = real(eig(J_LPA_top));
    real_part_e_vals_bottom = real(eig(J_LPA_bottom));
    perturbationresponse_top = zeros(size(u1_p));
    perturbationresponse_bottom = zeros(size(u1_p));

    if sum((real_part_e_vals_top>0))>0
      stability_top(i) = -1; %unstable since there is at least one positive real part
    else
      stability_top(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localtopbranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - topbranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_top(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            if max(abs(z(end,[3,4]) - bottombranch)) < 1e-6
              %LPA ODEs ended at the other HSS
              perturbationresponse_top(ii,jj) = 2;
            else
              % we hit a polarized branch
              perturbationresponse_top(ii,jj) = -1;
            end
          end
        end
      end
    end

    if sum((real_part_e_vals_bottom>0))>0
      stability_bottom(i) = -1; %unstable since there is at least one positive real part
    else
      stability_bottom(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localbottombranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - bottombranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_bottom(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            if max(abs(z(end,[3,4]) - topbranch)) < 1e-6
              %LPA ODEs ended at the other HSS
              perturbationresponse_bottom(ii,jj) = 2;
            else
              % we hit a polarized branch
              perturbationresponse_bottom(ii,jj) = -1;
            end
          end
        end
      end
    end

    perturbation_top{i} = perturbationresponse_top;
    perturbation_bottom{i} = perturbationresponse_bottom;

    polar_top(i) = ismember(-1,perturbationresponse_top);
    polar_bottom(i) = ismember(-1,perturbationresponse_bottom);

    JLPA_top{i} = J_LPA_top;
    JLPA_bottom{i} = J_LPA_bottom;
  end

  %if tristable
  if numsteadystates == 3
    bottombranch = steadystates(1,:);
    middlebranch = steadystates(2,:);
    topbranch = steadystates(3,:);
    %prep steady-state for LPA integration/Jacobian
    localbottombranch = [bottombranch(1), bottombranch(2), bottombranch(1), bottombranch(2)];
    localmiddlebranch = [middlebranch(1), middlebranch(2), middlebranch(1), middlebranch(2)]; %[u1g u2g u1l u2l]
    localtopbranch = [topbranch(1), topbranch(2), topbranch(1), topbranch(2)];
    J_LPA_bottom = lpa_jacobian(localbottombranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));
    J_LPA_middle = lpa_jacobian(localmiddlebranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));
    J_LPA_top = lpa_jacobian(localtopbranch,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5));

    real_part_e_vals_top = real(eig(J_LPA_top));
    real_part_e_vals_middle = real(eig(J_LPA_middle));
    real_part_e_vals_bottom = real(eig(J_LPA_bottom));
    perturbationresponse_top = zeros(size(u1_p));
    perturbationresponse_middle = zeros(size(u1_p));
    perturbationresponse_bottom = zeros(size(u1_p));

    if sum((real_part_e_vals_top>0))>0
      stability_top(i) = -1; %unstable since there is at least one positive real part
    else
      stability_top(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localtopbranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - topbranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_top(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            if max(abs(z(end,[3,4]) - bottombranch)) < 1e-6
              %LPA ODEs ended at the other HSS
              perturbationresponse_top(ii,jj) = 2;
            elseif max(abs(z(end,[3,4]) - middlebranch)) < 1e-6
              perturbationresponse_top(ii,jj) = 2;
            else
              % we hit a polarized branch
              perturbationresponse_top(ii,jj) = -1;
            end
          end
        end
      end
    end

    if sum((real_part_e_vals_middle>0))>0
      stability_middle(i) = -1; %unstable since there is at least one positive real part
    else
      stability_middle(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localmiddlebranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - middlebranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_middle(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            if max(abs(z(end,[3,4]) - bottombranch)) < 1e-6
              %LPA ODEs ended at the other HSS
              perturbationresponse_middle(ii,jj) = 2;
            elseif max(abs(z(end,[3,4]) - topbranch)) < 1e-6
              perturbationresponse_middle(ii,jj) = 2;
            else
              % we hit a polarized branch
              perturbationresponse_middle(ii,jj) = -1;
            end
          end
        end
      end
    end

    if sum((real_part_e_vals_bottom>0))>0
      stability_bottom(i) = -1; %unstable since there is at least one positive real part
    else
      stability_bottom(i) = 1; %stable (or possibly centre) since all real parts are less than or equal zero
      for ii=1:length(perturbs)
        for jj=1:length(perturbs)
          [t,z] = ode45(@(t,z) local_odes(t,z,X(i,1),X(i,1),X(i,2),X(i,2),X(i,3),X(i,3),switch1,switch2,k,n,X(i,4),X(i,5)),tspan,localbottombranch.*[1,1,u1_p(ii,jj),u2_p(ii,jj)],opts);
          if max(abs(z(end,[3,4]) - bottombranch)) < 1e-6
            %perturbation washed out ==> return to stable
            perturbationresponse_bottom(ii,jj) = 1;
          else
            %perturbation jumped system to different attractor
            if max(abs(z(end,[3,4]) - middlebranch)) < 1e-6
              %LPA ODEs ended at the other HSS
              perturbationresponse_bottom(ii,jj) = 2;
            elseif max(abs(z(end,[3,4]) - topbranch)) < 1e-6
              perturbationresponse_bottom(ii,jj) = 2;
            else
              % we hit a polarized branch
              perturbationresponse_bottom(ii,jj) = -1;
            end
          end
        end
      end
    end

    perturbation_top{i} = perturbationresponse_top;
    perturbation_bottom{i} = perturbationresponse_bottom;
    perturbation_middle{i} = perturbationresponse_middle;

    polar_top(i) = ismember(-1,perturbationresponse_top);
    polar_bottom(i) = ismember(-1,perturbationresponse_bottom);
    polar_middle(i) = ismember(-1,perturbationresponse_middle);

    JLPA_top{i} = J_LPA_top;
    JLPA_bottom{i} = J_LPA_bottom;
    JLPA_middle{i} = J_LPA_middle;
  end

  len(i) = numsteadystates;
  equilibria{i} = steadystates;

  if len(i) == 1
    stability{i} = stability_middle(i);
    LPAPolarizable{i} = polar_middle(i);
  elseif len(i) == 2
    stability{i} = [stability_bottom(i);stability_top(i)];
    LPAPolarizable{i} = [polar_bottom(i);polar_top(i)];
  elseif len(i) == 3
    stability{i} = [stability_bottom(i);stability_middle(i);stability_top(i)];
    LPAPolarizable{i} = [polar_bottom(i);polar_middle(i);polar_top(i)];
  else
    stability{i} = [];
    LPAPolarizable{i} = [];
  end

end
