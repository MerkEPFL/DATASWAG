function setGlobalRanges(min,max)
%SETGLOBALRANGES set ranges and calculate range width and get range
%linespace
%   Pay attention: variables are global!
global usefulFeatureStart;
global usefulFeatureEnd;
global nUsefulFeatures; 
global usefulFeaturesRange

usefulFeatureStart = min;
usefulFeatureEnd = max;
nUsefulFeatures = usefulFeatureEnd - usefulFeatureStart + 1;
usefulFeaturesRange = usefulFeatureStart:usefulFeatureEnd;

end

