function AdjustDTWAFigsInGroup_Plos1_CompBio_July2021(figGroup, offsetTop, bottomPictureXstart, displayLength, figureName)
  originalSignalFig = 3; alignedSignalFig = 2;   % Which child in Fig
  consensusLine = 1;  goldStandardLine = 2;
  numDBADTWAFigGroup = size(figGroup, 2);
  
  for countFigs = 1 : numDBADTWAFigGroup
%% Get data top picture
    goldStandard.YData = figGroup(countFigs).Children(originalSignalFig).Children(goldStandardLine).YData;
    consensus.YData = figGroup(countFigs).Children(originalSignalFig).Children(consensusLine).YData; 
    
% Get data bottom picture
    goldStandardAligned.YData = figGroup(countFigs).Children(alignedSignalFig).Children(goldStandardLine).YData;
    consensusAligned.YData = figGroup(countFigs).Children(alignedSignalFig).Children(consensusLine).YData;
    
%% Remove offset
    try
      oldOffsetTop = figGroup(countFigs).UserData.offsetTop;
      goldStandard.YData = goldStandard.YData - oldOffsetTop;
      consensus.YData  = consensus.YData;
      goldStandardAligned.YData = goldStandardAligned.YData - figGroup(countFigs).UserData.offsetBottom;
      consensusAligned.YData = consensusAligned.YData;
    catch
    end

%% Adjust and restore data
%% Restore data bottom picture 
    bottomOffset = offsetTop;
% % %     if bottomOffset > 2
% % %       bottomOffset = 2;
% % %     end
    figGroup(countFigs).Children(alignedSignalFig).Children(goldStandardLine).YData = goldStandardAligned.YData + bottomOffset;
    figGroup(countFigs).Children(alignedSignalFig).Children(consensusLine).YData = consensusAligned.YData;
    figGroup(countFigs).UserData.bottomOffset = bottomOffset;
    
% Trying to add a figure caption this way diorectly to figure 
% --screws up some figGroup pointer royally -- use it directly on a figure
%     text(-220, -30, sprintf('\\fontsize{20}%s', figCaption));

% Adjust what portion of the aligned data we are displaying and modify XLabel to show change
    if ischar(bottomPictureXstart)
      if strcmp(bottomPictureXstart, 'start')
        firstPointDisplayed = 1; lastPointDisplayed  = displayLength;
      else
        lastPointDisplayed = length(consensusAligned.YData);
        firstPointDisplayed = lastPointDisplayed - displayLength + 1 ; 
      end
    else
      firstPointDisplayed = bottomPictureXstart.firstPointDisplayed;
      lastPointDisplayed = bottomPictureXstart.lastPointDisplayed;
    end
    
    figGroup(countFigs).Children(alignedSignalFig).XLim = [firstPointDisplayed lastPointDisplayed];
    figGroup(countFigs).Children(alignedSignalFig).XLabel.String = sprintf('ALIGNED SIGNAL POSITIONS %d : %d', firstPointDisplayed, lastPointDisplayed);
%% Restore data top picture
    figGroup(countFigs).Children(originalSignalFig).Children(goldStandardLine).YData = goldStandard.YData + offsetTop;
    figGroup(countFigs).Children(originalSignalFig).Children(consensusLine).YData = consensus.YData; 
% Adjust xlim to make longest stream just fit the top picture  
    newXMax = max(length(goldStandard.YData), length(consensus.YData));
    figGroup(countFigs).Children(originalSignalFig).XLim =[0 newXMax];
    figGroup(countFigs).UserData.offsetTop = offsetTop;
    figGroup(countFigs).Children(alignedSignalFig).YLim  = figGroup(countFigs).Children(originalSignalFig).YLim;
    figGroup(countFigs).Children(originalSignalFig).InnerPosition = [0.08,0.78,0.88,0.17];
    figGroup(countFigs).Children(alignedSignalFig).InnerPosition = [0.08,0.10,0.88,0.55];
    
    figGroup(countFigs).Children(originalSignalFig).Title.String = sprintf('%s  Lengths Consensus / Gold = %d / %d  (%3.2f)', ...
      figGroup(countFigs).Children(originalSignalFig).Title.String, length(consensus.YData), length(goldStandard.YData),  length(consensus.YData) /  length(goldStandard.YData));
  end