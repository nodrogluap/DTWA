function adjustCleanedNoHeaderDataInfo = AdjustForDataLength_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, ensembleInfo)

    cleanedNoHeaderDirectory = ensembleInfo.cleanedNoHeaderDirectory; % 'CleanDataSets_Feb2019';    % './CleanDataSets_Sept2018/' 
    cleanedNoHeaderDataInfo.nameDetails = sprintf('%s_%1d_%1d', ...
            cleanedNoHeaderDataInfo.ensembleName, cleanedNoHeaderDataInfo.posnEnsembleStartStream, cleanedNoHeaderDataInfo.posnEnsembleLastStream);
    cleanedNoHeaderDataInfo.nameDetails = sprintf('%s_LnRange%d_%d', cleanedNoHeaderDataInfo.nameDetails, ensembleInfo.posnEnsembleLengthStart, ensembleInfo.posnEnsembleLengthEnd);
    cleanedNoHeaderFileName = sprintf('%s/CleanedNoHeader_%s.mat', ...
                cleanedNoHeaderDirectory, cleanedNoHeaderDataInfo.nameDetails);
    adjustCleanedNoHeaderDataInfo = cleanedNoHeaderDataInfo;
        
    if ensembleInfo.getCleanedDataIfAvailable == true  % If cleaned no header data available
        try
            load(cleanedNoHeaderFileName, 'cleaned_noHeaderData');
            adjustCleanedNoHeaderDataInfo.streams = cleaned_noHeaderData;
            adjustCleanedNoHeaderDataInfo.numCleanedStreams = length(cleaned_noHeaderData);
            fprintf('*** Loaded %s\n', cleanedNoHeaderFileName);
            return
        catch
            fprintf('*** >%s< not available -- generating cleaned no header data with fixed lengths\n', cleanedNoHeaderFileName);
        end
    end
    
    numStreams = cleanedNoHeaderDataInfo.numCleanedStreams;

    %% Get the information from the data stream
    functionValues = zeros(numStreams, 1);
    for count =  1 : numStreams
        functionValues(count) = length(cleanedNoHeaderDataInfo.streams{count});
    end
    
    indexInRange = find( (functionValues >=  ensembleInfo.posnEnsembleLengthStart) & ((functionValues <= ensembleInfo.posnEnsembleLengthEnd) ));

    % Output information on the cleaning operation
    numStreamsLeft = length(indexInRange);       % indexInRange is array of 1 and 0
    if (numStreamsLeft < 2)
        error('EXITTING -- %d streams in this range %d -> %d', numStreamsLeft, ensembleInfo.posnEnsembleLengthStart, ensembleInfo.posnEnsembleLengthEnd);
    end
    fprintf('\t\t\tKeeping %d streams in length range %d --> %d\n', numStreamsLeft, ensembleInfo.posnEnsembleLengthStart, ensembleInfo.posnEnsembleLengthEnd);

    adjustCleanedNoHeaderDataInfo.streams = cell(numStreamsLeft, 1);
    adjustCleanedNoHeaderDataInfo.numCleanedStreams = numStreamsLeft;
    for count = 1 : numStreamsLeft
        adjustCleanedNoHeaderDataInfo.streams{count} = cleanedNoHeaderDataInfo.streams{indexInRange(count)};
    end

    showNumLines = 30;
    if showNumLines > numStreamsLeft
        showNumLines = numStreamsLeft;
    end
    DisplayData_Plos1_CompBio_July2021(adjustCleanedNoHeaderDataInfo.streams, showNumLines, sprintf('AdjustForDataLength_Plos1_CompBio_July2021: Show %d FinalCleanedData - Length Adjusted',showNumLines));
    
    cleaned_noHeaderData = adjustCleanedNoHeaderDataInfo.streams;   % Save the data s we dont have t rebuild ths again
    save(cleanedNoHeaderFileName, 'cleaned_noHeaderData');
