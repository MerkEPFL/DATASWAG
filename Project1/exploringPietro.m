clear all; close all; clc;

%% IMPORTING DATA

cd('C:\Users\Pietro\Documents\MATLAB\Data Analysis\Project1');

testData = load('.\data\testSet.mat');
trainLabels = load('.\data\trainLabels.mat');
trainData = load('.\data\trainSet.mat');

testData = testData.testData;
trainLabels = trainLabels.trainLabels;
trainData = trainData.trainData;


sizeTest = size(testData);
sizeLabels = size(trainLabels);
sizeTrain = size(trainData);

nFeatures = sizeTrain(2);
nObservations = sizeTrain(1);


usefulFeatureStart = 700;
usefulFeatureEnd = 731;
nUsefulFeatures = usefulFeatureEnd - usefulFeatureStart + 1;
usefulFeaturesRange = usefulFeatureStart:usefulFeatureEnd;

%% ORDER DATA

trainErrorData = trainData(trainLabels==1,:);
trainCorrectData = trainData(trainLabels==0,:);

nErrorObservations = size(trainErrorData);x = 2*randn(5000,1) + 5;
nErrorObservations = nErrorObservations(1);
nCorrectObservations = size(trainCorrectData);
nCorrectObservations = nCorrectObservations(1);



%% EXPLORING DATA: 3D plot

% 3d plot label 600
figure;
hold on;

for sampleN = 1:nObservations
    plot3(usefulFeaturesRange,ones(1,nUsefulFeatures)*sampleN,trainData(sampleN,usefulFeaturesRange));
end
%%
% 3d plot label 600
figure;
hold on;

for sampleN = 1:nCorrectObservations
    plot3(usefulFeaturesRange,ones(1,nUsefulFeatures)*sampleN,trainCorrectData(sampleN,usefulFeaturesRange),'g');
end

for sampleN = 1:(nErrorObservations)
    plot3(usefulFeaturesRange,ones(1,nUsefulFeatures)*(nCorrectObservations+sampleN),trainErrorData(sampleN,usefulFeaturesRange),'r');
end

%%
% 3d plot label 600 only alcuni selected
figure;
hold on;

alcuniSelected0 = [3 8 100];
alcuniSelected1 = [1 8 4];

for sampleN = 1:length(alcuniSelected0)
    plot3(usefulFeaturesRange,ones(1,nUsefulFeatures)*sampleN,trainCorrectData(alcuniSelected0(sampleN),usefulFeaturesRange),'g');
end

for sampleN = 1:length(alcuniSelected1)
    plot3(usefulFeaturesRange,ones(1,nUsefulFeatures)*(nCorrectObservations+sampleN),trainErrorData(alcuniSelected0(sampleN),usefulFeaturesRange),'r');
end

%%
% 2d plot label 600 only alcuni selected
figure;
hold on;

alcuniSelected0 = [3 8 100];
alcuniSelected1 = [1 8 4];
plot(trainCorrectData(alcuniSelected0,usefulFeaturesRange)','g');
plot(trainErrorData(alcuniSelected1,usefulFeaturesRange)','r');

%% histogram
figure;
hold on;

coeff0 = 100/nCorrectObservations;
coeff1 = 100/nErrorObservations;


histogram(trainErrorData(:,usefulFeaturesRange),'FaceColor','r');
histogram(trainCorrectData(:,usefulFeaturesRange),'FaceColor','g');

