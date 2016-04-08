% This is a script for classfying speakers.
%
%
dir_train = '/Users/menglongji/Desktop/ASR/speechdata/Training'
dir_test = '/Users/menglongji/Desktop/ASR/speechdata/Testing'

% 
% mfcc_dir = dir( [ dir_test, filesep, '*', 'mfcc'] );
% dir_train = '/u/cs401/speechdata/Training';
% dir_test = '/u/cs401/speechdata/Testing';

DD = dir(dir_train);
max_iter = 10;
epsilon = 0.1;
M = 8;
max_LL=[];
gmms = gmmTrain( dir_train, max_iter, epsilon, M );

LL=zeros(1,length(DD)-3);
for i=4:length(DD)
    speaker_dir = strcat(dir_train,'/',DD(i).name);
    mfcc_dir = dir( [ strcat(dir_train,'/',DD(i).name), filesep, '*', 'mfcc'] );
    % fact: there are always 9 mfcc files for each speaker.
    for w=1:length(mfcc_dir)
        % mfcc input is mfcc_dir(i), set up matrix for it.
        matrix = [];
        mfcc_matrix = [matrix;dlmread([speaker_dir, filesep, mfcc_dir(1).name])];
    end
    g= i-3;
    gmms{g}.name = DD(i).name;
    gmms{g}.weights = omega;
    gmms{g}.means = mu;
    gmms{g}.cov = sigma;
    
    bm =zeros(T,M);
    bm_log = zeros(T,M);
    wmbm = zeros(T,M);
    for m=1:M
        x = mfcc_matrix-repmat(mu(:,m).',T,1);
        sigma_m = diag(sigma(:,:,m))';%1xD
        tmp = sum(((x.^2)./ repmat(sigma_m,T,1)),2);
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
    LL(g)=L;       
    
    for p=1:5
        [max_LL,index] = max(likelihood);
		top_speaker = gmms{index}.name;
    end
    
   
end




