function Build_Figs4ABC_MyData1_Plos1_CompBio_July2021()

    Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('MyData1_4ABC');


  dropFromTopFigure = 32.5;   xOffset = 100;
  figHandle = figure(1);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'A) - MyData1'));
  figHandle = figure(3);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'B) - MyData1'));
  figHandle = figure(5);   yRange = figHandle.Children(2).YLim;
  text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'C) - MyData1'))  