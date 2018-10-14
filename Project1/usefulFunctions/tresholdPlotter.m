function [tresholdAccuracy,maxVal,maxIndex,classError,minVal,minIndex] = tresholdPlotter(selectedData,correctData)
%TRESHOLDPLOTTER Summary of this function goes here
%   Detailed explanation goes here

% find treshold

maxSD = max(selectedData);
minSD = min(selectedData);

nObservations = length(correctData);

tresholdAccuracy = [];
classError = [];

for treshold = minSD:0.001:maxSD % <-- here you can set the precision
    
    idx = selectedData>treshold;
    
    nGroup0 = sum(~correctData);
    nGroup1 = sum(correctData);
    
    nGiusti0 = sum(idx.*(~correctData));
    nGiusti1 = sum(idx.*(correctData));
    
    currentClassError = 1/2*(nGroup0-nGiusti0)/nGroup0 ...
        +  1/2*(nGroup1-nGiusti1)/nGroup1;
        
    res = idx == correctData;
    totGiusti = sum(res);
    percGiusti = totGiusti / nObservations;
    tresholdAccuracy = [tresholdAccuracy;[treshold,percGiusti]];
    classError = [classError;[treshold,currentClassError]];
end

[maxVal,maxIndex] = max(tresholdAccuracy(:,2));
[minVal,minIndex] = min(classError(:,2));

end

