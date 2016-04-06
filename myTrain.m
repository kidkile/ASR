% Remember to change for CDF file structure
dir_train = 'speechdata/Training';
bnt_dir = 'bnt';

%addpath(genpath(bnt_dir));

M = 8;
Q = 3;
initType = 'kmeans';
max_iter = 3;
output_file = 'HMM';

PHN_MFCC_data = struct();
speakers = dir(dir_train);

for i = 1:length(speakers)
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
                phn_end = min((str2num(phoneme{2}) / 128), size(mfcc_data, 1));
                if strcmp(phoneme{3}, 'h#')
                    phn = 'sil';
                else
                    phn =  phoneme{3};
                end
                mfcc_phoneme = mfcc_data(phn_start:phn_end, :);
                
                if ~isfield(PHN_MFCC_data, phn)
                    PHN_MFCC_data.(phn) = {};
                end
                PHN_MFCC_data.(phn){length(PHN_MFCC_data.(phn)) + 1} = mfcc_phoneme;
            end
        end
    end 
end

unique_phonemes = fields(PHN_MFCC_data);
for n = 1:length(unique_phonemes)
    phoneme_data = PHN_MFCC_data.(unique_phonemes{n});
    HMM = initHMM(phoneme_data, M, Q, initType);
    [HMM, LL] = trainHMM(HMM, phoneme_data, max_iter);
    save(['hmm/HMM_', unique_phonemes{n}, '.mat'], 'HMM');
end


