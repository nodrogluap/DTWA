function noHeaderStreams = RemoveHeader_Plos1_CompBio_July2021(dataFileName, posnStartStream, numStreamsLeft, setStdDevRange, ensembleInfo, goldStandardInfo)
% function noHeaderStreams = RemoveHeader_Plos1_CompBio_July2021(dataFileName, posnStartStream, numStreamsLeft, setStdDevRange)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

%% Get File info and display example streams
    streamOrigData = GetStreamFromFile_Plos1_CompBio_July2021(dataFileName, numStreamsLeft, posnStartStream);
    showNumLines = 39;   % Default value to show in Plot
    
%% If testing with very small ensemble size (e.g. 32) then default showNumLines may be too large
    if length(streamOrigData) < showNumLines
      showNumLines = length(streamOrigData);
    end
    
    DisplayData_Plos1_CompBio_July2021(streamOrigData, showNumLines, 'Original Data with headers');   movegui('northwest');

%% Clean by length and data mean -- and split into header and data
    cleanedStreamByLength = GetStats_FromStream_Plos1_CompBio_July2021(streamOrigData, @length, 'ORIGINAL DATA LENGTH', setStdDevRange);
    cleanedStreamByLengthAndMean = GetStats_FromStream_Plos1_CompBio_July2021(cleanedStreamByLength, @mean, 'ORIGINAL DATA MEAN', setStdDevRange);

%% Decided to remove header information this way
    fprintf('****  Using Both_LocalStdDev_LocalMean to remove header\n');

    [numStreamsLeft, ~] = size(cleanedStreamByLengthAndMean);
    streamHeader = cell(numStreamsLeft, 1);
    noHeaderStreams = cell(numStreamsLeft, 1);

    for count = 1 : numStreamsLeft    
        goodEnd = length(cleanedStreamByLengthAndMean{count}) - 50;  % Don't use immediate end of data stream in calculation
        goodStart = goodEnd - 500;
        if (goodStart < 1)
            goodStart = 1;
        end
        endHeaderPosn = FindHeaderLength_Plos1_CompBio_July2021(cleanedStreamByLengthAndMean{count}, goodStart, goodEnd);
    % Now break into header and stream inormation
        streamHeader{count} = cleanedStreamByLengthAndMean{count}(1:endHeaderPosn);
        noHeaderStreams{count} = cleanedStreamByLengthAndMean{count}((endHeaderPosn+1) : end);
%         mean(noHeaderStreams{count})
%         std(noHeaderStreams{count})
    end

    
 %%  
  if ensembleInfo.display_Plos1_CompBio_July2021_Fig1 && strcmp(ensembleInfo.ensembleName, 'Sequin_R1_71_1')
    Fig1_DisplayHeaderDataInfo_Plos1_CompBio_July2021(cleanedStreamByLengthAndMean, streamHeader, noHeaderStreams, showNumLines, ...
      'Headers identified After Both_LocalStdDev_LocalMean', setStdDevRange, goldStandardInfo);
  else
    DisplayHeaderDataInfo_Plos1_CompBio_July2021(cleanedStreamByLengthAndMean, streamHeader, noHeaderStreams, showNumLines, ...
      'Headers identified After Both_LocalStdDev_LocalMean', setStdDevRange, ensembleInfo);
  end
  movegui('southwest');


% % % % function endHeader = FindHeaderLength_4Feb2019_SeeBelow(origData, goodStart, goodEnd)
% % % % % function endHeader = FindHeaderLength_4Feb2019_SeeBelow(origData, whichApproach, goodStart, goodEnd)
% % % % 
% % % % %% Take into account the data length might be smaller than suggested good range
% % % %     if length(origData) < goodEnd
% % % %         goodEnd = length(origData) - 100;
% % % %     end
% % % %     goodMean = mean(origData(goodStart : goodEnd));
% % % %     goodStdDev = std(origData(goodStart : goodEnd));
% % % % 
% % % %     %% **** needs fixing -- IGNORE FOR NOW
% % % %     % display('Adjust header first jump as was problem causing missing nucleotides for Sequin');
% % % %     endHeader =  50; % 100;  % Jump past the initial issues we found experimentally
% % % % 
% % % %     % Examine the data in small blocks 
% % % %     steps = 16;
% % % % 
% % % % 
% % % %     %% Compare header stats with "good data" stats
% % % %     % If deviation is smaller than this -- then out of header into true dats
% % % %     allowedMeanPercentageError = 0.03;
% % % %     allowedStdDevPercentageError = 0.1;
% % % %     maxNumberOfTimesStatsMatchBeforeEndHeaderReached = 2;
% % % % 
% % % %     inHeader = true;
% % % %     numGoodDataStatsFound = 0;
% % % % 
% % % %     % Step along the header finding its local mean and standard deviation
% % % %     % Make sure that if header difficult to find we don't run out of data
% % % %     while (inHeader) && ((endHeader + steps) < length(origData))
% % % %         localMean =  mean(origData(endHeader : endHeader + steps));
% % % %         localStdDev=  std(origData(endHeader : endHeader + steps));
% % % % 
% % % %          if ( ((abs(localStdDev - goodStdDev) / goodStdDev) < 2 * allowedStdDevPercentageError) ...
% % % %                  && ((abs(localMean - goodMean) / goodMean) < 2 * allowedMeanPercentageError) )
% % % %              numGoodDataStatsFound = numGoodDataStatsFound + 1;
% % % %              if (numGoodDataStatsFound == maxNumberOfTimesStatsMatchBeforeEndHeaderReached)
% % % %                  inHeader = false;
% % % %              else
% % % %                 endHeader = endHeader + steps / 2;    % Examine next bit of header
% % % %              end
% % % %          else
% % % %              endHeader = endHeader + steps / 2;       % Go a little farther
% % % %          end    
% % % %     end 
% % % %     
% % % %     %% *************************
% % % %     endHeader = endHeader - steps / 2;
% % % 
% % % % function DisplayHeaderDataInfo_10Jan2019(streamOrigData, streamHeader, streamData, showNumLines, figName, numberStdDev)
% % % % %function DisplayHeaderDataInfo_10Jan2019(streamHeader, streamData, showNumLines)
% % % % 
% % % % if 0
% % % %     fprintf('********** Header stats \n');
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @mean, 'streamHeader mean', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @length, 'streamHeader length', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @std, 'streamHeader stdDev', numberStdDev);
% % % % end
% % % % 
% % % %     figure('Name', figName);
% % % %     for count  = 1 : showNumLines
% % % %         xposnAllStream = 1:length(streamOrigData{count});
% % % %         xposnHeader = 1:length(streamHeader{count});
% % % %         xposnAllStream = (xposnAllStream) - max(xposnHeader);     
% % % %         xposnHeader = (xposnHeader) - max(xposnHeader);
% % % %         plot(xposnAllStream, streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
% % % %         
% % % %         plot(xposnHeader, streamHeader{count} + (count - 1) * 80, '-r'); hold on;
% % % %     end
% % % %     fprintf('\n');
% % % %     xlabel('SQUIGGLE EVENT POSITION');
% % % %     legend('SQUIGGLE', 'HEADER', 'LOCATION', 'BEST');
% % % %     axis([-900 1700 0 3200]);
% % % % %     stop;
% % % % 
% % % %     fprintf('********** Data without header stats -- No further cleaning occurring\n');
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @mean, 'streamData no header mean', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @length, 'streamData no header length', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @std, 'streamData no header stdDev', numberStdDev);
% % % %     fprintf('\n');
    
