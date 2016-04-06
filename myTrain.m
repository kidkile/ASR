% Remember to change for CDF file structure
dir_train = 'speechdata/Training';
bnt_dir = 'bnt';

%addpath(genpath(bnt_dir));

M = 8;
Q = 3;
initType = 'kmeans';
max_iter = 3;
output_file = './hmm/';

HMM = struct();

speakers = dir(dir_train);

TIMITlst = {'b','d','g','p','t','k','dx','q','jh','ch','s','sh','z','zh','f','th','v', 'dh','m','n','ng','em','en','eng','nx','l','r','w','y','hh','hv','el','iy','ih', 'eh','ey','ae','aa','aw','ah','ao','oy','ow','uh','uw','ux','er','ax','ix','axr', 'ax-h','pau','epi','h#','1','2','bcl','dcl', 'gcl', 'pcl', 'tcl', 'kcl'};

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
                phoneme = strplit(' ', phn_data{k});
                phn_start = (str2num(phoneme{1}) / 128) + 1;
                phn_end = min((str2num(phoneme{2}) / 128), size(mfcc_data, 1));
                phn =  phoneme{3};
                
            end
        end
        
    end 
end