function Build_Figs5ABC_Enolase_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('5ABC');
  
  figHandle = figure(1); text(-150, -100, sprintf('\\fontsize{20}%s', 'A)- 5'));
  legend('DBA CONSENSUS', 'SSG CONSENSUS', 'MM CONSENSUS', 'Location', 'best');
  figHandle.Name = '_F_Fig5A_Standard DTW.fig';
  xlim([0 1310]); ylim([0 2598]);movegui('northwest')

  figHandle = figure(2); text(-0.125, - 0.05, sprintf('\\fontsize{20}%s', 'B) - 5')); 
  legend('DBA CONSENSUS', 'SSG CONSENSUS', 'MM CONSENSUS', 'IDENTITY', 'Location', 'best');
  figHandle.Name ='_F_Fig5B_NormalizedStandard DTW.fig';
  movegui('north')

  figHandle = figure(3); text(-0.125, -7.5, sprintf('\\fontsize{20}%s', 'C) - 5'));
  legend('DBA CONSENSUS', 'SSG CONSENSUS', 'MM CONSENSUS', 'Location', 'best');
  figHandle.Name = '_F_Fig5C_DIFF FROM IDENTITY DTW.fig';
  movegui('northeast')
    