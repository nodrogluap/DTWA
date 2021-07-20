function Build_Figs14CFI_Sequin2_Plos1_CompBio_July2021
  Script_DTWPathFigs_Build_AddCaption_Plos1_CompBio_July2021('14CFI');
  
  figHandle = figure(1); text(-100, -100, sprintf('\\fontsize{20}%s', 'C) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
  figHandle.Name = '_F_Fig14C.fig';

  figHandle = figure(2); text(-0.125, -0.05, sprintf('\\fontsize{20}%s', 'F) - 14')); 
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
  figHandle.Name = '_F_Fig14F.fig';

  figHandle = figure(3); text(-0.125, -7.5, sprintf('\\fontsize{20}%s', 'I) - 14'));
  legend('DBA CONSENSUS', 'VOTED(DBA CONSENSUS)', ...
    'SSG CONSENSUS', 'VOTED(SSG CONSENSUS)', ...
    'MM CONSENSUS', 'VOTED(MM CONSENSUS)', 'Location', 'best');
  figHandle.Name = '_F_Fig14HI.fig';
  ylim([-7 4]);