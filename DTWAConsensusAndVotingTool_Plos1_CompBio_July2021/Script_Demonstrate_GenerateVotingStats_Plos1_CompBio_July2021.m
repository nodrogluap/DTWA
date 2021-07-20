function ensembleInfo = Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021(varargin)
% function Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021()
% M. Smith, Electrical and Sftware Engineering, University of Calgary, Calgary, Canada, June 2021

%% Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021(number 1 - 3) over rides forceEnsemble
  forceEnsemble = 2;    % hard code which one you want to analyse
  p = inputParser();
  
% With Enolase you can start difference consensus building eveery 128 streams up tom 7000
  p.addParameter('buildConsensusSize', 16, @(x) isnumeric(x));    % Votes on twice as many ??
  p.addParameter('posnEnsembleStartStream', 1, @(x) isnumeric(x)); 
  p.addParameter('whichEnsemble', forceEnsemble, @(x) isnumeric(x)); 
  
% Large scale voting takes time -- use this for fast check code is working
% Displaying all DTW figures when calculating voting slows things
  p.addParameter('displayVotingDTWFigures', true, @(x) islogical(x));
  p.addParameter('testVotingDisplay', true, @(x) islogical(x));
  p.addParameter('doDTWA', true, @(x) islogical(x));   % Set false if code run before and consensus already exist
  p.addParameter('doVoting', true, @(x) islogical(x));   % Set false if code run before and consensus already exist
  p.addParameter('saveVotingFigures', false, @(x) islogical(x));
  p.addParameter('increaseFactorsNumStreamsWhenVoting', 1, @(x) isnumeric(x));
%%    
  parse(p,varargin{:});      

  switch p.Results.whichEnsemble
    case 1
      ensembleName = 'Sequin_R1_71_1';
    case 2
      ensembleName = 'Sequin_R2_55_3'; 
    case 3
      ensembleName = 'Enolase';  
    case 4
      ensembleName = 'MyData1';
    case 5
      ensembleName = 'NyData2'; 
    case 6
      ensembleName = 'MyData3'; 
    otherwise
      error('Set your data base name %d\n', whichEnsemble);
  end

%% Prepare the cleaned data
  donotRegenerateConsensusIfAvailable = true;   % Set false if you have modified the consensus program
  getCleanedDataIfAvailable = true;             % Set false if you have modified the header removal program
  if ~getCleanedDataIfAvailable
    donotRegenerateConsensusIfAvailable = false;
  end
  
  ensembleInfo = Ensemble_DefaultSettings_Plos1_CompBio_July2021('ensembleName', ensembleName, ...
    'numStreams', p.Results.buildConsensusSize, 'posnEnsembleStartStream', p.Results.posnEnsembleStartStream, ...
    'getCleanedDataIfAvailable', getCleanedDataIfAvailable, 'doDTWA', p.Results.doDTWA, 'saveVotingFigures', p.Results.saveVotingFigures, ...
    'donotRegenerateConsensusIfAvailable', donotRegenerateConsensusIfAvailable, 'increaseFactorsNumStreamsWhenVoting', p.Results.increaseFactorsNumStreamsWhenVoting, ...
    'doVoting', true, 'testVotingDisplay', p.Results.testVotingDisplay, 'displayVotingDTWFigures', p.Results.displayVotingDTWFigures); 

  ensembleInfo = DataSets_Used_Plos1_CompBio_July2021(ensembleInfo);    
  goldStandardInfo = GetGoldStandardInfo_Plos1_CompBio_July2021(ensembleInfo);
 
%% Get or prepare cleaned data set with headers and outliers removed  
  cleanedNoHeaderDataInfo = GetCleanedDataInfo_Plos1_CompBio_July2021(ensembleInfo, goldStandardInfo);    

%% Performing DTWA analysis
    DBA_DTWA = 1;        SSG_DTWA = 2;     MM_DTWA = 3;

    DTWA(DBA_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('DBA_DTWA', cleanedNoHeaderDataInfo);
    DTWA(SSG_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('SSG_DTWA', cleanedNoHeaderDataInfo);
    DTWA(MM_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('MM_DTWA', cleanedNoHeaderDataInfo);
    
  if ensembleInfo.doDTWA  % Needed in voting -- but no need to recalculate  
    
    Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(DBA_DTWA));  
    Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(SSG_DTWA)); 
    Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(MM_DTWA));  
  end
	
%% Parameters controlling voting
  if (ensembleInfo.doVoting) 
    voteInfo = Voting_DefaultSettings_Plos1_CompBio_July2021(ensembleInfo); 
    
    DTWA(SSG_DTWA).doVoting = true;
    DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(SSG_DTWA), ensembleInfo);
    DTWA(MM_DTWA).doVoting = true;
    DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(MM_DTWA), ensembleInfo); 
    DTWA(DBA_DTWA).doVoting = true;          
    DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(DBA_DTWA), ensembleInfo);
  end
  
