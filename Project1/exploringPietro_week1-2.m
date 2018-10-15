clear all; close all; clc;

%% IMPORTING DATA

cd('C:\Users\Pietro\Documents\MATLAB\Data Analysis\Project1');
addpath('usefulFunctions');

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

global nUsefulFeatures;
global usefulFeaturesRange;

setGlobalRanges(700,731);

%% ORDER DATA

trainErrorData = trainData(trainLabels==1,:);
trainCorrectData = trainData(trainLabels==0,:);

nErrorObservations = size(trainErrorData);x = 2*randn(5000,1) + 5;
nErrorObservations = nErrorObservations(1);
nCorrectObservations = size(trainCorrectData);
nCorrectObservations = nCorrectObservations(1);


%% ricerca dei più bassi class error [validation test]

% elegant code per filtrare a cazzo 
maskSelection = randi([0 1],nObservations,1);

trainingSet = trainData(maskSelection == 1,:);
trainingSetLabels = trainLabels(maskSelection == 1);
validationSet = trainData(~maskSelection == 1,:);
validationSetLabels = trainLabels(~maskSelection == 1);

rangeFeatures = 1:1800;
tresholds = [];

for feature = rangeFeatures % trovo i migliori treshold per ogni feature
    [~,~,~,classError,minError,minIndex] = tresholdPlotter(trainingSet(:,feature),trainingSetLabels);
    foundedTreshold = classError(minIndex,1);
    tresholds = [tresholds;feature,foundedTreshold,minError];
end

% mo riscorro le features ma testo sul validationSet e prendo salvo i 
% ClassErros
classErrors = [];
for n = 1:numel(rangeFeatures) % trovo i migliori treshold per ogni feature
    feature = rangeFeatures(n);
    classError = findCEByTreshold(validationSet(:,feature),validationSetLabels,tresholds(n,2));
    classErrors = [classErrors;feature,tresholds(n,2),classError];
end

figure;
scatter(rangeFeatures,classErrors(:,3));



%% trovati i più bassi, vai di probabilità semplici

selectedData = trainData(:,feature);

%selectedFeatures = [669,965,1093,1149,1608,1661,1736];
%selectedTresholds = [0.428976685655704,...
%    0.779063676301258,0.620938714550238,0.481, ...
%    0.552680646475706, 0.41, 0.598970439687342];

% random features!
n = 1800;
nRandomFeatures = 200;
selectedFeatures = randperm(n,nRandomFeatures);

selectedTresholds = tresholds(selectedFeatures,2);


idxSumm = zeros(length(selectedData),1);

for n = 1:numel(selectedFeatures)
    feature = selectedFeatures(n);
    idxSumm = idxSumm+(selectedData>selectedTresholds(n));
end

idx = idxSumm;
idx(idx<=100) = 0;
idx(idx>100) = 1;

sum(idx)

%%

treshold = 0.489247970397037;
bestFeature = 964;

selectedTestData = testData(:,bestFeature);


l = length(trainData(:,bestFeature));
figure;
scatter(1:l,trainData(:,bestFeature),[],trainLabels);
hline(treshold);

%%

idxTestData = selectedTestData > treshold;

labelToCSV(~idxTestData,'prediction_f1609_t0_603.csv','./predictions/')





%% plotmatrix per capire

% /!\ ATTENZIONE: cicla e genera un sacco di plotmatrix 

fromTo = 70:73; % fattore 10 di moltiplicazione (0:80) = (0:800)

for i = fromTo
    lRange = i*10; % low range
    tRange = (i+1)*10;
    setGlobalRanges(lRange,tRange);
    figure;
    gplotmatrix(trainData(:,usefulFeaturesRange),[],trainLabels,'br');
    title(strcat('Matrix da ',num2str(lRange),' a ',num2str(tRange)));
end
