

speech_txt_dir = 'speech.txt'
f = fopen(speech_txt_dir, 'w');
for i=1:30
    % fix directories for cdf
    flac_dir = ['speechdata/Testing/unkn_', num2str(i), '.flac'];
    
    username='5e0c57e7-e358-43bd-a01e-a41ddd2c612a';
    password='8ygvoOxxLVTT';
    c1=' --header "Content-Type: audio/flac"';
    c2=' --header "Transfers-Encoding: chunked"';
    c3= [' --data-binary @', flac_dir];
    http=' "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true"';
    curl = ['curl -u ', username, ':', password, ' -X POST', ...
        c1, c2, c3, http];
    [status, result] = unix(curl);
    %data = JSON.parse(result);
    %disp(data.results{1, 1}.alternatives{1, 1}.transcript);
end
