function classification = gmmClassify(dir_test,likelihoods,M)
% dir_train = '/Users/menglongji/Desktop/ASR/speechdata/Training'
% dir_test = '/Users/menglongji/Desktop/ASR/speechdata/Testing'
% max_iter = 10;
% epsilon = 0.1;
% M = 8;
% 
% mfcc_dir = dir( [ dir_test, filesep, '*', 'mfcc'] );
gmms = gmmTrain( dir_train, max_iter, epsilon, M );
for i=1:length(mfcc_dir)
    mfcc = dlmread([dir_test,filesep,mfcc_dir(i).name]);
    for w=1:length(gmms)
        gmm = gmms(w);
    end
end