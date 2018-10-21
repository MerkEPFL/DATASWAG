%% loading Fisher Iris dataset
clear all; close all; clc;

load fisheriris

PL = meas(:,3); %petal lenght
PW = meas(:,4); %petal width

N = size(meas,1);

%partizioniamo a random i dati per avere dei training e dei test (10%)
rng(1); %per la riproducibilità
cvp = cvpartition(N,'Holdout',0.1);
idxTrn = training(cvp);
idxTest = test(cvp);

%storing in a table
tblTrn = array2table(meas(idxTrn,:));
tblTrn.Y = species(idxTrn,:);

%e creiamo il modello per il classifier come visto nell'altro script
Md1 = fitcdiscr(tblTrn,'Y');

%% PREDICTION
%prevediamo le labels per i test
labels = predict(Md1,meas(idxTest,:));
C = confusionmat(species(idxTest),labels)
imagesc(C);












