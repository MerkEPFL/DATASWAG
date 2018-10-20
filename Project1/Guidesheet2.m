clc; clear all; close all;

load('trainSet.mat')
load('trainLabels.mat')
load('testSet.mat')
%addpath('usefulFunctions');

[~,~,L1] = modelClassification(trainData, trainLabels,'Linear')
[~,~,L2] = modelClassification(trainData, trainLabels,'diagLinear')
[~,~,L3] = modelClassification(trainData, trainLabels,'diagQuadratic')

plot(L2,'mo') %3rd
hold on;
plot(L1,'go') %best
hold on;
plot(L3,'co') %2nd
hold on;

% with prior

[~,~,L1p] = Prior_modelClassification(trainData, trainLabels,'Linear')
[~,~,L2p] = Prior_modelClassification(trainData, trainLabels,'diagLinear')
[~,~,L3p] = Prior_modelClassification(trainData, trainLabels,'diagQuadratic')

plot(2, L2p,'ro') %2rd
hold on;
plot(2,L1p,'ko') %1st
hold on;
plot(2,L3p,'bo') %2nd
hold on;


%% Prior test

% classifier = fitcdiscr(trainData, trainLabels, 'DiscrimType', 'diagLinear', 'Prior', 'uniform')
% 
% 
% yhat = predict(classifier, trainData);
% 
% loss =loss(classifier, trainData, trainLabels)
% 




%% pb avec celui-ci
% fonctionne pas car: "You cannot use 'quadratic' type because one or more classes have singular covariance matrices."

[~,~,L4] = modelClassification(trainData, trainLabels,'Quadratic')  
plot(L4,'o')
hold on;

% avec prior aussi
[~,~,L4p] = Prior_modelClassification(trainData, trainLabels,'Quadratic')
plot(L4,'o')