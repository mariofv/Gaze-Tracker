% En este script se tienen que estudiar y comparar diferentes
% clasificadores, jugando con sus diferentes parametros. Se han de hacer
% diferentes graficas y tomar medidas estadisticas. Ejemplo:


%% Creates a classifier for detecting images with eyes

% Loads the features of the training dataset
load('..\..\data\datasetFeatures.mat');

% Creates the model 
classifierTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses); % TreeBagger

%% Tests the classifier

[labelsTreeBagger, ~] = predict(classifierTreeBagger, testingFeatures);

% Confusion matrix
[sz, ~] = size(testingClasses);

confusionMatrixTreeBagger = confusionmat(mat2cell(testingClasses,ones(sz,1)), labelsTreeBagger);

% Accuracy
accuracyTreeBagger = sum(diag(confusionMatrixTreeBagger))/sum(sum(confusionMatrixTreeBagger));

