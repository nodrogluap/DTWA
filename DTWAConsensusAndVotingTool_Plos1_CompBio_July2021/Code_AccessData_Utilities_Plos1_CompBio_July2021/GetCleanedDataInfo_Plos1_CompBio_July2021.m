function cleanedNoHeaderDataInfo = GetCleanedDataInfo_Plos1_CompBio_July2021(ensembleInfo, goldStandardInfo)
% function cleanedNoHeaderDataInfo = GetCleanedDataInfo_Plos1_CompBio_July2021(ensembleInfo, goldStandardInfo)
% M. Smith, Electrical and Software Engineering, University of Calgary, June 2021

%% Adjust request for number of streams available in ensemble
  cleanedNoHeaderDataInfo = ensembleInfo;
  cleanedNoHeaderDataInfo.posnEnsembleLastStream = CheckAvailableData(ensembleInfo);        % Adjust last position if insufficient data
  cleanedNoHeaderDataInfo.availableStreams = cleanedNoHeaderDataInfo.posnEnsembleLastStream - cleanedNoHeaderDataInfo.posnEnsembleStartStream + 1;
  if (cleanedNoHeaderDataInfo.availableStreams < cleanedNoHeaderDataInfo.numStreams)
      cleanedNoHeaderDataInfo.numStreams = cleanedNoHeaderDataInfo.availableStreams;
  end
  
%% Build the name of where cleaned no header data is stored
    cleanedNoHeaderDirectory = 'CleanDataSets_Plos1_CompBio_July2021'; 
    cleanedNoHeaderDataInfo.nameDetails = sprintf('%s_%1d_%1d', ...
        cleanedNoHeaderDataInfo.ensembleName, cleanedNoHeaderDataInfo.posnEnsembleStartStream, cleanedNoHeaderDataInfo.posnEnsembleLastStream);
    cleanedNoHeaderFileName = sprintf('%s/CleanedNoHeader_%s.mat', ...
        cleanedNoHeaderDirectory, cleanedNoHeaderDataInfo.nameDetails);
    
    if ensembleInfo.getCleanedDataIfAvailable == true  %% If cleaned no header data available
        try
            load(cleanedNoHeaderFileName, 'cleaned_noHeaderData');
            cleanedNoHeaderDataInfo.streams = cleaned_noHeaderData;
            cleanedNoHeaderDataInfo.numCleanedStreams = length(cleaned_noHeaderData);
            fprintf('*** Loaded %s\n', cleanedNoHeaderFileName);
            return;
        catch
            fprintf('*** >%s< not available -- generating cleaned no header data\n', cleanedNoHeaderFileName);
        end
    end
    
%% Build the name of where no header data is stored
    noHeaderDataInfoDirectory = ensembleInfo.noHeaderDataInfoDirectory; % 'NoHeaderDataSets_Plos1_CompBio_July2021';     % './NoHeaderDataSets_Sept2018/' 
    noHeaderDataFileName = sprintf('%s/NoHeader_%s_%1d_%1d.mat', ...
        noHeaderDataInfoDirectory, cleanedNoHeaderDataInfo.ensembleName, cleanedNoHeaderDataInfo.posnEnsembleStartStream, cleanedNoHeaderDataInfo.posnEnsembleLastStream);
    
    if ensembleInfo.getCleanedDataIfAvailable == true  %% If cleaned no header data available
        try
            load(noHeaderfileName, 'noHeaderData');
            cleaned_noHeaderData = CleanNoHeaderData_10Jan2019(noHeaderDataFileName, cleanedNoHeaderDataInfo.headerStdDevRange, cleanedNoHeaderDataInfo.stdDevAlongStream, goldStandardInfo); 
            save(cleanedNoHeaderFileName, 'cleaned_noHeaderData');          
            cleanedNoHeaderDataInfo.streams = cleaned_noHeaderData;
            cleanedNoHeaderDataInfo.numCleanedStreams = length(cleaned_noHeaderData);
            fprintf('*** Cleaned and Loaded %s\n', cleanedNoHeaderFileName);
            return;
        catch
            fprintf('*** >%s< not available -- generating no header data\n', noHeaderDataFileName);
        end
    end

%%  Grab the original data set -- remove headers and clean it
    originalDataDirectory = ensembleInfo.originalDataDirectory; % 'GordonData_May2018';    % './GordonData_May2018';
    originalDataFileName = sprintf('../%s/%s/%s.txt', originalDataDirectory, cleanedNoHeaderDataInfo.ensembleName, cleanedNoHeaderDataInfo.ensembleName);
    
    noHeaderData = RemoveHeader_Plos1_CompBio_July2021(originalDataFileName, cleanedNoHeaderDataInfo.posnEnsembleStartStream, cleanedNoHeaderDataInfo.numStreams, ...
      cleanedNoHeaderDataInfo.headerStdDevRange, ensembleInfo, goldStandardInfo);
    save(noHeaderDataFileName, 'noHeaderData'); 
    
    cleaned_noHeaderData = CleanNoHeaderData_Plos1_CompBio_July2021(noHeaderDataFileName, cleanedNoHeaderDataInfo.headerStdDevRange, cleanedNoHeaderDataInfo.cleanAlongStream_StdDevRange, ...
                goldStandardInfo, ensembleInfo); 
    save(cleanedNoHeaderFileName, 'cleaned_noHeaderData');          
    cleanedNoHeaderDataInfo.streams = cleaned_noHeaderData;
    cleanedNoHeaderDataInfo.numCleanedStreams = length(cleaned_noHeaderData);
    fprintf('*** Removed headers, cleaned and Loaded %s\n', cleanedNoHeaderFileName);

        
function updatedEnsembleEndStream = CheckAvailableData(ensembleInfo)        % Adjust last position if insufficient data
  updatedEnsembleEndStream = ensembleInfo.posnEnsembleEndStream;  % No change - default

  squiggleDirectory = sprintf('../%s/%s', ensembleInfo.originalDataDirectory, ensembleInfo.ensembleName);
  totalStreamFileName = sprintf('%s/TotalNumberStreams_%s.txt', squiggleDirectory, ensembleInfo.ensembleName);

  fileID = fopen(totalStreamFileName ,'r');
  if (fileID == -1)
      error('Bad file name for total streams value %s\n', totalStreamFileName );
  end
  oneLine = fgets(fileID);

  formatSpec = '%f';
  totalStreams = sscanf(oneLine,formatSpec);

  if (ensembleInfo.posnEnsembleStartStream > totalStreams)
      error('%s Not that number of data streams available start %d end %d', ensembleInfo.ensembleName, ensembleInfo.posnEnsembleStartStream, ensembleInfo.posnENsembleLastStream);
  end

  if (ensembleInfo.posnEnsembleEndStream > totalStreams)
      updatedEnsembleEndStream = totalStreams;
  end
