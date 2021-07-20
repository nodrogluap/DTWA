function simulationInfo = Simulation_DefaultSettings_Plos1_CompBio_July2021(varargin)
% function simulationInfo = Simulation_DefaultSettings_Plos1_CompBio_July2021(varargin)
% M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada, June 2021

    if nargin == 0
        simulationInfo.nameDetails = 'nameDetails not yet set';
    else
        simulationInfo.nameDetails = varargin{1}.nameDetails;
    end

    simulationInfo.whereDisplay = 'DISPLAY_UPPERROW';
    simulationInfo.PLOT_IX_v_IY = true;
    simulationInfo.analayse_IX_IY_fromStart = false;
    simulationInfo.whichDistribution = 'gev';
    simulationInfo.numMockedStreams = 'numMockedStreams not yet set';
    
%% Force recalculation of insert-delete stats or renerate mocked data by setting to false
    simulationInfo.reuseInsertionDeletionStatsIfAvailable = true;
    simulationInfo.reuseMockedDataIfAvailable = true;

%% Setting the simulation parameters
    simulationInfo.generateCDFexperimentally = true;
    if simulationInfo.generateCDFexperimentally == false
       simulationInfo.generateCDFcurve = 'gev';
    end

    simulationInfo.generateMockedStreamsBasedOnExperimentalDataOnly = false;

    if  simulationInfo.generateMockedStreamsBasedOnExperimentalDataOnly
        simulationInfo = SetGenerateMockedStreamsBasedOnExperimentalDataOnlyLocal(simulationInfo);
    else        
        simulationInfo = SetGenerateMockedStreamsBasedOnTheoryLocal(simulationInfo);    
    end

%% Adding noise to and cleaning simulated data
    simulationInfo.ADDNOISE_TO_MOCKED_DATA = true;
    simulationInfo.SNRwanted = 3;
    simulationInfo.CLEAN_MOCKED_DATA = false;

    
function simulationInfo = SetGenerateMockedStreamsBasedOnExperimentalDataOnlyLocal(simulationInfo)
        simulationInfo.USE_EXPERIMENTAL_LOCAL_INSERTION_RATES = 0;
        %  simulationInfo.modelUsed = 'USE_EXPERIMENTAL_LOCAL_INSERTION_RATES ';
        simulationInfo.USE_EXPERIMENTAL_LOCAL_DELETION_RATES = 0;
       % simulationInfo.modelUsed = 'EXPTL_LOCAL_INSERT+DELETE+RATES ';

        simulationInfo.USE_EXPERIMENTAL_GLOBAL_INSERTION_RATES = 1;
        % modelUsed = 'EXPT_GLOBAL_INSERT_RATES';
        simulationInfo.USE_EXPERIMENTAL_GLOBAL_DELETION_RATES = 1;
        % simulationInfo.modelUsed = 'USE_EXPERIMENTAL_GLOBAL_DELETION_RATES ';

        simulationInfo.USE_RANDOM_ADDITIONAL_INSERTION_TERMS = 0;
        % simulationInfo.modelUsed = 'USE_RANDOM_ADDITIONAL_INSERTION_TERMS '; 
        simulationInfo.USE_DEFINED_ADDITIONAL_INSERTION_TERMS = 1;
        % simulationInfo.modelUsed = 'EXPTL_GLOBAL_INSERT+DELETE+RATES+DEFINED_ADITIONAL';
        simulationInfo.additionalInsertionProbabilityFactor = 2.0;   %1.3
     %   simulationInfo.modelUsed = 'EXPTL_GLOBAL_INSERT+DELETE+RATES+MODIFIED_ADDITIONAL';
      %  simulationInfo.additionalInsertionProbabilityFactor = 1.5;
        simulationInfo.additionalDeletionProbabilityFactor = 0;

        simulationInfo.USE_DELETIONS_BECOME_DISTORTIONS = 0;
        % simulationInfo.modelUsed = 'EXPTL_GLOBAL_INSERT+DELETE+RATES+_ADD_DISTORTIONS';

        simulationInfo.USE_ADDITIONAL_INSERTION_TERMS_PLUS_VERY_LONG_RANDOM_EXTENSION = 1;
        simulationInfo.modelUsed = 'USE_ADDITIONAL_INSERTION_TERMS_PLUS_VERY_LONG_RANDOM_EXTENSION ';

function simulationInfo = SetGenerateMockedStreamsBasedOnTheoryLocal(simulationInfo);
        simulationInfo.CALCULATE_CHAN_MODEL_LOCAL = 0;
        % simulationInfo.modelUsed = ' CALCULATE_CHAN_MODEL_LOCAL';
        simulationInfo.CALCULATE_INSERTION_ONLY_MODEL_LOCAL = 0;
        % simulationInfo.modelUsed = ' CALCULATE_INSERTION_ONLY_MODEL_LOCAL';

        simulationInfo.CALCULATE_GLOBAL_MODEL_INSERTIONS_ONLY = 0;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_ONLY ';
        simulationInfo.CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS = 1;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS ';
        simulationInfo.ADD_COMPENSATORY_INSERTIONS = 1;
        simulationInfo.modelUsed = 'GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS+COMPENSATE_INSERTIONS';
        simulationInfo.SCALE_COMPENSATORY_INSERTIONS = 0;
        simulationInfo.ADJUSTED_DELETIONS = 0;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS ';

        simulationInfo.CONVERT_DELETIONS_INTO_DISTORTIONS = 0;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS ';
       simulationInfo. CONVERT_DELETIONS_INTO_TWO_DISTORTIONS = 0;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS ';
        simulationInfo.ADJUSTED_CONVERT_DELETIONS_INTO_DISTORTIONS = 0;
        % simulationInfo.modelUsed = 'CALCULATE_GLOBAL_MODEL_INSERTIONS_EMPIRICIAL_DELETIONS
        % ';
