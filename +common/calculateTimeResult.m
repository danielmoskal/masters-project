function [timeResult, timeResultString, timeStampString] = calculateTimeResult(start, stop)
    timeResult = stop - start;
    timeResultString = datestr(timeResult, 'HH:MM:SS');
    timeStampString = datestr(now, 'HH:MM:SS');
end