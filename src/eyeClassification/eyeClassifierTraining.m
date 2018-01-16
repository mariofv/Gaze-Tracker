%% Cleans console and Workspace

clc;
clear;

%% Creates a classifier for detecting images with eyes

% Loads the features of the training dataset
load('..\..\data\eyeClassification\datasetFeatures.mat');

% Creates the classifier 
classifierTreeBagger = TreeBagger(90, trainingFeatures, trainingClasses); % TreeBagger

%% Saves the classifier
save('../../data/eyeClassification/eyeClassifier.mat', 'classifierTreeBagger'); 
