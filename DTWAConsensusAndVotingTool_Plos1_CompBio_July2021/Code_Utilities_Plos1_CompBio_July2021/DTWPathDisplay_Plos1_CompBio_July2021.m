function setupRequiredData = DTWPathDisplay_Plos1_CompBio_July2021(numStreams, figNum, increaseFactorsNumStreamsWhenVoting)
% function DTWPathDisplay_Plos1_CompBio_July2021(numStreams)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

% Return setupRequiredData so other functions know whether a rebuild
% occurred - as there may be many extra pictures generated on build and the
% tool only works with the 6 final figures

% If no input arguments defaults to quick demo of 32 with Enolase 
  if nargin == 0
    numStreams = 32;  figNum = '4A'; % also generate 4B and 4C
  end
  posnEnsembleStartStream = 1; posnEnsembleEndStream = numStreams;
  
  [buildFig, ensembleNum, ensembleName, votingFiguresPath, setupRequiredData, posnEnsembleStartStream] = ...
        SetupFiguresParameters_Plos1_CompBio_July2021(numStreams, figNum);
  
  if setupRequiredData
    Script_Demonstrate_GenerateVotingStats_Plos1_CompBio_July2021('whichEnsemble', ensembleNum, 'buildConsensusSize', numStreams, ...
              'displayVotingDTWFigures', true, 'testVotingDisplay', true, 'saveVotingFigures', true, ...
                  'increaseFactorsNumStreamsWhenVoting', increaseFactorsNumStreamsWhenVoting, 'posnEnsembleStartStream', posnEnsembleStartStream); 
  end
 
