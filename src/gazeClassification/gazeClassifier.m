% Gaze classifier, tells us whether an image contains an eye looking at the camera or not.
classdef gazeClassifier

    properties(SetAccess = private)
      Classifier
      FeatureExtractor
      Labels
      Scores
    end

    methods
      function obj = gazeClassifier(classifier, featureExtractor)
         obj.Classifier = classifier;
         obj.FeatureExtractor = featureExtractor;
      end

      % Given an array of images it returns an array indicating whether
      % there is a eye looking at the camera on the image (TRUE) or not (FALSE).
      function [prediction] = classify(obj,images)
        features = obj.FeatureExtractor.extractFeatures(images);
        [obj.Labels, obj.Scores] = predict(obj.Classifier, features);
        prediction = cell2mat(obj.Labels)=='L';
      end

    end

end