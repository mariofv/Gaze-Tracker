%% Cleans console and Workspace

clc;
clear;
%% Feature extraction

% Loads the images and initialize var
load('..\..\data\datasetImages.mat');
vectorTest = [8 4 12; 10 4 12; 12 4 12; 14 4 12; 16 4 12; 18 4 12; 20 4 12; 22 4 12; 24 4 12; %9
                16 2 12; 16 3 12; 16 4 12; 16 5 12; 16 6 12; %5
                16 4 9; 16 4 10; 16 4 11; 16 4 12; 16 4 13; 16 4 14; 16 4 15]; %7
resultTest = zeros(21,4,6); %Fila: cell / black / numBins / acc / eyes / noEyes

% Creates the training and testing classes vector
trainingClasses = [repmat('E',1,numTrainingEyesImages), repmat('N',1,numTrainingNoEyesImages)]';

numTestingEyesImages = numImagesWithEyes - numTrainingEyesImages;
numTestingNoEyesImages = numImagesWithoutEyes - numTrainingNoEyesImages;

testingClasses = [repmat('E',1,numTestingEyesImages), repmat('N',1,numTestingNoEyesImages)]';

%% Testing feature extraction

parfor i=1:size(vectorTest)
    varTest = vectorTest(i,:);
    featureExtractor = featureExtractor();
    for j=1:4
        % Creates the training and testing feature matrix
        trainingFeatures = featureExtractor.extractFeaturesTesting(trainingDataset,varTest(1),varTest(2),varTest(3));
        testingFeatures = featureExtractor.extractFeaturesTesting(testingDataset,varTest(1),varTest(2),varTest(3));

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
        resultTest(i,j,:) = [varTest(1) varTest(2) varTest(3) accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];
        
        fprintf('Test %d.%d\n',i,j);
    end
end

%% Saves the results of the tests

save('../../data/testingResults.mat', 'resultTest');
