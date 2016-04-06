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

gmm = {};
% input dir, for Training data with all speakers' foler
DD = dir(dir_train);

for i=4:length(DD)
    % for each speaker, the directory of their mfcc files.
    speaker_dir = strcat(dir_train,'/',DD(i).name);
    mfcc_dir = dir( [ strcat(dir_train,'/',DD(i).name), filesep, '*', 'mfcc'] );
    
    % fact: there are always 9 mfcc files for each speaker.
    for w=1:length(mfcc_dir)
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
    % theta ={w,u,E}
    % theta = {omega,mu,sigma};
    
    
    prev_L = -Inf;
    improvement = Inf;
    l=0;
    while l<= max_iter && improvement >= epsilon
        [L,p_m_x_theta] = ComputeLikelihood(mfcc_matrix,T,M,D,omega,mu,sigma,max_iter, epsilon);
        [omega,mu,sigma] = UpdateParam(omega,p_m_x_theta,mfcc_matrix);
        improvement = L -prev_L;
        prev_L = L;
        l = l+1;
    end
    
    
    gmm.name = DD(i).name;
    gmm.weights = omega;
    gmm.means = mu;
    gmm.cov = sigma;
    
    
    

end
end

% Helper Functions as list below:

function [L,p_m_x_theta] = ComputeLikelihood(input,T,M,D,omega,mu,sigma,max_iter, epsilon)
% ComputeLikelihood
% inputs:
%           input          : mfcc_matrix
%           D          : size(mfcc_matrix,2), number of columns in mfcc_matrix
%           T          : size(mfcc_matrix,1), number of rows in mfcc_matrix
%           omega      : as described before
%           mu         : as described before
%           sigma      : as described before
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
bm_init = zeros(T,M);
for m=1:M
    mu_m = mu(:,m).';
    sigma_m = diag(sigma(:,:,m));
    temp1 = (input-repmat(mu_m,T,1))^2;
    numerator = sum(temp1/repmat(sigma_m,T,1),2);
    temp2 = (2*pi)^(D/2)  ;
    denominator = temp2 * sqrt(prod(sigma_m));
    bm = bm_init;
    bm(:,m)= numerator / denominator;
    wm =repmat(omega,T,1);
    p_m_x_theta = sum(wm*bm,2) ;
    L =sum(log(p_m_x_theta));
end
end

function [omega,mu,sigma] = UpdateParam(omega,p_m_x_theta,mfcc_matrix)
% UpdateParam
% inputs:
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
% outputs:
p_m_t = zeros(T,M);
for m=1:M
    wm =omega(1,m);
    p_m_t(:,m)=repmat(wm,T,1) * bm(:,m)/p_x_theta;
end

omega= sum(p_m_t,1)/T;
mu= (p_m_t.' * mfcc_matrix).'/repmat(sum(p_m_t,1),D,1);
temp = (p_m_t.' *(mfcc_matrix^2))'./repmat(sum(p_m_t, 1),D,1) - (mu_bar^2);
for i=1:M
    sigma(:,:,m) = diag(temp(:,m));
end

end
