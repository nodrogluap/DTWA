function DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA, ensembleInfo)
% function DetermineVoteOn_DTWA_Plos1_CompBio_July2021(cleanedNoHeaderDataInfo, goldStandardInfo, voteInfo, DTWA, ensembleInfo)
% M. Smith, Electrical and Cpmputer Engineering, University of Calgary, June 2021
  if ~DTWA.doVoting
      fprintf('*** Voting not activated\n');
      return;
  end

  whichDTWA = DTWA.name;
  
    if length(voteInfo.whichVotes) == 2 % Allows emperical investigation of BEST
      switch ensembleInfo.ensembleName
        case 'Enolase'
            switch whichDTWA
              case 'DBA_DTWA'
                voteInfo.whichVotes =  [100 37]; 
              case 'SSG_DTWA'
                voteInfo.whichVotes =  [100 41]; 
              case 'MM_DTWA'
                voteInfo.whichVotes =  [100 39];  
              otherwise
               error('Wrong DTWA name %s', whichDTWA);
            end
        case 'Sequin_R1_71_1'
          switch whichDTWA
            case 'DBA_DTWA'
              voteInfo.whichVotes =  [100 48]; 
            case 'SSG_DTWA'
              voteInfo.whichVotes =  [100 48]; 
            case 'MM_DTWA'
              voteInfo.whichVotes =  [100 48]; 
            otherwise
             error('Wrong DTWA name %s', whichDTWA);
          end
        case 'Sequin_R2_55_3'
          switch whichDTWA
            case 'DBA_DTWA'
              voteInfo.whichVotes =  [100 47]; 
            case 'SSG_DTWA'
              voteInfo.whichVotes =  [100 47]; 
            case 'MM_DTWA'
              voteInfo.whichVotes =  [100 72]; 
            otherwise
             error('Wrong DTWA name %s', whichDTWA);
          end
        otherwise
          fprintf('*************** Guesses on voting -- fix me -- DetermineVoteOn_DTWA_Plos1_CompBio_July2021\n');
          switch ensembleInfo.ensembleName          
            case 'MyData1'
            switch whichDTWA
              case 'DBA_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              case 'SSG_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              case 'MM_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              otherwise
               error('Wrong DTWA name %s', whichDTWA);
            end
            case 'MyData2'
            switch whichDTWA
              case 'DBA_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              case 'SSG_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              case 'MM_DTWA'
                voteInfo.whichVotes =  [100 40]; 
              otherwise
               error('Wrong DTWA name %s', whichDTWA);
            end
            case 'MyData3'
              switch whichDTWA
                case 'DBA_DTWA'
                  voteInfo.whichVotes =  [100 40];
                case 'SSG_DTWA'
                  voteInfo.whichVotes =  [100 40]; 
                case 'MM_DTWA'
                  voteInfo.whichVotes =  [100 40]; 
                otherwise
                 error('Wrong DTWA name %s', whichDTWA);
              end
            otherwise  
              error('Unknown %s', ensembleInfo.ensembleName);
          end
      end
    end

  consensusDirectory = DTWA.consensusDirectory; % 'Consensus_Jan2019'; %  './Consensus_Jan2019';
  goldStandardLength = goldStandardInfo.length;

  diary off;
  fprintf('*** Opening diary %s\n', DTWA.diaryNameVoting);
  if exist(DTWA.diaryNameVoting)
    try  % Try catch does not work for a ddelete command
      delete(DTWA.diaryNameVoting);
    catch
      fprintf('*** Can''t delete diary %s\n', DTWA.diaryNameVoting);
      x = 1;
    end
  end

  diary(DTWA.diaryNameVoting); 
  lengthInfo = zeros(cleanedNoHeaderDataInfo.numCleanedStreams, 1);
  for count = 1 : cleanedNoHeaderDataInfo.numCleanedStreams
      lengthInfo(count) = length(cleanedNoHeaderDataInfo.streams{count});
  end
  fprintf('Gold standard Length %d Mean stream length %5.1f +- %5.1f \n', goldStandardLength, mean(lengthInfo),  std(lengthInfo));
    
