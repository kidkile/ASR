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
% speaker_dir = strcat(dir_train,'/',DD(i).name);
% mfcc_dir = dir( [ strcat(dir_train,'/',DD(4).name), filesep, '*', 'mfcc'] );
% '/Users/menglongji/Desktop/ASR/speechdata/Training/FCJF0/SA1.mfcc'

gmm = struct();
% input dir, for Training data with all speakers' foler
DD = dir(dir_train);



% a.initializing theta
% a-1. Initialize omega_m randomly with constrains.
omega = ones(1,M)*(1/M);
% a-2. Initialize each mu_m to a random vector from the data
mu = zeros(8,14)
msize = numel(mfcc_matrix);
for m=1:8
    row=mfcc_matrix(randperm(msize,14))
    mu(m,:)=mu(m,:)+row
end
% a-3. Initialize sigma_m to a identity matrix.d =14.
for n=1:M
    sigma(:,:,n) =eye(d);
end
    
    

% theta ={w,u,E}
theta = {omega,mu,sigma};
prev_L = -Inf;
improvement = Inf;  

for i=4:length(DD)
    % for each speaker, the directory of their mfcc files.
    speaker_dir = strcat(dir_train,'/',DD(i).name);
    mfcc_dir = dir( [ strcat(dir_train,'/',DD(i).name), filesep, '*', 'mfcc'] );
    % fact: there are always 9 mfcc files for each speaker.
    for w=1:length(mfcc_DD)
        % mfcc input is mfcc_dir(i), set up matrix for it.
        matrix = [];
        mfcc_matrix = [matrix;dlmread([speaker_dir, filesep, mfcc_dir(1).name])];
     
        
        
    end
end
i=0;
while i<= max_iter & improvement >= epsilon
    L:= ComputeLikelihood(X,theta);
    theta:= UpdateParameters(theta,X,L);
    
end
    
    
    
    
    
    
end

% helper functions as list below:

function L = ComputeLikelihood(max_iter, epsilon, M)
% ComputeLikelihood
% inputs:
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
for m=1:M
    wmbm= zeros(M,9)
end



function theta = UpdateParam(max_iter, epsilon, M)
% UpdateParam
% inputs:
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
end
