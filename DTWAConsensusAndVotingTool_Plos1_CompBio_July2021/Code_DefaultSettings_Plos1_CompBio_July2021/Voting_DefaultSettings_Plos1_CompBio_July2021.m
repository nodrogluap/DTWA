function voteInfo = Voting_DefaultSettings_Plos1_CompBio_July2021(ensembleInfo)
% function voteInfo = Voting_DefaultSettings_Plos1_CompBio_July2021ensembleInfo)
% M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada, June 2021

%% Parameters controlling voting
  voteInfo.votingFiguresDirectory = './VotingFigures_Plos1_CompBio_July2021';
  voteInfo.consensusDirectory = './VotedConsensus_Plos1_CompBio_July2021';
  voteInfo.saveVotingFigures = ensembleInfo.saveVotingFigures;
  voteInfo.useCurrentConsensusIfAvailable = false;
  if ensembleInfo.testVotingDisplay  % This is a quick tesat to see that things work
    if strcmp(ensembleInfo.ensembleName, 'Enolase')
      voteInfo.whichVotes =  [100 35]; 
    elseif strcmp(ensembleInfo.ensembleName, 'Sequin_R1_71_1') 
       voteInfo.whichVotes =  [100 45];  %  [100 46];
    elseif strcmp(ensembleInfo.ensembleName, 'Sequin_R2_55_3')
       voteInfo.whichVotes =  [100 45]; %  [100 48];
    elseif strcmp(ensembleInfo.ensembleName, 'MyData1')
      fprintf('Guess best vote level -- Fix me Voting_DefaultSettings_Plos1_CompBio_July2021\n');
      voteInfo.whichVotes =  [100 40]; 
    elseif strcmp(ensembleInfo.ensembleName, 'MyData2') 
      fprintf('Guess best vote level -- Fix me Voting_DefaultSettings_Plos1_CompBio_July2021\n');
       voteInfo.whichVotes =  [100 40];  %  [100 46];
    elseif strcmp(ensembleInfo.ensembleName, 'MyData3')
      fprintf('Guess best vote level -- Fix me Voting_DefaultSettings_Plos1_CompBio_July2021\n');
       voteInfo.whichVotes =  [100 40]; %  [100 48];
    else
      error('Unknown ensembleInfo.ensembleName %s', ensembleInfo.ensembleName);
    end
    voteInfo.numVotes = length(voteInfo.whichVotes);
    voteInfo.whichVotesDisplayed     = [1 1] ;            % 1 is display
    voteInfo.whichDisplaysSaved      = [1 1];           % Figure saved
  else
    if 1  % Plos 1 Figs are generated with this setting if not testing voting display
      voteInfo.whichVotes              =  [100 85 80   75 70 65  60 56 53 50  47 44 41 38 33  28 23 18 10];
      voteInfo.numVotes = length(voteInfo.whichVotes);
      if ensembleInfo.displayVotingDTWFigures
        voteInfo.whichVotesDisplayed     =  [1 1 1      1 1 1      1 1 1 1      1  1  1  1  1   1  1  1  1];       % 1 is display
        voteInfo.whichDisplaysSaved      =  [1 1 1      1 1 1      1 1 1 1      1  1  1  1  1   1  1  1  1];       % or Figure saved
      else
        voteInfo.whichVotesDisplayed     =  [0 0 0      0 0 0      0 0 0 0      0  0  0  0  0   0  0  0  0];       % 1 is display
        voteInfo.whichDisplaysSaved      =  [0 0 0      0 0 0      0 0 0 0      0  0  0  0  0   0  0  0  0];       % or Figure saved
      end
    else  % More detailed analysis If used then change symbol skip interval = 5 in MyPlotManySymbols()
      voteInfo.whichVotes              =  [100 90 86 83 80   76 73 70 66 63  60 58 56 54 52  50 48 46 44 42  40 38 36 34 32  30 20 10];
      voteInfo.numVotes = length(voteInfo.whichVotes);
      if ensembleInfo.displayVotingDTWFigures
        voteInfo.whichVotesDisplayed     =  [1 1 1 1 1          1 1 1 1 1      1   1 1 1 1      1  1  1  1  1   1  1  1  1  1   1  1  1];       % 1 is display
        voteInfo.whichDisplaysSaved      =  [1 1 1 1 1          1 1 1 1 1      1   1 1 1 1      1  1  1  1  1   1  1  1  1  1   1  1  1];       % or Figure saved
      else
        voteInfo.whichVotesDisplayed     =  [0 0 0 0 0          0 0 0 0 0      0   0 0 0 0      0  0  0  0  0   0  0  0  0  0   0  0  0];       % 1 is display
        voteInfo.whichDisplaysSaved      =  [0 0 0 0 0          0 0 0 0 0      0   0 0 0 0      0  0  0  0  0   0  0  0  0  0   0  0  0];       % or Figure saved
      end
    end
  end  
