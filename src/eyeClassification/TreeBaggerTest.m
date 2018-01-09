%% Cleans console and Workspace

clc;
clear;
%% Feature extraction

% Loads the images and initialize var
load('..\..\data\eyeClassification\datasetFeaturesTest1.mat');
vectorTest = [65 70 75 80 85 90 95 100 105 110 115 120 125 130 135];
resultTest = zeros(15,5,4); %Fila: size / acc / eyes / noEyes

%% Testing treebagger

parfor i=1:15
    varTest = vectorTest(i);
    for j=1:5
        % Creates the model 
        classifierTreeBagger = TreeBagger(varTest, trainingFeatures, trainingClasses);

        % Tests the classifier
        [labelsTreeBagger, ~] = predict(classifierTreeBagger, testingFeatures);

        % Confusion matrix
        [sz, ~] = size(testingClasses);
        confusionMatrixTreeBagger = confusionmat(mat2cell(testingClasses,ones(sz,1)), labelsTreeBagger);

        % Accuracy
        accuracyTreeBagger = sum(diag(confusionMatrixTreeBagger))/sum(sum(confusionMatrixTreeBagger));
        
        %Store results
        resultTest(i,j,:) = [varTest accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];
        
        fprintf('Test %d.%d\n',i,j);
    end
end

%% Saves the results of the tests

save('../../data/eyeClassification/testingResults3.mat', 'resultTest');