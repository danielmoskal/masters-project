function stop = customTrainOutput(info, constParams)

    if ~constParams.maxMinExpectedEnabled || info.State == "done"
        return;
    end
    
    [stop1] = stopIfAccuracyNotImproving(info, constParams.validAccuracyPatience);
    [stop2] = stopIfMaxExpectedAccuracyAcheived(info, constParams.maxExpectedValidAccuracy);
    [stop3] = stopIfMinExpectedLossAcheived(info, constParams.minExpectedValidLoss);
    
    stop = stop1 || stop2 || stop3;

end

function [stop] = stopIfAccuracyNotImproving(info, N)

stop = false;

% Keep track of the best validation accuracy and the number of validations for which
% there has not been an improvement of the accuracy.
persistent bestValAccuracy
persistent valLag

% Clear the variables when training starts.
if info.State == "start"
    bestValAccuracy = 0;
    valLag = 0;
    
elseif ~isempty(info.ValidationLoss)
    
    % Compare the current validation accuracy to the best accuracy so far,
    % and either set the best accuracy to the current accuracy, or increase
    % the number of validations for which there has not been an improvement.
    if info.ValidationAccuracy >= bestValAccuracy
        valLag = 0;
        bestValAccuracy = info.ValidationAccuracy;
    else
        valLag = valLag + 1;
    end
    
    % If the validation lag is at least N, that is, the validation accuracy
    % has not improved for at least N validations, then return true and
    % stop training.
    if valLag >= N
        stop = true;
        fprintf("- OutputFun: stopped, accuracy not improved over %d validations\n", N);
    end
    
end

end

function [stop] = stopIfMaxExpectedAccuracyAcheived(info, maxExpectedAccuracy)

    stop = false;

    if ~isempty(info.ValidationLoss)
        if info.ValidationAccuracy >= maxExpectedAccuracy
        	stop = true;
            fprintf("- OutputFun: stopped, max expected accuracy achieved, max expected: %.4f, achieved: %.4f\n", maxExpectedAccuracy, info.ValidationAccuracy);
        end
    end
    
end

function [stop] = stopIfMinExpectedLossAcheived(info, minExpectedLoss)

    stop = false;

    if ~isempty(info.ValidationLoss)
        if info.ValidationLoss <= minExpectedLoss
        	stop = true;
            fprintf("- OutputFun: stopped, min expected loss achieved, min expected: %.4f, achieved: %.4f\n", minExpectedLoss, info.ValidationLoss);
        end
    end
    
end