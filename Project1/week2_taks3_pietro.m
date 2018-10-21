%% LOADING DATA & VARS

loadingInVars_pietro;

%%%%%%%%% TRAINING & TEST ERRORS %%%%%%%%%%%
%% SETTA I DATI PER IL TRAINER
% features selection
step = 1; % step = 1 per averle tutte
selectedFeatures = 1:step:nFeatures;
nSelectedFeatures = size(selectedFeatures,2);
seed = 45;
rng(seed);

%% AVVIA K-FOLD CROSS-VALIDATION TRAINING
N = nObservations;
k_fold = 10;

% set1 & set2 selection
cvp = cvpartition(N,'kfold',k_fold);

classErrors = [];

for fold = 1:k_fold
    clear('classifierModel');
    
    % setting masks
    idxSetTraining = cvp.training(fold);
    idxSetTest = cvp.test(fold);
    
    % selecting data
    dataSetTraining = trainData(idxSetTraining,selectedFeatures);
    dataLabelTraining = trainLabels(idxSetTraining);
    dataSetTest = trainData(idxSetTest,selectedFeatures);
    dataLabelTest = trainLabels(idxSetTest);
    
    % initialize classifier
    classifierModel = modelClassificationClass();
    classifierModel = classifierModel.setTrainData(dataSetTraining,dataLabelTraining);
    % togliamo il quadratic che se per alcuni lo trova e per altri no la
    % dimensione della matrice finale non sarà valida
    classifierModel = classifierModel.setModelTypes({'linear','diaglinear','diagquadratic'});
    
    % train classifier
    classifierModel = classifierModel.train();
    modelTypes = classifierModel.getModelTypes();
    
    % validation on test subset
    testRes = classifierModel.structuredResults(dataSetTest,dataLabelTest);
    
    classErrors = [classErrors,testRes.classErrors];
    
    % per l'ultimo punto:
    %cvp = repartition(cvp);
    
end

%% TREAT THE CLASS ERRORS
figure;
boxplot(classErrors',modelTypes);

