function Build_Figs11AB_CompareDTW_AllGroups_Plos1_CompBio_July2021()
% function Build_Figs11AB_CompareDTW_AllGroups_Plos1_CompBio_July2021()
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

  fprintf('Set doTest = 1 displays only 2 voting levels\n');
  doTest = true;
  close all;
  
  figure('Name', 'PLOS1_June2-21_Fig.13A');  % Force the final figures to be 1 and 2
  figure('Name', 'PLOS1_June2-21_Fig.13B');

  if doTest
    smallEnsemble = 16; %  16 works fastest for testing graphs -- but all DTWA give same result
    displayVotingDTWFigures = true;   % Useful to set false for debugging voting at all levels
    testVotingDisplay = true;
    
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 3, 'displayVotingDTWFigures', displayVotingDTWFigures, 'testVotingDisplay', testVotingDisplay, 'buildConsensusSize', smallEnsemble);
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 1, 'displayVotingDTWFigures', displayVotingDTWFigures, 'testVotingDisplay', testVotingDisplay, 'buildConsensusSize', smallEnsemble);
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 2, 'displayVotingDTWFigures', displayVotingDTWFigures, 'testVotingDisplay', testVotingDisplay, 'buildConsensusSize', smallEnsemble);
    posnEnsembleStartStream = 1; posnEnsembleEndStream = smallEnsemble; % Normally info inside ensembleInfo in other scripts
  else
    largerEnsemble = 128; % Enolase could be bigger size -- but want  the same to make a comparison
    
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 3, 'buildConsensusSize', largerEnsemble, 'testVotingDisplay', false, 'displayVotingDTWFigures', false);
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 1, 'buildConsensusSize', largerEnsemble, 'testVotingDisplay', false, 'displayVotingDTWFigures', false ); 
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', 2, 'buildConsensusSize', largerEnsemble, 'testVotingDisplay', false, 'displayVotingDTWFigures', false);
    posnEnsembleStartStream = 1; posnEnsembleEndStream = largerEnsemble;
  end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There is a Matlab weirdness associated with 'Diaries' not being correctly
% formatted -- typically error message about 'values not matching in gold
% standard'

% This occurs because sometime MatLab is keeping open one of the Diaries in
% the background -- probably because of a earlier program crash or user
% stop
% -- but I ca't fix as I can't get the problem to become stable
% Even though it seems to be this file Results_Enolase_1_64_DBA_DTWA_ZNORM=1.txt
% that is most often corrupted as it will not delete

% Easiest fix.  Exit from Matlab -- Delete Diaries inside Diaries_Plos1_CompBio_July2021
% Activate Matlab -- run this code as DisplayVotingStats_Plos1_2021_Figs6AB('Try Again'


%%
  diaryDirectory = 'Diaries_Plos1_CompBio_July2021';
  ensembleNames = {'Sequin_R1_71_1'; 'Sequin_R2_55_3'; 'Enolase'}; %; 'Enalose_128_Enolase_May2018'};
  DTWANames = {'DBA'; 'SSG'; 'MM'};

%% Need to grab the number of voting levels used in this file
  infileName = sprintf('./%s/Results_%s_%d_%d_%s_DTWA_ZNORM=1.txt', diaryDirectory, ensembleNames{1}, ...
    posnEnsembleStartStream, posnEnsembleEndStream, DTWANames{1})
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

  for whichEnsemble = 1 : 1 % length(ensembleNames)
    for whichDTWA = 1 : 1 % length(DTWANames)
      votingResults(whichEnsemble, whichDTWA).goldToConsensus = zeros(numVotingLevels, 1);           
      votingResults(whichEnsemble, whichDTWA).length_standard = zeros(numVotingLevels, 1);
      votingResults(whichEnsemble, whichDTWA).Consensus2Data_mean_dtwDistance = zeros(numVotingLevels, 1);
      votingResults(whichEnsemble, whichDTWA).Consensus2Data_std_dtwDistance = zeros(numVotingLevels, 1);
    end
  end
    