%% Set up controls on voting 
  agreementLevels = voteInfo.whichVotes;
  numAgreementLevels = length(agreementLevels);

  firstVoteLevel = 1;   % ????????????????????????
  lastVoteLevel = length(DTWA.consensusSizes);
  numberVoteChoices = lastVoteLevel - firstVoteLevel +1;

%% Set up various arrays to stored voting results
  goldToConsensus = zeros(numberVoteChoices, numAgreementLevels);
  goldToConsensus_Normalized_Gold = zeros(numberVoteChoices, numAgreementLevels);
  goldToConsensus_Normalized_PrunedConsensus = zeros(numberVoteChoices, numAgreementLevels);
  goldToConsensus_Normalized_Ix_Length = zeros(numberVoteChoices, numAgreementLevels);

  C2D_mean_dtwDistance = zeros(numberVoteChoices, numAgreementLevels);
  C2D_std_dtwDistance = zeros(numberVoteChoices, numAgreementLevels);
  C2D_mean_dtwDistance_Normalized_Gold = zeros(numberVoteChoices, numAgreementLevels);
  C2D_std_dtwDistance_Normalized_Gold = zeros(numberVoteChoices, numAgreementLevels);
  C2D_mean_dtwDistance_Normalized_Stream = zeros(numberVoteChoices, numAgreementLevels);
  C2D_std_dtwDistance_Normalized_Stream = zeros(numberVoteChoices, numAgreementLevels);

  length_standard = zeros(numberVoteChoices, numAgreementLevels);
  Ixlength_standard = zeros(numberVoteChoices, numAgreementLevels);

  G2D_mean_dtwDistance = zeros(numberVoteChoices, numAgreementLevels);
  G2D_std_dtwDistance = zeros(numberVoteChoices, numAgreementLevels);
  G2D_mean_dtwDistance_Normalized_Gold = zeros(numberVoteChoices, numAgreementLevels);
  G2D_std_dtwDistance_Normalized_Gold = zeros(numberVoteChoices, numAgreementLevels);
  G2D_mean_dtwDistance_Normalized_Stream = zeros(numberVoteChoices, numAgreementLevels);
  G2D_std_dtwDistance_Normalized_Stream = zeros(numberVoteChoices, numAgreementLevels);


  for DTWAlength = 1 : length(DTWA.consensusSizes)
    attempt = DTWAlength;
    DTWA.useNumStreamsInDTWA = DTWA.consensusSizes(DTWAlength);
    if  DTWA.useNumStreamsInDTWA > cleanedNoHeaderDataInfo.numCleanedStreams
        DTWA.useNumStreamsInDTWA = cleanedNoHeaderDataInfo.numCleanedStreams;
    end

    consensusFileName = sprintf('%s/%s_%s_%d_ZNORM_%d_SEEDED_%d.mat', consensusDirectory, cleanedNoHeaderDataInfo.nameDetails,  DTWA.name,  ...
                DTWA.useNumStreamsInDTWA, DTWA.applyZNORMBeforeDTWA, DTWA.seedStreamNumber);
    load(consensusFileName, 'consensus');
    fprintf('*** Loaded %s\n', consensusFileName);
    cleaned_noHeaderData = cleanedNoHeaderDataInfo.streams;


    [availableRows, ~] = size (cleaned_noHeaderData);
    useNumberStreamsWhenVoting = DTWA.useNumberStreamsWhenVoting(DTWAlength);
    if availableRows < useNumberStreamsWhenVoting
        fprintf('Reducing voting rows from %d to %d\n', DTWA.useNumberStreamsWhenVoting(DTWAlength), availableRows);
        useNumberStreamsWhenVoting = availableRows;
    end

    numStreamsUsedWhenPruningArray = floor([DTWA.useNumberStreamsWhenVoting DTWA.useNumberStreamsWhenVoting/2 DTWA.useNumberStreamsWhenVoting/4]);

