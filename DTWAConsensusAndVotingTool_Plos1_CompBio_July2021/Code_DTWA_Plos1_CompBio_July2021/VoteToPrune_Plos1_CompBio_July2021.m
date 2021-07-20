function [prunedAverage, voteDeleteAverage, voteInsertAverage] = VoteToPrune_Plos1_CompBio_July2021(DTWAconsensus, streamCells, ...
                deleteRejectionLevel, insertAcceptanceLevel, availableStreams, DTWA, voteDeleteAverage, voteInsertAverage)
% function [prunedAverage, voteDeleteAverage, voteInsertAverage] = VoteToPrune_Plos1_CompBio_July2021(DTWAconsensus, streamCells, ...
%                deleteRejectionLevel, insertAcceptanceLevel, availableStreams, DTWA, voteDeleteAverage, voteInsertAverage)
% M. Smith, Electrical and Software ENgineering, University of Calgary, June 2021

    numCells = availableStreams;
    
    if length(voteDeleteAverage) == 1
        fprintf('Calculating voting levels\n');
        voteDeleteAverage = zeros(1, length(DTWAconsensus));
        voteInsertAverage = zeros(1, length(DTWAconsensus));
        %legend('expected', 'average');

        if DTWA.applyZNORMBeforeDTWA
            DBAaverageSignal = (DTWAconsensus - mean(DTWAconsensus)) / std(DTWAconsensus);
        else
            DBAaverageSignal = (DTWAconsensus - mean(DTWAconsensus));
        end


         % length(streamCells); ** Hard code -- fix me
    %     if (numCells > availableStreams)
    %         numCells = availableStreams;
    %     end

     %   fprintf('NUMBER OF CELLS %d  USED IN VotePrune_10Jan2019  of %d\n', numCells, availableStreams);

        for count = 1 : numCells
    %         figure;
    %         dtw(ZNorm(streamCells{count}), DBAaverageNorm);
            if DTWA.applyZNORMBeforeDTWA
                zNormedSignal = (streamCells{count} - mean(streamCells{count})) / std(streamCells{count});
                [dist, Ix, Iy] = dtw(zNormedSignal, DBAaverageSignal);
            else
                noMeanSignal = (streamCells{count} - mean(streamCells{count})) ;
                [dist, Ix, Iy] = dtw(noMeanSignal, DBAaverageSignal);
            end
            % [dist, Ix, Iy] = dtw(streamCells{count}(end:-1:1), DBAaverage(end:-1:1));
            voteDeleteAverage = VoteDelete_10Jan2019(voteDeleteAverage, Ix, Iy);
            voteInsertAverage = VoteInsert_10Jan2019(voteInsertAverage, Ix, Iy);
        end
    end

%% Perform the pruning based on voting tables
    accept = 1;
    prunedAverage = 0;  % Reset to zero length arrays
 if 1
     for count = 1 : length(DTWAconsensus)
        if voteDeleteAverage(count) < deleteRejectionLevel
            prunedAverage(accept) = DTWAconsensus(count);
            accept = accept + 1;
        end
     end
 else
     for count = 1 : length(average)
        prunedAverage(accept) = average(count);
        accept = accept + 1;
        if voteInsertAverage(count) > insertAcceptanceLevel
            prunedAverage(accept) = average(count);
            fprintf('Insert %d ', voteInsertAverage(count));
            accept = accept + 1;
        end
     end
     fprintf('\n');
 end
 
function updatedVoteInsertAverage = VoteInsert_10Jan2019(voteInsertAverage, Ix, Iy)
    updatedVoteInsertAverage = voteInsertAverage;
    for count = 2 : (length(Iy) - 1)
        if Iy(count) == Iy(count - 1)
            updatedVoteInsertAverage(Iy(count)) = updatedVoteInsertAverage(Iy(count)) + 1;
        end
    end
    
function updatedVoteDeleteAverage = VoteDelete_10Jan2019(voteDeleteAverage, Ix, Iy)
    updatedVoteDeleteAverage = voteDeleteAverage;
    for count = 2 : (length(Ix) - 1 )
% fprintf('count %d size(Ix) %d %d Ix(count) %d size(updatedVoteDeleteAverage) %d %d\n', count, size(Ix) ,Ix(count), size(updatedVoteDeleteAverage));

        if Ix(count) == Ix(count - 1)
            updatedVoteDeleteAverage(Iy(count)) = updatedVoteDeleteAverage(Iy(count)) + 1;
        end
    end