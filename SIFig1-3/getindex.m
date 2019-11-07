function [j,ii,jj] = getindex(ell,l1,l2,numss)
  v = (1:(l1*l2))';
  A = reshape(v,l1,l2)';
  if numss == 3

    if ell > 2*l1*l2
      ell = ell - 2*l1*l2;
      j = 3;
    elseif ell > l1*l2
      ell = ell - 1*l1*l2;
      j = 2;
    else
      j = 1;
    end

  elseif numss == 2

    if ell > l1*l2
      ell = ell - l1*l2;
      j = 2;
    else
      j = 1;
    end

  elseif numss == 1

    j = 1;

  end
  [ii,jj] = find(A == ell);
end
