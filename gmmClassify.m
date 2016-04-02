function result = gmmClassify( testdir, theta )
% gmmClassify is a scripts that calculates 
% and reports the likehoods of the five 
% most likely speakers for each test utterance.
DD = dir(testdir);

%to get each data file load
test_file = load(strcat(dir_test,'/',files(1).name));


result = 1;
end