%% Capture data from Diaries
%     outfileName = sprintf('./%s/Plot_PruneDiariesFromVotingPaper.m', diaryDirectory);
%     outfileID = -1; % fopen('stdout', 'w')

  for whichEnsemble = 1 : length(ensembleNames)
    for whichDTWA = 1 : length(DTWANames)
      infileName = sprintf('./%s/Results_%s_%d_%d_%s_DTWA_ZNORM=1.txt', diaryDirectory, ensembleNames{whichEnsemble}, ...
         posnEnsembleStartStream, posnEnsembleEndStream, DTWANames{whichDTWA});

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
            if validValues ~= numVotingLevels  
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
          if validValues ~= numVotingLevels
            close(infileID);
            error('_length_standard  Need to clear diaries ');
          end
        elseif contains(nextLine, '_Consensus2Data_mean_dtwDistance')                
          if ~contains(nextLine, 'Normalized_Gold')
            fprintf('%s\n', nextLine);
            fgetl(infileID); % garbage voting info
            nextLine = fgetl(infileID);
            fprintf('%s\n',  nextLine(6:end));
            [votingResults(whichEnsemble, whichDTWA).Consensus2Data_mean_dtwDistance, validValues] = sscanf(nextLine(6:end), '%f');
            if validValues ~= numVotingLevels
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
            if validValues ~= numVotingLevels
              fclose(infileID);
              error('_Consensus2Data_std_dtwDistance  Need to clear diaries');
            end
          end
        end
      end
      fclose(infileID);              
    end
  end

  Enolase = 3;        Sequin_R1_71_1 = 1;         Sequin_R2_55_3 = 2;
  DBA = 1; 	SSG = 2;    MM = 3;

%% PLOS1_June2-21_Fig.9A
  figure(1);  
  E_GL = 1308; S1_GL= 815; S2_GL = 776;
  if 1 % Hack to get legends correct without a lot of extra work
    plot(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).goldToConsensus / E_GL, '-k', 'linewidth', 2); hold on; 
    plot(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).goldToConsensus / E_GL, '--k', 'linewidth', 2); hold on;       
    plot(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).goldToConsensus / E_GL, ':k', 'linewidth', 2); hold on; 

    plot(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).goldToConsensus / S1_GL, '-r', 'linewidth', 2); hold on; 
    plot(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).goldToConsensus / S1_GL, '--r', 'linewidth', 2); hold on;      
    plot(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).goldToConsensus / S1_GL, ':r', 'linewidth', 2); hold on; 

    plot(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).goldToConsensus  / S2_GL, '-b', 'linewidth', 2); hold on; 
    plot(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).goldToConsensus  / S2_GL, '--b', 'linewidth', 2); hold on;      
    plot(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).goldToConsensus  / S2_GL, ':b', 'linewidth', 2); hold on; 
    
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).goldToConsensus / E_GL, '-k'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).goldToConsensus / E_GL, '--k'); hold on;       
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).goldToConsensus / E_GL, ':k'); hold on; 

    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).goldToConsensus / S1_GL, '-r'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).goldToConsensus / S1_GL, '--r'); hold on;      
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).goldToConsensus / S1_GL, ':r'); hold on; 

    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).goldToConsensus  / S2_GL, '-b'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).goldToConsensus  / S2_GL, '--b'); hold on;      
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).goldToConsensus  / S2_GL, ':b'); hold on; 
  else
% % % %     plot(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).goldToConsensus, '-k', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).goldToConsensus, '--k', 'linewidth', 2); hold on;       
% % % %     plot(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).goldToConsensus, ':k', 'linewidth', 2); hold on; 
% % % % 
% % % %     plot(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).goldToConsensus, '-r', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).goldToConsensus, '--r', 'linewidth', 2); hold on;      
% % % %     plot(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).goldToConsensus, ':r', 'linewidth', 2); hold on; 
% % % % 
% % % %     plot(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).goldToConsensus, '-b', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).goldToConsensus, '--b', 'linewidth', 2); hold on;      
% % % %     plot(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).goldToConsensus, ':b', 'linewidth', 2); hold on; 
  end  
  plot([1 1], [0 1], ':k', 'linewidth', 3); hold on; 
 axis([0.55 1.9 0.15 0.65]);
  xlabel('CONSENSUS LENGTH / GOLD LENGTH');
  ylabel('DTWdist (GOLD {\fontsize{20}\rightarrow} CONSENSUS)');
  legend('Enolase DBA', 'Enolase SSG', 'Enolase MM', 'R1\_71\_1 DBA', 'R1\_71\_1 SSG', 'R1\_71\_1 MM', 'R2\_55\_3 DBA', 'R2\_55\_3 SSG', 'R2\_55\_3 MM', 'location', 'southeast');
  movegui('north');
  text(0.3, 220, '\fontsize{14}A) - 11');

