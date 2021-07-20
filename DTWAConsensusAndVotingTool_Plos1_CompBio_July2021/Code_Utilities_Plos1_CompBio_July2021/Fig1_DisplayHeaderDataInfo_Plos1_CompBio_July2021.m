function Fig1_DisplayHeaderDataInfo_Plos1_CompBio_July2021(streamOrigData, streamHeader, streamData, showNumLines, figName, numberStdDev, goldStandardInfo)
% function Fig1_DisplayHeaderDataInfo_Plos1_CompBio_July2021(streamOrigData, streamHeader, streamData, showNumLines, figName, numberStdDev)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021
  figure('Name', sprintf('PLOS1_2021_Fig 1 %s', figName));
%% Set up some initial plots so legend details are correct
  plot([0 0], [0 0], '-k'); hold on;
  plot([0 0], [1 2], '-r');   
  plot([goldStandardInfo.length goldStandardInfo.length], [0 3250], '-g', 'linewidth', 2);  % Show gold standard length

%% Plot all the data
  for count  = 1 : showNumLines
      xposnAllStream = 1:length(streamOrigData{count});
      xposnHeader = 1:length(streamHeader{count});
      xposnAllStream = (xposnAllStream) - max(xposnHeader);     
      xposnHeader = (xposnHeader) - max(xposnHeader);
      plot(xposnAllStream, streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
      plot(xposnHeader, streamHeader{count} + (count - 1) * 80, '-r'); hold on;
  end

%% Replot the last line -- scaled by 5 to show detail
  xposnAllStreamZoom = 1:length(streamOrigData{showNumLines});
  xposnHeaderZoom = 1:length(streamHeader{showNumLines});
  xposnAllStreamZoom = (xposnAllStreamZoom) - max(xposnHeaderZoom);     
  xposnHeaderZoom = (xposnHeaderZoom) - max(xposnHeaderZoom);
  zoomRange = 1 : 650;
  zoomFactor = 4;
  zoomStartOffset = 940;  % If displaying 39 lines in Fig. 1
  plot(zoomFactor * xposnAllStreamZoom(zoomRange) + zoomStartOffset, 8 * streamOrigData{showNumLines}(zoomRange) + (showNumLines - 1) * 80 - 250, '-k'); hold on;
  plot(zoomFactor * xposnHeaderZoom + zoomStartOffset, 8 * streamHeader{showNumLines} + (showNumLines - 1) * 80 - 250, '-r'); hold on;

% connect to previous plot 

  plot([(zoomFactor * xposnAllStreamZoom(1) + zoomStartOffset) xposnAllStream(1)], ...
    [(8 * streamOrigData{showNumLines}(1) + (showNumLines - 1) * 80 - 250) (streamOrigData{showNumLines}(1) + (showNumLines - 1) * 80) ], '-r', 'linewidth', 1);
  plot([(zoomFactor * xposnAllStreamZoom(zoomRange(end)) + zoomStartOffset) xposnAllStream(zoomRange(end))], ...
    [(8 * streamOrigData{showNumLines}(zoomRange(end)) + (showNumLines - 1) * 80 - 250) (streamOrigData{showNumLines}(zoomRange(end)) + (showNumLines - 1) * 80) ], '-k', 'linewidth', 1);

  xlabel('SQUIGGLE EVENT POSITION');
  ylabel('SQUIGGLE AMPLITUDE (Offset for clarity)');
  ylim([1800 3700]);
  xlim([-700 2000]);
  
% % Place arrows on screen and then micro move them
%   annotation('arrow',[0.716 0.610], [0.630 0.619], 'linewidth', 3, 'color', 'red', 'linestyle', ':');
%   annotation('arrow',[0.691 0.579], [0.756 0.695], 'linewidth', 3, 'color', 'red');
%   annotation('arrow',[0.85 0.6782], [0.308 0.297], 'linewidth', 3, 'color', 'red', 'linestyle', ':');
%   annotation('arrow',[0.534 0.3766], [0.139 0.1283], 'linewidth', 3, 'color', 'red');

  text(-400, 3400, '\fontsize{14}ZOOMED', 'color', 'blue');
  legend('RAW SQUIGGLE', 'HEADER', 'GOLD LENGTH', 'LOCATION', 'east');