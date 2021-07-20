function [cleanedStream, meanValue, stdDev, percentageFit] = ...
         GetStats_FromStream_Plos_June2021(streamData, cleanFunctionCall, cleanFunctionInfo, setSTDDevRange)
% function [cleanedStream, meanValue, stdDev, percentageFit] = ...
%          GetStats_FromStream_Plos_June2021(streamData, cleanFunctionCall, cleanFunctionInfo, setSTDDevRange)
% M. Smith, Electrical and SOftware ENgineering, University of Calgary, June 2021

[numStreams, ~] = size(streamData);

%% Get the information from the data stream
functionValues = zeros(numStreams, 1);
for count =  1 : numStreams
    functionValues(count) = cleanFunctionCall(streamData{count});
end

%% Calculate mean and stdev of function stats
meanValue = mean(functionValues);
stdDev = std(functionValues');  
indexInRange = find((functionValues < (meanValue + setSTDDevRange * stdDev)) & (functionValues > (meanValue - setSTDDevRange * stdDev)));

% Output information on the cleaning operation
numStreamsLeft = length(indexInRange);       % indexInRange is array of 1 and 0
percentageFit = sum(length(indexInRange)) / numStreams;
fprintf('%s -- mean %4.1f +- %4.1f -- percentage fit (%3.1f stdev) %4.3f\n', cleanFunctionInfo, meanValue, stdDev, setSTDDevRange, percentageFit);

%% Actually perform the cleaning operation
infoOnCleanFunctionValues = zeros(numStreamsLeft, 1);
cleanedStream = cell(numStreamsLeft, 1);
for count = 1 : numStreamsLeft
    cleanedStream{count} = streamData{indexInRange(count)};
    infoOnCleanFunctionValues(count) = cleanFunctionCall(cleanedStream{count});
end

fprintf('If cleaned at %3.1f stdev there would be %d streams left from %d\n', setSTDDevRange, numStreamsLeft, numStreams);
meanValue = mean(infoOnCleanFunctionValues);
stdDev = std(infoOnCleanFunctionValues);
fprintf('After cleaning %s would have a mean %4.1f +- %4.1f\n\n', cleanFunctionInfo, meanValue, stdDev);   % *** NOV 2018 -- Minor word change
