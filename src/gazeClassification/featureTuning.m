%% Cleans console and Workspace

clc;
clear;
%% Feature extraction

% Loads the images and initialize var
load('..\..\data\gazeClassification\datasetImages.mat');
vectorTest = [8 4 9; 12 4 9; 16 4 9; 20 4 9; 24 4 9;
                16 2 9; 16 3 9; 16 4 9; 16 5 9; 16 6 9;
                16 4 9; 16 4 10; 16 4 11; 16 4 12; 16 4 13];
resultTest = zeros(15,5,6); %Fila: cell / black / numBins / acc / eyes / noEyes

% Creates the training and testing classes vector
trainingClasses = [repmat('L',1,numTrainingEyesImages), repmat('N',1,numTrainingNoEyesImages)]';

numTestingEyesImages = numImagesWithEyes - numTrainingEyesImages;
numTestingNoEyesImages = numImagesWithoutEyes - numTrainingNoEyesImages;

testingClasses = [repmat('L',1,numTestingEyesImages), repmat('N',1,numTestingNoEyesImages)]';

%% Testing feature extraction

parfor i=1:15
    varTest = vectorTest(i,:);
    featureExtractor = featureExtractorGaze();
    for j=1:5
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

save('../../data/eyeClassification/testingResults2.mat', 'resultTest');
