% Eye classificator, tells us whether an image contains and eye or not.
classdef eyeClassifier
    
   properties(SetAccess = private)
      Classifier
      FeatureExtractor
      Labels
      Scores
   end
   
   methods
      function obj = eyeClassifier(classifier, featureExtractor)
         obj.Classifier = classifier;
         obj.FeatureExtractor = featureExtractor;
      end
      
      % Given an array of images it returns an array indicating whether
      % there is an eye on the image (TRUE) or not (FALSE).
      function [prediction] = classify(obj,images)
        features = obj.FeatureExtractor.extractFeatures(images);
        [obj.Labels, obj.Scores] = predict(obj.Classifier, features);
        prediction = cell2mat(obj.Labels)=='E';
      end
  
   end
   
end