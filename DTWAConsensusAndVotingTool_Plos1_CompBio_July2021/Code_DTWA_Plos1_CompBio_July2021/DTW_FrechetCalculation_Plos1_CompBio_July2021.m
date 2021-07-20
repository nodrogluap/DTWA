function [mean_dtwDistance, std_dtwDistance, mean_dtwDistance_Normalized_Gold, std_dtwDistance_Normalized_Gold, ...
     mean_dtwDistance_Normalized_Stream, std_dtwDistance_Normalized_Stream] = ...
                    DTW_FrechetCalculation_Plos1_CompBio_July2021(standard, shortSet, numCompares, whichStandard, goldstandardLength, DTWA)
% function [mean_dtwDistance, std_dtwDistance, mean_dtwDistance_Normalized_Gold, std_dtwDistance_Normalized_Gold, ...
%     mean_dtwDistance_Normalized_Stream, std_dtwDistance_Normalized_Stream] = ...
%                    DTW_FrechetCalculation_Plos1_CompBio_July2021(standard, shortSet, numCompares, whichStandard, goldstandardLength, DTWA)

dtwDistance = zeros(numCompares, 1);
dtwDistance_NormGold = zeros(numCompares, 1);
dtwDistance_NormStream = zeros(numCompares, 1);

if DTWA.applyZNORMBeforeDTWA
    standardZNorm = (standard - mean(standard)) / std(standard);
    for count = 1 : numCompares
        signalZNorm = (shortSet{count} - mean(shortSet{count})) / std(shortSet{count});
        dtwDistance(count) = dtw(standardZNorm, signalZNorm);
        % **************  Now normalize by length goldstandard
        dtwDistance_NormGold(count) = dtwDistance(count) / goldstandardLength; 
        dtwDistance_NormStream(count) = dtwDistance(count) / length(shortSet{count});
    end
else
    standardNoMean = (standard - mean(standard));
    for count = 1 : numCompares
        signalNoMean = (shortSet{count} - mean(shortSet{count}));
        dtwDistance(count) = dtw(standardNoMean, signalNoMean);
        % **************  Now normalize by length goldstandard
        dtwDistance_NormGold(count) = dtwDistance(count) / goldstandardLength; 
        dtwDistance_NormStream(count) = dtwDistance(count) / length(shortSet{count});
    end
end
    

mean_dtwDistance = mean(dtwDistance);
std_dtwDistance = std(dtwDistance);
mean_dtwDistance_Normalized_Gold = mean(dtwDistance_NormGold);
std_dtwDistance_Normalized_Gold = std(dtwDistance_NormGold);

mean_dtwDistance_Normalized_Stream = mean(dtwDistance_NormStream);
std_dtwDistance_Normalized_Stream = std(dtwDistance_NormStream);


fprintf('#Vote with %d mean %4.0f +- %4.0f  NormGold %4.3f +- %4.3f  NormCons %4.3f +- %4.3f %s \tstandardLength \t%d  bias %4.3f\n', ...
    numCompares, mean(dtwDistance), std(dtwDistance), mean(dtwDistance_NormGold), std(dtwDistance_NormGold), ...
        mean(dtwDistance_NormStream), std(dtwDistance_NormStream), whichStandard, length(standard), length(standard) / goldstandardLength);

