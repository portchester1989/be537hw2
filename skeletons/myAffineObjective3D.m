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
if nargout > 1
   
    % Your code to compute the elements of dE_dA and dE_db
    
end