%% 
  figure(2);
  if 1
    % Hack to get legend correct
    plot(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).Consensus2Data_mean_dtwDistance / E_GL, '-k', 'linewidth', 2); hold on; 
    plot(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).Consensus2Data_mean_dtwDistance / E_GL, '--k', 'linewidth', 2); hold on;       
    plot(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).Consensus2Data_mean_dtwDistance / E_GL, ':k', 'linewidth', 2); hold on; 

    plot(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).Consensus2Data_mean_dtwDistance / S1_GL, '-r', 'linewidth', 2); hold on; 
    plot(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).Consensus2Data_mean_dtwDistance / S1_GL, '--r', 'linewidth', 2); hold on;      
    plot(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).Consensus2Data_mean_dtwDistance / S1_GL, ':r', 'linewidth', 2); hold on; 

    plot(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).Consensus2Data_mean_dtwDistance   / S2_GL, '-b', 'linewidth', 2); hold on; 
    plot(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).Consensus2Data_mean_dtwDistance   / S2_GL, '--b', 'linewidth', 2); hold on;      
    plot(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).Consensus2Data_mean_dtwDistance  / S2_GL, ':b', 'linewidth', 2); hold on; 
    
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).Consensus2Data_mean_dtwDistance / E_GL, '-k'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).Consensus2Data_mean_dtwDistance / E_GL, '--k'); hold on;       
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).Consensus2Data_mean_dtwDistance / E_GL, ':k'); hold on; 

    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).Consensus2Data_mean_dtwDistance  / S1_GL, '-r'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).Consensus2Data_mean_dtwDistance  / S1_GL, '--r'); hold on;      
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).Consensus2Data_mean_dtwDistance / S1_GL, ':r'); hold on; 

    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).Consensus2Data_mean_dtwDistance  / S2_GL, '-b'); hold on; 
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).Consensus2Data_mean_dtwDistance  / S2_GL, '--b'); hold on;      
    MyPlotManySymbols_Plos1_CompBio_July2021(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).Consensus2Data_mean_dtwDistance  / S2_GL, 'b'); hold on; 
  else
% % % %     plot(votingResults(Enolase, DBA).length_standard, votingResults(Enolase, DBA).Consensus2Data_mean_dtwDistance, '-k', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Enolase, SSG).length_standard, votingResults(Enolase, SSG).Consensus2Data_mean_dtwDistance, '--k', 'linewidth', 2); hold on;       
% % % %     plot(votingResults(Enolase, MM).length_standard, votingResults(Enolase, MM).Consensus2Data_mean_dtwDistance, ':k', 'linewidth', 2); hold on; 
% % % % 
% % % %     plot(votingResults(Sequin_R1_71_1, DBA).length_standard, votingResults(Sequin_R1_71_1, DBA).Consensus2Data_mean_dtwDistance, '-r', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Sequin_R1_71_1, SSG).length_standard, votingResults(Sequin_R1_71_1, SSG).Consensus2Data_mean_dtwDistance, '--r', 'linewidth', 2); hold on;      
% % % %     plot(votingResults(Sequin_R1_71_1, MM).length_standard, votingResults(Sequin_R1_71_1, MM).Consensus2Data_mean_dtwDistance, ':r', 'linewidth', 2); hold on; 
% % % % 
% % % %     plot(votingResults(Sequin_R2_55_3, DBA).length_standard, votingResults(Sequin_R2_55_3, DBA).Consensus2Data_mean_dtwDistance, '-b', 'linewidth', 2); hold on; 
% % % %     plot(votingResults(Sequin_R2_55_3, SSG).length_standard, votingResults(Sequin_R2_55_3, SSG).Consensus2Data_mean_dtwDistance, '--b', 'linewidth', 2); hold on;      
% % % %     plot(votingResults(Sequin_R2_55_3, MM).length_standard, votingResults(Sequin_R2_55_3, MM).Consensus2Data_mean_dtwDistance, ':b', 'linewidth', 2); hold on; 
  end
  plot([1 1], [0 1], ':k', 'linewidth', 3); hold on; 
 axis([0.55 1.9 0.15 0.7]);
  xlabel('CONSENSUS LENGTH / GOLD LENGTH');
  ylabel('NORMALIZED DTWdist (CONSENSUS {\fontsize{20}\rightarrow} ENSEMBLE)');
  legend('Enolase DBA', 'Enolase SSG', 'Enolase MM', 'R1\_71\_1 DBA', 'R1\_71\_1 SSG', 'R1\_71\_1 MM', 'R2\_55\_3 DBA', 'R2\_55\_3 SSG', 'R2\_55\_3 MM', 'location', 'southeast');
  movegui('south');
  text(0.3, 220, '\fontsize{14}B) - 11)');
  
    figHandle = figure(1);    movegui('northwest');  figHandle.Name = '_F_Fig13A';
    figHandle = figure(2);    movegui('northeast');  figHandle.Name = '_F_Fig13B';
 
