function cleaned_noHeaderData = CleanNoHeaderData_Plos1_CompBio_July2021(noHeaderDataFileName, setStdDevRange, stdDevAlongStream, goldStandardInfo, ensembleInfo)
% function cleaned_noHeaderData = CleanNoHeaderData_Plos1_CompBio_July2021(noHeaderDataFileName, setStdDevRange, stdDevAlongStream, goldStandardInfo, ensembleInfo)

load(noHeaderDataFileName, 'noHeaderData');

showNumLines = 30;
DisplayData_Plos1_CompBio_July2021(noHeaderData, showNumLines, sprintf('First %d Original Data with no headers',showNumLines));
movegui('northeast');

fprintf('***** Original Stats before Cleaning noHeader data\n');
GetStats_FromStream_Plos1_CompBio_July2021(noHeaderData,      @length, 'Length', setStdDevRange);
GetStats_FromStream_Plos1_CompBio_July2021(noHeaderData,      @mean, 'mean', setStdDevRange);
GetStats_FromStream_Plos1_CompBio_July2021(noHeaderData,      @std, 'stdev', setStdDevRange);
fprintf('\n');

roughCleanStream = noHeaderData;

%%  Very strong initial length deletion of anything smaller than goldStram length
[numStreams, ~] = size(roughCleanStream);
functionValues = zeros(numStreams, 1);
for count =  1 : numStreams
    functionValues(count) = length(roughCleanStream{count});
end

minimumLengthPercentage = 100;
fprintf('Delete all data with length less than %d percent of goldstandard length\n', minimumLengthPercentage); 

indexInRange = find(functionValues > floor(minimumLengthPercentage * goldStandardInfo.length / 100.));

numStreamsLeft = length(indexInRange);       % indexInRange is array of 1 and 0

infoOnCleanFunctionValues = zeros(numStreamsLeft, 1);
hardLengthCleanedStream = cell(numStreamsLeft, 1);
for count = 1 : numStreamsLeft
    hardLengthCleanedStream{count} = roughCleanStream{indexInRange(count)};
    infoOnCleanFunctionValues(count) = length(hardLengthCleanedStream{count});
end

roughCleanStream = hardLengthCleanedStream;
GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @length, 'Length -- after strong length clean', setStdDevRange);
GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @mean, 'mean  -- after strong length clean', setStdDevRange);
GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @std, 'stdev  -- after strong length clean', setStdDevRange);
fprintf('\n');

% DisplayData_10Jan2019(roughCleanStream, showNumLines, sprintf('First %d Hard clean data based on gold standard length',showNumLines));

%% Perform a quick first clean operations on data with header
% but without displaying information on the statistical characteristics of the data
fprintf('***  First round of pruning  setStdDevRange %d\n', setStdDevRange);


roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @length, 'Length', setStdDevRange);
if ensembleInfo.displayFirstRoundHeaderRemoval
    DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('First %d clean by length',showNumLines));
    movegui('northwest');
end


roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @mean, 'mean', setStdDevRange);
if ensembleInfo.displayFirstRoundHeaderRemoval
    DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('First %d  clean by length',showNumLines));
movegui('north');
end

roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @std, 'stdev', setStdDevRange);
if ensembleInfo.displayFirstRoundHeaderRemoval
    DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('First %d clean by stdDev',showNumLines));
    movegui('northeast');
end

fprintf('***  Second round of pruning\n');

roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @length, 'Length', setStdDevRange);
if ensembleInfo.displaySecondRoundHeaderRemoval
    DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('Second %d clean by length',showNumLines));
    movegui('southwest');
end

roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @mean, 'mean', setStdDevRange);
if ensembleInfo.displaySecondRoundHeaderRemoval  || ensembleInfo.display_Plos1_CompBio_July2021_Fig3A
    if ensembleInfo.display_Plos1_CompBio_July2021_Fig3A
      Fig3A_DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('Fig 3A ShowLines # %d',showNumLines), goldStandardInfo);
    else
      DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('Second %d clean by length',showNumLines));
    end
    movegui('south');
end

roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @std, 'stdev', setStdDevRange);
if ensembleInfo.displaySecondRoundHeaderRemoval
    DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('Second %d clean by stdDev',showNumLines));
    movegui('southeast');
end

for count = 1 : 5
    roughCleanStream = GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream, @stdDev_AverageAlongStream_10Jan2019, ...
                'Clean using stdDev_AverageAlongStream_Nov2018', stdDevAlongStream);
    if ensembleInfo.displaySecondRoundHeaderRemoval
        DisplayData_Plos1_CompBio_July2021(roughCleanStream, showNumLines, sprintf('Second %d clean by stdDev',showNumLines));
        movegui('southeast');
    end
end

%% Final cleaned data
cleaned_noHeaderData = roughCleanStream;
fprintf('*** Final stats on length\n');
GetStats_FromStream_Plos1_CompBio_July2021(roughCleanStream,          @length, 'Length', setStdDevRange);
if ensembleInfo.display_Plos1_CompBio_July2021_Fig3B
	Fig3B_DisplayData_Plos1_CompBio_July2021(cleaned_noHeaderData, showNumLines, sprintf('Fig 3B Showlines #  %d',showNumLines), goldStandardInfo);
else
	DisplayData_Plos1_CompBio_July2021(cleaned_noHeaderData, showNumLines, sprintf(' %d FinalCleanedData',showNumLines));
end
movegui('southeast');

function result = stdDev_AverageAlongStream_10Jan2019(signal)
% function result = stdDev_AverageAlongStream_10Jan2019(signal)

numPoints = length(signal);
numDivisions = 30;
sizeDivision = floor(numPoints / numDivisions);

sumStdDeviations = 0;

for count = 1 : sizeDivision : (numDivisions * sizeDivision)
    sumStdDeviations = sumStdDeviations +  std(signal(count : (count + sizeDivision -1)));
end

result = sumStdDeviations / numDivisions;
