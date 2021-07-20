function Build_Figs12AB_CompareDTW_MSEnolase_Plos1_CompBio_July2021
% function Build_Figs12AB_CompareDTW_MSEnolase_Plos1_CompBio_July2021
% M. Smith, Electrical and Computer Engineering, 
% University of Calgary, Calgary, Canada, June 2021

  ensembleNames = {'Sequin_R1_71_1'; 'Sequin_R2_55_3'; 'Enolase'};
  whichEnsemble = 3;   % Hard code for Enolase as only ENolase has enough data for multiple stream group analysis
  doTest = true;
  if doTest
    numStreams = 16;
    numDifferentCompares = 1;
    doDTWA = true;  doVoting = true; testVotingDisplay = 	true; saveVotingFigures = false; displayVotingDTWFigures = false;
  else
    numStreams = 256;
    numDifferentCompares = 20; 
    doDTWA = true;  doVoting = true; testVotingDisplay = 	false; saveVotingFigures = false; displayVotingDTWFigures = false;
  end

    Gold2ConsensusFigure = figure('Name', sprintf('%s GOLD TO CONSENSUS', string(ensembleNames(whichEnsemble)))); movegui('south');
    MeanConsensus2Ensemble = figure('Name', sprintf('%s MEAN CONSENSUS - ENSEMBLE', string(ensembleNames(whichEnsemble)))); movegui('southeast');
    SSGVotingFigure = nan;

  
  applyZNORMBeforeDTWA = true;  % ???????? Need for future investigation as discussed in Paper Section 7 
  
 for countCompares = 1 : numDifferentCompares
    for countEnsemble = whichEnsemble : whichEnsemble % Hard coded for Enolase
      ensembleName = ensembleNames{countEnsemble};
    
      posnEnsembleStartStream = 1 + numStreams * (countCompares - 1);   % Do consensus on numStreams do voting on twice as many
      posnEnsembleEndStream = posnEnsembleStartStream + numStreams - 1;
      ensembleInfo = Ensemble_DefaultSettings_Plos1_CompBio_July2021('ensembleName', ensembleName, 'applyZNORMBeforeDTWA', applyZNORMBeforeDTWA, ...
        'numStreams', numStreams, 'posnEnsembleStartStream', posnEnsembleStartStream, ...
        'doDTWA', doDTWA, 'donotRegenerateConsensusIfAvailable', true, 'saveVotingFigures', saveVotingFigures, ...
        'doVoting', doVoting, 'testVotingDisplay', testVotingDisplay, 'displayVotingDTWFigures', displayVotingDTWFigures); 
      
      ensembleInfo.quietFig5Generation = true;

      ensembleInfo = DataSets_Used_Plos1_CompBio_July2021(ensembleInfo);    
      goldStandardInfo = GetGoldStandardInfo_Plos1_CompBio_July2021(ensembleInfo);

    %% Get or prepare cleaned data set with headers and outliers removed  
       cleanedNoHeaderDataInfo = GetCleanedDataInfo_Plos1_CompBio_July2021(ensembleInfo, goldStandardInfo);    

    %% Performing DTWA analysis
        DBA_DTWA = 1;        SSG_DTWA = 2;     MM_DTWA = 3;

        DTWA(SSG_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('SSG_DTWA', cleanedNoHeaderDataInfo);
        DTWA(MM_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('MM_DTWA', cleanedNoHeaderDataInfo);
        DTWA(DBA_DTWA) = DTWA_DefaultSettings_Plos1_CompBio_July2021('DBA_DTWA', cleanedNoHeaderDataInfo);

      if ensembleInfo.doDTWA  % Needed in voting -- but no need to recalculate  
        Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(SSG_DTWA)); 
        Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(MM_DTWA));  
        Generate_DTWA_Consensus_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, DTWA(DBA_DTWA));  
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
    end
    seperateFigs5 = false;  % HACK
    [votingLevels, keepLegends] = DisplayVotingStats_Plos1_2021_Fig6(posnEnsembleStartStream, posnEnsembleEndStream, ...
      seperateFigs5, Gold2ConsensusFigure, MeanConsensus2Ensemble, SSGVotingFigure, ensembleInfo);
  end

  Fig12_MakeLegends_Plos1_CompBio_July2021(votingLevels,  keepLegends, seperateFigs5, Gold2ConsensusFigure, MeanConsensus2Ensemble, SSGVotingFigure)
  

    figHandle = figure(1);    movegui('northwest');  figHandle.Name = '_F_Fig10A';
    figHandle = figure(2);    movegui('northeast');  figHandle.Name = '_F_Fig10B';

  
  
