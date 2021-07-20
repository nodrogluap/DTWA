function Build_Figs14ADG_Enolase_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('14ADG');
  
  figHandle = figure(1); text(-100, -100, sprintf('\\fontsize{20}%s', 'A) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
   figHandle.Name = '_F_Fig14A.fig';
   xlim([0 824]); ylim([0 1240]);  movegui('northwest');

  figHandle = figure(2); text(-0.125, -0.05, sprintf('\\fontsize{20}%s', 'D) - 14')); 
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'IDENTITY', 'Location', 'best');   
  figHandle.Name ='_F_Fig14D.fig';
   movegui('north');

  figHandle = figure(3); text(-0.125, -7.55, sprintf('\\fontsize{20}%s', 'G) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');  
   figHandle.Name = '_F_Fig14G.fig';
   movegui('northeast');  
  