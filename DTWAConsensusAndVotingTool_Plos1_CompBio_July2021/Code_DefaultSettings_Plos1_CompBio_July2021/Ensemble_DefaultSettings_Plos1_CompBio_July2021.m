function ensembleInfo = Ensemble_DefaultSettings_Plos1_CompBio_July2021(varargin)
% function ensembleInfo = Ensemble_DefaultSettings(varargin)
% M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada, June 2021
   
  p = inputParser();
  
  p.addParameter('ensembleName', '', @(x) ischar(x));
  
%% Parameters controlling number of original streams and their position in the data set   
  p.addParameter('numStreams', 64, @(x) isnumeric(x)); % Set default number of streams in analysis
  p.addParameter('posnEnsembleStartStream', 1, @(x) isnumeric(x));
  p.addParameter('applyZNORMBeforeDTWA', true, @(x) islogical(x));
 
%% String cleaning parameters
  p.addParameter('getCleanedDataIfAvailable', true, @(x) islogical(x));   % ******* If false, then will always build the new data Set
  p.addParameter('generalCleaning_StdDevRange', 5.0, @(x) isnumeric(x));
  p.addParameter('cleanAlongStream_StdDevRange', 2.0, @(x) isnumeric(x));
  p.addParameter('headerStdDevRange', 3.0, @(x) isnumeric(x));
  p.addParameter('displayFirstRoundHeaderRemoval', false, @(x) islogical(x));
  p.addParameter('displaySecondRoundHeaderRemoval', false, @(x) islogical(x));

%% Get data only in a certain length range
  p.addParameter('getCertainLengthRange', false, @(x) islogical(x));     % Set to true if wish to analyse specific length range (For SNR calculations)
  p.addParameter('posnEnsembleLengthStart', 2000, @(x) isnumeric(x));   % Only becomes useful if getCertainLengthRange = true;
  p.addParameter('posnEnsembleLengthEnd', 2100, @(x) isnumeric(x));

%% Get data whose length has been adjusted down to that of the goldStandard
  p.addParameter('generateShortenedSquiggles', false, @(x) islogical(x));
    
%%  Parameters to perform certain operations on the cleaned data set 
  p.addParameter('determineInsertionsDeletionProbabilities', false, @(x) islogical(x));
  p.addParameter('estimateSNR', false, @(x) islogical(x));
  p.addParameter('generateMockedData', false, @(x) islogical(x));

  p.addParameter('doDTWA', true, @(x) islogical(x));            % Part of other papers 
  p.addParameter('donotRegenerateConsensusIfAvailable', true, @(x) islogical(x));
  p.addParameter('doVoting', true, @(x) islogical(x)); 
  p.addParameter('testVotingDisplay', false, @(x) islogical(x));
  p.addParameter('displayVotingDTWFigures', false, @(x) islogical(x));
  p.addParameter('doCalculateDTWASpread', true, @(x) islogical(x));
  p.addParameter('saveVotingFigures', false, @(x) islogical(x));
  p.addParameter('increaseFactorsNumStreamsWhenVoting', 2, @(x) isnumeric(x));
  
  p.addParameter('cleanedNoHeaderDirectory', 'CleanDataSets_Plos1_CompBio_July2021', @(x) ischar(x));
  p.addParameter('originalDataDirectory', 'SquiggleStreamData_As_txt_Files', @(x) ischar(x)); 
  p.addParameter('noHeaderDataInfoDirectory',  'CleanDataSets_Plos1_CompBio_July2021/NoHeaderDataSets_Plos1_CompBio_July2021', @(x) ischar(x));   
  
  p.addParameter('display_Plos1_CompBio_July2021_Fig1', false, @(x) islogical(x));
  p.addParameter('display_Plos1_CompBio_July2021_Fig3A', false, @(x) islogical(x));
  p.addParameter('display_Plos1_CompBio_July2021_Fig3B', false, @(x) islogical(x));
  
%%    
  parse(p,varargin{:});
  
  ensembleInfo.ensembleName = p.Results.ensembleName;
%   ensembleInfo.fileName = DataSets_Used_Plos1_2021(ensembleInfo.ensembleName);  
  
