dir_test = 'speechdata/Testing';

bnt_dir = '/bnt/';


results = struct();

all_hmms = dir (['hmm/train', filesep, '*.mat']);
for l = 1:length(all_hmms)
    if not(strcmp(all_hmms(l).name, 'standard2_HMM.mat') || ...
            strcmp(all_hmms(l).name, 'standard_HMM.mat') || ...
            strcmp(all_hmms(l).name, 'dim1_iter20_HMM.mat') || ...
            strcmp(all_hmms(l).name, 'dim3_iter20_HMM.mat') || ...
            strcmp(all_hmms(l).name, 'dim7_iter20_HMM.mat') || ...
            strcmp(all_hmms(l).name, 'dim10_iter20_HMM.mat'))
        
        hmm_file = all_hmms(l).name;
        hmm = load(['hmm/train', filesep, hmm_file]);
        hmm = hmm.trainedHMM;
        dimensions = 14;
        
%         if strcmp(hmm_file, 'dim10_iter20_HMM.mat')
%             dimensions = 10;
%         elseif strcmp(hmm_file, 'dim1_iter20_HMM.mat')
%             dimensions = 1;
%         elseif strcmp(hmm_file, 'dim3_iter20_HMM.mat')
%             dimensions = 3;
%         elseif strcmp(hmm_file, 'dim7_iter20_HMM.mat')
%             dimensions = 7;
%         else
%             dimensions = 14;
%         end
        
        correct = 0;
        total = 0;
        addpath(genpath(bnt_dir));

        phn_files = dir([dir_test, filesep, '*.phn']);
        mfcc_files = dir([dir_test, filesep, '*.mfcc']);
        for i = 1:length(phn_files)
            mfcc = load([dir_test, filesep, mfcc_files(i).name]);
            phn = textread([dir_test, filesep, phn_files(i).name], '%s', 'delimiter', '\n');

            total = total + length(phn);

            for j = 1:length(phn)
                phn_data = strsplit(' ', phn{j});
                phn_start = (str2num(phn_data{1}) / 128) + 1;
                phn_end = min((str2num(phn_data{2}) / 128) + 1, size(mfcc, 1));
                if strcmp(phn_data{3}, 'h#')
                    phoneme = 'sil';
                else
                    phoneme =  phn_data{3};
                end
                mfcc_phoneme = transpose(mfcc(phn_start:phn_end, 1:dimensions));

                max_log_prob = -Inf;
                phn_prediction = '';
                unique_phns = fieldnames(hmm);
                for k = 1:length(unique_phns)
                    log_prob = loglikHMM(hmm.(unique_phns{k}), mfcc_phoneme);
                    if log_prob > max_log_prob
                        max_log_prob = log_prob;
                        phn_prediction = unique_phns{k};
                    end    
                end
                if strcmp(phoneme, phn_prediction)
                    correct = correct + 1;
                end
            end

        end
        name = strsplit('.', hmm_file);
        results.(name{1}) = correct;
        disp(correct);
        disp(total);
    end
end