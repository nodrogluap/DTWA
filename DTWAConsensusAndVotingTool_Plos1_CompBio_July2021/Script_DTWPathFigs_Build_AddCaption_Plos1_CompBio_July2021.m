function Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021(figNum)
% function Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021( )
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

% % %% Build with 64 point when using Enolase
% % % This allows a fairer comparision with noisy Sequin data
% % % which ends up with 64 streams when using all the data available
% % % Return handle figGroup(1) =  to all figures if you want to save them
% % % together
  increaseFactorsNumStreamsWhenVoting = 1;  % Default
  
  doTest = true;

  switch figNum
    case {'4ABC' '14CFI'}
      numStreams = 128;  % Sequin 2
      
    case {'MyData1_4ABC'}
      numStreams = 128; 
    case {'Sequin1' '14BEH'}
      numStreams = 128;  % Sequin 1
    case {'7ABCDEF' '5ABC', '8ABC'}
      numStreams = 128; % Enolase
      increaseFactorsNumStreamsWhenVoting = 2;
      numStreams = 2 * numStreams;
    case '14ADG' 
      increaseFactorsNumStreamsWhenVoting = 1;
      numStreams = 128;
    otherwise
      error('Unknown Figure request %s', figNum);
      
  end
  
  if doTest
    numStreams = 16;
  end
  
  close all;
  setupRequiredData = DTWPathDisplay_Plos1_CompBio_July2021(numStreams, figNum, increaseFactorsNumStreamsWhenVoting);
  
  if setupRequiredData  % Then other figures on screen
    close all;
    DTWPathDisplay_Plos1_CompBio_July2021(numStreams, figNum, increaseFactorsNumStreamsWhenVoting);
  end
  
  if strcmp(figNum, '4ABC')  % Last drawn was top figure
%    Moved to Build script
  elseif strcmp(figNum, 'MyData1_4ABC')  % Last drawn was top figure
%    Moved to Build script
    
  elseif strcmp(figNum, 'Sequin1')
    dropFromTopFigure = 32.5;   xOffset = 100;
    figHandle = figure(1);   yRange = figHandle.Children(2).YLim;
    text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'A)- Sequin1'));
    figHandle = figure(3);   yRange = figHandle.Children(2).YLim;
    text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'B)- Sequin1'));
    figHandle = figure(5);   yRange = figHandle.Children(2).YLim;
    text(-xOffset, yRange(1) - dropFromTopFigure, sprintf('\\fontsize{20}%s', 'C)- Sequin1'))    
    
  elseif strcmp(figNum, '7ABCDEF')
    %    Moved to Build script
  elseif strcmp(figNum, '5ABC')
%    Moved to Build script    
  elseif strcmp(figNum, '8ABC')
%    Moved to Build script    
  elseif strcmp(figNum, '14ADG')
%    Moved to Build script
   elseif strcmp(figNum, '14BEH')
%    Moved to Build script
  elseif strcmp(figNum, '14CFI')
%    Moved to Build script
  else
    error('Unknown Fig request');
  end
    
  