dir_test = 'speechdata/Testing';
hmm_dir = 'hmm/';
bnt_dir = 'bnt/';
addpath(genpath(bnt_dir));
dimensions = 14;

correct = 0;
total = 0;

phn_files = dir([dir_test, filesep, '*.phn']);
mfcc_files = dir([dir_test, filesep, '*.mfcc']);
for i = 1:length(phn_files)
    mfcc = load([dir_test, filesep, mfcc_files{i}.name]);
    phn = textread([dir_test, filesep, phn_files{i}.name], '%s', 'delimiter', '\n');
    
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
        mfcc_phoneme = mfcc(phn_start:phn_end, 1:dimensions);
        
        hmms = dir([hmm_dir, filesep])l;
        max_log_prob = -Inf;
        phn_prediction = '';
        for k = 1:length(hmms)
            if not(strcmp(hmms{k}.name, '.') || strcmp(hmms{k}.name, '..'))
                HMM = load([hmm_dir, filesep, hmms{k}.name]);
                log_prob = loglikHMM(HMM, mfcc_phoneme);
                if log_prob > max_log_prob
                    max_log_prob = log_prob;
                    phn_prediction = hmms{k}.name;
                end    
            end
        end
        if strcmp(phoneme, phn_prediction)
            correct = correct + 1;
        end
    end
    
end