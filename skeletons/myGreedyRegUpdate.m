function [E,Ux,Uy,Uz] = myGreedyRegUpdate(ux,uy,uz,I,J,sigma,tau,rho)
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
