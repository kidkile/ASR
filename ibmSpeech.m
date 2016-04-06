

speech_txt_dir = '/Users/menglongji/desktop/ASR/speech.txt'
f = fopen(sppech_txt_dir,w);
for i=1:30
    flac_dir = strcat('/u/cs401/speechdata/Testing/unkn_',num2str(i),'.flac');
    username='';
    password='';
    c1='--header "Content-Type: audio/flac"';
    c2='--header "Transfers-Encoding: chunked"';
    c3= '--data-binary @%s';
    http='https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true';
    
end