function  Build_Figs6_10AB_14ABCD_Plos1_CompBio_July2021
% function  Build_Figs6_10AB_14ABCD_Plos1_CompBio_July2021
% M. Smith, Electrical and Software Engineering, University of Calgary June 2021

% set doTest = true for fast check of any code changes
	doTest = true;

  if doTest
    % Need to do check if things are built
    numStreamsUsedDTWA = 16;  % Probably faster to test smaller if concensus not generated
  else
    numStreamsUsedDTWA = 128;  
  end

  generateFiles = true;
  ensembleNames = {'Sequin_R1_71_1'; 'Sequin_R2_55_3'; 'Enolase'};
  
  doDTWA = true;  doVoting = true; testVotingDisplay = 	true; saveVotingFigures = true; displayVotingDTWFigures = false;
  
  if generateFiles
    for countEnsemble = 1 : 3
      ensembleName = ensembleNames{countEnsemble};
    
      posnEnsembleStartStream = 1;   % Do consensus on numStreamsUsedDTWA do voting on twice as many
% % % %       posnEnsembleEndStream = posnEnsembleStartStream + numStreamsUsedDTWA - 1;
      ensembleInfo = Ensemble_DefaultSettings_Plos1_CompBio_July2021('ensembleName', ensembleName, ...
        'numStreams', numStreamsUsedDTWA, 'posnEnsembleStartStream', posnEnsembleStartStream, ...
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
%         VoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(SSG_DTWA), ensembleInfo); 
        DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(SSG_DTWA), ensembleInfo);
        DTWA(MM_DTWA).doVoting = true;
        DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(MM_DTWA), ensembleInfo); 
        DTWA(DBA_DTWA).doVoting = true;          
        DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA(DBA_DTWA), ensembleInfo);
      end
    end
  end
    
    
if doTest
  % Need to do check if things are built
%   Figs_5_9_14_Generate_Plos1_CompBio_July2021('5A', numStreamsUsedDTWA, ensembleNames);
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('13A', numStreamsUsedDTWA, ensembleNames);
else
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('6', numStreamsUsedDTWA, ensembleNames);  
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('9A', numStreamsUsedDTWA, ensembleNames);  
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('9B', numStreamsUsedDTWA, ensembleNames);   
  
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('13A', numStreamsUsedDTWA, ensembleNames);
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('13B', numStreamsUsedDTWA, ensembleNames);  
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('13C', numStreamsUsedDTWA, ensembleNames);
  Figs_6_9_13_Generate_Plos1_CompBio_July2021('13D', numStreamsUsedDTWA, ensembleNames);  
end

function votingLevels = FindNumVotingFigures_Plos1_CompBio_July2021(diaryName)
% Find num of voting figures in each DTWA figures from file in Diaries_Plos1_CompBio_July2021
  diaryDirectory = 'Diaries_Plos1_CompBio_July2021';
  infileName = sprintf('./%s/%s', diaryDirectory, diaryName)
  infileID = fopen(infileName,'r');
  while ~feof(infileID)
    nextLine = fgetl(infileID); 
    if contains(nextLine, '_goldToConsensus')
      if ~contains(nextLine, 'Normalized_Gold')
        fprintf('Diary Info %s\n', nextLine);
        votingInfo = fgetl(infileID); fprintf('%s\n',votingInfo);
        break;
      end 
    end
  end
  fclose(infileID);
  [votingLevels, numConsensusFigs] = sscanf(votingInfo(2:end), '%f');
  
function Figs_6_9_13_Generate_Plos1_CompBio_July2021(whichFig, numStreamsUsedDTWA, ensembleNames)
% function Figs_6_9_13_Generate_Plos1_CompBio_July2021(whichFig)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

  numEnsemble = 3;
  
%% File format of files seen in  VotingFigures_Plos1_CompBio_July2021
  numSequin_R1_71_1 = 1;  numSequin_R2_55_3 = 2; numEnolase = 3;
  dtwFigNameParts = cell(numEnsemble, 1);

%% Find information on voting figures in each dtw figures from file in Diaries_Plos1_CompBio_July2021
%   numStreamsUsedDTWA = 128;
  posnStartInStream = 1;    posnEndInStream = posnStartInStream + numStreamsUsedDTWA - 1;
% Example diaryName = Results_Enolase_1_64_DBA_DTWA_ZNORM=1  

  diaryName = sprintf('Results_%s_%d_%d_DBA_DTWA_ZNORM=1.txt', string(ensembleNames{1}), posnStartInStream, posnEndInStream)
  votingLevels = FindNumVotingFigures_Plos1_CompBio_July2021(diaryName);

