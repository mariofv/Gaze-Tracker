%% Cleans console and Workspace

clc;
clear;

%% Feature extraction

% Loads the features
load('..\..\data\gazeClassification\datasetFeatures.mat');

% Creates the model 
classifierTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses);

% Tests the classifier
[labelsTreeBagger, ~] = predict(classifierTreeBagger, testingFeatures);

% Confusion matrix
[sz, ~] = size(testingClasses);
confusionMatrixTreeBagger = confusionmat(mat2cell(testingClasses,ones(sz,1)), labelsTreeBagger);

% Accuracy
accuracyTreeBagger = sum(diag(confusionMatrixTreeBagger))/sum(sum(confusionMatrixTreeBagger));