%% Perform voting
    voteInfo.useNumberStreamsWhenVoting = useNumberStreamsWhenVoting;
    if  voteInfo.useNumberStreamsWhenVoting > cleanedNoHeaderDataInfo.numCleanedStreams
        fprintf('Reducing number of streams used when voting from %d to %d\n', voteInfo.useNumberStreamsWhenVoting, cleanedNoHeaderDataInfo.numCleanedStreams);
        voteInfo.useNumberStreamsWhenVoting = cleanedNoHeaderDataInfo.numCleanedStreams;      
    end
    shortSet = cell(voteInfo.useNumberStreamsWhenVoting, 1);

   if DTWA.applyZNORMBeforeDTWA
      for count = 1 : voteInfo.useNumberStreamsWhenVoting
          signal = cleaned_noHeaderData{count};
          shortSet{count} = (signal - mean(signal)) / std(signal);
      end

      consensusScaled = consensus;                % No need to scale since consensus was generated using Z-Norm
      goldStandardInfo.stream = (goldStandardInfo.stream  - mean(goldStandardInfo.stream)) / std(goldStandardInfo.stream);

   else
%       streamForDTWA = cell(DTWA.useNumStreamsInDTWA, 1); 
      scaleByFirstStreamStdDev = std(cleanedNoHeaderDataInfo.streams{1});
      for count = 1 : voteInfo.useNumberStreamsWhenVoting
        signal = cleanedNoHeaderDataInfo.streams{count};
        shortSet{count} =  (signal - mean(signal)); % / scaleByFirstStreamStdDev;
      end
        
   warning('Going to scale goldStandard to match first data set mean and  stdDev NOT DONE\n');