%% Parameters controlling number of original streams and their position in the data set   
  ensembleInfo.numStreams = p.Results.numStreams; % Set default number of streams in analysis
  ensembleInfo.applyZNORMBeforeDTWA = p.Results.applyZNORMBeforeDTWA;
  ensembleInfo.posnEnsembleStartStream = p.Results.posnEnsembleStartStream;
  ensembleInfo.posnEnsembleEndStream = ensembleInfo.posnEnsembleStartStream + ensembleInfo.numStreams - 1;
 
%% String leaning parameters
  ensembleInfo.getCleanedDataIfAvailable = p.Results.getCleanedDataIfAvailable;  % ******* If false, then will always build the new data Set
  if (ensembleInfo.getCleanedDataIfAvailable == false)
      fprintf('ensembleInfo.getCleanedDataIfAvailable = false\n');   % Reminder that will take longer to generate cleaned data
  end
  ensembleInfo.generalCleaning_StdDevRange = p.Results.generalCleaning_StdDevRange;
  ensembleInfo.cleanAlongStream_StdDevRange = p.Results.cleanAlongStream_StdDevRange;
  ensembleInfo.headerStdDevRange = p.Results.headerStdDevRange;
  ensembleInfo.displayFirstRoundHeaderRemoval = p.Results.displayFirstRoundHeaderRemoval;
  ensembleInfo.displaySecondRoundHeaderRemoval = p.Results.displaySecondRoundHeaderRemoval;
  
  
%% Get data only in a certain length range
  ensembleInfo.getCertainLengthRange = p.Results.getCertainLengthRange;     % Set to true if wish to analyse specific length range (For SNR calculations)
  ensembleInfo.posnEnsembleLengthStart = p.Results.posnEnsembleLengthStart; 
  ensembleInfo.posnEnsembleLengthEnd = p.Results.posnEnsembleLengthEnd; 
    
%% Get data whose length has been adjusted down to that of the goldStandard
  ensembleInfo.generateShortenedSquiggles = p.Results.generateShortenedSquiggles;
    
%%  Parameters to perform certain operations on the cleaned data set 
  ensembleInfo.determineInsertionsDeletionProbabilities = p.Results.determineInsertionsDeletionProbabilities;
  ensembleInfo.estimateSNR = p.Results.estimateSNR;
  ensembleInfo.generateMockedData = p.Results.generateMockedData;
  if ensembleInfo.generateMockedData
    ensembleInfo.mockDataSetSize = 0;   % If 0 -- then will throw an error later
    warning('ensembleInfo.generateMockedData not useful in this paper\n');
  end  

  ensembleInfo.doDTWA = p.Results.doDTWA;
  ensembleInfo.doVoting = p.Results.doVoting;
  ensembleInfo.testVotingDisplay = p.Results.testVotingDisplay;
  ensembleInfo.displayVotingDTWFigures = p.Results.displayVotingDTWFigures;
  ensembleInfo.doCalculateDTWASpread = p.Results.doCalculateDTWASpread;
  ensembleInfo.saveVotingFigures = p.Results.saveVotingFigures;
  ensembleInfo.donotRegenerateConsensusIfAvailable = p.Results.donotRegenerateConsensusIfAvailable;
  ensembleInfo.increaseFactorsNumStreamsWhenVoting = p.Results.increaseFactorsNumStreamsWhenVoting;
  
  ensembleInfo.cleanedNoHeaderDirectory = p.Results.cleanedNoHeaderDirectory;
  ensembleInfo.originalDataDirectory = p.Results.originalDataDirectory;
  ensembleInfo.noHeaderDataInfoDirectory = p.Results.noHeaderDataInfoDirectory; 

  ensembleInfo.display_Plos1_CompBio_July2021_Fig1 = p.Results.display_Plos1_CompBio_July2021_Fig1; 
  ensembleInfo.display_Plos1_CompBio_July2021_Fig3A = p.Results.display_Plos1_CompBio_July2021_Fig3A; 
  ensembleInfo.display_Plos1_CompBio_July2021_Fig3B = p.Results.display_Plos1_CompBio_July2021_Fig3B; 
 
