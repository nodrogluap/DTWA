function keepLegends = MyPlotManySymbols_Plos1_CompBio_July2021(xData, yData,  mainLineColour)
  numPoints = length(xData);

  symbol = { 'o' 's'  '<'  'v' 'd' '^' 'h' 'p' '<'};
  colours = {'cyan' 'magenta' 'blue' 'green' 'black' 'red'};
  lengthSymbol = length(symbol);
  lengthColours = length(colours);

  keepLegends = zeros(numPoints, 1);
  if numPoints <= min(lengthSymbol, lengthColours)
    keepLegends(:) = 1;
  else % May be better to markless frequently
    skipInterval = 4; 
    keepLegends(1 : skipInterval : end) = 1;
  end
  
  if keepLegends(numPoints) ~= 1
    keepLegends(numPoints) = 1;  % Always display the last point as a symoble
  end
  
  countSymbolsUsed = 1;
  hold on;
  for count =  1 : numPoints % Plot as points, rotate colours and shapes
    if keepLegends(count)
       scatter(xData(count), yData(count), symbol{1 + mod(countSymbolsUsed, lengthSymbol)}, ...
              colours{1 + mod(countSymbolsUsed, lengthColours)}, 'filled');
       countSymbolsUsed = countSymbolsUsed + 1;
    end
  end

  plot(xData, yData, mainLineColour);  % Plot as line
  hold off;