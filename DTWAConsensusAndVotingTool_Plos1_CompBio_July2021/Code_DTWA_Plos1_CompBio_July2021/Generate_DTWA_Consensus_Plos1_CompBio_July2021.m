function Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA, goldStandardInfo)
% function Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA, goldStandardInfo)
% M. Smith, Electrical and Software Engineering, University of Calgary,
% June 2021

    for DTWAlength = 1 : length(DTWA.consensusSizes)
        DTWA.useNumStreamsInDTWA = DTWA.consensusSizes(DTWAlength);
        if  DTWA.useNumStreamsInDTWA > cleanedNoHeaderDataInfo.numCleanedStreams
            DTWA.useNumStreamsInDTWA = cleanedNoHeaderDataInfo.numCleanedStreams;
        end
        consensusDirectory = DTWA.consensusDirectory; % 'Consensus_Jan2019'; %  './Consensus_Jan2019'; 
        consensusFileName = sprintf('%s/%s_%s_%d_ZNORM_%d_SEEDED_%d.mat', consensusDirectory, cleanedNoHeaderDataInfo.nameDetails,  DTWA.name,  ...
            DTWA.useNumStreamsInDTWA, DTWA.applyZNORMBeforeDTWA, DTWA.seedStreamNumber);
        if (DTWA.donotRegenerateConsensusIfAvailable) && exist(consensusFileName, 'file')
                fprintf('\t\t>%s< already generated\n', consensusFileName)
        else
            %% Is it good or bad to Z-normalize the streams?
            fprintf('\t\t>%s< Generating\n', consensusFileName)
            if  DTWA.applyZNORMBeforeDTWA == true
                fprintf('%S DTWA using \n',  DTWA.name, DTWA.useNumStreamsInDTWA);  % numCleanStreamRemaining);
                streamForDTWA = cell(DTWA.useNumStreamsInDTWA, 1);  
                for count = 1 : DTWA.useNumStreamsInDTWA 
                    signal = cleanedNoHeaderDataInfo.streams{count};
                    streamForDTWA{count} = (signal - mean(signal)) / std(signal);
                end
            else
                fprintf('%S DTWA using \n',  DTWA.name, DTWA.useNumStreamsInDTWA);  % numCleanStreamRemaining);
                streamForDTWA = cell(DTWA.useNumStreamsInDTWA, 1); 
                scaleByFirstStreamStdDev = std(cleanedNoHeaderDataInfo.streams{1});
                for count = 1 : DTWA.useNumStreamsInDTWA 
                    signal = cleanedNoHeaderDataInfo.streams{count};
                    streamForDTWA{count} =  (signal - mean(signal)) / scaleByFirstStreamStdDev;
                end
            end

            tic
            if contains(DTWA.name, 'DBA') % Run Petitjean DBA
                pruneDBA = false;    
                consensus = DTW_BarycentreAveraging_Plos1_CompBio_July2021(streamForDTWA, DTWA, pruneDBA);

            elseif  contains(DTWA.name, 'MM') 
                consensus = MinimunMean_Plos1_CompBio_July2021(streamForDTWA, DTWA);     

            elseif contains(DTWA.name,  'SSG') % Run SSG DTWA
                consensus = SubGradientDescent_Plos1_CompBio_July2021(streamForDTWA, DTWA, []);      
            else
                error('Unknown %s', DTWA.name);
            end
            toc;
            
            save(consensusFileName, 'consensus');
        end
    end



