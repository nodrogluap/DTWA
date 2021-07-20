function [buildFig, ensembleNum, ensembleName, votingFiguresPath, setupRequiredData, posnEnsembleStartStream] ...
    = SetupFiguresParameters_Plos1_CompBio_July2021(numStreams, figNum)  
  votingFiguresPath = 'VotingFigures_Plos1_CompBio_July2021';
  buildFig.buildFig4ABC = false;  % Don't build all at once
  buildFig.buildFig7ABCDEF = false;
  
  buildFig.buildFig5ABC = false;
  buildFig.buildFig8ABC = false;
  
  buildFig.buildFig12A = false;
  buildFig.buildFig12B = false;
  buildFig.buildFig12C = false;
  
  posnEnsembleStartStream = 1;  % In case wanted to explore pictures of different Enolase ensemble groupings
  
  switch figNum
    case {'MyData1_4ABC'}
      buildFig.buildFig4ABC = true;
      ensembleNum = 4;  % MyData1
      ensembleName = 'MyData1'
      posnEnsembleStartStream = 1;
    case {'4ABC'}
      buildFig.buildFig4ABC = true;
      ensembleNum = 2;  % Sequin_R2_55_3
      ensembleName = 'Sequin_R2_55_3'
      posnEnsembleStartStream = 1;
    case {'Sequin1'}
      buildFig.buildFig4ABC = true;
      ensembleNum = 1;  % Sequin_R1_71_1
      ensembleName = 'Sequin_R1_71_1'
      posnEnsembleStartStream = 1;
    case {'7ABCDEF'}
      buildFig.buildFig7ABCDEF = true;
      ensembleNum = 3;  % Enolase
      ensembleName = 'Enolase';
      posnEnsembleStartStream = 1;
    case { '5ABC'}
      buildFig.buildFig5ABC= true;
      ensembleNum = 3;  % Enolase
      ensembleName = 'Enolase';
      posnEnsembleStartStream = 1;
    case {'8A' '8B' '8C' '8ABC'}
      buildFig.buildFig8ABC = true;
      ensembleNum = 3;  
      ensembleName = 'Enolase'; 
    case '14ADG'
      buildFig.buildFig12A = true;
      ensembleNum = 3;
      ensembleName = 'Enolase';
    case '14BEH'
      buildFig.buildFig12B = true;
      ensembleNum = 1;
      ensembleName = 'Sequin_R1_71_1';
    case '14CFI'
      buildFig.buildFig12C = true;
      ensembleNum = 2;
      ensembleName = 'Sequin_R2_55_3';
    otherwise
      error('Unknown figuire requested %s', figNum);
  end
  
%% Don't build the files needed for these figures if they exist already
  posnEnsembleEndStream = posnEnsembleStartStream + numStreams - 1;
  fileNameGroupFigures = sprintf('./%s/%s_%d_%d_DBA_DTWA_ZNORM=1.fig', ...
            votingFiguresPath, ensembleName, posnEnsembleStartStream, posnEnsembleEndStream)
   
  setupRequiredData = true;        
  if exist(fileNameGroupFigures, 'file')
    setupRequiredData = false;
  end  
  