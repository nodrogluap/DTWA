function ensembleInfo = DataSets_Used_Plos1_CompBio_July2021(ensembleInfo)
% function fileName = DataSets_Used_Plos1_CompBio_July2021(ensembleInfo)
% M. R. Smith
% Electrical and Software Engineering, University of Calgary, June 2021

    switch ensembleInfo.ensembleName
        case 'Enolase'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/Enolase';
        case 'Sequin_R1_71_1'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/Sequin_R1_71_1';
        case 'Sequin_R2_55_3'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/Sequin_R2_55_3';  
        case 'MyData1'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/MyData1';
        case 'MyData2'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/MyData2';
        case 'MyData3'
            ensembleInfo.fileName = 'SquiggleStreamData_As_txt_Files/MyData3'; 
        otherwise
            error('No such data set known %s', ensembleInfo.ensembleName);
    end