function streamData = GetStreamFromFile_Plos1_CompBio_July2021(inFileName, numStreams, posnStartStream) 
% function streamData = GetStreamFromFile_Plos1_CompBio_July2021(inFileName, numStreams, posnStartStream) 
% M. Smith, Electrical and SOftware Engineering, University of Calgary, June 2021

    formatSpec = '%f'; 

    inFileID = fopen(inFileName,'r');
    if (inFileID == -1)
        error('Bad file name %s\n', inFileName);
    end

    %% Skip to first stream wanted
    for count = 1 : (posnStartStream - 1)
        fgets(inFileID);
    end

    %% Place streams into cells as all different lengths
    streamData = cell(numStreams, 1);
    for count = 1 : numStreams
        oneLine = fgets(inFileID);
%         mean(oneLine)
%         std(oneLine)
        [streamData{count}, ~] = sscanf(oneLine, formatSpec);
    end
    fclose(inFileID);
% end
