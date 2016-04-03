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
    T = size(mfcc_matrix,1);
    D = size(mfcc_matrix,2);
    % a.initializing theta
    % a-1. Initialize omega_m randomly with constrains.
    omega = ones(1,M)*(1/M);
    % a-2. Initialize each mu_m to a random vector from the data
    mu = zeros(M,D);
    msize = numel(mfcc_matrix);
    for m=1:M   
        row = mfcc_matrix(randperm(msize,D));
        mu(m,:) = mu(m,:)+row;
    end
    % a-3. Initialize sigma_m to a identity matrix.
    for n=1:M
        sigma(:,:,n) = eye(D);
    end
end
% theta ={w,u,E}
% theta = {omega,mu,sigma};


prev_L = -Inf;
improvement = Inf;  
l=0;
while l<= max_iter && improvement >= epsilon
    L = ComputeLikelihood(X,theta);
    theta = UpdateParameters(theta,X,L);
    
end
    
    
    
    
    
    
end

% Helper Functions as list below:

function L = ComputeLikelihood(x,D,T,omega,mu,sigma,max_iter, epsilon, M)
% ComputeLikelihood
% inputs:
%           x          : mfcc_matrix
%           D          : size(mfcc_matrix,2), number of columns in mfcc_matrix
%           T          : size(mfcc_matrix,1), number of rows in mfcc_matrix
%           omega      : as described before
%           mu         : as described before
%           sigma      : as described before
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
b = zeros(T,M);
for t=1:T
    
    for m=1:M
        
        for d=1:D
            % By simplification of original equation
            % log b_m(x)= - Sum_d_n=1{[(x[n]-mu[n])^2 / 2*sigma[n]^2] -
            % (d/2)*log(2pi)-(1/2)*log*prod(sigma^2[n])}, which is
            % log b_m(x)= - Sum_d_n=1 {(1/2)*x[n]^2*sigma[n]^(-2) - 
            % mu[n]*x[n]*sigma[n]^(-2)}- Sum_d_n=1 {}
            %
            %
            denom(m) =(2*pi)^(d/2)*sqrt(prod(sigma(d,d,m)));
            numer(m,t) = sum((x(:,t)-mu(:,m))^2)/sigma(d,d,m);
        end
        b(t,m)=;numer(m,t)/denom(m);
        weight_m = omega(1,m);
        
    end
    
    
end





end

function theta = UpdateParam(T,max_iter, epsilon, M)
% UpdateParam
% inputs:
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
weight = sum(pm_x,2)/T;
mu =;
for i=1:M
    sigma(:,:,m) =
end


end
