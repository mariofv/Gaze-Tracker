%% Cleans console and Workspace

% clc;
% clear;

%% Feature extraction

% Loads the features
load('..\..\data\gazeClassification\datasetFeatures.mat');
load('..\..\data\gazeClassification\testingResults.mat');

%% Testing feature extraction

% resultTest = zeros(20,4); %Fila: yes_no / acc / eyes / noEyes

parfor i=11:20
    
    % Creates the model 
    classifierTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses);

    % Tests the classifier
    [labelsTreeBagger, ~] = predict(classifierTreeBagger, testingFeatures);

    % Confusion matrix
    [sz, ~] = size(testingClasses);
    confusionMatrixTreeBagger = confusionmat(mat2cell(testingClasses,ones(sz,1)), labelsTreeBagger);

    % Accuracy
    accuracyTreeBagger = sum(diag(confusionMatrixTreeBagger))/sum(sum(confusionMatrixTreeBagger));
    
    %Store results
    resultTest(i,:) = [0 accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];

    fprintf('Test %d\n',i);
end

%% Saves the results of the tests

save('../../data/gazeClassification/testingResults.mat', 'resultTest');