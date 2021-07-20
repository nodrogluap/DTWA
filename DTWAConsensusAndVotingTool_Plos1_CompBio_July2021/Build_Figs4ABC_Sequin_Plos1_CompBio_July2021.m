function Build_Figs4ABC_Sequin_Plos1_CompBio_July2021(doSequin1)

% Sequin 2 for Plos 1 paper Fig. 4
  if nargin == 0
    Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('4ABC');
  else  
  % Sequin 1 needed for Tables to compare consensus and gold  
    Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('Sequin1');
  end

  dropFromTopFigure = 32.5;   xOffset = 100;
  figHandle = figure(1);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'A) - 4'));
  figHandle = figure(3);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'B) - 4'));
  figHandle = figure(5);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'C) - 4'))  