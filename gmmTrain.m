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


% (Test information #dont delete)
% dir_train = '/Users/menglongji/Desktop/ASR/speechdata/Training'
% DD = dir(dir_train)
% speaker_dir = dir(strcat(dir_train,'/',DD(i).name));
% mfcc_dir = dir( [ speaker_dir, filesep, '*', 'mfcc'] );
%

gmm = struct();
% input dir, for Training data with all speakers' foler
DD = dir(dir_train);
% a.initializing theta
% a-1. Initialize omega_m randomly with constrains.
omega = 1/M;
% a-2. Initialize each mu_m to a random vector from the data
mu = zeros(14,M);
% a-3. Initialize sigma_m to a identity matrix.d =14.
sigma = eye(14);

% theta ={w,u,E}
theta = {omega,mu,sigma};
prev_L = -Inf;
improvement = Inf;  


for i=4:length(DD)
    % for each speaker, the directory of their mfcc files.
    speaker_dir = dir(strcat(dir_train,'/',DD(i).name));
    mfcc_dir = dir( [ speaker_dir, filesep, '*', 'mfcc'] );
    for w=1:length(mfcc_dir)
        
        
        
    end
end
  
    
    
    
    
    
    
end


