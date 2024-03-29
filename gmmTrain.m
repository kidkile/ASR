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

gmms = {};
% input dir, for Training data with all speakers' foler
DD = dir(dir_train);

for i=4:length(DD)
    % for each speaker, the directory of their mfcc files.
    speaker_dir = strcat(dir_train,'/',DD(i).name);
    mfcc_dir = dir( [ speaker_dir, filesep, '*', 'mfcc'] );
    
    % fact: there are always 9 mfcc files for each speaker.
    for w=1:length(mfcc_dir)
        % mfcc input is mfcc_dir(i), set up matrix for it.
        matrix = [];
        mfcc_matrix = [matrix;dlmread([speaker_dir, filesep, mfcc_dir(w).name])];
    end
    T = size(mfcc_matrix,1);
    D = size(mfcc_matrix,2);
    % a.initializing theta
    % a-1. Initialize omega_m randomly with constrains.
    omega = ones(1,M)*(1/M);% omega is 1xM;
    % a-2. Initialize each mu_m to a random vector from the data
    mu = zeros(D,M); % DxM matrix ie. 14x8
    msize = numel(mfcc_matrix);
    for m=1:M   
        cloumn = mfcc_matrix(randperm(msize,D));% (1xD)1x14
        mu(:,m) = mu(:,m)+cloumn.';% mu is 14x8(DxM)
    % a-3. Initialize sigma_m to a identity matrix.
        sigma(:,:,m) = eye(D);%DxDxM 14x14x8
    end
    
   
    % theta ={weight,means,cov}
    % theta = {omega,mu,sigma};
    
    
    prev_L = -Inf;
    improvement = Inf;
  
    l=0;
    while l<= max_iter && improvement >= epsilon
        [L,p_m_t] = ComputeLikelihood(mfcc_matrix,T,M,D,omega,mu,sigma);
        [omega,mu,sigma] = UpdateParam(mfcc_matrix,p_m_t,M);
        improvement = L -prev_L;
        prev_L = L;
        l = l+1;
    end
    o=i-3;
    gmms{o}.name = DD(i).name;
    gmms{o}.weights = omega;
    gmms{o}.means = mu;
    gmms{o}.cov = sigma;
    
    
    

end
end

% Helper Functions as list below:

function [L,p_m_t] = ComputeLikelihood(input,T,M,D,omega,mu,sigma)
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
bm =zeros(T,M);
bm_log = zeros(T,M);
wmbm = zeros(T,M);
for m=1:M
    x = input-repmat(mu(:,m).',T,1);
    sigma_m = diag(sigma(:,:,m))';%1xD
    tmp = sum(((x.*x)./ repmat(sigma_m,T,1)),2);
    deno = ((2*pi)^(D/2)).* sqrt(prod(prod(sigma_m)));
    bm_log(:,m)= exp(-0.5*tmp)./deno;
    %disp(size(bm_log));
    wm =repmat(omega,T,1);
    %disp(size(wm));
    wmbm(:,m) = wm(:,m).*bm_log(:,m);
    p_x_theta=sum(wmbm,2);
    %disp(log(p_x_theta));
    L = sum(log(p_x_theta));
    tmp=omega(1,m);
    p_m_t(:,m)=repmat(tmp,T,1).*bm(:,m)./p_x_theta;
    
end
end

function [omega,mu,sigma] = UpdateParam(mfcc_matrix,p_m_t,M)
% UpdateParam
% inputs:
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)

T= size(mfcc_matrix,1);
D=size(mfcc_matrix,2);
omega = sum(p_m_t,1)/T;
mu= (p_m_t'*mfcc_matrix)'./repmat(sum(p_m_t,1),D,1);
sigm =(p_m_t' * (mfcc_matrix.^2))'./repmat(sum(p_m_t, 1),D,1) - mu.^2;
for m=1:M
    sigma(:,:,m)=diag(sigm(:,m));
end
end
