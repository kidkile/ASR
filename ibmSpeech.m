

speech_txt_dir = '/Users/menglongji/desktop/ASR/speech.txt'
f = fopen(sppech_txt_dir,w);
for i=1:30
    flac_dir = strcat('/u/cs401/speechdata/Testing/unkn_',num2str(i),'.flac');
    username='5e0c57e7-e358-43bd-a01e-a41ddd2c612a';
    password='8ygvoOxxLVTT';
    c1='--header "Content-Type: audio/flac"';
    c2='--header "Transfers-Encoding: chunked"';
    c3= '--data-binary @%s';
    http='https://stream.watsonplatform.net/speech-to-text/api';
end
