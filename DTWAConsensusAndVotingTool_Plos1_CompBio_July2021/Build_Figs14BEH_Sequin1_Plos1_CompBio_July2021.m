function Build_Figs12BEH_Sequin1_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('14BEH');
  
  figHandle = figure(1); text(-100, -100, sprintf('\\fontsize{20}%s', 'B) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
   figHandle.Name = '_F_Fig12B.fig';
   xlim([0 824]); ylim([0 1240]);  movegui('northwest');

  figHandle = figure(2); text(-0.125, -0.05, sprintf('\\fontsize{20}%s', 'E) - 14')); 
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'IDENTITY', 'Location', 'best');   
  figHandle.Name ='_F_Fig12E.fig';
   movegui('north');

  figHandle = figure(3); text(-0.125, -5.25, sprintf('\\fontsize{20}%s', 'H) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');  
   figHandle.Name = '_F_Fig12H.fig';
   movegui('northeast');   