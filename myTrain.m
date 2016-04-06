% Remember to change for CDF file structure
dir_train = 'speechdata/Training';
bnt_dir = '/bnt/';

trainedHMM = struct();
PHN_MFCC_data = struct();
speakers = dir(dir_train);

M = 8; % try different values (2, 5)
Q = 3; % try with fewer states (1, 2)
initType = 'kmeans';
max_iter = 3; 
dimensions = 14; % try with reduced dimensions (2, 5) for 3.2
number_of_training_examples = length(speakers); % try with fewer examples


for i = 1:number_of_training_examples
    speaker_name = speakers(i).name;
    if not(strcmp(speaker_name, '.') || strcmp(speaker_name, '..'))
        speaker_path = [dir_train, filesep, speaker_name];
        mfccs = dir([speaker_path, filesep, '*.mfcc']);
        phns = dir([speaker_path, filesep, '*.phn']);
        
        for j = 1:length(mfccs)
            mfcc_data = load([speaker_path, filesep, mfccs(j).name]);
            phn_data = textread([speaker_path, filesep, phns(j).name], '%s', 'delimiter', '\n');
            for k = 1:length(phn_data)
                phoneme = strsplit(' ', phn_data{k});
                phn_start = (str2num(phoneme{1}) / 128) + 1;
                phn_end = min((str2num(phoneme{2}) / 128) + 1, size(mfcc_data, 1));
                if strcmp(phoneme{3}, 'h#')
                    phn = 'sil';
                else
                    phn =  phoneme{3};
                end
                mfcc_phoneme = transpose(mfcc_data(phn_start:phn_end, 1:dimensions));
                
                if ~isfield(PHN_MFCC_data, phn)
                    PHN_MFCC_data.(phn) = {};
                end
                PHN_MFCC_data.(phn){length(PHN_MFCC_data.(phn)) + 1} = mfcc_phoneme;
            end
        end
    end 
end

addpath(genpath(bnt_dir));

unique_phonemes = fieldnames(PHN_MFCC_data);
for n = 1:length(unique_phonemes)
    phoneme_data = PHN_MFCC_data.(unique_phonemes{n});
    HMM = initHMM(phoneme_data, M, Q, initType);
    trainedHMM.(unique_phonemes{n}) = trainHMM(HMM, phoneme_data, max_iter);
    save('trainedHMM.mat', 'trainedHMM');
end


