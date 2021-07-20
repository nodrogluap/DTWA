function Build_Figs1_3_Demonstrate_HeaderRemoval_Plos1_CompBio_July2021(whichEnsemble)
% function Build_Figs1_3_Demonstrate_HeaderRemoval_Plos1_CompBio_July2021()
% M. Smith, Electrical and Computer Engineering, 
% University of Calgary, Calgary, Canada, June 2021

%% This script can be used to generate Figs 1, 3A and 3B
% or a general scriptto clean your signals with a change of data names and directory
% See Ensemble_DefaultSettings_Plos1_CompBio_July2021.m in Code_DefaultSettings_Plos1_CompBio_July2021

  if nargin == 0  % Prepare Plos1 Fig. 1, Figs 3A and 5B unless argument in
    whichEnsemble = 1;
  end
  
% Default turn off of specific figure generation
  close all; % To start figure counters back to 1
  display_Plos1_CompBio_July2021_Fig1 = false;  % Plos1 Figs were generated on for Sequin_R1
  display_Plos1_CompBio_July2021_Fig3A = false;
  display_Plos1_CompBio_July2021_Fig3B = false;
  
  % Force a new cleaning to show stages of header removal
  % If set true -- then will hunt for the previous cleaning results
  getCleanedDataIfAvailable = false;  % This forces a new cleaning
  
  switch whichEnsemble
    case 1  % Used inPLOS1 June 2021  Fig 1
      ensembleName = 'Sequin_R1_71_1';
      numStreams = 130;         % Slightly more than is available
      display_Plos1_CompBio_July2021_Fig1 = true;
      display_Plos1_CompBio_July2021_Fig3A = true;
      display_Plos1_CompBio_July2021_Fig3B = true;
    case 2
      ensembleName = 'Sequin_R2_55_3';
      numStreams = 130;         % Slightly more than is available
    case 3
      ensembleName = 'Enolase';
      numStreams = 130;         % Make equivalent -- 7000 available
    otherwise
      error('Set your data base name %d\n', whichEnsemble);
  end
  
  ensembleInfo = ...
    Ensemble_DefaultSettings_Plos1_CompBio_July2021('ensembleName', ensembleName, ...
      'numStreams', numStreams, 'getCleanedDataIfAvailable', getCleanedDataIfAvailable, ...
      'display_Plos1_CompBio_July2021_Fig1', display_Plos1_CompBio_July2021_Fig1, ...
      'display_Plos1_CompBio_July2021_Fig3A', display_Plos1_CompBio_July2021_Fig3A, ...
      'display_Plos1_CompBio_July2021_Fig3B', display_Plos1_CompBio_July2021_Fig3B);   
    
  ensembleInfo = DataSets_Used_Plos1_CompBio_July2021(ensembleInfo);    
  goldStandardInfo = GetGoldStandardInfo_Plos1_CompBio_July2021(ensembleInfo);
 
%% Get or prepare cleaned data set with headers and outliers removed  
    cleanedNoHeaderDataInfo = GetCleanedDataInfo_Plos1_CompBio_July2021(ensembleInfo, goldStandardInfo);    

%% Set figures to be ethe size required for PACE
  PACE = true;
  if PACE && (whichEnsemble == 1)
    figHandle = figure(2);   figHandle.Units = 'centimeters'; figHandle.Position = [ 21 10 22.5 16.5]; movegui('northwest'); figHandle.Name = '_F_Fig1_Sequin2_withHeader';
    figHandle = figure(4);   movegui('northeast'); figHandle.Name = '_F_Fig3A_Sequin2_SomeClean';
    figHandle = figure(5);   movegui('southeast'); figHandle.Name = '_F_Fig3B_Sequin2_FinalClean';
  end
    