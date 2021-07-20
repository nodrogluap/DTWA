function Build_Figs8ABC_Enolase_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('8ABC');
  
  figHandle = figure(1); text(-150, 200, sprintf('\\fontsize{20}%s', 'A) - 8'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
  figHandle.Name = '_F_Fig8A_Standard DTW.fig';
  xlim([0 1310]); ylim([0 2598]);  movegui('northwest');

  figHandle = figure(2); text(-0.125, -0.05, sprintf('\\fontsize{20}%s', 'B) - 8')); 
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'IDENTITY', 'Location', 'best');   
  figHandle.Name ='_F_Fig8B_NormalizedStandard DTW.fig';
  movegui('north');

  figHandle = figure(3); text(-0.125, -7.5, sprintf('\\fontsize{20}%s', 'C) - 8'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');  
  figHandle.Name = '_F_Fig8C_DIFF FROM IDENTITY DTW.fig';
  movegui('northeast');