%    scaleByStdDev = std(goldStandardInfo.stream{1};
      goldStandardInfo.stream = (goldStandardInfo.stream  - mean(goldStandardInfo.stream)); 
      goldStandardInfo.stream = goldStandardInfo.stream / max(goldStandardInfo.stream) * max(consensus);% / std(goldStandardInfo.stream);
%       consensusScaled = (consensus - mean(consensus)) / scaleByStdDev;
      consensusScaled = consensus;
      
   end
    
%     DTWA.useNumberStreamsWhenVoting(DTWAlength)
%     stop
    numVotes = length(voteInfo.whichVotes);
    numFiguresSaved = 0;
    
    votesDisplayLocation = {'southwest' 'northwest' 'south', 'north', 'southeast', 'northeast'};
    voteDeleteAverage = 0;   % Quicck Hack to avoid recalculating voting levels
    voteInsertAverage = 0;    % ************* Need to fix sometime
    
    for count = 1 : numVotes
      deleteRejectionLevel = voteInfo.whichVotes(count) * voteInfo.useNumberStreamsWhenVoting / 100;
      insertAcceptanceLevel = voteInfo.whichVotes(count) * voteInfo.useNumberStreamsWhenVoting / 100;
      fprintf('Vote Level \t%f\n', voteInfo.whichVotes(count));
      [prunedConsensus,  voteDeleteAverage, voteInsertAverage] = VoteToPrune_Plos1_CompBio_July2021(consensusScaled, shortSet, ...
                                          deleteRejectionLevel, insertAcceptanceLevel, voteInfo.useNumberStreamsWhenVoting, DTWA, voteDeleteAverage, voteInsertAverage);

      if DTWA.applyZNORMBeforeDTWA
          [dtwDistance, Ix, Iy] = dtw(goldStandardInfo.stream, (prunedConsensus - mean(prunedConsensus)/std(prunedConsensus)));
      else
          [dtwDistance, Ix, Iy] = dtw(goldStandardInfo.stream, (prunedConsensus - mean(prunedConsensus))); 
      end
                 
      if voteInfo.whichVotesDisplayed(count)
        if voteInfo.whichDisplaysSaved(count)
          numFiguresSaved = numFiguresSaved + 1;
          figHandle(numFiguresSaved) = ...
              figure('Name',  sprintf('%s %s_%d_%d L%d_%3.2f ZNORM=%d DTW %3.0f_%4.2f V%3.0f%%', ensembleInfo.ensembleName, whichDTWA, DTWA.useNumStreamsInDTWA, DTWA.useNumberStreamsWhenVoting, length(prunedConsensus), ...
                 length(prunedConsensus) / goldStandardInfo.length, DTWA.applyZNORMBeforeDTWA, dtwDistance, dtwDistance / goldStandardInfo.length, voteInfo.whichVotes(count)));
        else
          figure('Name',  sprintf('%s %s_%d_%d L%d_%3.2f  ZNORM=%d DTW %3.0f_%4.2f V%3.0f%%', ensembleInfo.ensembleName, whichDTWA, DTWA.useNumStreamsInDTWA, DTWA.useNumberStreamsWhenVoting, length(prunedConsensus),...
             length(prunedConsensus) / goldStandardInfo.length,  DTWA.applyZNORMBeforeDTWA, dtwDistance, dtwDistance / goldStandardInfo.length, voteInfo.whichVotes(count)));
        end

        %  pretty print gimic -- puts say DTWA figures on top of each other
        switch DTWA.name
          case 'SSG_DTWA'
            movegui(votesDisplayLocation{1 + rem(count - 1 , 2)});
          case 'MM_DTWA'
            movegui(votesDisplayLocation{3 + rem(count - 1, 2)});
          case 'DBA_DTWA'
            movegui(votesDisplayLocation{5 + rem(count - 1 , 2)});
        end

        % Show figure then calculate dtw distance
        if DTWA.applyZNORMBeforeDTWA
            dtw(goldStandardInfo.stream, (prunedConsensus - mean(prunedConsensus)/std(prunedConsensus)));
        else   
            dtw(goldStandardInfo.stream, (prunedConsensus - mean(prunedConsensus))); 
        end

        maxLengthDisplayed = floor(3 * goldStandardInfo.length / 6 );
        minLengthDisplayed = floor(1 * goldStandardInfo.length / 6 );
        legend('GOLD STANDARD', sprintf('CONSENSUS VOTE %d%%', voteInfo.whichVotes(count)));
        axis([minLengthDisplayed  maxLengthDisplayed -2  3]) ;
        xlabel(sprintf('ALIGNED SIGNAL POSITIONS %d : %d', minLengthDisplayed, maxLengthDisplayed));
      end
     
        % mean_dtwDistance_Normalized_Stream, std_dtwDistance_Normalized_Stream
        goldToConsensus(attempt, count) = dtwDistance;      
        goldToConsensus_Normalized_Gold(attempt, count) = dtwDistance / goldStandardInfo.length;
        goldToConsensus_Normalized_PrunedConsensus(attempt, count) = dtwDistance / length(prunedConsensus);
        goldToConsensus_Normalized_Ix_Length(attempt, count) = dtwDistance / length(Ix);
        
        fprintf('dtwDistance Gold2Consen %4.0f\t dtwDis/goldLen %4.3f\t  dtwDis/prunedConsensusL %4.3f dtwDis/Ix %4.3f\n', ...
                     dtwDistance, dtwDistance / goldStandardInfo.length, dtwDistance / length(prunedConsensus), dtwDistance / length(Ix));

      %[mean_dtwDistance, std_dtwDistance, mean_dtwDistance_Normalized, std_dtwDistance_Normalized] = ...
      %                      CompareDTWSpread_Nov2018(goldStandard, shortSet, numStreams, 'GOLD', goldstandardLength);
        [C2D_mean_dtwDistance(attempt, count), C2D_std_dtwDistance(attempt, count), C2D_mean_dtwDistance_Normalized_Gold(attempt, count), C2D_std_dtwDistance_Normalized_Gold(attempt, count), ...
                    C2D_mean_dtwDistance_Normalized_Stream(attempt, count), C2D_std_dtwDistance_Normalized_Stream(attempt, count)] = ...
                            DTW_FrechetCalculation_Plos1_CompBio_July2021(prunedConsensus, shortSet, voteInfo.useNumberStreamsWhenVoting, 'Consensus2Dats_', goldStandardInfo.length, DTWA);
 
        [G2D_mean_dtwDistance(attempt, count), G2D_std_dtwDistance(attempt, count), G2D_mean_dtwDistance_Normalized_Gold(attempt, count), G2D_std_dtwDistance_Normalized_Gold(attempt, count), ...
                    G2D_mean_dtwDistance_Normalized_Stream(attempt, count), G2D_std_dtwDistance_Normalized_Stream(attempt, count)] = ...
                            DTW_FrechetCalculation_Plos1_CompBio_July2021(goldStandardInfo.stream, shortSet, voteInfo.useNumberStreamsWhenVoting, 'Gold2Data_', goldStandardInfo.length,  DTWA);
                        
                        %% FIX ME
       %      [all_mean_dtwDistance(attempt, count), all_std_dtwDistance(attempt, count), all_mean_dtwDistance_Normalized(attempt, count), all_std_dtwDistance_Normalized(attempt, count)] = ...
        %                        CompareDTWSpread_Sept2018(prunedConsensus, set128, 128, 'long set compare prunedAverage', goldstandardLength);
        length_standard(attempt, count) = length(prunedConsensus) /  goldStandardInfo.length;
        Ixlength_standard(attempt, count) = length(Ix) /  goldStandardInfo.length;
        fprintf('\n');

        prunedConsensus_ZNorm = (prunedConsensus - mean(prunedConsensus)) / std(prunedConsensus);
         
        prunedConsensus_ZNormFileName = sprintf('%s/%s_%d_%d_%s_%d_Vote%d.mat',  ...
                                 voteInfo.consensusDirectory, ...
                                 ensembleInfo.ensembleName, ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, ...
                                      whichDTWA, DTWA.useNumStreamsInDTWA, voteInfo.whichVotes(count));
        save(prunedConsensus_ZNormFileName,  'prunedConsensus_ZNorm');
    end
    if (numFiguresSaved > 0)
       %  savefig(figHandle, sprintf('./Figures/%s_%d_ZNORM=%d', whichDTWA, useMaxNumberStreamsWhenVoting, DTWA.applyZNORMBeforeDTWA), 'compact');
       % savefig(figHandle, sprintf('./Figures/%s_???_ZNORM=%d', whichDTWA,  DTWA.applyZNORMBeforeDTWA), 'compact');
       if voteInfo.saveVotingFigures 
           if cleanedNoHeaderDataInfo.getCertainLengthRange
               savefig(figHandle, sprintf('%s/%s_%d_%d_%s_%d_UsingStream_%d_ZNORM=%d_L%d_LR_%d_%d', voteInfo.votingFiguresDirectory, ensembleInfo.ensembleName, ...
                 ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, ...
                 whichDTWA, DTWA.useNumStreamsInDTWA,  voteInfo.useNumberStreamsWhenVoting, ...
                    DTWA.applyZNORMBeforeDTWA, cleanedNoHeaderDataInfo.numStreams, cleanedNoHeaderDataInfo.posnEnsembleLengthStart, cleanedNoHeaderDataInfo.posnEnsembleLengthEnd), 'compact');
           else                        
               savefig(figHandle, ...
                   sprintf('%s/%s_%d_%d_%s_ZNORM=%d', voteInfo.votingFiguresDirectory, ensembleInfo.ensembleName, ...
                    ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnEnsembleEndStream, whichDTWA, ...
                    DTWA.applyZNORMBeforeDTWA), 'compact');
           end
       end
    end
end        
    


DBAdetails = sprintf('%s_%d', whichDTWA, DTWA.useNumStreamsInDTWA);
% 
ExcelFormat(goldToConsensus, DBAdetails, 'goldToConsensus', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(goldToConsensus_Normalized_Gold, DBAdetails, 'goldToConsensus_Normalized_Gold', agreementLevels, numStreamsUsedWhenPruningArray);
% % ExcelFormat(goldToConsensus_Normalized_PrunedConsensus, DBAdetails, 'goldToConsensus_Normalized_PrunedConsensus', agreementLevels, numStreamsUsedWhenPruningArray);
% % ExcelFormat(goldToConsensus_Normalized_Ix_Length, DBAdetails, 'goldToConsensus_Normalized_Ix_Length', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(length_standard, DBAdetails, 'length_standard', agreementLevels, numStreamsUsedWhenPruningArray); 
ExcelFormat(Ixlength_standard, DBAdetails, 'Ixlength_standard', agreementLevels, numStreamsUsedWhenPruningArray);

ExcelFormat(C2D_mean_dtwDistance, DBAdetails, 'Consensus2Data_mean_dtwDistance', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(C2D_std_dtwDistance, DBAdetails, 'Consensus2Data_std_dtwDistance', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(C2D_mean_dtwDistance_Normalized_Gold, DBAdetails, 'Consensus2Data_mean_dtwDistance_Normalized_Gold', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(C2D_std_dtwDistance_Normalized_Gold, DBAdetails, 'Consensus2Data_std_dtwDistance_Normalized_Gold', agreementLevels, numStreamsUsedWhenPruningArray);
% % ExcelFormat(C2D_mean_dtwDistance_Normalized_Stream, DBAdetails, 'Consensus2Data_mean_dtwDistance_Normalized_Stream', agreementLevels, numStreamsUsedWhenPruningArray);
% % ExcelFormat(C2D_std_dtwDistance_Normalized_Stream, DBAdetails, 'Consensus2Data_std_dtwDistance_Normalized_Stream', agreementLevels, numStreamsUsedWhenPruningArray);

ExcelFormat(G2D_mean_dtwDistance, DBAdetails, 'Gold2Data__mean_dtwDistance', agreementLevels, numStreamsUsedWhenPruningArray);
ExcelFormat(G2D_std_dtwDistance, DBAdetails, 'Gold2Data_std_dtwDistance', agreementLevels, numStreamsUsedWhenPruningArray);
% ExcelFormat(G2D_mean_dtwDistance_Normalized_Gold, DBAdetails, 'Gold2Data_mean_dtwDistance_Normalized_Gold', agreementLevels, numStreamsUsedWhenPruningArray);
% ExcelFormat(G2D_std_dtwDistance_Normalized_Gold, DBAdetails, 'Gold2Data_std_dtwDistance_Normalized_Gold', agreementLevels, numStreamsUsedWhenPruningArray);

diary off;

function ExcelFormat(array, DBAdetails, arrayName, agreementLevels, numStreamsUsedWhenPruningArray)
numVotes = length(agreementLevels);
agreementLevels = agreementLevels(1:numVotes);
fprintf('%s_%s =\n', DBAdetails, arrayName);
[numRows, numCols] = size(array);
fprintf('V\t\t'); fprintf('%5.2f \t', agreementLevels(1:numCols)); fprintf('\n');
for row = 1 : numRows
    fprintf('# %d \t', numStreamsUsedWhenPruningArray(row));
    for col = 1 : numCols
        if  array(row, col) < 3  % Change format display whether number large or small
            fprintf('%5.3f \t', array(row, col));
        else
            fprintf('%5.1f \t', array(row, col));
        end
    end
    fprintf('\n');
end
fprintf('\n');
        

    