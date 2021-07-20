function DisplayData_Plos1_CompBio_July2021(streamOrigData, showNumLines, figName)
% function DisplayData_Plos1_CompBio_July2021(streamOrigData, showNumLines, figName)
% M. Smith, Electrical and Software Engineering, University of Calgary, Jume 2021

doZoomOnLastLine = 0;

%% If testing with very small ensemble size (e.g. 32) then default showNumLines may be too large
% As progress through cleaning 
% -- size may continually reduce -- hence new check
  if length(streamOrigData) < showNumLines
    showNumLines = length(streamOrigData);
  end

if doZoomOnLastLine
  figure('Name', figName);
  for count  = 1 : showNumLines
      plot(streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
  end

  count = showNumLines;
  lastLength = length(streamOrigData{count});
  zoomRange =floor(lastLength/2):floor(10*lastLength/16);
  zoomXaxis = 1 : length(zoomRange);
  zoomFactor = 10;
  plot(50+zoomFactor*zoomXaxis, 5 * streamOrigData{count}(zoomRange) + (count - 1) * 80, '-k'); hold on;

  plot([zoomRange(1), 50+zoomFactor*zoomXaxis(1)], [streamOrigData{count}(1) + (count - 1) * 80, ...
      5 * streamOrigData{count}(1) + (count - 1) * 80], '--r');
  plot([zoomRange(end), 50+zoomFactor*zoomXaxis(end)], [streamOrigData{count}(zoomRange(end)) + (count - 1) * 80, ...
      5 * streamOrigData{count}(zoomRange(end)) + (count - 1) * 80], '--r');
else
  figure('Name', figName);
  for count  = 1 : showNumLines
      plot(streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
  end
end
