function Fig3B_DisplayData_Plos1_CompBio_July2021(streamOrigData, showNumLines, figName, goldStandardInfo)
% function Fig3B_DisplayData_Plos1_CompBio_July2021(streamOrigData, showNumLines, figName)
% M. Smith, Electrical and Software Engineering, University of Calgary, Jume 2021

doZoomOnLastLine = 0;
  figure('Name', figName);
  plot([goldStandardInfo.length goldStandardInfo.length], [0 3250], '-g', 'linewidth', 2);  hold on;% Show gold standard length
  % DUmmy plots to match legend colours to arrows
  plot([0 1], [0 1], 'linewidth', 3, 'color', 'red', 'linestyle', '-.');
  plot([0 1], [0 1], 'linewidth', 3, 'color', 'red', 'linestyle', ':');
  annotation('arrow',[0.5383 0.5058], [0.8586 0.737], 'linewidth', 3, 'color', 'red', 'linestyle', '-.');
  annotation('arrow',[0.90051 0.3585], [0.6403 0.6403], 'linewidth', 3, 'color', 'red', 'linestyle', ':', 'headstyle', 'none');
  if doZoomOnLastLine

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
    for count  = 1 : showNumLines
        plot(streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
    end
end

  xlabel('SQUIGGLE EVENT POSITION');
  ylabel('SQUIGGLE AMPLITUDE (Offset for clarity)');
  xlim([0 1360]);
  ylim([1400 2380]);
  text(-200, 1400, '\fontsize{20}B) - 3');
    % Place arrows on screen and then micro move them

  legend('GOLD LENGTH', 'SHORTER INSERTION BURST', 'MANY INDIVIDUAL INSERTIONS', 'location', 'southeast');
  