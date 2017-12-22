%% Cleans console and Workspace

clc;
clear;
%% Feature extraction

% Loads the images and initialize var
load('..\..\data\datasetImages.mat');
featureExtractor = featureExtractor();
cellTest = [8 10 12 14 16 18 20 22 24]; %9
blockTest = [2 3 4 5 6]; %5
numBinsTest = [9 10 11 12 13 14 15]; %7
resultTest = zeros([21*4,6]); %Fila: cell / black / numBins / acc / eyes / noEyes

% Creates the training and testing classes vector
trainingClasses = [repmat('E',1,numTrainingEyesImages), repmat('N',1,numTrainingNoEyesImages)]';

numTestingEyesImages = numImagesWithEyes - numTrainingEyesImages;
numTestingNoEyesImages = numImagesWithoutEyes - numTrainingNoEyesImages;

testingClasses = [repmat('E',1,numTestingEyesImages), repmat('N',1,numTestingNoEyesImages)]';

%% Testing feature extraction

for i=1:size(cellTest)
    for j=1:5
        % Creates the training and testing feature matrix
        trainingFeatures = featureExtractor.extractFeaturesTesting(trainingDataset,cellTest(i),4,12);
        testingFeatures = featureExtractor.extractFeaturesTesting(testingDataset,cellTest(i),4,12);

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
        resultTest(i*4-(j-1),:) = [cellTest(i) 4 12 accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];
        
        fprintf('Test cell: %d.%d\n',i,j);
    end
end

for i=1:size(blockTest)
    for j=1:5
        % Creates the training and testing feature matrix
        trainingFeatures = featureExtractor.extractFeaturesTesting(trainingDataset,16,blockTest(i),12);
        testingFeatures = featureExtractor.extractFeaturesTesting(testingDataset,16,blockTest(i),12);

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
        resultTest(9*4+i*4-(j-1),:) = [16 blockTest(i) 12 accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];
        
        fprintf('Test block: %d.%d\n',i,j);
    end
end

for i=1:size(numBinsTest)
    for j=1:5
        % Creates the training and testing feature matrix
        trainingFeatures = featureExtractor.extractFeaturesTesting(trainingDataset,16,4,numBinsTest(i));
        testingFeatures = featureExtractor.extractFeaturesTesting(testingDataset,16,4,numBinsTest(i));

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
        resultTest(14*4+i*4-(j-1),:) = [16 4 numBinsTest(i) accuracyTreeBagger confusionMatrixTreeBagger(1,2) confusionMatrixTreeBagger(2,1)];
        
        fprintf('Test numBins: %d.%d\n',i,j);
    end
end

%% Saves the results of the tests

save('../../data/testingResults.mat', 'resultTest');