%% 
  graphXPosition = 'end';
  if nargin == 0  % Have something with no arghuments
    whichFig = '6';
  end
  switch whichFig
    case '6' % No voting
      buildFigComparingDTWA = numEnolase;
      useDTWAFig = 1; 
      graphXPosition = 'start';
      numStreamsUsedDTWA = 128;
    case '9A' % No voting
      buildFigComparingDTWA = numEnolase;
      useDTWAFig = 1; 
      graphXPosition = 'end';
      numStreamsUsedDTWA = 128;
    case '9B'
      buildFigComparingDTWA = numEnolase;
      useDTWAFig = 2;
      graphXPosition = 'end';
      
      numStreamsUsedDTWA = 128;
      
    case '13A' % No voting
      buildFigComparingDTWA = numSequin_R1_71_1;
      useDTWAFig = 1;  
    case '13C'
      buildFigComparingDTWA = numSequin_R1_71_1;
      useDTWAFig = 2;
      
    case '13B' % No voting
      buildFigComparingDTWA = numSequin_R2_55_3;
      useDTWAFig = 1;
      
    case '13D'
      buildFigComparingDTWA = numSequin_R2_55_3;
      useDTWAFig = 2;
      
    otherwise
      error('Figure configuration not found %s', whichFig);
  end
  
  if strcmp(graphXPosition, 'end')
    fprintf('I hand changed the last two connection lines to bold before saving\n');
  end
      
  DisplayFigs_5_9AB_13ABCD_Plos1_CompBio_July2021(buildFigComparingDTWA, ensembleNames, votingLevels, useDTWAFig, graphXPosition, whichFig, ...
    posnStartInStream, posnEndInStream);
  
  
function DisplayFigs_5_9AB_13ABCD_Plos1_CompBio_July2021(buildFig, ensembleNames, votingLevels, useFig, graphXPosition, whichFig, posnStartInStream, posnEndInStream)
%%
  votingFigDir = 'VotingFigures_Plos1_CompBio_July2021';
  originalSignalFig = 3; alignedSignalFig = 2;   % Which child in Fig
  consensusLine = 1;  goldStandardLine = 2;
  orderDisplayDTWA ={'DBA' 'SSG' 'MM'};
  
%% Display Position Control
  DBAYOffSetDisplay = 6.6;
  SSGYOffSetDisplay = 3.3;
  MMYOffSetDisplay = 0;
  useLineWidth = 3;
%   displayOffset = [DBAYOffSetDisplay, SSGYOffSetDisplay, MMYOffSetDisplay];
  
  goldYOffSetDisplay = 10;
