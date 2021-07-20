function Build_Figs10AB_Part2_Plos1_CompBio_July2021

ensembleSize = [16 32 64 128 256 512 1024];

times_SSG_MM_DBA = [4 5 5   8 7 17   17  16  76    25 34 197   50 57 217    102 125 843  246 163  3057];

figure('Name', 'TIME'); movegui('northwest');

plot(ensembleSize, times_SSG_MM_DBA(1 : 3 : end), '-xg'); hold on;
plot(ensembleSize, times_SSG_MM_DBA(2 : 3 : end), '-xr'); hold on;
plot(ensembleSize, times_SSG_MM_DBA(3 : 3 : end), '-xk'); hold on;
xlim([0 1024]);
ylim([0 3100]);
xlabel('INITIAL ENOLASE ENSEMBLE SIZE');
ylabel('EXECUTION TIME (s)');
legend('SSG DTWA', 'MM DTWA', 'DBA DTWA', 'location', 'northwest');



figure('Name', 'DTW metrics');
gold2Consensus_SSG_MM_DBA = [0.29 0.32 0.33  0.29 0.26 0.31  0.27 0.26 0.31 0.28 0.31 0.33 0.25 0.28 0.42 0.25 0.32 0.4 0.28 0.24 0.39];
meanConsensus2Ensemble = [0.33 0.35 0.38  0.33 0.33 0.38   0.32 0.33 0.38  0.31 0.35 0.37 0.31 0.32 0.44 0.31 0.33 0.44 0.38  0.3 0.42];
meanConsensus2EnsembleStdDev = [0.06 0.04 0.12  0.05 0.052 0.09  0.04 0.04 0.06   0.04 0.04 0.05  0.04 0.04 0.05 0.04 0.04 0.05, 0.04 0.04 0.04];
meanGold2Ensemble =       [0.38 0.38 0.38  0.38 0.38 0.38  0.37 0.37 0.37  0.37 0.37 0.37  0.36 0.36 0.36 0.35 0.35 0.35 0.35];
meanGold2EnsembleStdDev = [0.05 0.05 0.05   0.05 0.05 0.05 0.04 0.04 0.04  0.04 0.04 0.04  0.05 0.05 0.04 0.04 0.04 0.04 0.04];
 
% Dummy plots to set legend
plot(ensembleSize(1), gold2Consensus_SSG_MM_DBA(1), ':b', 'linewidth', 2); hold on;
errorbar(ensembleSize(1), meanConsensus2Ensemble(1), meanConsensus2EnsembleStdDev(1), '-b', 'linewidth', 2); hold on;
errorbar(ensembleSize(1), meanGold2Ensemble(1), meanGold2EnsembleStdDev(1), '--b', 'linewidth', 2); hold on;

plot(ensembleSize(1), gold2Consensus_SSG_MM_DBA(1), '-g', 'linewidth', 2); hold on;
plot(ensembleSize(1), gold2Consensus_SSG_MM_DBA(1), '-r', 'linewidth', 2); hold on;
plot(ensembleSize(1), gold2Consensus_SSG_MM_DBA(1), '-b', 'linewidth', 2); hold on;


% Actual plots
plot(ensembleSize, gold2Consensus_SSG_MM_DBA(1 : 3 : end), ':xg', 'linewidth', 2); hold on;
errorbar(ensembleSize, meanConsensus2Ensemble(1 : 3 : end), meanConsensus2EnsembleStdDev(1 : 3 : end), '-g', 'linewidth', 2); hold on;




plot(ensembleSize, gold2Consensus_SSG_MM_DBA(2 : 3 : end), ':xr', 'linewidth', 2); hold on;
plot(ensembleSize, gold2Consensus_SSG_MM_DBA(3 : 3 : end), ':xk', 'linewidth', 2); hold on;

errorbar(ensembleSize, meanConsensus2Ensemble(2 : 3 : end), meanConsensus2EnsembleStdDev(1 : 3 : end), '-r', 'linewidth', 2); hold on;
errorbar(ensembleSize, meanConsensus2Ensemble(3 : 3 : end), meanConsensus2EnsembleStdDev(1 : 3 : end), '-k', 'linewidth', 2); hold on;
errorbar(ensembleSize, meanGold2Ensemble(1 : 3 : end), meanGold2EnsembleStdDev(1 : 3 : end), '--b', 'linewidth', 2); hold on;
ylim([0.24 0.5]);
xlim([0 1024]);
xlabel('INITIAL ENOLASE ENSEMBLE SIZE');
ylabel('NORMALIZED DTW_{DISTANCE}');
legend('GOLD to CONSENSUS', 'MEAN CONSENSUS to ENSEMBLE', 'MEAN GOLD to ENSEMBLE', 'SSG DTWA (green)', 'MM DTWA (red)', 'DBA DTWA (black)');







