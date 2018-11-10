function [E,Ux,Uy,Uz] = myGreedyRegUpdate(ux,uy,uz,I,J,sigma,tau,rho)
%initialize t

[X,Y,Z] = ndgrid(1:size(I,1),1:size(I,2),1:size(I,3));
new_x = X + ux;
new_y = Y + uy;
new_z = Z + uz;
T = [new_x(:)';new_y(:)';new_z(:)'];
transform = reshape(interpn(X,Y,Z,J,T(1,:)',T(2,:)',T(3,:)','linear',0),size(J));
diff_img = I - transform;
E = (norm(diff_img(:))) ^ 2 ;
[dJ_dy, dJ_dx, dJ_dz] = gradient(J);
% difference = (I - transform);
% w_x = 2 * difference * [dJ_dx(:)';dJ_dy(:)';dJ_dz(:)'];
gradients = {dJ_dx, dJ_dy, dJ_dz}; 
w_sm = zeros(size(T));
for i = 1:3
    this_grad = reshape(interpn(X,Y,Z,gradients{i},new_x(:),new_y(:),new_z(:),'linear',0),size(J));
    noisy_w_sm = 2 * diff_img .* this_grad;
    %apply Gaussian filter
    filtered_w_sm = myGaussianLPF(noisy_w_sm,sigma);
    w_sm(i,:) = filtered_w_sm(:)';
end

W = max(vecnorm(w_sm,2,1));
if W > rho
    w_nrm = (rho / W) * w_sm;
else
    w_nrm = w_sm;
end
w_nrm = reshape(w_nrm,[size(J) 3]);
x_displaced = X + squeeze(w_nrm(:,:,:,1));
y_displaced = Y + squeeze(w_nrm(:,:,:,2));
z_displaced = Z + squeeze(w_nrm(:,:,:,3));
displacements = {ux,uy,uz};

for j = 1:3
    this_w_nrm = squeeze(w_nrm(:,:,:,j));
    this_displacement = reshape(interpn(X,Y,Z,displacements{j},x_displaced(:),y_displaced(:),z_displaced(:),'linear',0),size(J));
    if j == 1
     Ux = myGaussianLPF(this_w_nrm + this_displacement,tau);
    elseif j == 2
     Uy = myGaussianLPF(this_w_nrm + this_displacement,tau);
    else
     Uz = myGaussianLPF(this_w_nrm + this_displacement,tau);   
    end
    
end

% t = 0;
% for 
% myGreedyRegUpdate : perform an iteration of greedy registration
%
%    [E,Ux,Uy,Uz] = myGreedyRegUpdate(ux,uy,uz,I,J,sigma,tau,rho)
%
%    Performs one iterative update in the greedy deformable registration
%    algorithm, with I as the fixed image, J as the moving image. Other
%    parameters are:
%
%      ux, uy, uz          The x,y,z components of the displacement field
%                          u^t. Each is of the same dimensions as I.
%      sigma               Smoothing applied to the gradient of the energy
%      tau                 Smoothing applied to the composed displacement
%      rho                 Normalization factor
%
%    Return values:
%      E                   The value of MSID metric for u^t
%      Ux,Uy,Uz            The x,y,z components of the displacement field
%                          u^(t+1)