function [votingLevels, keepLegends] = DisplayVotingStats_Plos1_2021_Fig6(startPosn, endPosn, ...
      seperateFigs5, DBAVotingFigure, MMVotingFigure, SSGVotingFigure, ensembleInfo)
% function DisplayVotingStats_Plos1_2021_Fig5(startPosn, endPosn, ...
%       seperateFigs5, DBAVotingFigure, MMVotingFigure, SSGVotingFigure);)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021


%%
    diaryDirectory = 'Diaries_Plos1_CompBio_July2021';
%     ensembleNames = {sprintf('Enolase_%d_%d',startPosn, endPosn); ... 
%       sprintf('Sequin_R1_71_1_%d_%d',startPosn, endPosn);  sprintf('Sequin_R2_55_3_%d_%d',startPosn, endPosn)} 
    ensembleNames = {sprintf('Enolase_%d_%d',startPosn, endPosn)};
    DTWANames = {'DBA'; 'SSG'; 'MM'};

%% Need to grab the number of voting levels used in this file
  infileName = sprintf('./%s/Results_%s_%s_DTWA_ZNORM=1.txt', diaryDirectory, ensembleNames{1}, DTWANames{1})
  infileID = fopen(infileName,'r');
  while ~feof(infileID)
    nextLine = fgetl(infileID); 
    if contains(nextLine, '_goldToConsensus')
      if ~contains(nextLine, 'Normalized_Gold')
        fprintf('%s\n', nextLine);
        votingInfo = fgetl(infileID); fprintf('%s\n',votingInfo);
        break;
      end 
    end
  end
  fclose(infileID);
  [votingLevels, numVotingLevels] = sscanf(votingInfo(2:end), '%f');

%  votingResults = nan(length(ensembleNames), length(DTWANames));
  for whichEnsemble = 1 : 1 % length(ensembleNames) 
    for whichDTWA = 1 : 1 % length(DTWANames)        % Think okay -- except this array can change size
      votingResults(whichEnsemble, whichDTWA).goldToConsensus = zeros(numVotingLevels, 1);           
      votingResults(whichEnsemble, whichDTWA).length_standard = zeros(numVotingLevels, 1);
      votingResults(whichEnsemble, whichDTWA).Consensus2Data_mean_dtwDistance = zeros(numVotingLevels, 1);
      votingResults(whichEnsemble, whichDTWA).Consensus2Data_std_dtwDistance = zeros(numVotingLevels, 1);
    end
  end
    
