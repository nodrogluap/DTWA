function endHeader = FindHeaderLength_Plos1_CompBio_July2021(origData, goodStart, goodEnd)
% function endHeader = FindHeaderLength_Plos1_CompBio_July2021(origData, whichApproach, goodStart, goodEnd)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

%% Take into account the data length might be smaller than suggested good range
    if length(origData) < goodEnd
        goodEnd = length(origData) - 100;
    end
    goodMean = mean(origData(goodStart : goodEnd));
    goodStdDev = std(origData(goodStart : goodEnd));

    %% **** needs fixing -- IGNORE FOR NOW
    % display('Adjust header first jump as was problem causing missing nucleotides for Sequin');
    endHeader =  50; % 100;  % Jump past the initial issues we found experimentally

    % Examine the data in small blocks 
    steps = 16;


    %% Compare header stats with "good data" stats
    % If deviation is smaller than this -- then out of header into true dats
    allowedMeanPercentageError = 0.03;
    allowedStdDevPercentageError = 0.1;
    maxNumberOfTimesStatsMatchBeforeEndHeaderReached = 2;

    inHeader = true;
    numGoodDataStatsFound = 0;

    % Step along the header finding its local mean and standard deviation
    % Make sure that if header difficult to find we don't run out of data
    while (inHeader) && ((endHeader + steps) < length(origData))
        localMean =  mean(origData(endHeader : endHeader + steps));
        localStdDev=  std(origData(endHeader : endHeader + steps));

         if ( ((abs(localStdDev - goodStdDev) / goodStdDev) < 2 * allowedStdDevPercentageError) ...
                 && ((abs(localMean - goodMean) / goodMean) < 2 * allowedMeanPercentageError) )
             numGoodDataStatsFound = numGoodDataStatsFound + 1;
             if (numGoodDataStatsFound == maxNumberOfTimesStatsMatchBeforeEndHeaderReached)
                 inHeader = false;
             else
                endHeader = endHeader + steps / 2;    % Examine next bit of header
             end
         else
             endHeader = endHeader + steps / 2;       % Go a little farther
         end    
    end 
    
    %% *************************
    endHeader = endHeader - steps / 2;
