function Build_Figs9ABCDEF_Enolase_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('7ABCDEF');
  
  dropFromTopFigure = 32.5;   xOffset = 100;
  figHandle = figure(1);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'A)- 7'));
  figHandle = figure(3);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'B)- 7'));
  figHandle = figure(5);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'C)- 7')) 

  figHandle = figure(2);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'D)- 7'));
  figHandle = figure(4);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'E)- 7'));
  figHandle = figure(6);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'F)- 7'))    