%   consensus = zeros(length(orderDisplayDTWA), 1);
  
  for countDTWA = 1 : 3  % Select each DTWA info
    figName = sprintf('./%s/%s_%d_%d_%s_DTWA_ZNORM=1.fig', votingFigDir, string(ensembleNames{buildFig}), posnStartInStream, posnEndInStream, ...
        string(orderDisplayDTWA(countDTWA)));
    groupFigureHandle = open(figName);
    if countDTWA == 1  % All the same gold standard
      goldStandard.YData = groupFigureHandle(useFig).Children(originalSignalFig).Children(goldStandardLine).YData;
    end
    consensus(countDTWA).YData = groupFigureHandle(useFig).Children(originalSignalFig).Children(consensusLine).YData;
  end
  
  drawingFig = figure('Name', sprintf('%s', string(ensembleNames{buildFig})));
  if strcmp(graphXPosition, 'start')
      goldXOffSetDisplay = 0;
      axisInfomation = [0 length(goldStandard.YData)/3 -2 13];
  elseif strcmp(graphXPosition, 'middle')
      goldXOffSetDisplay = length(goldStandard.YData) * showProportion / 2;
  elseif strcmp(graphXPosition, 'end')
      goldXOffSetDisplay = -length(goldStandard.YData);
      axisInfomation = [-length(goldStandard.YData)/3 0 -2 13];
  end

  showProportion = 1.0;
  
  NewPlot(goldStandard.YData, -goldXOffSetDisplay, goldYOffSetDisplay, graphXPosition, showProportion, 'blue'); hold on;  % GOLD   

    useColor ={'black' 'green' 'red'}
  consensusXOffsetDisplay = zeros(3,1);        
  for whichConsensus = 1 : 3
    if strcmp(graphXPosition, 'start')
         consensusXOffsetDisplay(whichConsensus) = 0;
    elseif strcmp(graphXPosition, 'middle')
        consensusXOffsetDisplay(whichConsensus) = showProportion * (length(consensus(whichConsensus).YData) - length(goldStandard.YData)) /  2 + goldXOffSetDisplay; 
    elseif strcmp(graphXPosition, 'end')
        consensusXOffsetDisplay(whichConsensus) = length(consensus(whichConsensus).YData);
    end
    NewPlot(consensus(whichConsensus).YData, -consensusXOffsetDisplay(whichConsensus), goldYOffSetDisplay - whichConsensus * 3.3 , graphXPosition, showProportion, useColor{whichConsensus}); 
  end

  for whichConsensus = 1 : 3
     [DISTdtw, goldWarpPath(whichConsensus).path, consensusWarpPath(whichConsensus).path] = dtw(goldStandard.YData, consensus(whichConsensus).YData);
  end
  ShowLinks_GoldToDBA(goldStandard.YData, goldYOffSetDisplay, goldXOffSetDisplay, consensus(1).YData, DBAYOffSetDisplay, -consensusXOffsetDisplay(1), ...
                                      goldWarpPath(1).path, consensusWarpPath(1).path, graphXPosition, showProportion, useLineWidth);
  ShowLinks_ConsensusToConsensus(goldStandard.YData, consensus(1).YData, DBAYOffSetDisplay, -consensusXOffsetDisplay(1), consensus(2).YData,SSGYOffSetDisplay, -consensusXOffsetDisplay(2), ...
                                      goldWarpPath(1).path, consensusWarpPath(1).path, goldWarpPath(2).path, consensusWarpPath(2).path, graphXPosition, showProportion, useLineWidth);
  ShowLinks_ConsensusToConsensus(goldStandard.YData, consensus(2).YData, SSGYOffSetDisplay, -consensusXOffsetDisplay(2), consensus(3).YData, MMYOffSetDisplay, -consensusXOffsetDisplay(3), ...
                                      goldWarpPath(2).path, consensusWarpPath(2).path, goldWarpPath(3).path, consensusWarpPath(3).path, graphXPosition, showProportion, useLineWidth);
 

  legend('GOLD STANDARD', string(orderDisplayDTWA(1)), string(orderDisplayDTWA(2)), string( orderDisplayDTWA(3))); %, 'Location', 'northeast');
  ylabel('Z-NORM AMPLITUDE (Offset for clarity)');
  
  if strcmp(graphXPosition, 'end')
    xlabel('POSITION FROM SQUIGGLE END');
  else 
    xlabel('POSITION IN SQUIGGLE');
  end
  axis(axisInfomation);
  
  text( axisInfomation(1) - 30, axisInfomation(3) + 0.9,   sprintf('\\fontsize{16}%s)', whichFig));
 
 
function ShowLinks_ConsensusToConsensus(gold, consensus1, consensusYoffset1, consensusXOffsetDisplay1, consensus2, consensusYoffset2, consensusXOffsetDisplay2, ...
                      goldWarpPath1, consensusWarpPath1, goldWarpPath2, consensusWarpPath2, graphXPosition, showProportion, useLineWith)
 goldShowPosnStep = floor(length(gold) / 20);

 if strcmp(graphXPosition, 'start')
    goldShowPosn = 1;   
    goldStretchPosn1 = 1;
    goldStretchPosn2 = 1;
    goldEndPosn = floor(length(gold) * showProportion);

  elseif strcmp(graphXPosition, 'middle') 
    goldShowPosn = 1;  
    goldStretchPosn1 = 1;
    goldStretchPosn2 = 1;

    goldEndPosn = length(gold);
            plot(  [consensusWarpPath1(end)+consensusXOffsetDisplay1 consensusWarpPath2(end)+consensusXOffsetDisplay2], ...
    [consensus1(consensusWarpPath1(end))+consensusYoffset1 consensus2(consensusWarpPath2(end))+consensusYoffset2], ':k', 'linewidth', useLineWith);

  elseif strcmp(graphXPosition, 'end') 
    goldShowPosn = 1;
    goldStretchPosn1 = 1;
    goldStretchPosn2 = 1;

    goldEndPosn = length(gold);
