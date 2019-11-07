function y = is_polarized(rac,rho)
  % #takes rac and rho, two vectors which #describe concentration over space.
  % #Determine if polarized pattern exists...

  tol = 0.01;

  if abs(max(rac) - min(rac)) > tol
    if abs(max(rho) - min(rho)) > tol
      %polarized
      y = 1;
    else
      %problems
      y = 2;
    end
  else
    %not polarized
    y = 0;
  end
end
