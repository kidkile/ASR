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
% Initialize theta
%i = 0;
%prev_L = -Inf;
%improvement = Inf;
%while i =< max_iter and improvement >= epsilon
%   L = ComputeLikelihood(X,theta);
%    theta = UpdateParameters(theta,X,L);
%    improvement +L- prev_L
%    prev_L = L
%    i = i+1
    
%end

% analysis for input mfcc
% In each Training sub folders(under Training), there is a list of files 
% including(x.mfccx.txt, x.wav) where x is the name of contents.
% Each sub folder name is the name of speaker.
% Then, all Training sub folders are similar to each other.
% (speech contents) but different speakers.
