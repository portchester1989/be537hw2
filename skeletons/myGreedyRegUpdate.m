function [E,Ux,Uy,Uz] = myGreedyRegUpdate(ux,uy,uz,I,J,sigma,tau,rho)
%initialize t
[X,Y,Z] = ndgrid(1:size(I,1),1:size(I,2),1:size(I,3));
T = [X(:)'+ ux(:)';Y(:) + uy(:)';Z(:)' + uz(:)'] ;
transform = interpn(X,Y,Z,J,T(1,:)',T(2,:)',T(3,:)','linear',0);
E = (norm(I(:) - transform)) ^ 2;
[dJ_dy, dJ_dx, dJ_dz] = gradient(J);
% difference = (I - transform);
% w_x = 2 * difference * [dJ_dx(:)';dJ_dy(:)';dJ_dz(:)'];
gradients = {dJ_dx, dJ_dy, dJ_dz}; 
w_sm = zeros(3,size(transform,1));
for i = 1:3
    noisy_w_sm = resample(interpn(X,Y,Z,gradients{i},X(:)'+ ux(:)',Y(:) + uy(:)',Z(:)' + uz(:)'),size(J));
    filtered_w_sm = myGaussianLPF(noisy_w_sm,sigma);
    w_sm(i,:) = filtered_w_sm(:)';
end
%apply Gaussian filter
[~,maximum_dim] = max(size(w_sm));
W = max(vecnorm(w_sm,2,maximum_dim));
if W > rho
    w_nrm = (rho / W) * w_sm;
else
    w_nrm = w_sm;
end
displacements = {ux,uy,uz};
for j = 1:3
    this_w_nrm = w_nrm(j,:);
    this_displacement = interpn(X,Y,Z,displacements(j),X(:) + w_nrm(1,:),Y(:) + w_nrm(2,:),Z(:) +  w_nrm(3,:));
    if j == 1
     Ux = myGaussianLPF(reshape(this_w_nrm + this_displacement,size(J)),tau);
    elseif j == 2
     Uy = myGaussianLPF(reshape(this_w_nrm + this_displacement,size(J)),tau);
    else
     Uz = myGaussianLPF(reshape(this_w_nrm + this_displacement,size(J)),tau);   
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
