function goldStandard = GetGoldStandardInfo_Plos1_CompBio_July2021(ensembleInfo)
% function goldStandard = GetGoldStandardInfo_Plos1_CompBio_July2021(ensembleInfo)
% M. Smith. Electrical and Software Engineering,  University of Calgary, June 2021

    goldStandardDirectory = sprintf('../%s/%s', ensembleInfo.originalDataDirectory, ensembleInfo.ensembleName);
    goldStandardFileName = sprintf('%s/GoldStandard_%s.txt', goldStandardDirectory, ensembleInfo.ensembleName);

%% Grab the requested gold standard
    fileID = fopen(goldStandardFileName ,'r');
    if (fileID == -1)
        error('Bad file name %s\n', goldStandardFileName );
    end
    oneLine = fgets(fileID);

    formatSpec = '%f';
    goldStandard.stream = sscanf(oneLine,formatSpec);
    
%% Remove known initial distortions in the goldstandard
    switch (ensembleInfo.ensembleName)
        case 'Enolase'
            firstValidPoint = 20;  % Unclear why first 19 points are identical
            fprintf('*** Removed %d initial points from %s goldStandard\n', firstValidPoint - 1, ensembleInfo.ensembleName);
        otherwise
            firstValidPoint = 1;
    end

    goldStandard.stream = goldStandard.stream(firstValidPoint : end);
    goldStandard.length = length(goldStandard.stream);
    
    if ensembleInfo.applyZNORMBeforeDTWA
      goldStandard.stream = (goldStandard.stream - mean(goldStandard.stream)) / std(goldStandard.stream);
      fprintf('*** %s contained %d points -- HAVE Z-normalized the gold stream\n', goldStandardFileName, goldStandard.length); 
    else
      fprintf('*** %s contained %d points -- HAVE NOT Z-normalized the gold stream\n', goldStandardFileName, goldStandard.length); 
    end