%     consensusXOffsetDisplay1 = consensusXOffsetDisplay1 + goldXOffSetDisplay;
%     consensusXOffsetDisplay2 = consensusXOffsetDisplay2 + goldXOffSetDisplay;
    plot(  [consensusWarpPath1(end)+consensusXOffsetDisplay1 consensusWarpPath2(end)+consensusXOffsetDisplay2], ...
    [consensus1(consensusWarpPath1(end))+consensusYoffset1 consensus2(consensusWarpPath2(end))+consensusYoffset2], ':k', 'linewidth', useLineWith);
  end

  while goldShowPosn < goldEndPosn
    while (goldWarpPath1(goldStretchPosn1) < goldShowPosn)
        goldStretchPosn1 = goldStretchPosn1 + 1;
    end
    goldStretchPosn1 = goldStretchPosn1 + 1;

    while (goldWarpPath2(goldStretchPosn2) < goldShowPosn)
        goldStretchPosn2 = goldStretchPosn2 + 1;
    end
    goldStretchPosn2 = goldStretchPosn2 + 1;

     plot(  [consensusWarpPath1(goldStretchPosn1)+consensusXOffsetDisplay1 consensusWarpPath2(goldStretchPosn2)+consensusXOffsetDisplay2], ...
         [consensus1(consensusWarpPath1(goldStretchPosn1))+consensusYoffset1 consensus2(consensusWarpPath2(goldStretchPosn2))+consensusYoffset2], ':k', 'linewidth', useLineWith);
     goldShowPosn = goldShowPosn + goldShowPosnStep;
  end

    
 function  ShowLinks_GoldToDBA(gold, goldYoffset, goldXOffSetDisplay, consensus, consensusYoffset, consensusXOffsetDisplay, ...
                          goldWarpPath, consensusWarpPath, graphXPosition, showProportion, useLineWith)

  goldShowPosnStep = floor(length(gold) / 20);
  if strcmp(graphXPosition, 'start')
    goldShowPosn = 1;
    goldStretchPosn = 1;
    goldEndPosn = floor(length(gold) * showProportion);

  elseif strcmp(graphXPosition, 'middle') 
    goldShowPosn = 1;
    goldStretchPosn = 1;
    goldEndPosn = length(gold);

    plot(  [goldWarpPath(end)+goldXOffSetDisplay consensusWarpPath(end)+consensusXOffsetDisplay], ...
         [gold(goldWarpPath(end))+goldYoffset consensus(consensusWarpPath(end))+consensusYoffset], ':k', 'linewidth', useLineWith);

  elseif strcmp(graphXPosition, 'end') 
    goldShowPosn = 1;
    goldStretchPosn = 1;
%     consensusXOffsetDisplay = consensusXOffsetDisplay + goldXOffSetDisplay;
    
    goldEndPosn = length(gold);
    plot(  [goldWarpPath(end)+goldXOffSetDisplay consensusWarpPath(end)+consensusXOffsetDisplay], ...
         [gold(goldWarpPath(end))+goldYoffset consensus(consensusWarpPath(end))+consensusYoffset], ':k', 'linewidth', useLineWith);
  end

  while goldShowPosn < goldEndPosn
    while (goldWarpPath(goldStretchPosn) < goldShowPosn)
        goldStretchPosn = goldStretchPosn + 1;
    end
    goldStretchPosn = goldStretchPosn + 1;
    plot(  [goldWarpPath(goldStretchPosn)+goldXOffSetDisplay consensusWarpPath(goldStretchPosn)+consensusXOffsetDisplay], ...
         [gold(goldWarpPath(goldStretchPosn))+goldYoffset consensus(consensusWarpPath(goldStretchPosn))+consensusYoffset], ':k', 'linewidth', useLineWith);
    goldShowPosn = goldShowPosn + goldShowPosnStep;
  end
 

 function NewPlot(signal, xShift, yShift, whichend, showProportion, useColour)
  lengthSignal = length(signal);
  showLength = floor(lengthSignal * showProportion);
% % % %   showLengthBy2 = floor(showLength / 2);
% % % %   showLengthBy4 = floor(showLength / 4);

  if strcmp(whichend, 'start')
    shortSignal = signal(1:showLength);
    xPosn = (1:showLength); % + xShift;
  elseif strcmp(whichend, 'end')
    shortSignal = signal((1:showLength) + length(signal) - showLength);
    xPosn = (1:showLength) - showLength;
  else
% % % %         shortSignal = signal(showLengthBy2 : (showLengthBy+showLengthBy2-1));
% % % %         xPosn = showLengthBy2 : (showLengthBy4+showLengthBy2-1);
    xPosn = 1 : showLength;
    shortSignal = signal(xPosn);
    xPosn = xPosn + xShift;
  end
  plot(xPosn, shortSignal + yShift, 'Color', useColour);    


