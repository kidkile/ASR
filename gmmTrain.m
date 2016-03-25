function gmms = gmmTrain( dir_train, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  dir_train  : a string pointing to the high-level
%                        directory containing each speaker directory
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  gmms       : a 1xN cell array. The i^th element is a structure
%                        with this structure:
%                            gmm.name    : string - the name of the speaker
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture


DD = dir(dir_train);
gmms ={};
%pesudo code
% Initialize theta
i = 0;
prev_L = -Inf;
improvement = Inf;
while i =< max_iter and improvement >= epsilon
    L = ComputeLikelihood(X,theta);
    theta = UpdateParameters(theta,X,L);
    improvement +L- prev_L
    prev_L = L
    i = i+1
    
end


function likelihood = computeLL()