
function [classifier, yhat, Loss] = modelClassification(features, labels, discrimtype)
%utile pour la partie 1 du guidesheet2

classifier = fitcdiscr(features, labels, 'DiscrimType', discrimtype);
yhat = predict(classifier, features); %Predict labels using discriminant analysis classification model, ce qu'il faudra tester


Loss = loss(classifier, features, labels); % is an inherited method to find the Classification error, 
%L = loss(obj,X,Y) returns the classification loss, which is a scalar representing how well obj classifies the data in X, when Y contains the true classifications

end