%% Read data from Diaries and 
  for whichEnsemble = 1 : length(ensembleNames)
    for whichDTWA = 1 : length(DTWANames) % File name already has filled in %d_%d
      infileName = sprintf('./%s/Results_%s_%s_DTWA_ZNORM=1.txt', diaryDirectory, ensembleNames{whichEnsemble},  DTWANames{whichDTWA});

      infileID = fopen(infileName,'r');     
      while ~feof(infileID)
        nextLine = fgetl(infileID); 
        if contains(nextLine, '*** Loaded')
          fprintf('\n%% %s\n', nextLine);
        elseif contains(nextLine, '_goldToConsensus')
          if ~contains(nextLine, 'Normalized_Gold')
            fprintf('%s\n', nextLine);
            fgetl(infileID); % garbage voting info
            nextLine = fgetl(infileID);
            fprintf('%s\n',  nextLine(6:end));
            [votingResults(whichEnsemble, whichDTWA).goldToConsensus, validValues] = sscanf(nextLine(6:end), '%f');

            if validValues ~= (numVotingLevels)
              fclose(infileID);
              error('_goldToConsensus Need to clear diaries');
            end
          end

        elseif contains(nextLine, '_length_standard')
          fprintf('%s\n', nextLine);
          fgetl(infileID); % garbage voting info
          nextLine = fgetl(infileID);
          fprintf('%s\n',  nextLine(6:end));
          [votingResults(whichEnsemble, whichDTWA).length_standard, validValues] = sscanf(nextLine(6:end), '%f');
          if validValues ~= (numVotingLevels )
            fclose(infileID);
            error('_length_standard  Need to clear diaries ');
          end
        elseif contains(nextLine, '_Consensus2Data_mean_dtwDistance')                
          if ~contains(nextLine, 'Normalized_Gold')
            fprintf('%s\n', nextLine);
            fgetl(infileID); % garbage voting info
            nextLine = fgetl(infileID);
            fprintf('%s\n',  nextLine(6:end));
            [votingResults(whichEnsemble, whichDTWA).Consensus2Data_mean_dtwDistance, validValues] = sscanf(nextLine(6:end), '%f');
            if validValues ~= (numVotingLevels )
              fclose(infileID);
              error('_Consensus2Data_mean_dtwDistance  Need to clear diaries');
            end
          end
        elseif contains(nextLine, '_Consensus2Data_std_dtwDistance')                     
          if ~contains(nextLine, 'Normalized_Gold')
            fprintf('%s\n', nextLine);
            fgetl(infileID); % garbage voting info
            nextLine = fgetl(infileID);
            fprintf('%s\n',  nextLine(6:end));
            [votingResults(whichEnsemble, whichDTWA).Consensus2Data_std_dtwDistance, validValues] = sscanf(nextLine(6:end), '%f');
            if validValues ~= (numVotingLevels)
              fclose(infileID);
              error('_Consensus2Data_std_dtwDistance  Need to clear diaries');
            end
          end
        end
      end
      fclose(infileID);              
    end
  end
    
  Enolase = 1;  Sequin_R1_71_1 = 2;         Sequin_R2_55_3 = 3;
  whichEnsemble = Enolase;
  DBA = 1; 	SSG = 2;    MM = 3;

%% PLOS1_June2-21_Fig.6A 6B 6C -- OLD version  6A 6B new version
  if seperateFigs5
% % % %     figure(DBAVotingFigure);  
% % % %     MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, DBA).length_standard, votingResults(whichEnsemble, DBA).goldToConsensus, '-k'); hold on; 
% % % % 
% % % %     figure(SSGVotingFigure);  
% % % %     MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, SSG).length_standard, votingResults(whichEnsemble, SSG).goldToConsensus, '-k'); hold on; 
% % % % 
% % % %     figure(MMVotingFigure);  
% % % %     keepLegends = MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, MM).length_standard, votingResults(whichEnsemble, MM).goldToConsensus, '-k'); hold on; 
  else
    E_GL = 1308; 
    figure(DBAVotingFigure);  
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, DBA).length_standard, votingResults(whichEnsemble, DBA).goldToConsensus / E_GL, '-k'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, SSG).length_standard, votingResults(whichEnsemble, SSG).goldToConsensus / E_GL, '-g'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, MM).length_standard, votingResults(whichEnsemble, MM).goldToConsensus / E_GL, '-r'); hold on; 
    
    figure(MMVotingFigure);  
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, DBA).length_standard, votingResults(whichEnsemble, DBA).Consensus2Data_mean_dtwDistance / E_GL, '-k'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, SSG).length_standard, votingResults(whichEnsemble, SSG).Consensus2Data_mean_dtwDistance / E_GL, '-g'); hold on; 
    keepLegends = MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(whichEnsemble, MM).length_standard, votingResults(whichEnsemble, MM).Consensus2Data_mean_dtwDistance / E_GL, '-r'); hold on; 
  end

