function DisplayHeaderDataInfo_Plos1_CompBio_July2021(streamOrigData, streamHeader, streamData, showNumLines, figName, numberStdDev, ensembleInfo)
% function DisplayHeaderDataInfo_Plos1_CompBio_July2021(streamOrigData, streamHeader, streamData, showNumLines, figName, numberStdDev, ensembleInfo);)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021
if 0
% % % %     fprintf('********** Header stats \n');
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @mean, 'streamHeader mean', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @length, 'streamHeader length', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamHeader, @std, 'streamHeader stdDev', numberStdDev);
end

%% If testing with very small ensemble size (e.g. 32) then default showNumLines may be too large
% As progress through cleaning 
% -- size may continually reduce -- hence new check
    if length(streamOrigData) < showNumLines
      showNumLines = length(streamOrigData);
    end
    
    figure('Name', sprintf('%s %s', ensembleInfo.ensembleName, figName));
    for count  = 1 : showNumLines
        xposnAllStream = 1:length(streamOrigData{count});
        xposnHeader = 1:length(streamHeader{count});
        xposnAllStream = (xposnAllStream) - max(xposnHeader);     
        xposnHeader = (xposnHeader) - max(xposnHeader);
        plot(xposnAllStream, streamOrigData{count} + (count - 1) * 80, '-k'); hold on;
        
        plot(xposnHeader, streamHeader{count} + (count - 1) * 80, '-r'); hold on;
    end
    fprintf('\n');
    xlabel('SQUIGGLE EVENT POSITION');
    legend('SQUIGGLE', 'HEADER', 'LOCATION', 'BEST');
% % %  %   axis([-900 1700 0 3200]);
% % % %     stop;
% % % 
% % % %     fprintf('********** Data without header stats -- No further cleaning occurring\n');
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @mean, 'streamData no header mean', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @length, 'streamData no header length', numberStdDev);
% % % %     GetStats_FromStream_Plos1_CompBio_July2021(streamData, @std, 'streamData no header stdDev', numberStdDev);
% % % %     fprintf('\n');