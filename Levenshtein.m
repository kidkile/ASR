function [SE IE DE LEV_DIST] =Levenshtein(hypothesis,annotation_dir)
% Input:
%	hypothesis: The path to file containing the the recognition hypotheses
%	annotation_dir: The path to directory containing the annotations
%			(Ex. the Testing dir containing all the *.txt files)
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

hyp = textread(hypothesis, '%s', 'delimiter', '\n');
ref_word_count = 0;
SE = 0;
IE = 0;
DE = 0;
for i = 1:length(hyp)
   ref = textread([annotation_dir, filesep, 'unkn_', num2str(i), '.txt'], ...
       '%s', 'delimiter', '\n');
   hyp_parts = strsplit(hyp{i}, ' ');
   hyp_sentence = hyp_parts(3:end);
   
   ref_parts = strsplit(ref{1}, ' ');
   ref_sentence = ref_parts(3:end);
   ref_length = length(ref_parts);
   ref_word_count = ref_word_count + ref_length; % minus 2 to account for leading bit values
   
   n = length(ref_sentence);
   m = length(hyp_sentence);
   dist_mat = zeros(n+1, m+1);
   dist_mat(1, :) = Inf;
   dist_mat(:, 1) = Inf;
   dist_mat(1, 1) = 0;
   back_mat = zeros(n+1, m+1);
   for i = 1:n
       for j = 1:m
           del = dist_mat(i, j+1) + 1;
           ins = dist_mat(i+1, j) + 1;
           miss = dist_mat(i, j) +1;
           hit = dist_mat(i, j) + not(strcmp(ref_sentence{i}, hyp_sentence{j}));
           
           [dist_mat(i+1, j+1), am] = min([del, ins, miss, hit], [], 2);
           back_mat(i+1, j+1) = am;
       end
   end
   error_counter = zeros(1, 4);
   i = n+1;
   j = m+1;
   while not((j == 1) && (i == 1))
       am = back_mat(i, j);
       error_counter(am) = error_counter(am) + 1;
       i = i - (am ~= 2);
       j = j - (am ~= 1);
   end
   
   disp(SE / ref_length)
   disp(SE / ref_length)
   disp(SE / ref_length)
   disp((SE + IE + DE) / ref_length)
   
   SE = SE + error_counter(1);
   IE = IE + error_counter(2);
   DE = DE + error_counter(3);
   
end

SE = SE / ref_word_count;
IE = IE / ref_word_count;
DE = DE / ref_word_count;
LEV_DIST = SE + IE + DE;

return