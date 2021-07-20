function Fig12_MakeLegends_Plos1_CompBio_July2021(votingLevels, keepLegends, seperateFigs5, varargin)
% function Fig12_MakeLegends_Plos1_CompBio_July2021(votingLevels, keepLegends, seperateFigs5, varargin)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

%% Legend entries are only correct if all figurees have same levels
% which doies not occur when using the testdisplay option which uses 100%, BEST and 10% voting only
  numLegendEntries = length(votingLevels);
  
  legendEntries = cell(sum(keepLegends), 1);
  
  legendsUsed = 1;
  for countEntries = 1 : numLegendEntries
    if keepLegends(countEntries)
      legendEntries{legendsUsed} = sprintf('%d%%', votingLevels(countEntries));
      legendsUsed = legendsUsed + 1;
    end
  end
  
% This is not true with the fast test as levels are 100 best 10
  if numLegendEntries == 3
     legendEntries{2} = 'BEST %';
  end
  
  if seperateFigs5
% % % %     for countFigs = 1 : length(varargin)
% % % %       figure(varargin{countFigs});
% % % %       xlabel('CONSENSUS LENGTH / GOLD STANDARD LENGTH');
% % % %       ylabel('GOLD TO CONSENSUS DTW DISTANCE');
% % % %       legend(legendEntries, 'Location', 'northwest');
% % % %       xLimits = xlim();
% % % %       yLimits = ylim();
% % % %       figLabel = '6A';
% % % %       figLabelXPosn = xLimits(1) - (xLimits(2) - xLimits(1)) / 20;
% % % %       figLabelYPosn = yLimits(1) + (yLimits(2) - yLimits(1)) / 20;
% % % %       text(figLabelXPosn, figLabelYPosn, sprintf('\\fontsize{14}%c)', figLabel + countFigs - 1));
% % % %     end
  else
    for countFigs = 1 : 2
      figure(varargin{countFigs});
      xlabel('CONSENSUS LENGTH / GOLD STANDARD LENGTH');
      if countFigs == 1
        ylabel('NORMALIZED GOLD TO CONSENSUS DTW DISTANCE');
      else
        ylabel('NORMALIZED MEAN CONSENSUS TO ENSEMBLE DTW DISTANCE');
      end
      legend(legendEntries, 'Location', 'northwest');
      xLimits = xlim();
      yLimits = ylim();
      figLabel = 'A';
      figLabelXPosn = xLimits(1) - (xLimits(2) - xLimits(1)) / 20;
      figLabelYPosn = yLimits(1) + (yLimits(2) - yLimits(1)) / 20;
      text(figLabelXPosn, figLabelYPosn, sprintf('\\fontsize{14}%c) - 12)', figLabel + countFigs - 1));
    end
  end

