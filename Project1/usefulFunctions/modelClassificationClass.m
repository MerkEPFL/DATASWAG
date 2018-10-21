classdef modelClassificationClass
    
    properties
        classNames = [0,1];
        trainData;
        trainLabels;
        discrModels;
    end
    
    properties(Access = private)
        settedTypes = {'linear','quadratic','diaglinear','diagquadratic'};
        types = {};
        priorProbability = 'empirical';
    end
    
    methods
        function obj = setTrainData(obj,trainData,trainLabel)
            obj.trainData = trainData;
            obj.trainLabels = trainLabel;
        end
        
        function obj = setPriorProbability(obj,prior)
            obj.priorProbability = prior;
        end
        
        function obj = setModelTypes(obj,types)
            obj.settedTypes = types;
        end
        
        function types = getModelTypes(obj)
            types = obj.types;
        end
        
        function obj = setClassNames(obj,names)
            obj.classNames = names;
        end
        
        function obj = trainAndCalc(obj)
            obj = obj.train();
            obj = obj.setTrainPredictions();
            obj = obj.calculateTrainLosses();
            obj = obj.calculateTrainClassErrors();
        end
        
        function obj = train(obj)
            obj.types = {};
            for k=1:length(obj.settedTypes)
                obj = obj.trainByType(obj.settedTypes{k});
            end
        end
        
        function predictions = findPrediction(obj,features)
            predictions = [];
            for k=1:length(obj.types)
                type = obj.types{k};
                try
                    prediction = obj.predictByType(type,features);
                    predictions = [predictions,prediction];
                catch
                    warning('errore durante le predictions di %s',type);
                end
            end
        end
        
        function errors = calculateClassErrors(obj,predictions,labels)
            errors = [];
            for k=1:length(obj.types)
                prediction = predictions(:,k);
                classError = obj.classError(obj.classNames,prediction,labels);
                errors = [errors;classError];
            end
        end
        
        function losses = calculateLosses(obj,data,labels)
            losses = [];
            for k=1:length(obj.types)
                type = obj.types{k};
                discrModel = getfield(obj.discrModels,type);
                lossVal = loss(discrModel.model,data,labels);
                losses = [losses;lossVal];
            end
        end
        
        function plotClassificationErrors(obj)
            x = obj.getTrainClassificationErrors();
            
            figure;
            bar(x);
            set(gca,'xticklabel',obj.types);
        end
        
        function CE = getTrainClassificationError(obj,modelType)
            try
                model = getfield(obj.discrModels,modelType);
                CE = model.lossTrain;
            catch
                CE = 0;
            end
        end
        
        function CE = getTrainClassError(obj,modelType)
            try
                model = getfield(obj.discrModels,modelType);
                CE = model.classError;
            catch
                CE = 0;
            end
        end
        
        function x = getTrainClassificationErrors(obj)
            x = [];
            for k=1:length(obj.types)
                x = [x,obj.getTrainClassificationError(obj.types{k})];
            end
        end
        
        function x = getTrainClassErrors(obj)
            x = [];
            for k=1:length(obj.types)
                x = [x,obj.getTrainClassError(obj.types{k})];
            end
        end
        
        function SR = structuredResults(obj,data,labels)
            SR.predictions = obj.findPrediction(data);
            SR.modelTypes = obj.getModelTypes();
            SR.classificationErrors = obj.calculateLosses(data,labels);
            SR.classErrors = obj.calculateClassErrors(SR.predictions,labels);
        end
        
    end
    
    
    %%
    methods(Access = private)
        function obj = trainByType(obj,type)
            try
                model = ...
                    fitcdiscr(obj.trainData, obj.trainLabels, ...
                    'DiscrimType', type, ...
                    'Prior',obj.priorProbability);

                lossTrain = loss(model,obj.trainData,obj.trainLabels);

                discrModel.model = model;
                discrModel.lossTrain = lossTrain;

                obj.discrModels = setfield(obj.discrModels,type,discrModel);
                
                obj.types = [obj.types,{type}];
            catch
                warning('errore durante il train di %s',type);
            end
        end
        
        function obj = calculateTrainLosses(obj)
            for k=1:length(obj.types)
                obj = obj.calculateTrainLossByType(obj.types{k});
            end
        end
        
        function obj = calculateTrainClassErrors(obj)
            for k=1:length(obj.types)
                type = obj.types{k};
                try
                    discrModel = getfield(obj.discrModels,type);
                    classError = obj.classError(obj.classNames,discrModel.prediction,obj.trainLabels);
                    discrModel = setfield(discrModel,'classError',classError);
                    obj.discrModels = setfield(obj.discrModels,type,discrModel);
                catch ME
                    
                end
            end
        end
        
        function obj = setTrainPredictions(obj)
            for k=1:length(obj.types)
                type = obj.types{k};
                try
                    discrModel = getfield(obj.discrModels,type);
                    prediction = obj.predictByType(type,obj.trainData);
                    discrModel = setfield(discrModel,'prediction',prediction);
                    obj.discrModels = setfield(obj.discrModels,type,discrModel);
                catch
                    warning('errore durante il train prediction di %s',type);
                end
            end
        end
        
        function labels = predictByType(obj,type,features)
            modelType = getfield(obj.discrModels,type);
            classifier = modelType.model;
            labels = predict(classifier,features);
        end
        
        function obj = calculateTrainLossByType(obj,type)
            try
                discrModel = getfield(obj.discrModels,type);
                lossTrain = loss(discrModel.model,obj.trainData,obj.trainLabels);
                discrModel = setfield(discrModel,'lossTrain',lossTrain);
                obj.discrModels = setfield(obj.discrModels,type,discrModel);
            catch
                warning('errore durante loss() di %s',type);
            end
        end
        
    end
    
    
    
    %%
    methods(Static)
        function classError = classError(classNames,predictedLabels,correctLabels)
            nClass = length(classNames);
            
            tots = [];
            for k = 1:nClass
                tot = sum(correctLabels == classNames(k));
                tots = [tots;tot];
            end
            C = confusionmat(predictedLabels,correctLabels);
            
            missclassifieds = [];
            for k = 1:nClass
                missclassified = tots(k) - C(k,k);
                missclassifieds = [missclassifieds;missclassified];
            end
            
            classError = sum((1/nClass)*(missclassifieds./tots));
        end
    end
    
end

