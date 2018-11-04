function [E,dE_dA,dE_db] = myAffineObjective3D(A, b, I, J)
% myAffineObjective3D  Compute the energy functoin for affine registration
%
%     E = myAffineObjective3D(A, b, I, J)
%
%     Computes the energy function E for affine registration between fixed
%     image I and moving image J, with affine transformation given by the
%     3x3 matrix A and 3x1 vector b. 
%     
%     [E,dE_dA,dE_db] = myAffineObjective3D(A, b, I, J)
%
%     Also computes the partial derivaties of E with respect to the elements
%     of A and b. Thus dE_dA is a 3x3 matrix, and dE_db is a 3x1 vector.
%

% Use ndgrid to generate a coordinate grid

% Apply the affine transformation in A,b to the coordinate grid

% Resample the moving image

% Compute the objective function value (E)

% Compute the partial derivatives only if requested
[X,Y,Z] = ndgrid(1:size(I,1),1:size(I,2),1:size(I,3));
T = A * [X(:)';Y(:)';Z(:)'] + b;
transform = interpn(X,Y,Z,J,T(1,:)',T(2,:)',T(3,:)','linear',0);
%compute E
E = (norm(I(:) - transform)) ^ 2;
if nargout > 1
   % compute Å›E/Å›A and Å›E/Å›b
   difference = (I - transform);
   [dJ_dy, dJ_dx, dJ_dz] = gradient(J);
   gradients = {dJ_dx, dJ_dy, dJ_dz}; 
   dE_dA = zeros(3,3);
   dE_db = zeros(3,1);
   for i = 1:3
      this_interp_dJ = interpn(X,Y,Z,gradients{i},'linear',0);
      dE_dA(i,:) = -2 * sum( difference .* this_interp_dJ .* X) * ones(1,3);
      dE_db(i) = -2  * sum(difference .* this_interp_dJ);
   end
%    de_dA = 2 * A(i,:) * sum( difference .* this_interp_dJ .* X)
else
end
   
%    interpn     
    % Your code to compute the elements of dE_dA and dE_db
    
    
end

