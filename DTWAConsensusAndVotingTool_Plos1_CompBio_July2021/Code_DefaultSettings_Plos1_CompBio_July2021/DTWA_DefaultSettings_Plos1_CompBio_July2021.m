function DTWA = DTWA_DefaultSettings_Plos1_CompBio_July2021(DTWAname, ensembleInfo)
% function DTWA_DefaultSettings_Plos1_CompBio_July2021(DTWAname, ensembleName)
% Modified M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada, June 2021

    DTWA.name = DTWAname;
 
    DTWA.seedStreamNumber = 0; % 0 = default centroid approach; -num = use gold as seed; +num = use stream as seed 
    DTWA.epochs = 5;
    DTWA.applyZNORMBeforeDTWA = ensembleInfo.applyZNORMBeforeDTWA;
    DTWA.donotRegenerateConsensusIfAvailable = ensembleInfo.donotRegenerateConsensusIfAvailable;   % Set to false to regenerate consensus
    
    DTWA.doVoting = false;
    DTWA.diaryDirectory = './Diaries_Plos1_CompBio_July2021'; 
    DTWA.consensusDirectory = './Consensus_Plos1_CompBio_July2021'; 
    increaseFactorsNumStreamsWhenVoting = ensembleInfo.increaseFactorsNumStreamsWhenVoting;
    
    DTWA.consensusSizes =  ensembleInfo.numStreams;
    DTWA.useNumberStreamsWhenVoting = increaseFactorsNumStreamsWhenVoting * ensembleInfo.numStreams;    
    if nargin == 0    % GARBAGE STATEMENT -- WHY? 
      error('WHy do we get here?');
        DTWA.consensusSizes =  [32 64 64 64]; % 32]; % 32 32 32];   % [8 16 32 64 128 256];
        DTWA.useNumberStreamsWhenVoting = [32 64 128 256]; %64]; %  64 128 256];  % DTWA(SSG_DWTA).consensusSizes;
        DTWA.diaryNameVoting = sprintf('%s/Results_%s_ZNORM=%d.txt', DTWA.diaryDirectory, DTWA.name, DTWA.applyZNORMBeforeDTWA);
    elseif strcmp(ensembleInfo.ensembleName, 'Enolase')     
        DTWA.diaryNameVoting = sprintf('%s/Results_Enolase_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory, ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream,  DTWA.name, DTWA.applyZNORMBeforeDTWA);
    elseif strcmp(ensembleInfo.ensembleName, 'Sequin_R1_71_1')
        DTWA.diaryNameVoting = sprintf('%s/Results_Sequin_R1_71_1_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory,  ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, DTWA.name, DTWA.applyZNORMBeforeDTWA);
    elseif strcmp(ensembleInfo.ensembleName, 'Sequin_R2_55_3')
        DTWA.diaryNameVoting = sprintf('%s/Results_Sequin_R2_55_3_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory,   ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, DTWA.name, DTWA.applyZNORMBeforeDTWA);
        
    elseif strcmp(ensembleInfo.ensembleName, 'MyData1')
        DTWA.diaryNameVoting = sprintf('%s/Results_MyData1_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory,   ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, DTWA.name, DTWA.applyZNORMBeforeDTWA);
    elseif strcmp(ensembleInfo.ensembleName, 'MyData2')
        DTWA.diaryNameVoting = sprintf('%s/Results_MyData2_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory,   ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, DTWA.name, DTWA.applyZNORMBeforeDTWA);
    elseif strcmp(ensembleInfo.ensembleName, 'MyData3')
        DTWA.diaryNameVoting = sprintf('%s/Results_MyData3_%d_%d_%s_ZNORM=%d.txt', DTWA.diaryDirectory,   ...
          ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, DTWA.name, DTWA.applyZNORMBeforeDTWA);

    else
        error('Unknown request in DTWA_DefaultSettings_Plos1_CompBio_July2021 - %d',ensembleInfo.ensembleName);
    end


    