%% Find the voting figure group we have saved and grab gold and consensus data
  if  buildFig.buildFig4ABC % Modified version of Matlab Display
    close all;
      bottomPictureXstart = 'start'; 
      displayLength = 300;    offset = 2.8;  % Seperate to allow better compare of consensus to each other rather than to gold
      DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(DBADTWAFigGroup, offset, bottomPictureXstart, displayLength, 'A');
  
      SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
            votingFiguresPath,ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(SSGDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'B');

      MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(MMDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'C');
   elseif buildFig.buildFig4ABC % Modified version of Matlab Display
      close all;
      bottomPictureXstart = 'start'; 
      displayLength = 300;    offset = 2.8;  % Seperate to allow better compare of consensus to each other rather than to gold
      DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(DBADTWAFigGroup, offset, bottomPictureXstart, displayLength, 'A');
  
      SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
            votingFiguresPath,ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(SSGDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'B');

      MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(MMDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'C');
  elseif buildFig.buildFig7ABCDEF % Modified version of Matlab Display
      bottomPictureXstart = 'start'; 
      displayLength = 300;    offset = 2.8;  % Seperate to allow better compare of consensus to each other rather than to gold
      DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(DBADTWAFigGroup, offset, bottomPictureXstart, displayLength, 'A');
  
      SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
            votingFiguresPath,ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(SSGDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'B');

      MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
      AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(MMDTWAFigGroup, offset, bottomPictureXstart, displayLength, 'C');    
      
  elseif buildFig.buildFig5ABC
    figWarpPath(1) = figure('Name', sprintf('%s STANDARD WARP PATH DISPLAY', ensembleName)); movegui('southwest');
    figWarpPath(2) = figure('Name', sprintf('%s NORMALIZED WARP PATH DISPLAY', ensembleName)); movegui('south');
    figWarpPath(3) = figure('Name', sprintf('%s DIFF FROM IDEAL WARP PATH DISPLAY', ensembleName)); movegui('southeast');

    DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(DBADTWAFigGroup,  buildFig, 'black', figWarpPath);

    SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(SSGDTWAFigGroup, buildFig, 'green', figWarpPath);

    MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
        votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(MMDTWAFigGroup, buildFig, 'red', figWarpPath);   
    
  elseif buildFig.buildFig8ABC
    figWarpPath(1) = figure('Name', sprintf('%s STANDARD WARP PATH DISPLAY', ensembleName)); movegui('southwest');
    figWarpPath(2) = figure('Name', sprintf('%s NORMALIZED WARP PATH DISPLAY', ensembleName)); movegui('south');
    figWarpPath(3) = figure('Name', sprintf('%s DIFF FROM IDEAL WARP PATH DISPLAY', ensembleName)); movegui('southeast');
    DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(DBADTWAFigGroup,  buildFig, 'black', figWarpPath);

    SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(SSGDTWAFigGroup, buildFig, 'green', figWarpPath);

    MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
        votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(MMDTWAFigGroup, buildFig, 'red',  figWarpPath);
 
  elseif buildFig.buildFig12A
    figWarpPath(1) = figure('Name', sprintf('%s STANDARD WARP PATH DISPLAY', ensembleName)); movegui('southwest');
    figWarpPath(2) = figure('Name', sprintf('%s NORMALIZED WARP PATH DISPLAY', ensembleName)); movegui('south');
    figWarpPath(3) = figure('Name', sprintf('%s DIFF FROM IDEAL WARP PATH DISPLAY', ensembleName)); movegui('southeast');
    DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(DBADTWAFigGroup,  buildFig, 'black', figWarpPath);

    SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(SSGDTWAFigGroup, buildFig, 'green', figWarpPath);

    MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
        votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(MMDTWAFigGroup, buildFig, 'red', figWarpPath);
    
  elseif buildFig.buildFig12B
    figWarpPath(1) = figure('Name', sprintf('%s STANDARD WARP PATH DISPLAY', ensembleName)); movegui('southwest');
    figWarpPath(2) = figure('Name', sprintf('%s NORMALIZED WARP PATH DISPLAY', ensembleName)); movegui('south');
    figWarpPath(3) = figure('Name', sprintf('%s DIFF FROM IDEAL WARP PATH DISPLAY', ensembleName)); movegui('southeast');
    DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(DBADTWAFigGroup,  buildFig, 'black', figWarpPath);

    SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(SSGDTWAFigGroup, buildFig, 'green', figWarpPath);

    MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
        votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(MMDTWAFigGroup, buildFig, 'red', figWarpPath);
    
   elseif buildFig.buildFig12C 
    figWarpPath(1) = figure('Name', sprintf('%s STANDARD WARP PATH DISPLAY', ensembleName)); movegui('southwest');
    figWarpPath(2) = figure('Name', sprintf('%s NORMALIZED WARP PATH DISPLAY', ensembleName)); movegui('south');
    figWarpPath(3) = figure('Name', sprintf('%s DIFF FROM IDEAL WARP PATH DISPLAY', ensembleName)); movegui('southeast');
    DBADTWAFigGroup = open(sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(DBADTWAFigGroup,  buildFig, 'black', figWarpPath);

    SSGDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_SSG_DTWA_ZNORM=1.fig', ...
          votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(SSGDTWAFigGroup, buildFig, 'green', figWarpPath);

    MMDTWAFigGroup = open(sprintf('./%s/%s_%d_%d_MM_DTWA_ZNORM=1.fig', ...
        votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream));
    DisplayWarpedPath_Plos1_CompBio_July2021(MMDTWAFigGroup, buildFig, 'red', figWarpPath);
  else
    fprintf('Wrong figure request somehow -- AM PAUSED\n');
    pause
    error('Wrong figure request somehow\n');
  end
  
  if ~buildFig.buildFig4ABC  && ~buildFig.buildFig7ABCDEF 
    figure(figWarpPath(1))
    xlabel('GOLD WARP POSITION');
    ylabel('CONSENSUS WARP POSITION');

    figure(figWarpPath(2))
    xlabel('NORMALIZED GOLD WARP POSITION');
    ylabel('NORMALIZED CONSENSUS WARP POSITION');
    plot([0 1], [0 1], '--k');

    figure(figWarpPath(3))
    xlabel('NORMALIZED GOLD WARP POSITION');
    ylabel('WARP PERCENTAGE FROM IDENTITY');
    plot([0 1], [0 0], '--k');
  end
  
function DisplayWarpedPath_Plos1_CompBio_July2021(figGroup, buildFig, useColor, varargin)
  originalSignalFig = 3; alignedSignalFig = 2;   % Which child in Fig
  consensusLine = 1;  goldStandardLine = 2;
  
  if buildFig.buildFig5ABC
    fillTheseFigs = 1;
  elseif buildFig.buildFig12B || buildFig.buildFig12C || buildFig.buildFig8ABC || buildFig.buildFig12A
    fillTheseFigs = 1 : 2;
  else
    error('Unknown Figure request');
  end
    
%% Get data top picture
  for countFigs = fillTheseFigs
    goldStandard.YData = figGroup(countFigs).Children(originalSignalFig).Children(goldStandardLine).YData;
    consensus.YData = figGroup(countFigs).Children(originalSignalFig).Children(consensusLine).YData; 
    
% Get data bottom picture
    goldStandardAligned.YData = figGroup(countFigs).Children(alignedSignalFig).Children(goldStandardLine).YData;
    consensusAligned.YData = figGroup(countFigs).Children(alignedSignalFig).Children(consensusLine).YData;
    
%% Remove offset in case Fig has already been changed
    try
      oldOffsetTop = figGroup(countFigs).UserData.offsetTop;
      goldStandard.YData = goldStandard.YData - oldOffsetTop;
      consensus.YData  = consensus.YData;
      goldStandardAligned.YData = goldStandardAligned.YData - figGroup(countFigs).UserData.offsetBottom;
      consensusAligned.YData = consensusAligned.YData;
    catch
    end

  
   [dtwDist, goldWarp, consensusWarp] = dtw(goldStandard.YData, consensus.YData);

    p = length(goldWarp);
%     use = 1 : (p - 30);
     use = 1 : (p);
    
    if length(fillTheseFigs) == 1
      lineStyle = '--';
      linewidth = 1;
    else
      if countFigs == 1
        lineStyle = '--';
        linewidth = 1;
      else
        lineStyle = '-';
        linewidth = 2;
      end
    end
    
    if 1 % buildFig.buildFig4DE
       figure(varargin{1}(1));
       x = (goldWarp - 1);
       y = (consensusWarp - 1); 
       plot(x, y, lineStyle, 'Linewidth', linewidth, 'Color', useColor); hold on;


       figure(varargin{1}(2));
       x = (goldWarp(use) - 1)/ (max(goldWarp(use) - 1));
       y = (consensusWarp(use) - 1) / (max(consensusWarp(use) - 1)); 
       plot(x, y, lineStyle, 'Linewidth', linewidth, 'Color', useColor); hold on;
    end

       figure(varargin{1}(3));
       x = (goldWarp(use) - 1) / (max(goldWarp(use) - 1));
       y =  100 * ((consensusWarp(use) - 1)/ (max(consensusWarp(use)) - 1) - ...
            (goldWarp(use) - 1) / (max(goldWarp(use) - 1))); 
%      y = y  * 3;
     
       plot(x, y, lineStyle, 'Linewidth', linewidth, 'Color', useColor); hold on;
  end
 

  



