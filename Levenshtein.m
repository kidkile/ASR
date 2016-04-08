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
ref_count = 0;
SE = 0;
IE = 0;
DE = 0;
for i = 1:length(hyp)
   ref = textread([annotation_dir, filesep, 'unkn_', num2str(i), '.txt'], ...
       '%s', 'delimiter', '\n');
   hyp_parts = strsplit(' ', hyp{i});
   hyp_sentence = hyp_parts{3};
   
   ref_parts = strsplit(' ', ref{1});
   ref_sentence = ref_parts(3:end);
   ref_count = ref_count + length(ref_sentence);
    
end

SE = SE / ref_count;
IE = IE / ref_count;
DE = DE / ref_count;
LEV_DIST = SE + IE + DE;

return