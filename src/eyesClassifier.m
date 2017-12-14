%% Cleans console and Workspace

clc;
clear;

%% Creates a classifier for detecting images with eyes

% Loads the features of the training and testing dataset
load('datasetFeatures.mat');

% Creates the model 
modelTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses); % TreeBagger
% modelSVM = fitcsvm(trainingFeatures, trainingClasses); % Support Vector Machines

%% Tests the classifier

[labelsTreeBagger, ~] = predict(modelTreeBagger, testingFeatures);
% [labelsSVM, ~] = predict(modelSVM, testingFeatures);

% Confusion matrix
[sz, ~] = size(testingClasses);

confusionMatrixTreeBagger = confusionmat(mat2cell(testingClasses,ones(sz,1)), labelsTreeBagger);
% confusionMatrixSVM = confusionmat(testingClasses, labelsSVM);

% Accuracy
accuracyTreeBagger = sum(diag(confusionMatrixTreeBagger))/sum(sum(confusionMatrixTreeBagger));
% accuracySVM = sum(diag(confusionMatrixSVM))/sum(sum(confusionMatrixSVM));